import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:api_key/secreen/components/notification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  TextEditingController message = TextEditingController();
  List messages = [];
  String myId = "";
  String myName = "";
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadMyIdThenConnect();
  }

  Future<void> loadMyIdThenConnect() async {
    await loadMyId();
    await getMessages();
    connectToSocket();
  }

  Future<void> deletemessage(String id) async {
    try {
      final preter = await SharedPreferences.getInstance();
      final token = preter.getString('token');
      final apiUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.delete(
        Uri.parse('http://$apiUrl/chat/message/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          messages.removeWhere((msg) => msg['_id'] == id);
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Message delete successfully!"),
            backgroundColor: Colors.black,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  Future<void> loadMyId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      myId = prefs.getString('userId') ?? "";
      myName = prefs.getString('userName') ?? "";
    });
    print("👤 MY ID: $myId");
    print("👤 MY NAME: $myName");
  }

  void connectToSocket() {
    final apiUrl = dotenv.env['API_URL'] ?? '';
    socket = IO.io('http://$apiUrl:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print("✅ Socket connected");
      socket.emit('join', myId);
      print("✅ Joined room: $myId");
    });

    // ✅ chat messages
    socket.on('newmessage', (data) {
      if (!mounted) return;
      final senderId = data['sender']?.toString() ?? "";
      setState(() {
        messages.add({
          'message': data['message'],
          'sender': senderId,
          'receiver': data['receiver']?.toString() ?? "",
          'createdAt': data['createdAt'],
        });
      });
      if (senderId != myId) {
        showNotification(
          senderName: widget.receiverName,
          message: data['message'] ?? "",
        );
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    });
  }

  @override
  void dispose() {
    message.dispose();
    socket.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> getMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
final apiUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.get(
        Uri.parse("http://$apiUrl:3000/chat/messages/${widget.receiverId}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          messages = data['messages'];
          isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> sendMessage() async {
    if (message.text.trim().isEmpty) return;
    final text = message.text.trim();
    message.clear();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
final apiUrl = dotenv.env['API_URL'] ?? '';
      final response = await http.post(
        Uri.parse(
          "http://$apiUrl:3000/chat/sendmessage/${widget.receiverId}",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"mess": text}),
      );

      if (!mounted) return;
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed: ${response.body}"),
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

  String formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final min = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'pm' : 'am';
      return "$hour:$min $period";
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE7D9),
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54),
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                widget.receiverName[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "online",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF075E54)),
                  )
                : messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No messages yet",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          "Say hello! 👋",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      String senderId = '';
                      if (messages[i]['sender'] is Map) {
                        senderId = messages[i]['sender']['_id'].toString();
                      } else {
                        senderId = messages[i]['sender'].toString();
                      }
                      final isSender = senderId == myId;

                      return Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onLongPress: () async {
                            HapticFeedback.mediumImpact();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Delete"),
                                  content: Text("Are you want to delete"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        deletemessage(messages[i]['_id']);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Delete"),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            margin: EdgeInsets.symmetric(vertical: 3),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSender
                                  ? Color(0xFFDCF8C6)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: isSender
                                    ? Radius.circular(16)
                                    : Radius.circular(0),
                                bottomRight: isSender
                                    ? Radius.circular(0)
                                    : Radius.circular(16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${messages[i]['message']}",
                                  style: TextStyle(fontSize: 15),
                                ),

                                SizedBox(height: 3),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      formatTime(messages[i]['createdAt']),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (isSender) ...[
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.done_all,
                                        size: 14,
                                        color: Color(0xFF4FC3F7),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
            color: Color(0xFFEFE7D9),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: message,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        prefixIcon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Color(0xFF075E54),
                  child: IconButton(
                    onPressed: sendMessage,
                    icon: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
