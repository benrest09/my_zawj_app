import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/chat_controller.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/chat_group_screen.dart';
import 'package:zawj_app/services/preference_handler.dart';
import 'package:zawj_app/widgets/app_color.dart';

class UstadzChatScreen extends StatefulWidget {
  const UstadzChatScreen({super.key});

  @override
  State<UstadzChatScreen> createState() => _UstadzChatScreenState();
}

class _UstadzChatScreenState extends State<UstadzChatScreen> {
  final ChatController _chatController = ChatController();

  List<Map<String, dynamic>> _listChat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _listChat = [];
        _isLoading = false;
      });
      return;
    }

    final result = await _chatController.getDaftarChatUser(user.uid);

    if (!mounted) return;

    setState(() {
      _listChat = result;
      _isLoading = false;
    });
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        'Belum ada grup taaruf',
        style: GoogleFonts.montserrat(fontSize: 14, color: AppColor.abutua),
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    final namaIkhwan = item['nama_ikhwan'] ?? '-';
    final namaAkhwat = item['nama_akhwat'] ?? '-';
    final pesanTerakhir = item['pesan_terakhir'] ?? 'Belum ada pesan';
    final ruangChatId = item['ruang_chat_id'];

    return InkWell(
      onTap: () {
        context.push(
          GroupChatScreen(
            ruangChatId: ruangChatId,
            namaLawanBicara: '$namaIkhwan & $namaAkhwat',
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.groups, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$namaIkhwan & $namaAkhwat',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pesanTerakhir,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await PreferenceHandler.logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        title: Text(
          'Pendampingan Ustadz',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listChat.isEmpty
          ? _buildEmpty()
          : RefreshIndicator(
              onRefresh: _loadChat,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _listChat.length,
                itemBuilder: (context, index) {
                  return _buildItem(_listChat[index]);
                },
              ),
            ),
    );
  }
}
