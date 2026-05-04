import 'package:api_key/secreen/components/routers.dart';
import 'package:flutter/material.dart';
import 'package:api_key/secreen/components/appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    fname.dispose();
    lname.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    try {
      if (fname.text.isEmpty ||
          lname.text.isEmpty ||
          email.text.isEmpty ||
          password.text.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Allfields required!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
       final apiUrl = dotenv.env['API_URL'] ?? ''; 
      final response = await http.post(
        Uri.parse("http://$apiUrl:3000/user/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fname': fname.text,
          'lname': lname.text,
          'email': email.text,
          'password': password.text,
        }),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Register successfuly!"),
            backgroundColor: Colors.indigo,
          ),
        );
        Navigator.pushNamed(context, AppRouter.login);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error $e"), backgroundColor: Colors.red),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "Regiter page"),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                "Register Now",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                controller: fname,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "First Name",
                  hintText: "Enter your first name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                controller: lname,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Last Name",
                  hintText: "Enter your last name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                controller: password,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ElevatedButton(
                onPressed: () {
                  registerUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text("Register"),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.login);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: Text("Already have an account!"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
