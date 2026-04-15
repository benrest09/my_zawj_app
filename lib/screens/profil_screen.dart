import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/lengkapi_profil_screen.dart';
import 'package:zawj_app/screens/login_screen.dart';
import 'package:zawj_app/widgets/app_color.dart';
import 'package:zawj_app/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
        _profileData = null;
      });
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .get();

    final profile = doc.data();

    setState(() {
      _profileData = profile;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Konfirmasi Logout',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.pinktua),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _infoCard({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColor.pinktua, size: 20),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: AppColor.abutua,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: AppColor.hitam,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBelumLengkapCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 80,
              color: AppColor.pinktua,
            ),
            const SizedBox(height: 16),
            Text(
              "Profil Belum Lengkap",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.hitam,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Lengkapi profil terlebih dahulu agar kamu bisa menggunakan fitur taaruf dan mendapatkan pasangan yang sesuai.",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: AppColor.abutua,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            customButton(
              text: "Lengkapi Profil",
              width: double.infinity,
              onPressed: () async {
                await context.push(const LengkapiProfilScreen());
                if (!mounted) return;
                _loadProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    final data = _profileData!;

    return Column(
      children: [
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: AssetImage(
                    (data['foto_profil'] != null &&
                            data['foto_profil'].toString().isNotEmpty)
                        ? data['foto_profil'].toString()
                        : (data['jenis_kelamin'] == 'Akhwat'
                              ? 'assets/images/akhwat.png'
                              : 'assets/images/ikhwan.png'),
                  ),
                ),

                const SizedBox(height: 14),
                Text(
                  data['nama_lengkap'] ?? '-',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.hitam,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${data['jenis_kelamin'] ?? '-'} • ${data['usia']?.toString() ?? '-'} tahun",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: AppColor.abutua,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                customButton(
                  text: "Edit Profil",
                  width: double.infinity,
                  onPressed: () async {
                    await context.push(const LengkapiProfilScreen());
                    _loadProfile();
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _infoCard(
          label: "Tentang Saya",
          value: data['tentang_saya'] ?? '-',
          icon: Icons.notes_outlined,
        ),
        _infoCard(
          label: "Domisili",
          value: data['domisili'] ?? '-',
          icon: Icons.location_on_outlined,
        ),
        _infoCard(
          label: "Suku",
          value: data['suku'] ?? '-',
          icon: Icons.people_outline,
        ),
        _infoCard(
          label: "Kewarganegaraan",
          value: data['kewarganegaraan'] ?? '-',
          icon: Icons.flag_outlined,
        ),
        _infoCard(
          label: "Pendidikan",
          value: data['pendidikan'] ?? '-',
          icon: Icons.school_outlined,
        ),
        _infoCard(
          label: "Pekerjaan",
          value: data['pekerjaan'] ?? '-',
          icon: Icons.work_outline,
        ),
        _infoCard(
          label: "Bidang Pekerjaan",
          value: data['bidang_pekerjaan'] ?? '-',
          icon: Icons.business_center_outlined,
        ),
        _infoCard(
          label: "Target Menikah",
          value: data['target_nikah'] ?? '-',
          icon: Icons.favorite_outline,
        ),
        _infoCard(
          label: "Status Pernikahan",
          value: data['status_nikah'] ?? '-',
          icon: Icons.people_alt_outlined,
        ),
        _infoCard(
          label: "Sholat",
          value: data['sholat'] ?? '-',
          icon: Icons.menu_book_outlined,
        ),
        _infoCard(
          label: "Kajian Rutin",
          value: data['kajian_rutin'] ?? '-',
          icon: Icons.mosque_outlined,
        ),
        _infoCard(
          label: "Hafalan Al-Quran",
          value: data['hafalan_quran'] ?? '-',
          icon: Icons.auto_stories_outlined,
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 350,
          height: 55,
          child: ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              "Logout",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool profileLengkap =
        _profileData != null && _profileData!['is_profile_complete'] == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: AppColor.hitam,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xfffafafa),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  profileLengkap
                      ? _buildProfileContent()
                      : _buildBelumLengkapCard(),
                ],
              ),
            ),
    );
  }
}
