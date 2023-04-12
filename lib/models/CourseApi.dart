import 'dart:convert';

import 'package:dh_course_application/const.dart';
import 'package:dh_course_application/models/CourseModel.dart';
import 'package:http/http.dart' as http;

class CourseApi {
  static Future<List<Course>> getCourses() async {
    var uri = Uri.parse(
      "${baseUrl}/course",
    );
    final response = await http.get(
      uri,
    );
    Map data = jsonDecode(response.body);
    
    List temp = [];
    for (var i in data['courses']) {
      temp.add(i);
    }
    return Course.coursesFromSnapShot(temp);
  }
  static Future<List<Course>> getOneCourse({courseId}) async {
    var uri = Uri.parse(
      "${baseUrl}/course/${courseId}",
    );
    final response = await http.get(
      uri,
    );
    Map data = jsonDecode(response.body);
    
    List temp = [];
    for (var i in data['course']) {
      temp.add(i);
    }
    return Course.coursesFromSnapShot(temp);
  }
}
