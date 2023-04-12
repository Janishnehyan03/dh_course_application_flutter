import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: appBarHeight,
            child: AppBar(
              backgroundColor: Color.fromARGB(255, 9, 96, 104),
              title: Text('My App'),
              centerTitle: true,
            ),
          );
        }
        final sharedPreferences = snapshot.data!;
        final userName = sharedPreferences.getString('username');
        return SizedBox(
          height: appBarHeight,
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 9, 96, 104),
            title: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'My App',
                    style: TextStyle(fontSize: 24),
                  ),
                  if (userName != null)
                    Text(
                      userName,
                      style: TextStyle(fontSize: 18),
                    ),
                ],
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              if (userName != null)
                GestureDetector(
                  onTap: () => _showProfileDialog(context, userName),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CircleAvatar(
                      child: Text(userName[0]),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  void _showProfileDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                child: Text(
                  userName[0],
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'user@example.com',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
