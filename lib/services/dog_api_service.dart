import 'dart:convert';

import 'package:http/http.dart' as http;

class DogApiService {
  static const String _url =
      'https://dog.ceo/api/breeds/image/random/6';

  Future<List<String>> fetchDogImages() async {
    final response = await http.get(
      Uri.parse(_url),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['status'] == 'success') {
        return List<String>.from(data['message'] as List);
      }
    }

    throw Exception('Failed to load dog images from the API.');
  }
}
