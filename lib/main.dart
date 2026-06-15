import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'screens/sensei/main_navigation.dart';
import 'screens/siswa/main_navigation.dart';
import 'services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  runApp(const TanohsiiApp());
}

class TanohsiiApp extends StatelessWidget {
  const TanohsiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tanoshii APP",
      theme: AppTheme.lightTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            // Jika sudah login, kita perlu cek rolenya sebentar untuk menentukan halaman
            return FutureBuilder<String>(
              future: AuthService().getUserRole(snapshot.data!.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                // Gunakan nilai default jika snapshot.data masih null
                String role = roleSnapshot.data ?? 'Pelajar';

                return role.contains('Pelajar')
                    ? const MainNavigation()
                    : const SenseiNavigation();
              },
            );
          }
          return const SplashScreen(); // Belum login, ke Splash lalu ke Login
        },
      ),
    );
  }
}
