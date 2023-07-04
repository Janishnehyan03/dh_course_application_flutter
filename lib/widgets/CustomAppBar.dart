import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                "https://seeklogo.com/images/U/udemy-wordmark-logo-5BA74BCA61-seeklogo.com.png",
                width: 100,
                height: 100,
                color: Colors.black,
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () => {},
              ),
            ],
          ),
          Text(
            "Welcome, Janish Nehyan!",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(100); // Set the desired height of the app bar
}
