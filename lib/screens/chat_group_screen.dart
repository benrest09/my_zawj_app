import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zawj_app/controllers/chat_controller.dart';

class GroupChatScreen extends StatefulWidget {
  final String ruangChatId;
  final String namaLawanBicara;

  const GroupChatScreen({
    super.key,
    required this.ruangChatId,
    required this.namaLawanBicara,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final ChatController _chatController = ChatController();
  final TextEditingController _pesanController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _kirimPesan() async {
    if (_pesanController.text.trim().isEmpty) return;

    await _chatController.kirimPesan(
      ruangChatId: widget.ruangChatId,
      pesan: _pesanController.text,
    );

    _pesanController.clear();
  }

  Widget _buildBubble(Map<String, dynamic> pesan) {
    final senderId = pesan['senderId'] ?? '';
    final isiPesan = pesan['pesan'] ?? '';
    final isMe = senderId == FirebaseAuth.instance.currentUser?.uid;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.pink[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(isiPesan, style: GoogleFonts.poppins(fontSize: 14)),
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _pesanController,
                decoration: InputDecoration(
                  hintText: 'Tulis pesan...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            IconButton(onPressed: _kirimPesan, icon: const Icon(Icons.send)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pesanController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.namaLawanBicara)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatController.streamPesanChat(widget.ruangChatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildBubble(data);
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }
}
