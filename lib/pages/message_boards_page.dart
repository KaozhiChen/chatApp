import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_window_page.dart';

class MessageBoardsPage extends StatelessWidget {
  const MessageBoardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message Boards"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('messageBoards').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final boards = snapshot.data!.docs;

          if (boards.isEmpty) {
            return const Center(
              child: Text("No Message Boards available."),
            );
          }

          return ListView.builder(
            itemCount: boards.length,
            itemBuilder: (context, index) {
              final board = boards[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.message), // 可替换为 board['icon']
                  title: Text(board['boardName']),
                  subtitle:
                      Text(board['description'] ?? "No description available"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatWindowPage(
                            boardId: board.id, boardName: board['boardName']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
