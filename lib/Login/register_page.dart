import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_scaffold.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Registro con correo y contraseña
  Future<void> _register() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      showAuthMessage(context, 'Registro exitoso.', error: false);
      // El usuario queda logueado: AuthWrapper cambia al HomePage,
      // pero esta pantalla sigue en la pila, así que la cerramos.
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Error: ${e.message}';
      if (e.code == 'weak-password') {
        message = 'La contraseña es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Este correo ya está registrado.';
      } else if (e.code == 'invalid-email') {
        message = 'El correo no es válido.';
      }
      showAuthMessage(context, message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Registro / inicio con Google
  Future<void> _registerWithGoogle() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // Usuario canceló

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      showAuthMessage(context, 'Registro/Inicio con Google exitoso.',
          error: false);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      showAuthMessage(context, 'Error al registrar con Google: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final toggle = IconButton(
      tooltip: _obscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
      icon: Icon(_obscure
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined),
      onPressed: () => setState(() => _obscure = !_obscure),
    );

    return AuthScaffold(
      icon: Icons.person_add_alt_1_rounded,
      title: 'Crear cuenta',
      subtitle: 'Regístrate para empezar a usar la app',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: toggle,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una contraseña';
                }
                if (value.length < 6) return 'Debe tener al menos 6 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _register(),
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
                prefixIcon: Icon(Icons.lock_reset_rounded),
              ),
              validator: (value) => value != _passwordController.text
                  ? 'Las contraseñas no coinciden'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _register,
              child: _loading ? const ButtonSpinner() : const Text('Registrarse'),
            ),
            const SizedBox(height: 16),
            const AuthDivider(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _loading ? null : _registerWithGoogle,
              icon: const Icon(Icons.account_circle_outlined),
              label: const Text('Registrarse con Google'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loading ? null : () => Navigator.pop(context),
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
