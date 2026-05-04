import 'package:api_key/secreen/components/routers.dart';
import 'package:flutter/material.dart';
import 'package:api_key/secreen/components/home.dart';
import 'package:api_key/secreen/components/voicerecoder.dart';
import 'package:api_key/secreen/components/login.dart';
import 'package:api_key/secreen/components/states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_key/secreen/components/charapp.dart';

class Drawer_page extends StatelessWidget {
  const Drawer_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.indigo,
      shadowColor: Colors.white,
      width: 200,
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text(
                "Home",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                if (setLogin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                    (route) => false,
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.voice_chat, color: Colors.white),
              title: Text(
                "Testing",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                if (setLogin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Voice()),
                  );
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                    (route) => false,
                  );
                }
              },
            ),
             ListTile(
              leading: Icon(Icons.chat, color: Colors.white),
              title: Text(
                "Chatapp",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                if (setLogin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chatapp()),
                  );
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                    (route) => false,
                  );
                }
              },
            ),
            Spacer(),
            Divider(
              color: Colors.white54,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              height: 20,
            ),
            !setLogin
                ? ListTile(
                    leading: Icon(Icons.login, color: Colors.white),
                    title: Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.logout, color: Colors.white),

                    title: Text(
                      "Logout",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onTap: () async {
                      final prefer = await SharedPreferences.getInstance();
                      await prefer.remove('token');
                      setLogin = false;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.login,
                        (route) => false,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
