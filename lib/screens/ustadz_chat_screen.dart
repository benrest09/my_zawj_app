import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/chat_controller.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/chat_group_screen.dart';
import 'package:zawj_app/screens/login_screen.dart';
import 'package:zawj_app/services/firebase_service.dart';
import 'package:zawj_app/widgets/app_color.dart';

class UstadzChatScreen extends StatefulWidget {
  const UstadzChatScreen({super.key});

  @override
  State<UstadzChatScreen> createState() => _UstadzChatScreenState();
}

class _UstadzChatScreenState extends State<UstadzChatScreen> {
  final ChatController _chatController = ChatController();

  List<Map<String, dynamic>> _grupSaya = [];
  bool _isLoading = true;
  String _namaUstadz = '';

  @override
  void initState() {
    super.initState();
    _loadNamaUstadz();
    _loadGrupSaya();
  }

  // Ambil nama ustadz
  Future<void> _loadNamaUstadz() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final data = await FirebaseService.getUserById(user.uid);

    if (!mounted) return;

    setState(() {
      _namaUstadz = data?.nama ?? user.email ?? 'Ustadz';
    });
  }

  // Load grup yang otomatis sudah di-assign
  Future<void> _loadGrupSaya() async {
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    final result = await _chatController.getDaftarChatUser(user.uid);

    if (!mounted) return;

    setState(() {
      _grupSaya = result;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Keluar',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah kamu yakin ingin keluar?',
          style: GoogleFonts.montserrat(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Batal', style: TextStyle(color: AppColor.abutua)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _buildItemGrupSaya(Map<String, dynamic> item) {
    final namaIkhwan = item['nama_ikhwan'] ?? '-';
    final namaAkhwat = item['nama_akhwat'] ?? '-';
    final pesanTerakhir = item['lastMessage'] ?? 'Belum ada pesan';
    final ruangChatId = item['id'];

    final updatedAt = item['updatedAt'];
    String waktu = '';

    if (updatedAt != null) {
      try {
        final dt = (updatedAt as dynamic).toDate() as DateTime;
        final now = DateTime.now();
        waktu = dt.day == now.day
            ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
            : '${dt.day}/${dt.month}';
      } catch (_) {}
    }

    return InkWell(
      onTap: () {
        context.push(
          GroupChatScreen(
            ruangChatId: ruangChatId,
            namaLawanBicara: '$namaIkhwan & $namaAkhwat',
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              radius: 26,
              backgroundColor: Colors.green.shade100,
              child: const Icon(
                Icons.groups_rounded,
                color: Colors.green,
                size: 28,
              ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (waktu.isNotEmpty)
                  Text(
                    waktu,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              'Belum ada grup taaruf yang kamu dampingi.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: AppColor.abutua,
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
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pendampingan Ustadz',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Assalamu'alaikum, $_namaUstadz",
              style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded, color: Colors.red),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadGrupSaya,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _grupSaya.isEmpty
            ? _buildEmpty()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _grupSaya.length,
                itemBuilder: (context, index) =>
                    _buildItemGrupSaya(_grupSaya[index]),
              ),
      ),
    );
  }
}
