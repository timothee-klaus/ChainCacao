import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/storage/local_storage_service.dart';
import '../../data/models/user_model.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

/// Configuration de l'injection de dépendances via Riverpod

// Source de données
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  // Mode MOCK activé pour le moment comme demandé
  return MockAuthRemoteDataSource();
});

// Repository (on l'expose via son interface pour respecter Clean Architecture)
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return AuthRepositoryImpl(dataSource, storage);
});

// Use Case
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// État de l'authentification
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier gérant l'état UI et appelant obligatoirement le Use Case
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final LocalStorageService localStorageService;

  AuthNotifier(this.loginUseCase, this.localStorageService) : super(AuthState()) {
    // Vérification automatique au démarrage
    checkAuth();
  }

  /// Vérifie si une session existe localement
  Future<void> checkAuth() async {
    final token = await localStorageService.getToken();
    final userData = await localStorageService.getUserData();

    if (token != null && userData != null) {
      try {
        final user = UserModel.fromJson(jsonDecode(userData)).toEntity();
        state = state.copyWith(user: user);
      } catch (e) {
        // En cas d'erreur de parsing, on nettoie tout
        await logout();
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    // Appel direct au Use Case (pas au repository !)
    final result = await loginUseCase(email, password);
    
    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error),
      (user) => state = state.copyWith(isLoading: false, user: user),
    );
  }

  /// Déconnexion et nettoyage du stockage
  Future<void> logout() async {
    await localStorageService.clearAll();
    state = AuthState();
  }
}

// Global Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return AuthNotifier(loginUseCase, storage);
});
