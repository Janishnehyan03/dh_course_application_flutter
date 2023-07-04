import 'package:dh_course_application/screens/CourseDetails.dart';
import 'package:dh_course_application/screens/LoginScreen.dart';
import 'package:dh_course_application/screens/Payment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseCard extends StatefulWidget {
  final String title;
  final String price;
  final String slug;
  final String description;
  final String courseId;
  final List learners;
  final String thumbnail;
  const CourseCard(
      {super.key, required this.title,
      required this.price,
      required this.learners,
      required this.slug,
      required this.thumbnail,
      required this.courseId,
      required this.description});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  String userId = '';

  Future<String?> getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
   if(userId != null){
     setState(() {
      userId = userId;
    });
   }
    return userId;
  }

  @override
  void initState() {
    print(userId);
    // TODO: implement initState
    super.initState();
    getUserIdFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 225, 225, 225)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            width: MediaQuery.of(context).size.width,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 13, 71, 89)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              widget.description,
              style: const TextStyle(color: Color.fromARGB(255, 110, 109, 109)),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: ElevatedButton(
              onPressed: () {
                userExists().then((exists) => {
                      if (exists)
                        {
                          getUserIdFromSharedPreferences().then((value) => {
                                if (widget.learners.contains(value))
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CourseDetailsPage(
                                            slug: widget.slug,
                                            thumbnail: widget.thumbnail,
                                          ),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentScreen(
                                            courseId: widget.courseId,
                                            title: widget.title,
                                            thumbnail: widget.thumbnail,
                                            price: int.parse(widget.price),
                                          ),
                                        ))
                                  }
                              })
                        }
                      else
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          )
                        }
                    });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    widget.learners.contains(userId)
                        ? const Color.fromARGB(255, 81, 36, 192)
                        : const Color.fromARGB(255, 5, 57, 62)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              child: Text(widget.learners.contains(userId)
                  ? 'Learn Now'
                  : 'Buy Now ₹ ${widget.price}'),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> userExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool exists = prefs.getBool('userExists') ?? false;
    return exists;
  }
}
