import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/models/inbox_model.dart';
import 'package:zawj_app/widgets/app_color.dart';

class DetailInboxScreen extends StatelessWidget {
  final InboxModel item;

  const DetailInboxScreen({super.key, required this.item});

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return AppColor.pinktua;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'accepted':
        return 'Diterima';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.pinktua, size: 20),
          const SizedBox(width: 10),
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarPath = ((item.fotoProfil ?? '').isNotEmpty)
        ? item.fotoProfil!
        : (item.jenisKelamin == 'Akhwat'
              ? 'assets/images/akhwat.png'
              : 'assets/images/ikhwan.png');

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Detail Pengaju',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: AppColor.hitam,
          ),
        ),
        iconTheme: IconThemeData(color: AppColor.hitam),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
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
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFF4F8),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: AssetImage(avatarPath),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.namaLengkap,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColor.hitam,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${item.usia} tahun • ${item.domisili}',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: AppColor.abutua,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(item.status).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _statusLabel(item.status),
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _statusColor(item.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoTile(
                          icon: Icons.school_outlined,
                          label: 'Pendidikan',
                          value: item.pendidikan,
                        ),
                        _buildInfoTile(
                          icon: Icons.work_outline,
                          label: 'Pekerjaan',
                          value: item.pekerjaan,
                        ),
                        _buildInfoTile(
                          icon: Icons.person_outline,
                          label: 'Jenis Kelamin',
                          value: item.jenisKelamin,
                        ),
                        _buildInfoTile(
                          icon: Icons.location_on_outlined,
                          label: 'Domisili',
                          value: item.domisili,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFF9FB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.pink.shade50),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pesan Pengajuan',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.abutua,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.pesanPengajuan.isEmpty
                                    ? '-'
                                    : item.pesanPengajuan,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: AppColor.hitam,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
