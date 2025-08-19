class ApiService {
  // TODO: replace with real endpoints using http/dio
  // Keeping signatures so UI won’t change when backend is ready.

  Future<Map<String, dynamic>> predictNormal(String imagePath) async {
    throw UnimplementedError('Connect backend here');
  }

  Future<Map<String, dynamic>> predictXray(String imagePath) async {
    throw UnimplementedError('Connect backend here');
  }

  Future<List<Map<String, dynamic>>> nearbyClinics(String query) async {
    throw UnimplementedError('Connect backend here');
  }
}
