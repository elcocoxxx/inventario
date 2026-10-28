import 'package:flutter/material.dart';

import '../shared/theme/app_colors.dart';

/// Marco visual común para Login y Registro:
/// fondo con imagen oscurecida + tarjeta centrada de ancho máximo.
class AuthScaffold extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const AuthScaffold({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/velas.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withAlpha(170),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                    decoration: BoxDecoration(
                      color: AppColors.card.withAlpha(235),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(120),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.soft(AppColors.primary),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(icon,
                                size: 32, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Snackbar de feedback para pantallas de autenticación.
void showAuthMessage(BuildContext context, String message,
    {bool error = true}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppColors.danger : AppColors.success,
      ),
    );
}

/// Separador "o" entre el botón principal y los alternativos.
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('o',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}

/// Spinner pequeño para dentro de un botón.
class ButtonSpinner extends StatelessWidget {
  const ButtonSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: AppColors.onPrimary,
      ),
    );
  }
}
