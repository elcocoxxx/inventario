import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home_page.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Escucha cambios de login
      builder: (context, snapshot) {
        // 1️⃣ Mientras carga el estado de autenticación
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2️⃣ Si ocurre un error en el stream
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Ocurrió un error al verificar la sesión",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          );
        }

        // 3️⃣ Si el usuario está autenticado → va a HomePage
        if (snapshot.hasData) {
          return const HomePage();
        }

        // 4️⃣ Si no hay sesión iniciada → va a LoginPage
        return const LoginPage();
      },
    );
  }
}

