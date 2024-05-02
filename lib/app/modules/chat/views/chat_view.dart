import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mekanik/app/data/data_endpoint/history.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../main.dart';
import '../../../componen/color.dart';
import '../../../componen/loading_shammer_booking.dart';
import '../../../data/data_endpoint/kategory.dart';
import '../../../data/endpoint.dart';
import '../../../tester/tester_kategori.dart';

class ChatView extends StatelessWidget {
  final List<User> users = [
    User(name: 'Irwan', profileImage: 'https://example.com/alice.jpg'),
    User(name: 'Dayat', profileImage: 'https://example.com/bob.jpg'),
  ];

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: null
      ),
      appBar: AppBar(
        centerTitle: false,
        title: const Text('User List'),
      ),
      body:  Column(
        children: [
          FutureBuilder(
            future: API.kategoriID(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState != ConnectionState.waiting &&
                  snapshot.data != null) {
                Kategori getDataAcc =
                    snapshot.data ?? DataKategoriKendaraan();
                return Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 475),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: getDataAcc.dataKategoriKendaraan != null
                        ? getDataAcc.dataKategoriKendaraan!
                        .map((e) {
                      return Datakategori(
                        items: e,
                        onTap: () {},
                      );
                    })
                        .toList()
                        : [Container()],
                  ),
                );
              } else {
                return SizedBox(
                  height: Get.height - 250,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [],
                    ),
                  ),
                );
              }
            },
          ),

        ])
  );


      // ListView.builder(
      //   itemCount: users.length,
      //   itemBuilder: (context, index) {
      //     final user = users[index];
      //     return ListTile(
      //       leading: CircleAvatar(
      //         backgroundImage: NetworkImage(user.profileImage),
      //       ),
      //       title: Text(user.name),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => ChatScreen(user: user)),
      //         );
      //       },
      //     );
      //   },
      // ),

  }
}

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.profileImage),
            ),
            const SizedBox(width: 8),
            Text(widget.user.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  message: message,
                  isMe: message.isMe,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _messages.add(Message(text: _controller.text, isMe: true));
                        _controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String name;
  final String profileImage;

  User({required this.name, required this.profileImage});
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              message.text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
