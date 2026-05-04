import 'package:api_key/secreen/components/routers.dart';
import 'package:flutter/material.dart';
import 'package:api_key/secreen/components/appbar.dart';
import 'package:api_key/secreen/components/states.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isppasswordVisible = false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> sentLoginData() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All fields required!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
      final apiUrl = dotenv.env['API_URL'] ?? ''; 
      print("login request send $apiUrl");
    try {
      final response = await http
          .post(
            Uri.parse('http://$apiUrl:3000/user/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email.text, 'password': password.text}),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              print("URL: http://$apiUrl:3000/user/login");
              throw Exception('Connection timed out - is the server running?');
            },
          );
      print("login request send");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        print("login successfull");
        final prefer = await SharedPreferences.getInstance();
        await prefer.setString('token', token);
        await prefer.setString('userId', data['userId']);

        await prefer.setString('userName', '${data['fname']} ${data['lname']}');

        setLogin = true;
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRouter.home);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wrong username or password!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppbar(title: "Login page"),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          child: Column(
            children: [
              Text(
                "Login Here",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "Enter username",
                  labelText: "username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                obscureText: !_isppasswordVisible,
                controller: password,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Enter password",
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isppasswordVisible = !_isppasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isppasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: Text("Forgot Password?"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ElevatedButton(
                onPressed: () {
                  sentLoginData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text("Login"),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.register);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: Text("Do'not have an account"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
