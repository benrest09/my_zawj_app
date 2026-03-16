import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/widgets/app_color.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Ganti isi list ini jadi [] kalau mau lihat tampilan chat kosong
  final List<Map<String, dynamic>> chatRooms = [
    {
      "name": "Aisyah Rahmah",
      "gender": "Akhwat",
      "lastMessage": "Assalamu'alaikum, bagaimana kabarnya?",
      "time": "09:41",
    },
    {
      "name": "Ahmad Fauzan",
      "gender": "Ikhwan",
      "lastMessage": "InsyaAllah saya siap mengikuti sesi taaruf.",
      "time": "08:15",
    },
    {
      "name": "Ustadz Pendamping",
      "gender": "Ikhwan",
      "lastMessage": "Silakan jaga adab komunikasi selama proses taaruf.",
      "time": "Kemarin",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find My Zawj',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColor.pinktua,
              ),
            ),
            Text(
              'Pesan',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.abutua,
              ),
            ),
          ],
        ),
      ),
      body: chatRooms.isEmpty
          ? const _EmptyChat()
          : _ChatList(chatRooms: chatRooms),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.pink.shade50),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xffFFF4F8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 50,
                  color: AppColor.pinktua,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Belum ada percakapan',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.hitam,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Terima ajuan taaruf untuk memulai percakapan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: AppColor.abutua,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  final List<Map<String, dynamic>> chatRooms;

  const _ChatList({required this.chatRooms});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatRooms.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final chat = chatRooms[index];
        final isFemale =
            chat["gender"] == "Akhwat" || chat["gender"] == "akhwat";

        final avatarPath = isFemale
            ? "assets/images/avatar_akhwat.png"
            : "assets/images/avatar_ikhwan.png";

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.pink.shade50),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xffFFF4F8),
              backgroundImage: AssetImage(avatarPath),
            ),
            title: Text(
              chat["name"] ?? "",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColor.hitam,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                chat["lastMessage"] ?? "Belum ada pesan",
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppColor.abutua,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Text(
              chat["time"] ?? "",
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: AppColor.abutua,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
