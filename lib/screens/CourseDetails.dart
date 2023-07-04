import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailsPage extends StatefulWidget {
  final String slug;
  final String thumbnail;

  const CourseDetailsPage(
      {super.key, required this.slug, required this.thumbnail});

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late bool videoLoaded = false;
  late String videoUrl = 'https://www.youtube.com/watch?v=IieZRZIrNJQ';

  late YoutubePlayerController _controller;
  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ));

    super.initState();
  }

  Future<Map<String, dynamic>> _fetchCourseData() async {
    final response = await http.get(Uri.parse(
        'https://dhcourse-server.vercel.app/api/v1/course/${widget.slug}'));
    final jsonData = await json.decode(response.body);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            videoLoaded
                ? player
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(
                            0.0,
                            10.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: -6.0,
                        ),
                      ],
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.35),
                          BlendMode.multiply,
                        ),
                        image: NetworkImage(widget.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'About the course',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: _fetchCourseData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final courseData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          courseData['title'],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 17, 103, 109),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Amount: ₹${courseData['price'].toString()}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 32, 142, 98),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          courseData['description'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Lessons",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: courseData['videos'].map<Widget>((lesson) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                videoLoaded = true;
                              });
                              final videoId = YoutubePlayer.convertUrlToId(
                                  lesson['videoUrl']);
                              _controller.load(videoId!);
                              _controller.play();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 16, 100, 106),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 6),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(
                                      lesson['videoTitle'].toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Error loading course data',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Loading course data...',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  );
                }
              },
            ),
          ]),
        );
      },
    );
  }
}
