import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/social_login_button.dart';
import '../widgets/auth_glass_card.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Écoute des erreurs pour afficher un SnackBar
    ref.listen(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 40.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight -
                          80, // On enlève le padding du calcul
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AuthGlassCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AuthHeader(),
                              const SizedBox(height: 24),
                              // Instruction Text
                              const Text(
                                'Veuillez vous connecter pour accéder à votre espace sécurisé.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Email Field
                              AuthTextField(
                                controller: _emailController,
                                label: 'E-MAIL / TÉLÉPHONE',
                                hintText: 'Ex: +228 90 00 00 00',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              // Password Field
                              AuthTextField(
                                controller: _passwordController,
                                label: 'MOT DE PASSE',
                                hintText: '••••••••',
                                obscureText: !_isPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.brown[300],
                                  ),
                                  onPressed: () => setState(
                                    () => _isPasswordVisible =
                                        !_isPasswordVisible,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Mot de passe oublié ?',
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              // Login Button + Biometric Row
                              Row(
                                children: [
                                  Expanded(
                                    child: AuthButton(
                                      text: 'Se connecter',
                                      isLoading: authState.isLoading,
                                      onPressed: () => ref
                                          .read(authProvider.notifier)
                                          .login(
                                            _emailController.text,
                                            _passwordController.text,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.brown.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.fingerprint,
                                        color: Colors.brown,
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        // Logic for biometrics
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Register Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Pas encore de compte ?",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "S'inscrire",
                                      style: TextStyle(
                                        color: Colors.brown,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Divider
                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.black26),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'OU',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.black26),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Social Buttons
                              Row(
                                children: [
                                  const Expanded(
                                    child: SocialLoginButton(
                                      label: 'GOOGLE',
                                      assetPath: 'assets/images/google.png',
                                      color: Colors.white,
                                      textColor: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: SocialLoginButton(
                                      label: 'FACEBOOK',
                                      icon: Icons.facebook,
                                      color: const Color(0xFF1877F2),
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Footer
                        Column(
                          children: [
                            const Icon(Icons.eco, color: Colors.white70),
                            const SizedBox(height: 8),
                            Text(
                              'PARTENAIRE DU MINISTÈRE DE L\'AGRICULTURE DU TOGO',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFooterLink("CGU", () {}),
                                _buildFooterDivider(),
                                _buildFooterLink("Confidentialité", () {}),
                                _buildFooterDivider(),
                                _buildFooterLink("Aide", () {}),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        "|",
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 11,
        ),
      ),
    );
  }
}
