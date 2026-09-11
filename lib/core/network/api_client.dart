import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';
import '../storage/storage_service.dart';

class ApiClient {
  final StorageService _storage = StorageService();
  bool _isRefreshing = false;

 Future<Map<String, dynamic>> sendRequest(
  String method,
  String path, 
  {
  Map<String, dynamic>? body,
  Map<String, String>? query,
  bool authenticated = false,
  bool isRetry = false
}) async {
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  if (authenticated) {
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
  }

  var uri = Uri.parse('${ApiConfig.baseUrl}$path');
  if (query != null && query.isNotEmpty) {
    uri = uri.replace(queryParameters: query);
  }

  http.Response response;
  final encodedBody = body != null ? jsonEncode(body) : null;

  switch (method.toUpperCase()) {
    case 'GET':
      response = await http.get(uri, headers: headers);
      break;
    case 'POST':
      response = await http.post(uri, headers: headers, body: encodedBody);
      break;
    case 'PUT':
      response = await http.put(uri, headers: headers, body: encodedBody);
      break;
    case 'DELETE':
      response = await http.delete(uri, headers: headers, body: encodedBody);
      break;
    default:
      throw Exception('Método HTTP no soportado: $method');
  }

  // -------------------------------------------------------------------------
  // Manejo de expiración de Token (401 Unauthorized)
  // -------------------------------------------------------------------------
  if (response.statusCode == 401 && authenticated && !isRetry) {
    final refreshed = await _refreshToken();

    if (refreshed) {
      // Reintentamos la misma petición con el nuevo token guardado
      return sendRequest(
        method,
        path,
        body: body,
        query: query,
        authenticated: authenticated,
        isRetry: true,
      );
    }
  }

  Map<String, dynamic> data = {};
  if (response.body.isNotEmpty) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      data = decoded;
    }
  }

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return data;
  }

  throw Exception('HTTP ${response.statusCode}: ${response.body}');
}

Future<bool> _refreshToken() async {
   if (_isRefreshing) return false;
  _isRefreshing = true;

  try {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

     final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/Auth/v1/refresh'), // Ajusta tu ruta
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['token'] ?? data['access_token'];

      if (newAccessToken != null) {
        await _storage.updateAccessToken(newAccessToken);
        return true;
      }
    }
  } catch (_) { 
  } finally {
    _isRefreshing = false;
  }

  await _storage.clearTokens();
  return false;
}


}
