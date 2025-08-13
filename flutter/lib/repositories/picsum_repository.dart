import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/picsum_photo.dart';

class PicsumRepository {
  static const String _baseUrl = 'https://picsum.photos';

  Future<List<PicsumPhoto>> getPhotos({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/v2/list?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => PicsumPhoto.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load photos: $e');
    }
  }

  Future<PicsumPhoto> getPhotoById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/id/$id/info'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return PicsumPhoto.fromJson(json);
      } else {
        throw Exception('Failed to load photo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load photo: $e');
    }
  }

  String getPhotoUrl(String id, {int width = 300, int height = 300}) {
    return '$_baseUrl/$width/$height?random=$id';
  }
}
