import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/sync/sync_service.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'core/presentation/pages/main_navigation_shell.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Initialisation du service de synchronisation dès le lancement de l'app
    ref.listen(syncServiceProvider, (previous, next) {
      // Le service commence à écouter la connectivité automatiquement
    });

    return MaterialApp(
      title: 'ChainCacao',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown[900]!,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: authState.user != null
          ? const MainNavigationShell()
          : const LoginPage(),
    );
  }
}
