import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage/local_storage_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://chain-cacao-api.begeek.tg/api/v1', // URL fictive du backend FastAPI
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  // Intercepteur pour la gestion globale (Auth, Erreurs, etc.)
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Récupération du token d'authentification depuis le stockage sécurisé
      final token = await storage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onResponse: (response, handler) {
      return handler.next(response);
    },
    onError: (DioException e, handler) {
      if (e.response?.statusCode == 401) {
        // Gérer l'expiration de session
      }
      return handler.next(e);
    },
  ));

  // Configuration du logger premium pour le debug
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  ));

  return dio;
});
