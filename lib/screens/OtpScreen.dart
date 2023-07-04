import 'dart:convert';

import 'package:dh_course_application/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
  final String email;
  const OtpScreen({super.key, required this.email});
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> handleOtp() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse('https://dhcourse-server.vercel.app/api/v1/auth/verify-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'otpToken': otpController.text,
        'email': widget.email,
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      final authToken = json.decode(response.body)['token'];
      final username = json.decode(response.body)['name'];
      final userId = json.decode(response.body)['id'];
      final prefs = await SharedPreferences.getInstance();
      if (authToken) await prefs.setString('authToken', authToken);
      if (username) await prefs.setString('username', username);
      if (userId) await prefs.setString('userId', userId);
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      setState(() {
        _isLoading = false;
      });
      final error = json.decode(response.body)['message'];
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Type Your OTP here',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your OTP';
                      }
                      return null;
                    },
                    controller: otpController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'OTP'),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 15, 104, 151),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () {
                        handleOtp();
                      },
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("we have sent an email to your email"),
                Text(
                  " ${widget.email}",
                  style: const TextStyle(color: Colors.lightBlue),
                ),
              ],
            )
          ]),
        ),
      )),
    );
  }
}
