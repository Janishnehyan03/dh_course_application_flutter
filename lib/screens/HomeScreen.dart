import 'dart:convert';
import 'package:dh_course_application/widgets/CustomAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:dh_course_application/models/CourseApi.dart';
import 'package:dh_course_application/models/CourseModel.dart';
import 'package:dh_course_application/widgets/CourseCards.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _data = [];
  List<Course> courses = [];

  bool isLoading = true;
  String usename = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourses();
    getUser();
  }

  Future<void> getCourses() async {
    var uri = Uri.parse(
      "${baseUrl}/course",
    );
    final response = await http.get(uri);
    final jsonData = json.decode(response.body)['courses'];
    setState(() {
      _data = jsonData;
      isLoading = false;
    });
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    setState(() {
      usename = username!;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(courses);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 40,
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _data.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CourseCard(
                          title: _data[index]['title'],
                          price: _data[index]['price'].toString(),
                          slug: _data[index]['slug'],
                          thumbnail: _data[index]['thumbnail'],
                          description: _data[index]['description'],
                        );
                      }),
            ]),
          ),
        ),
      ),
    );
  }
}
