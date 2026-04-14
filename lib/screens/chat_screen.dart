import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/database/sqflite.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/chat_group_screen.dart';
import 'package:zawj_app/services/preference_handler.dart';
import 'package:zawj_app/widgets/app_color.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Ganti isi list ini jadi [] kalau mau lihat tampilan chat kosong
  List<Map<String, dynamic>> _daftarChat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    setState(() {
      _isLoading = true;
    });

    final userId = await PreferenceHandler.getUserId();
    if (userId == null) {
      if (!mounted) return;
      setState(() {
        _daftarChat = [];
        _isLoading = false;
      });
      return;
    }

    final hasil = await DBHelper.getDaftarChatUser(userId);
    if (!mounted) return;
    setState(() {
      _daftarChat = hasil;
      _isLoading = false;
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Belum ada percakapan',
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final nama = chat['nama_lawan_bicara']?.toString() ?? 'Tanpa Nama';
    final gender = chat['jenis_kelamin_lawan_bicara']?.toString() ?? '';
    final pesanTerakhir =
        chat['pesan_terakhir']?.toString() ?? 'Belum ada pesan';

    final isAkhwat = gender == 'Akhwat';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(
            isAkhwat ? 'assets/images/akhwat.png' : 'assets/images/ikhwan.png',
          ),
        ),
        title: Text(
          nama,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          pesanTerakhir,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
        ),
        onTap: () {
          context.push(
            GroupChatScreen(
              ruangChatId: chat['ruang_chat_id'] as int,
              namaLawanBicara: nama,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Pesan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColor.pinktua,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _daftarChat.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadChat,
              child: ListView.builder(
                itemCount: _daftarChat.length,
                itemBuilder: (context, index) {
                  return _buildChatItem(_daftarChat[index]);
                },
              ),
            ),
    );
  }
}
