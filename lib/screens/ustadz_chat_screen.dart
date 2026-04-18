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

class _UstadzChatScreenState extends State<UstadzChatScreen>
    with SingleTickerProviderStateMixin {
  final ChatController _chatController = ChatController();

  // Tab: 0 = Grup Saya, 1 = Grup Tersedia (belum ada ustadz)
  late TabController _tabController;

  List<Map<String, dynamic>> _grupSaya = [];
  List<Map<String, dynamic>> _grupTersedia = [];
  bool _isLoadingGrupSaya = true;
  bool _isLoadingTersedia = true;
  String _namaUstadz = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNamaUstadz();
    _loadGrupSaya();
    _loadGrupTersedia();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Ambil nama ustadz dari Firestore
  Future<void> _loadNamaUstadz() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final data = await FirebaseService.getUserById(user.uid);
    if (!mounted) return;

    setState(() {
      _namaUstadz = data?.nama ?? user.email ?? 'Ustadz';
    });
  }

  // Grup yang sudah diikuti ustadz ini
  Future<void> _loadGrupSaya() async {
    setState(() => _isLoadingGrupSaya = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoadingGrupSaya = false);
      return;
    }

    final result = await _chatController.getDaftarChatUser(user.uid);

    if (!mounted) return;
    setState(() {
      _grupSaya = result;
      _isLoadingGrupSaya = false;
    });
  }

  // Grup yang belum punya ustadz — bisa diambil ustadz
  Future<void> _loadGrupTersedia() async {
    setState(() => _isLoadingTersedia = true);

    final result = await _chatController.getGrupTanpaUstadz();

    if (!mounted) return;
    setState(() {
      _grupTersedia = result;
      _isLoadingTersedia = false;
    });
  }

  // Ustadz gabung ke grup yang belum punya ustadz
  Future<void> _gabungGrup(String ruangChatId) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Gabung Grup',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah kamu yakin ingin menjadi pendamping grup taaruf ini?',
          style: GoogleFonts.montserrat(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Batal', style: TextStyle(color: AppColor.abutua)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Gabung', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    final error = await _chatController.ustadzGabungGrup(ruangChatId);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil bergabung ke grup!'),
        backgroundColor: Colors.green,
      ),
    );

    // Refresh kedua list
    _loadGrupSaya();
    _loadGrupTersedia();
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

  // ── Widget item untuk "Grup Saya" ──
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
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pesanTerakhir,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey.shade500,
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
                      color: Colors.grey.shade400,
                    ),
                  ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Widget item untuk "Grup Tersedia" (belum ada ustadz) ──
  Widget _buildItemGrupTersedia(Map<String, dynamic> item) {
    final namaIkhwan = item['nama_ikhwan'] ?? '-';
    final namaAkhwat = item['nama_akhwat'] ?? '-';
    final ruangChatId = item['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.orange.shade50,
            child: Icon(
              Icons.groups_outlined,
              color: Colors.orange.shade400,
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Belum ada pendamping ustadz',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.orange.shade400,
                  ),
                ),
              ],
            ),
          ),
          // Tombol gabung
          ElevatedButton(
            onPressed: () => _gabungGrup(ruangChatId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(
              'Dampingi',
              style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(String pesan) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.forum_outlined,
                size: 50,
                color: Colors.green.shade300,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              pesan,
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
                color: Colors.black87,
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
            tooltip: 'Keluar',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green,
          labelStyle: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'Grup Saya'),
            Tab(text: 'Grup Tersedia'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── TAB 1: Grup yang sudah diikuti ustadz ──
          RefreshIndicator(
            onRefresh: _loadGrupSaya,
            child: _isLoadingGrupSaya
                ? const Center(child: CircularProgressIndicator())
                : _grupSaya.isEmpty
                ? _buildEmpty(
                    'Kamu belum mendampingi grup taaruf.\nPergi ke tab "Grup Tersedia" untuk mulai mendampingi.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _grupSaya.length,
                    itemBuilder: (context, index) =>
                        _buildItemGrupSaya(_grupSaya[index]),
                  ),
          ),

          // ── TAB 2: Grup yang belum punya ustadz ──
          RefreshIndicator(
            onRefresh: _loadGrupTersedia,
            child: _isLoadingTersedia
                ? const Center(child: CircularProgressIndicator())
                : _grupTersedia.isEmpty
                ? _buildEmpty(
                    'Semua grup taaruf sudah punya pendamping ustadz.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _grupTersedia.length,
                    itemBuilder: (context, index) =>
                        _buildItemGrupTersedia(_grupTersedia[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
