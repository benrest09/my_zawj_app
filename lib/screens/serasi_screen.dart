import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/serasi_controller.dart';
import 'package:zawj_app/database/sqflite.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/models/serasi_model.dart';
import 'package:zawj_app/screens/detail_serasi_screen.dart';
import 'package:zawj_app/services/preference_handler.dart';
import 'package:zawj_app/widgets/app_color.dart';

class SerasiScreen extends StatefulWidget {
  const SerasiScreen({super.key});

  @override
  State<SerasiScreen> createState() => _SerasiScreenState();
}

class _SerasiScreenState extends State<SerasiScreen> {
  final SerasiController _controller = SerasiController();

  List<SerasiModel> _profiles = [];
  bool _isLoading = true;
  String _jenisKelamin = 'Ikhwan';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadSerasi();
  }

  Future<void> _loadSerasi() async {
    setState(() {
      _isLoading = true;
    });

    final userId = await PreferenceHandler.getUserId();

    if (userId == null) {
      setState(() {
        _profiles = [];
        _isLoading = false;
      });
      return;
    }

    final myProfile = await DBHelper.getProfileByUserId(userId);
    final myGender = myProfile?['jenis_kelamin'] ?? 'Ikhwan';

    final profiles = await _controller.getSerasiProfiles(
      currentUserId: userId,
      currentGender: myGender,
    );

    if (!mounted) return;

    setState(() {
      _userId = userId;
      _jenisKelamin = myGender;
      _profiles = profiles;
      _isLoading = false;
    });
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffFFF4F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.pink.shade50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColor.pinktua),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: AppColor.hitam,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(SerasiModel profile) {
    final avatarPath =
        (profile.fotoProfil != null && profile.fotoProfil!.isNotEmpty)
        ? profile.fotoProfil!
        : (profile.jenisKelamin == 'Akhwat'
              ? 'assets/images/avatar_akhwat.png'
              : 'assets/images/avatar_ikhwan.png');

    return GestureDetector(
      onTap: () {
        context.push(DetailSerasiScreen(profile: profile));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.pink.shade50),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xffFFF4F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage(avatarPath),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.namaLengkap,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.hitam,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${profile.usia} tahun • ${profile.domisili}',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColor.abutua,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(Icons.school_outlined, profile.pendidikan),
                      _buildInfoChip(Icons.work_outline, profile.pekerjaan),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.tentangSaya,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppColor.hitam,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(DetailSerasiScreen(profile: profile));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.pinktua,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Lihat Detail',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada profil yang serasi',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.hitam,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba lagi nanti setelah lebih banyak pengguna melengkapi profil mereka.',
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
              'Temukan pasangan yang serasi',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColor.abutua,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profiles.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadSerasi,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _profiles.length,
                itemBuilder: (context, index) {
                  return _buildProfileCard(_profiles[index]);
                },
              ),
            ),
    );
  }
}
