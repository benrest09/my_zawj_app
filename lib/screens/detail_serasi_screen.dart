import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/serasi_controller.dart';
import 'package:zawj_app/models/serasi_model.dart';
import 'package:zawj_app/widgets/app_color.dart';

class DetailSerasiScreen extends StatefulWidget {
  final SerasiModel profile;

  const DetailSerasiScreen({super.key, required this.profile});

  @override
  State<DetailSerasiScreen> createState() => _DetailSerasiScreenState();
}

class _DetailSerasiScreenState extends State<DetailSerasiScreen> {
  final TextEditingController _messageController = TextEditingController();
  final SerasiController _controller = SerasiController();

  bool _isSubmitting = false;

  Future<void> _submitTaaruf() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan tulis pesan untuk ajuan taaruf')),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User tidak ditemukan')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final validationMessage = await _controller.validateAjukanTaaruf(
      pengajuId: userId,
      targetId: widget.profile.uid,
    );

    if (validationMessage != null) {
      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationMessage)));
      return;
    }

    try {
      await _controller.submitTaarufRequest(
        targetId: widget.profile.uid.toString(),
        pesanPengajuan: _messageController.text.trim(),
      );

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ajuan Terkirim',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            'Ajuan taaruf berhasil dikirim. Mohon tunggu respon dari user terkait.',
            style: GoogleFonts.montserrat(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: AppColor.pinktua,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim ajuan taaruf')),
      );
    }
  }

  Widget _buildSection(String title, {String? content, Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.pink.shade50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.hitam,
            ),
          ),
          const SizedBox(height: 12),
          if (content != null && content.isNotEmpty)
            Text(
              content,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: AppColor.hitam,
                height: 1.6,
              ),
            ),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColor.abutua,
              ),
            ),
          ),
          Expanded(
            child: Text(
              ': $value',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppColor.hitam,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    final avatarPath =
        (profile.fotoProfil != null && profile.fotoProfil!.isNotEmpty)
        ? profile.fotoProfil!
        : (profile.jenisKelamin == 'Akhwat'
              ? 'assets/images/avatar_akhwat.png'
              : 'assets/images/avatar_ikhwan.png');

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 238, 246),
        elevation: 0,
        title: Text(
          'Detail Serasi',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: AppColor.hitam,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xffFFF4F8),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.pink.shade50),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage(avatarPath),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    profile.namaLengkap,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColor.hitam,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${profile.usia} tahun • ${profile.domisili}',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColor.abutua,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildSection('Tentang Saya', content: profile.tentangSaya),

            const SizedBox(height: 16),

            _buildSection(
              'Biodata Singkat',
              child: Column(
                children: [
                  _buildInfoRow('Pendidikan', profile.pendidikan),
                  _buildInfoRow('Pekerjaan', profile.pekerjaan),
                  _buildInfoRow('Jenis Kelamin', profile.jenisKelamin),
                  _buildInfoRow('Domisili', profile.domisili),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffFFF4F8),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.pink.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ajukan Taaruf',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.hitam,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tulis pesan perkenalan dengan sopan dan singkat.',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppColor.abutua,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Assalamu'alaikum, perkenalkan saya...",
                      hintStyle: GoogleFonts.montserrat(
                        color: AppColor.abutua,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColor.pinktua),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitTaaruf,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        _isSubmitting ? 'Mengirim...' : 'Ajukan Taaruf',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.pinktua,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
