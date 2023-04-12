import 'package:dh_course_application/screens/CourseDetails.dart';
import 'package:dh_course_application/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String price;
  final String slug;
  final String description;
  final String thumbnail;
  CourseCard(
      {required this.title,
      required this.price,
      required this.slug,
      required this.thumbnail,
      required this.description});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 225, 225, 225)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            width: MediaQuery.of(context).size.width,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: Offset(
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
                image: NetworkImage(thumbnail),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 13, 71, 89)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              description,
              style: TextStyle(color: Color.fromARGB(255, 110, 109, 109)),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: ElevatedButton(
              onPressed: () {
                userExists().then((exists) => {
                      if (exists)
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailsPage(
                                  slug: slug,
                                  thumbnail: thumbnail,
                                ),
                              ))
                        }
                      else
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          )
                        }
                    });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 5, 57, 62)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              child: Text('Buy Now ₹ ${price}'),
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
