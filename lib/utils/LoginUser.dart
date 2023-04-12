import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> loginUser(String email, String password) async {
  if (email == null || email.isEmpty) {
    throw 'Please enter your email';
  }
  if (password == null || password.isEmpty) {
    throw 'Please enter your password';
  }
  final response = await http.post(
    Uri.parse('https://dhcourse.digitiostack.co.in/api/v1/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON response and return the token.
    final responseData = jsonDecode(response.body);
    final token = responseData['token'];
    final username = responseData['user']['name'];
    final userId = responseData['user']['id'];
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('authToken', token);
    await prefs.setString('username', username);
    await prefs.setBool('userExists', true);
    await prefs.setString('userId', userId);
    return token;
  } else {
    final errorMessage = json.decode(response.body)['message'];
    throw errorMessage;
  }
}
