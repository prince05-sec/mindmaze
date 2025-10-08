import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/community_provider.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final communityProvider = Provider.of<CommunityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Community Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: communityProvider.messages.length,
              itemBuilder: (ctx, i) {
                final msg = communityProvider.messages[i];
                return ListTile(
                  title: Text(msg.isAnonymous ? "Anonymous" : msg.userId),
                  subtitle: Text(msg.message),
                  trailing: Text(
                    "${msg.timestamp.hour}:${msg.timestamp.minute}",
                  ),
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
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    try {
                      communityProvider.sendMessage(
                          "user123", _controller.text);
                      _controller.clear();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
