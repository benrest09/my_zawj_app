import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/chat_controller.dart';
import 'package:zawj_app/services/preference_handler.dart';

class GroupChatScreen extends StatefulWidget {
  final int ruangChatId;
  final String namaLawanBicara;

  GroupChatScreen({
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

  List<Map<String, dynamic>> _pesanList = [];
  bool _isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadPesan();
  }

  @override
  void dispose() {
    _pesanController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPesan() async {
    final userId = await PreferenceHandler.getUserId();
    final hasil = await _chatController.getPesanChat(widget.ruangChatId);

    if (!mounted) return;
    setState(() {
      _userId = userId;
      _pesanList = hasil;
      _isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _kirimPesan() async {
    if (_userId == null) return;
    if (_pesanController.text.trim().isEmpty) return;

    await _chatController.kirimPesan(
      ruangChatId: widget.ruangChatId,
      senderId: _userId!,
      pesan: _pesanController.text,
    );

    _pesanController.clear();
    await _loadPesan();
  }

  Widget _buildBubble(Map<String, dynamic> pesan) {
    final senderId = pesan['sender_id'] as int;
    final isiPesan = pesan['pesan']?.toString() ?? '';
    final isMe = senderId == _userId;

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
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        color: Colors.white,
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              child: IconButton(
                onPressed: _kirimPesan,
                icon: const Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.namaLawanBicara,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _pesanList.length,
                    itemBuilder: (context, index) {
                      return _buildBubble(_pesanList[index]);
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }
}
