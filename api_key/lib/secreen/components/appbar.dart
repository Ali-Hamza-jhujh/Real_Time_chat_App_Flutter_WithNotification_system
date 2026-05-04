import 'package:api_key/secreen/components/login.dart';
import 'package:flutter/material.dart';
class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MyAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return
      AppBar(
        backgroundColor: Colors.indigo,
        title:Text(title,style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.search,color: Colors.white,),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.login,color: Colors.white,),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
            },
          ),
        ],
      ) ;

  }
  @override
  Size get preferredSize =>Size.fromHeight(kToolbarHeight);
}
