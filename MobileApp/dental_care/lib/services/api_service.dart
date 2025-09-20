import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8001';

  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final url = Uri.parse('$baseUrl/content/articles');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articles = data['articles'] as List<dynamic>?;
      if (articles == null) return [];
      return articles.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to fetch articles');
    }
  }

  Future<Map<String, dynamic>> predictNormal(String imagePath) async {
    final url = Uri.parse('$baseUrl/predict/normal');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to predict normal image');
    }
  }

  Future<Map<String, dynamic>> predictNormalWeb(Uint8List imageBytes,
      {String filename = 'image.jpg'}) async {
    final url = Uri.parse('$baseUrl/predict/normal');
    final request = http.MultipartRequest('POST', url)
      ..files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: filename));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to predict normal image (web)');
    }
  }

  Future<Map<String, dynamic>> predictXray(String imagePath) async {
    final url = Uri.parse('$baseUrl/predict/xray');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to predict xray image');
    }
  }

  Future<Map<String, dynamic>> predictXrayWeb(Uint8List imageBytes,
      {String filename = 'image.jpg'}) async {
    final url = Uri.parse('$baseUrl/predict/xray');
    final request = http.MultipartRequest('POST', url)
      ..files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: filename));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to predict xray image (web)');
    }
  }

  Future<List<Map<String, dynamic>>> nearbyClinics(String city) async {
    final url = Uri.parse('$baseUrl/clinics?location=$city');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final clinics = data['clinics'] as List<dynamic>?;
      return clinics?.cast<Map<String, dynamic>>() ?? [];
    } else {
      throw Exception('Failed to fetch clinics');
    }
  }

  // User signup
  Future<Map<String, dynamic>> signup(String email, String password,
      {String? name}) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        if (name != null) 'name': name,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(json.decode(response.body)['detail'] ?? 'Signup failed');
    }
  }

  // User login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(json.decode(response.body)['detail'] ?? 'Login failed');
    }
  }
}

class ChatbotResponse {
  final String reply;
  ChatbotResponse({required this.reply});
  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(reply: json['reply'] ?? '');
  }
}

extension ApiServiceChatbot on ApiService {
  Future<ChatbotResponse> sendChatMessage(String message) async {
    final url = Uri.parse('${ApiService.baseUrl}/chatbot/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': message}),
    );
    if (response.statusCode == 200) {
      return ChatbotResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get chatbot reply');
    }
  }
}
