import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resep.dart';
import '../models/resep_detail.dart';

class ApiService {
  static const String _baseUrl =  'https://www.themealdb.com/api/json/v1/1'; 

  static Future<List<Resep>> getResep(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?c=$category')); 

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>; 
      final List rawList = data['meals']; 
      return rawList.map((e) => Resep.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat resep');
  }

  static Future<ResepDetail?> getResepDetail(String nama) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?s=$nama')); 

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body); 
      final List? rawList = data['meals']; 

      if(rawList == null || rawList.isEmpty) return null; 

      return ResepDetail.fromJson(rawList[0]);
    } else {
      throw Exception("Gagal memuat detail resep");
    }
  }
}