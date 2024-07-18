import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.0.60:8080';

  Future<void> initiateGoogleSignIn() async {
    final url = '$baseUrl/oauth2/authorization/google';
    final response = await http.get(Uri.parse(url));

    // Print the status code and response body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Google Sign-In initiated');
      // Optionally, parse the response body if it contains user info
      var responseData = json.decode(response.body);
      print('User Data: $responseData');
    } else {
      throw Exception('Failed to initiate Google Sign-In');
    }
  }
}
