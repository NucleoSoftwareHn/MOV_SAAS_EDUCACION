import 'dart:convert';

import '../../../core/network/api_client.dart';
import '../../../core/storage/storage_service.dart';
import '../../../models/features/auth/user_model.dart';

class AuthService {
  final ApiClient _api = ApiClient();
  final StorageService _storage = StorageService();

  Future<UserModel> login({
    required String usuario,
    required String password,
  }) async {
    final response = await _api.sendRequest('POST',
      '/Auth/v1/login_movil',
      body: {
        'P_USUARIO': usuario,
        'P_CONTRA': password,
      },
    );
     
 
    final token = response['token']?.toString();
    final refreshToken = response['refreshToken'].toString();
    if (token != null && token.isNotEmpty) {
      await _storage.saveTokens(token: token, refreshToken: refreshToken);
    }

    final userJson =  (response['data']); 
    if (userJson is Map<String, dynamic>) {
      return UserModel.fromJson(userJson);
    }
      return UserModel.fromJson(userJson);
  }

  Future<void> logout() async {
    await _storage.clearTokens();
  }
}
  