import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  // Konstanta channel Android
  static const _androidChannel = AndroidNotificationChannel(
    'tanoshii_channel',
    'Pengumuman Tanoshii',
    description: 'Notifikasi pengumuman dari Sensei',
    importance: Importance.high,
  );

  /// Panggil sekali di main() sebelum runApp
  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Minta izin notifikasi (wajib untuk iOS & Android 13+)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Buat channel Android (wajib untuk Android 8+)
    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Inisialisasi flutter_local_notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // sudah diminta di atas
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotif.initialize(
      settings: const InitializationSettings(
        android: androidSettings, 
        iOS: iosSettings,
      ),
    );

    // Handler saat app di FOREGROUND — tampilkan local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notif = message.notification;
      if (notif != null) {
        _showLocalNotification(
          title: notif.title ?? 'Pengumuman',
          body: notif.body ?? '',
        );
      }
    });
  }

  /// Tampilkan banner notifikasi di dalam app (foreground)
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();

    await _localNotif.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: androidDetails, 
        iOS: iosDetails,
      ),
    );
  }

  /// Kirim push notifikasi ke semua siswa di domain akademi yang sama.
  /// Dipanggil dari AnnouncementScreen setelah pengumuman tersimpan ke Firestore.
  ///
  /// [akademiDomain] — domain akademi Sensei, contoh: "lpk.ac.id"
  /// [message]       — isi pesan pengumuman
  /// [serverKey]     — FCM Legacy Server Key dari Firebase Console
  // ── 1. Fungsi Rahasia untuk Mencetak Token OAuth2 ──
  static Future<String> _getAccessToken() async {
    final jsonString = await rootBundle.loadString('assets/service-account.json');
    final accountCredentials = ServiceAccountCredentials.fromJson(jsonString);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    
    final authClient = await clientViaServiceAccount(accountCredentials, scopes);
    final token = authClient.credentials.accessToken.data;
    authClient.close();
    
    return token;
  }

  // ── 2. Fungsi Pengirim FCM v1 ──
  static Future<void> sendToAkademi({
    required String akademiDomain,
    required String message,
    required String projectId, // v1 menggunakan Project ID, bukan Server Key
  }) async {
    if (akademiDomain.isEmpty) return;

    try {
      // Dapatkan kunci akses dinamis
      final accessToken = await _getAccessToken();

      // Ambil token HP siswa dari Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('akademiDomain', isEqualTo: akademiDomain)
          .where('role', whereIn: ['Pelajar Akademi', 'Pelajar'])
          .get();

      final tokens = snapshot.docs
          .map((d) => d.data()['fcmToken'] as String?)
          .whereType<String>()
          .where((t) => t.isNotEmpty)
          .toList();

      if (tokens.isEmpty) return;

      // Endpoint API v1 yang baru
      final endpoint = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      // FCM v1 mengharuskan pengiriman satu per satu
      for (String deviceToken in tokens) {
        await http.post(
          Uri.parse(endpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            'message': {
              'token': deviceToken,
              'notification': {
                'title': '📢 Pengumuman Baru',
                'body': message,
              },
              'data': {
                'type': 'announcement',
                'akademiDomain': akademiDomain,
              },
            }
          }),
        );
      }
    } catch (e) {
      debugPrint('Gagal kirim push notifikasi v1: $e');
    }
  }
}