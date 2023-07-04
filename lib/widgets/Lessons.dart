import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DetailCourse extends StatelessWidget {
  final Map<String, dynamic> course;
  final Map<String, dynamic> courseData;
  final bool userExists;
  final int currentVideoIndex;
  final List<int> durations;
  final String userId;
  final Function(int) setCurrentVideoIndex;
  final List<String> videoTitles;
  final List<String> thumbnails;

  DetailCourse({
    required this.course,
    required this.courseData,
    required this.userExists,
    required this.currentVideoIndex,
    required this.durations,
    required this.userId,
    required this.setCurrentVideoIndex,
    required this.videoTitles,
    required this.thumbnails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            courseData['title'],
            style: styles['courseTitle'],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 9),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(40),
              color: Color(0xFFF1F1F1),
            ),
            child: Row(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1607990281513-2c110a25bd8c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=934&q=80',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Text(
                  course['creator']['name'],
                  style: styles['username'],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'About The Course',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum',
              style: styles['courseDescription'],
            ),
          ),
          if (userExists && course['learners'].contains(userId))
            Column(
              children: List.generate(
                courseData['videos'].length,
                (index) => Lessons(
                  currentVideoIndex: currentVideoIndex,
                  index: index,
                  durations: durations,
                  formatDuration: (p0) => {},
                  setCurrentVideoIndex: setCurrentVideoIndex,
                  videoTitles: videoTitles,
                  thumbnails: thumbnails,
                ),
              ),
            )
          else
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Column(
                children: List.generate(
                  courseData['videos'].length,
                  (index) => GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFC9C9C9)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lesson ${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F7D89),
                            ),
                          ),
                          Text(
                            courseData['videos'][index]['videoTitle'],
                            style: styles['title'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Lessons extends StatelessWidget {
  final int currentVideoIndex;
  final int index;
  final List<int> durations;
  final Function(int) formatDuration;
  final Function(int) setCurrentVideoIndex;
  final List<String> videoTitles;
  final List<String> thumbnails;

  Lessons({
    required this.currentVideoIndex,
    required this.index,
    required this.durations,
    required this.formatDuration,
    required this.setCurrentVideoIndex,
    required this.videoTitles,
    required this.thumbnails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setCurrentVideoIndex(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFC9C9C9)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lesson ${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F7D89),
              ),
            ),
            Text(
              videoTitles[index],
              style: styles['title'],
            ),
          ],
        ),
      ),
    );
  }
}

final Map<String, TextStyle> styles = {
  'card': TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    color: Color(0xFF124E56),
  ),
  'title': TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    color: Color(0xFF124E56),
  ),
  'username': TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF333333),
  ),
  'courseTitle': TextStyle(
    fontSize: 30,
    color: Color(0xFF103977),
    fontWeight: FontWeight.bold,
  ),
  'courseDescription': TextStyle(
    fontSize: 14,
    color: Colors.grey,
    height: 1.5,
    letterSpacing: 0.5,
  ),
};
