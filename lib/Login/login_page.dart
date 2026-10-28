import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_scaffold.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Iniciar sesión con correo y contraseña
  Future<void> _login() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _userController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // AuthWrapper redirige automáticamente al HomePage
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Error: ${e.message}';
      // Las versiones nuevas de Firebase devuelven 'invalid-credential'
      // en vez de 'user-not-found' / 'wrong-password'.
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'Correo o contraseña incorrectos.';
      } else if (e.code == 'too-many-requests') {
        message = 'Demasiados intentos. Intenta de nuevo más tarde.';
      }
      showAuthMessage(context, message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Iniciar sesión con Google
  Future<void> _googleLogin() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return; // Usuario canceló

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (!mounted) return;
      showAuthMessage(context, 'Error al iniciar con Google: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.content_cut,
      title: 'Bienvenido',
      subtitle: 'Inicia sesión para gestionar tu barbería',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _userController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Por favor ingresa tu correo'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _login(),
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
                  icon: Icon(_obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Por favor ingresa tu contraseña'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading ? const ButtonSpinner() : const Text('Iniciar sesión'),
            ),
            const SizedBox(height: 16),
            const AuthDivider(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _loading ? null : _googleLogin,
              icon: const Icon(Icons.account_circle_outlined),
              label: const Text('Continuar con Google'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loading ? null : _goToRegister,
              child: const Text('¿No tienes cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
