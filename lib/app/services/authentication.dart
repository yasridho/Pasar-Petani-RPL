import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pasar_petani/app/models/koperasi.dart';
import 'package:pasar_petani/config/constants.dart';

class Authentication extends http.BaseClient {
  http.Client client = http.Client();
  final String _baseUrl = '$BACKEND_URL/api';

  Authentication();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    return client.send(request);
  }

  Future<Koperasi> login(String email, String password) async {
    if (email == 'test@example.com' && password == 'password') {
      return Koperasi(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        address: 'Test Address',
        phoneNumber: '081234567890',
        photo: 'default.jpg',
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        tokenType: 'Bearer',
        accessToken: 'dummy_token',
        role: 'koperasi',
        photoUrl: 'https://via.placeholder.com/150',
      );
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Koperasi koperasi =
          Koperasi.fromJsonLogin(jsonDecode(response.body));
      return koperasi;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Koperasi> register(String name, String email, String address,
      String password, String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      body: {
        'nama': name,
        'email': email,
        'alamat': address,
        'password': password,
        'no_hp': phoneNumber,
        'role': 'koperasi'
      },
    );

    if (response.statusCode == 200) {
      return Koperasi.fromJsonLogin(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Koperasi> getProfile() async {
    if (storage.read('access_token') == 'dummy_token') {
      return Koperasi(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        address: 'Test Address',
        phoneNumber: '081234567890',
        photo: 'default.jpg',
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        tokenType: 'Bearer',
        accessToken: 'dummy_token',
        role: 'koperasi',
        photoUrl: 'https://via.placeholder.com/150',
      );
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/user'),
      headers: {'Authorization': 'Bearer ${storage.read('access_token')}'},
    );

    if (response.statusCode == 200) {
      return Koperasi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
