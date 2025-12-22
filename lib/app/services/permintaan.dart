import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pasar_petani/app/models/barang.dart';
import 'package:pasar_petani/app/models/status.dart';
import 'package:pasar_petani/config/constants.dart';

class Permintaan extends http.BaseClient {
  http.Client client = http.Client();
  final String _baseUrl = '$BACKEND_URL/api';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${storage.read('access_token')}'
  };

  Permintaan();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return client.send(request);
  }

  Future<List<Barang>> getAll() async {
    if (storage.read('access_token') == 'dummy_token') {
      return [
        Barang(
          id: 1,
          idPetani: 1,
          idKoperasi: 1,
          kategori: 'Sayur',
          harga: 5000,
          berat: 100,
          jumlah: 10,
          durasiTahan: '7 hari',
          foto: 'bayam.png',
          fotoUrl: 'https://via.placeholder.com/150',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          name: 'Bayam',
          description: 'Bayam segar langsung dari petani',
          petani: {'nama': 'Petani A', 'alamat': 'Desa A'},
          koperasi: {'nama': 'Koperasi A'},
          status: [],
        ),
        Barang(
          id: 2,
          idPetani: 2,
          idKoperasi: 1,
          kategori: 'Sayur',
          harga: 10000,
          berat: 200,
          jumlah: 5,
          durasiTahan: '5 hari',
          foto: 'brokoli.png',
          fotoUrl: 'https://via.placeholder.com/150',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          name: 'Brokoli',
          description: 'Brokoli hijau segar',
          petani: {'nama': 'Petani B', 'alamat': 'Desa B'},
          koperasi: {'nama': 'Koperasi A'},
          status: [
            Status(
              id: 1,
              idPermintaan: '2',
              tglPerubahan: DateTime.now(),
              status: 'diproses',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              keterangan: 'Sedang diproses',
            )
          ],
        ),
        Barang(
          id: 3,
          idPetani: 3,
          idKoperasi: 1,
          kategori: 'Kacang',
          harga: 15000,
          berat: 500,
          jumlah: 20,
          durasiTahan: '1 bulan',
          foto: 'kacang-merah.png',
          fotoUrl: 'https://via.placeholder.com/150',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          name: 'Kacang Merah',
          description: 'Kacang merah berkualitas',
          petani: {'nama': 'Petani C', 'alamat': 'Desa C'},
          koperasi: {'nama': 'Koperasi A'},
          status: [
            Status(
              id: 2,
              idPermintaan: '3',
              tglPerubahan: DateTime.now(),
              status: 'diterima',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              keterangan: 'Sudah diterima',
            )
          ],
        ),
      ];
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/permintaan'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['data'].isEmpty) {
        return [];
      }
      return List<Barang>.from(
          jsonDecode(response.body)['data'].map((x) => Barang.fromJson(x)));
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Barang> detail(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/permintaan/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Barang.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
