import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/chat_controller.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/chat_group_screen.dart';
import 'package:zawj_app/widgets/app_color.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = ChatController();

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message_outlined, size: 72, color: AppColor.abutua),
            SizedBox(height: 16),
            Text(
              'Belum ada percakapan',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.hitam,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada group taaruf bersama calonmu.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppColor.abutua,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final nama = chat['namaLawanBicara']?.toString() ?? 'Tanpa Nama';
    final gender = chat['jenisKelaminLawanBicara']?.toString() ?? '';
    final pesanTerakhir = chat['lastMessage']?.toString() ?? 'Belum ada pesan';
    final isGroupTaaruf = chat['isGroupTaaruf'] == true;

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
          backgroundColor: isGroupTaaruf ? Colors.green.shade100 : null,
          backgroundImage: isGroupTaaruf
              ? null
              : AssetImage(
                  isAkhwat
                      ? 'assets/images/akhwat.png'
                      : 'assets/images/ikhwan.png',
                ),
          child: isGroupTaaruf
              ? const Icon(Icons.groups_rounded, color: Colors.green)
              : null,
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
              ruangChatId: chat['id'] as String,
              namaLawanBicara: nama,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        title: Column(
          children: [
            Row(
              children: [
                Text(
                  'Pesan',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE76CA3),
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 239, 97, 144),
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
      body: user == null
          ? _buildEmptyState()
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatController.streamDaftarChatUser(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _buildEmptyState();
                }

                final daftarChat = snapshot.data ?? [];

                if (daftarChat.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: daftarChat.length,
                  itemBuilder: (context, index) {
                    return _buildChatItem(daftarChat[index]);
                  },
                );
              },
            ),
    );
  }
}
