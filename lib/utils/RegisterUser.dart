import 'dart:convert';
import 'package:dh_course_application/screens/OtpScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> registerUser(String email, String password, String name,
    String confirmPassword, BuildContext context) async {
  if (name == null || name.isEmpty) {
    throw 'Please enter your name';
  }
  if (confirmPassword != password) {
    throw 'Passwords do not match';
  }
  if (confirmPassword == null || confirmPassword.isEmpty) {
    throw 'Please enter your confirm password';
  }
  if (email == null || email.isEmpty) {
    throw 'Please enter your email';
  }
  if (password == null || password.isEmpty) {
    throw 'Please enter your password';
  }
  final response = await http.post(
    Uri.parse('https://dhcourse.digitiostack.co.in/api/v1/auth/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'name': name,
      'password': password,
    }),
  );
  if (response.statusCode == 201) {
    final email = json.decode(response.body)['user']['email'];

    Navigator.push(
      context as BuildContext,
      MaterialPageRoute(
        builder: (context) => OtpScreen(email: email),
      ),
    );
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    final error = json.decode(response.body)['message'];
    throw error;
  }
}
