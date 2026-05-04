import 'package:flutter/material.dart';
class Profile  extends StatelessWidget {
  const Profile ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   body: Center(
    child: Hero(tag: "Profile_image", child: CircleAvatar(backgroundImage: AssetImage("assets/images/image1.JPG"),radius: 100,)),
   ),
    );
  }
}