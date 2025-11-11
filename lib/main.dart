import 'dart:io';

import 'package:enciphered_app/views/dashboard_screen.dart';
import 'package:enciphered_app/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'views/login_screen.dart';

SnackBar showWelcomeSnackbar(BuildContext context, String username) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Bem-Vindo $username',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        IconButton(
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.close, color: Colors.white, size: 40),
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Theme.of(context).colorScheme.secondary,
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // Inicializa o FFI
    databaseFactory = databaseFactoryFfi; // Define a fábrica de banco de dados
  }

  runApp(const LunacipherApp());
}

class LunacipherApp extends StatelessWidget {
  const LunacipherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lunacipher',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0F1F),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3A5BA0),
          secondary: Color(0xFF4C7DD1),
          secondaryContainer: Color.fromARGB(255, 68, 118, 203),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E2A4A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
