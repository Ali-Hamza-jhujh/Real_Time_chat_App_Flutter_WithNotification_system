import 'package:api_key/secreen/components/appbar.dart';
import 'package:api_key/secreen/components/screenchat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Chatapp extends StatefulWidget {
  const Chatapp({super.key});

  @override
  State<Chatapp> createState() => _ChatappState();
}

class _ChatappState extends State<Chatapp> {
  List users = [];
  @override
  void initState() {
    super.initState();
    getusers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getusers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
final apiUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.get(
        Uri.parse("http://$apiUrl:3000/chat/allusers"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          users = data['users'];
        });
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
      backgroundColor: Color(0xFFEFE7D9),
      appBar: MyAppbar(title: "ChatApp"),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "All Contacts",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "${users.length} contacts",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: users.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: users.length,

                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text("${users[i]['fname'][0]}"),
                        ),
                        title: Text(
                          "${users[i]['fname']} ${users[i]['lname']}",
                        ),
                        subtitle: Text("${users[i]['email']}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                receiverId: users[i]['_id'],
                                receiverName:
                                    "${users[i]['fname']} ${users[i]['lname']}",
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
