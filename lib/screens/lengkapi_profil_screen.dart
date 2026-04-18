import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zawj_app/controllers/lengkapi_profil_controller.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/models/profile_model.dart';
import 'package:zawj_app/screens/navbar.dart';
import 'package:zawj_app/widgets/app_color.dart';
import 'package:zawj_app/widgets/custom_button.dart';
import 'package:zawj_app/widgets/custom_textfield.dart';

class LengkapiProfilScreen extends StatefulWidget {
  const LengkapiProfilScreen({super.key});

  @override
  State<LengkapiProfilScreen> createState() => _LengkapiProfilScreenState();
}

class _LengkapiProfilScreenState extends State<LengkapiProfilScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final LengkapiProfilController _profilController = LengkapiProfilController();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _domisiliController = TextEditingController();
  final TextEditingController _sukuController = TextEditingController();
  final TextEditingController _kewarganegaraanController =
      TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _bidangPekerjaanController =
      TextEditingController();
  final TextEditingController _penghasilanController = TextEditingController();
  final TextEditingController _tentangSayaController = TextEditingController();
  final TextEditingController _kajianRutinController = TextEditingController();
  final TextEditingController _jumlahAnakController = TextEditingController();

  String? _fotoProfilPath;
  String _jenisKelamin = 'Ikhwan';
  String _pendidikan = 'SD';
  String _targetNikah = '< 6 bulan';
  String _statusNikah = 'Belum menikah';
  String _mauPoligami = 'Ya, saya bersedia';
  String _sholat = 'Selalu tepat waktu';
  String _hafalanQuran = 'Juz 30';
  String _panjangHijab = 'Tidak Berhijab';

  bool _waliTahu = false;
  bool _bersediaPindah = false;
  bool _punyaAnak = false;
  bool _bercadar = false;

  bool _setujuTidakKomunikasiDiluarSistem = false;
  bool _setujuSatuTaarufSatuWaktu = false;
  bool _setujuKebijakanPrivasi = false;

  String? _fotoKtpPath;
  String? _akteCeraiPath;
  String? _buktiSedekahPath;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadDataProfil();
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _tanggalLahirController.dispose();
    _usiaController.dispose();
    _tempatLahirController.dispose();
    _domisiliController.dispose();
    _sukuController.dispose();
    _kewarganegaraanController.dispose();
    _pekerjaanController.dispose();
    _bidangPekerjaanController.dispose();
    _penghasilanController.dispose();
    _tentangSayaController.dispose();
    _kajianRutinController.dispose();
    _jumlahAnakController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pilihAvatar() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Foto Profil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _fotoProfilPath = 'assets/images/ikhwan.png';
                      });
                      Navigator.pop(context);
                    },
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            'assets/images/ikhwan.png',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Ikhwan'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _fotoProfilPath = 'assets/images/akhwat.png';
                      });
                      Navigator.pop(context);
                    },
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            'assets/images/akhwat.png',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Akhwat'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pilihTanggalLahir() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final now = DateTime.now();
      int usia = now.year - pickedDate.year;

      if (now.month < pickedDate.month ||
          (now.month == pickedDate.month && now.day < pickedDate.day)) {
        usia--;
      }

      setState(() {
        _tanggalLahirController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/"
            "${pickedDate.month.toString().padLeft(2, '0')}/"
            "${pickedDate.year}";
        _usiaController.text = usia.toString();
      });
    }
  }

  Future<String?> _pilihFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path!;
    }
    return null;
  }

  Future<String?> _ambilFotoDariKamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      return image.path;
    }
    return null;
  }

  Future<void> _pilihSumberDokumen({
    required Function(String path) onSelected,
  }) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await _ambilFotoDariKamera();
                  if (path != null) {
                    setState(() {
                      onSelected(path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Pilih dari Device'),
                onTap: () async {
                  Navigator.pop(context);
                  final path = await _pilihFile();
                  if (path != null) {
                    setState(() {
                      onSelected(path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pilihSumberKtp() async {
    await _pilihSumberDokumen(
      onSelected: (path) {
        _fotoKtpPath = path;
      },
    );
  }

  Future<void> _pilihSumberAkteCerai() async {
    await _pilihSumberDokumen(
      onSelected: (path) {
        _akteCeraiPath = path;
      },
    );
  }

  Future<void> _pilihSumberBuktiSedekah() async {
    await _pilihSumberDokumen(
      onSelected: (path) {
        _buktiSedekahPath = path;
      },
    );
  }

  Widget _buildUploadItem({
    required String title,
    required String? filePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_file, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _getFileLabel(filePath),
                    style: TextStyle(fontSize: 12, color: AppColor.abutua),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<String?> _uploadFileToFirebase({
    required String path,
    required String folder,
    required String fileName,
  }) async {
    try {
      File file = File(path);

      final ref = FirebaseStorage.instance.ref().child('$folder/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() {});

      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint("UPLOAD ERROR: $e");
      return null;
    }
  }

  bool _isRemoteFile(String? path) {
    if (path == null || path.isEmpty) return false;
    return path.startsWith('http://') || path.startsWith('https://');
  }

  String _getFileLabel(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return "Klik untuk upload";
    }

    if (_isRemoteFile(filePath)) {
      final uri = Uri.tryParse(filePath);
      final segments = uri?.pathSegments ?? const <String>[];
      if (segments.isNotEmpty) {
        return segments.last;
      }
      return "Dokumen sudah tersimpan";
    }

    final normalizedPath = filePath.replaceAll('\\', '/');
    return normalizedPath.split('/').last;
  }

  Future<String?> _uploadDokumenJikaPerlu({
    required String? currentPath,
    required String folder,
    required String fileName,
  }) async {
    if (currentPath == null || currentPath.isEmpty) {
      return null;
    }

    if (_isRemoteFile(currentPath)) {
      return currentPath;
    }

    return _uploadFileToFirebase(
      path: currentPath,
      folder: folder,
      fileName: fileName,
    );
  }

  void _isiFormDariProfile(ProfileModel profile, {String? namaRegister}) {
    _fotoProfilPath = profile.fotoProfil;
    _namaLengkapController.text =
        (profile.namaLengkap != null && profile.namaLengkap!.trim().isNotEmpty)
        ? profile.namaLengkap!
        : (namaRegister ?? '');
    _tanggalLahirController.text = profile.tanggalLahir ?? '';
    _usiaController.text = profile.usia?.toString() ?? '';
    _tempatLahirController.text = profile.tempatLahir ?? '';
    _domisiliController.text = profile.domisili ?? '';
    _sukuController.text = profile.suku ?? '';
    _kewarganegaraanController.text = profile.kewarganegaraan ?? '';
    _pekerjaanController.text = profile.pekerjaan ?? '';
    _bidangPekerjaanController.text = profile.bidangPekerjaan ?? '';
    _penghasilanController.text = profile.penghasilan ?? '';
    _tentangSayaController.text = profile.tentangSaya ?? '';
    _kajianRutinController.text = profile.kajianRutin ?? '';
    _jumlahAnakController.text = profile.jumlahAnak ?? '';

    _jenisKelamin = profile.jenisKelamin ?? 'Ikhwan';
    _pendidikan = profile.pendidikan ?? 'SD';
    _targetNikah = profile.targetNikah ?? '< 6 bulan';
    _statusNikah = profile.statusNikah ?? 'Belum menikah';
    _mauPoligami = profile.mauPoligami ?? 'Ya, saya bersedia';
    _sholat = profile.sholat ?? 'Selalu tepat waktu';
    _hafalanQuran = profile.hafalanQuran ?? 'Juz 30';
    _panjangHijab = profile.panjangHijab ?? 'Tidak Berhijab';
    _waliTahu = profile.waliTahu;
    _bersediaPindah = profile.bersediaPindah;
    _punyaAnak = profile.punyaAnak;
    _bercadar = profile.bercadar;
    _setujuTidakKomunikasiDiluarSistem = profile.setujuTidakKomunikasi;
    _setujuSatuTaarufSatuWaktu = profile.setujuSatuTaaruf;
    _setujuKebijakanPrivasi = profile.setujuKebijakan;
    _fotoKtpPath = profile.fotoKtp;
    _akteCeraiPath = profile.akteCerai;
    _buktiSedekahPath = profile.buktiSedekah;
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.pink[300], size: 30),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }

  Widget _buildSpacingField({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label),
        child,
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildYesNoRadio({
    required bool groupValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<bool>(
            title: const Text("Ya"),
            value: true,
            groupValue: groupValue,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: const Color.fromARGB(255, 255, 119, 164),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: RadioListTile<bool>(
            title: const Text("Tidak"),
            value: false,
            groupValue: groupValue,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: const Color.fromARGB(255, 255, 119, 164),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxPersetujuan({
    required bool value,
    required String title,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile(
      value: value,
      onChanged: (newValue) => onChanged(newValue ?? false),
      activeColor: AppColor.pinktua,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildPendidikanKarirSection() {
    return _buildSectionCard(
      icon: Icons.school,
      title: "Pendidikan & Karir",
      children: [
        _buildSpacingField(
          label: "Pendidikan Terakhir",
          child: DropdownButtonFormField<String>(
            initialValue: _pendidikan,
            items: ['SD', 'SMP', 'SMA', 'S1', 'S2', 'S3'].map((value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              if (newValue == null) return;
              setState(() {
                _pendidikan = newValue;
              });
            },
          ),
        ),
        _buildSpacingField(
          label: "Pekerjaan",
          child: TextFormField(
            controller: _pekerjaanController,
            decoration: customTextField(hintText: "Pekerjaan"),
          ),
        ),
        _buildSpacingField(
          label: "Bidang Pekerjaan",
          child: TextFormField(
            controller: _bidangPekerjaanController,
            decoration: customTextField(hintText: "Bidang Pekerjaan"),
          ),
        ),
        _buildSpacingField(
          label: "Kisaran Penghasilan (Optional)",
          child: TextFormField(
            controller: _penghasilanController,
            decoration: customTextField(hintText: "Kisaran Penghasilan"),
          ),
        ),
      ],
    );
  }

  Widget _buildPemahamanAgamaSection() {
    return _buildSectionCard(
      icon: Icons.menu_book,
      title: "Pemahaman Agama",
      children: [
        _buildSpacingField(
          label: "Bagaimana sholatnya?",
          child: DropdownButtonFormField<String>(
            decoration: customTextField(hintText: "Rutinitas Sholat"),
            initialValue: _sholat,
            items: [
              'Selalu tepat waktu',
              'Sering tepat waktu',
              'Kadang-kadang',
              'Jarang',
            ].map((value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              if (newValue == null) return;
              setState(() {
                _sholat = newValue;
              });
            },
          ),
        ),
        _buildSpacingField(
          label: "Apakah mengikuti kajian rutin?",
          child: TextFormField(
            controller: _kajianRutinController,
            decoration: customTextField(
              hintText: "Jika iya, kajian apa dan dimana",
            ),
          ),
        ),
        _buildSpacingField(
          label: "Hafalan Al-Quran",
          child: DropdownButtonFormField<String>(
            decoration: customTextField(hintText: "Hafalan Al-Qur'an"),
            initialValue: _hafalanQuran,
            items: [
              'Juz 30',
              '1-5 Juz',
              '6-10 Juz',
              '11-20 Juz',
              '21-30 Juz',
              '30 Juz',
            ].map((value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              if (newValue == null) return;
              setState(() {
                _hafalanQuran = newValue;
              });
            },
          ),
        ),
        _buildFieldLabel("Apakah Bercadar"),
        _buildYesNoRadio(
          groupValue: _bercadar,
          onChanged: (value) {
            setState(() {
              _bercadar = value;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildSpacingField(
          label: "Panjang Hijab",
          child: DropdownButtonFormField<String>(
            decoration: customTextField(hintText: "Panjang hijab"),
            initialValue: _panjangHijab,
            items: [
              'Tidak Berhijab',
              'Lilit leher',
              'Menutupi dada',
              'Menutupi perut',
              'Menutupi lutut',
            ].map((value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              if (newValue == null) return;
              setState(() {
                _panjangHijab = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDokumenSection() {
    return _buildSectionCard(
      icon: Icons.description,
      title: "Upload Dokumen",
      children: [
        _buildUploadItem(
          title: "Foto KTP",
          filePath: _fotoKtpPath,
          onTap: _pilihSumberKtp,
        ),
        if (_statusNikah == 'Cerai Hidup' || _statusNikah == 'Cerai Mati') ...[
          const SizedBox(height: 12),
          _buildUploadItem(
            title: _statusNikah == 'Cerai Hidup'
                ? "Akte Cerai"
                : "Akte Kematian",
            filePath: _akteCeraiPath,
            onTap: _pilihSumberAkteCerai,
          ),
        ],
        const SizedBox(height: 12),
        _buildUploadItem(
          title: "Bukti Sedekah",
          filePath: _buktiSedekahPath,
          onTap: _pilihSumberBuktiSedekah,
        ),
      ],
    );
  }

  Widget _buildPersetujuanSection() {
    return _buildSectionCard(
      icon: Icons.assignment_turned_in,
      title: "Persetujuan & Kebijakan",
      children: [
        _buildCheckboxPersetujuan(
          value: _setujuTidakKomunikasiDiluarSistem,
          title: "Saya siap tidak berkomunikasi diluar sistem",
          onChanged: (value) {
            setState(() {
              _setujuTidakKomunikasiDiluarSistem = value;
            });
          },
        ),
        _buildCheckboxPersetujuan(
          value: _setujuSatuTaarufSatuWaktu,
          title: "Setuju jika hanya satu kali taaruf dalam satu waktu",
          onChanged: (value) {
            setState(() {
              _setujuSatuTaarufSatuWaktu = value;
            });
          },
        ),
        _buildCheckboxPersetujuan(
          value: _setujuKebijakanPrivasi,
          title: "Menyetujui kebijakan privasi dan aturan aplikasi",
          onChanged: (value) {
            setState(() {
              _setujuKebijakanPrivasi = value;
            });
          },
        ),
      ],
    );
  }

  Future<void> _simpanProfil() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User tidak ditemukan")));
      return;
    }

    final errorMessage = _profilController.validasiProfil(
      namaLengkap: _namaLengkapController.text,
      tanggalLahir: _tanggalLahirController.text,
      tempatLahir: _tempatLahirController.text,
      domisili: _domisiliController.text,
      pekerjaan: _pekerjaanController.text,
      setujuTidakKomunikasi: _setujuTidakKomunikasiDiluarSistem,
      setujuSatuTaaruf: _setujuSatuTaarufSatuWaktu,
      setujuKebijakan: _setujuKebijakanPrivasi,
      statusNikah: _statusNikah,
      akteCeraiPath: _akteCeraiPath,
    );

    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final ktpUrl = await _uploadDokumenJikaPerlu(
        currentPath: _fotoKtpPath,
        folder: 'ktp',
        fileName: '$userId.jpg',
      );
      final akteUrl = await _uploadDokumenJikaPerlu(
        currentPath: _akteCeraiPath,
        folder: 'akte',
        fileName: '$userId.jpg',
      );
      final sedekahUrl = await _uploadDokumenJikaPerlu(
        currentPath: _buktiSedekahPath,
        folder: 'sedekah',
        fileName: '$userId.jpg',
      );

      final profile = ProfileModel(
        uid: userId,
        fotoProfil: _fotoProfilPath,
        namaLengkap: _namaLengkapController.text.trim(),
        jenisKelamin: _jenisKelamin,
        tanggalLahir: _tanggalLahirController.text.trim(),
        usia: int.tryParse(_usiaController.text),
        tempatLahir: _tempatLahirController.text.trim(),
        domisili: _domisiliController.text.trim(),
        suku: _sukuController.text.trim(),
        kewarganegaraan: _kewarganegaraanController.text.trim(),
        pendidikan: _pendidikan,
        pekerjaan: _pekerjaanController.text.trim(),
        bidangPekerjaan: _bidangPekerjaanController.text.trim(),
        penghasilan: _penghasilanController.text.trim(),
        targetNikah: _targetNikah,
        statusNikah: _statusNikah,
        mauPoligami: _mauPoligami,
        sholat: _sholat,
        kajianRutin: _kajianRutinController.text.trim(),
        hafalanQuran: _hafalanQuran,
        panjangHijab: _panjangHijab,
        tentangSaya: _tentangSayaController.text.trim(),
        jumlahAnak: _jumlahAnakController.text.trim(),
        waliTahu: _waliTahu,
        bersediaPindah: _bersediaPindah,
        punyaAnak: _punyaAnak,
        bercadar: _bercadar,
        setujuTidakKomunikasi: _setujuTidakKomunikasiDiluarSistem,
        setujuSatuTaaruf: _setujuSatuTaarufSatuWaktu,
        setujuKebijakan: _setujuKebijakanPrivasi,
        fotoKtp: ktpUrl,
        akteCerai: akteUrl,
        buktiSedekah: sedekahUrl,
      );

      final result = await _profilController.simpanProfil(
        uid: userId,
        profile: profile,
      );

      if (result != null) throw Exception(result);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profil berhasil disimpan")));

      context.pushAndRemoveAll(const Navbar());
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan profil")));
    }
  }

  Future<void> _loadDataProfil() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final profile = await _profilController.loadProfil(userId);
    final namaRegister = await _profilController.loadNamaRegister(userId);

    if (profile == null) {
      if (!mounted) return;

      setState(() {
        _namaLengkapController.text = namaRegister ?? '';
      });
      return;
    }

    setState(() {
      _isiFormDariProfile(profile, namaRegister: namaRegister);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(255, 250, 238, 246),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Text(
                  'Find My Zawj',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 119, 164),
                    fontSize: 30,
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
            Text(
              'Lengkapi Profil',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.abutua,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.pink[300], size: 30),
                          const SizedBox(width: 6),
                          const Text(
                            "Foto Profil",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: _pilihAvatar,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: _fotoProfilPath != null
                                    ? AssetImage(_fotoProfilPath!)
                                    : null,
                                child: _fotoProfilPath == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.pinktua,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Center(
                        child: Text(
                          "Klik foto untuk memilih avatar",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.pink[300],
                            size: 25,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Informasi Dasar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Nama Lengkap",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _namaLengkapController,
                        decoration: customTextField(hintText: "Nama Lengkap"),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Jenis Kelamin",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _jenisKelamin,
                        items: ['Ikhwan', 'Akhwat'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue == null) return;
                          setState(() {
                            _jenisKelamin = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tanggal Lahir",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: _pilihTanggalLahir,
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: _tanggalLahirController,
                                  decoration: customTextField(
                                    hintText: "dd/mm/yyyy",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _usiaController,
                              decoration: customTextField(hintText: "Usia"),
                              keyboardType: TextInputType.number,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tempat Lahir",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _tempatLahirController,
                        decoration: customTextField(hintText: "Tempat Lahir"),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Domisili",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _domisiliController,
                        decoration: customTextField(hintText: "Domisili"),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Asal Suku",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _sukuController,
                        decoration: customTextField(
                          hintText: "Suku atau Etnis",
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Kewarganegaraan",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _kewarganegaraanController,
                        decoration: customTextField(
                          hintText: "Kewarganegaraan",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildPendidikanKarirSection(),

              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.favorite_outline, color: Colors.pink[300]),
                          const SizedBox(width: 8),
                          const Text(
                            "Kesiapan Menikah",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Target menikah dalam",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _targetNikah,
                        items:
                            [
                              '< 6 bulan',
                              '6 bulan - 1 tahun',
                              '1 - 2 tahun',
                              '> 2 tahun',
                              'Belum ditentukan',
                            ].map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          if (newValue == null) return;
                          setState(() {
                            _targetNikah = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Apakah wali sudah mengetahui?",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text("Ya"),
                              value: true,
                              groupValue: _waliTahu,
                              onChanged: (value) {
                                setState(() {
                                  _waliTahu = value ?? false;
                                });
                              },
                              activeColor: const Color.fromARGB(
                                255,
                                255,
                                119,
                                164,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text("Tidak"),
                              value: false,
                              groupValue: _waliTahu,
                              onChanged: (value) {
                                setState(() {
                                  _waliTahu = value ?? false;
                                });
                              },
                              activeColor: const Color.fromARGB(
                                255,
                                255,
                                119,
                                164,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Bersedia pindah kota setelah menikah?",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text("Ya"),
                              value: true,
                              groupValue: _bersediaPindah,
                              onChanged: (value) {
                                setState(() {
                                  _bersediaPindah = value ?? false;
                                });
                              },
                              activeColor: const Color.fromARGB(
                                255,
                                255,
                                119,
                                164,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text("Tidak"),
                              value: false,
                              groupValue: _bersediaPindah,
                              onChanged: (value) {
                                setState(() {
                                  _bersediaPindah = value ?? false;
                                });
                              },
                              activeColor: const Color.fromARGB(
                                255,
                                255,
                                119,
                                164,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tentang Saya",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _tentangSayaController,
                        decoration: customTextField(
                          hintText: "Ceritakan tentang dirimu",
                        ),
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people, color: Colors.pink[300], size: 30),
                          const SizedBox(width: 6),
                          const Text(
                            "Status Pernikahan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: customTextField(
                          hintText: "Status Pernikahan",
                        ),
                        initialValue: _statusNikah,
                        items:
                            [
                              'Belum menikah',
                              'Menikah',
                              'Cerai Hidup',
                              'Cerai Mati',
                            ].map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          if (newValue == null) return;

                          setState(() {
                            _statusNikah = newValue;

                            if (_statusNikah == 'Belum menikah' ||
                                _statusNikah == 'Menikah') {
                              _akteCeraiPath = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Memiliki Anak",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text("Ya"),
                              value: true,
                              groupValue: _punyaAnak,
                              onChanged: (value) {
                                setState(() {
                                  _punyaAnak = value ?? false;
                                });
                              },
                              activeColor: const Color.fromARGB(
                                255,
                                255,
                                119,
                                164,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text("Tidak"),
                              value: false,
                              groupValue: _punyaAnak,
                              onChanged: (value) {
                                setState(() {
                                  _punyaAnak = value ?? false;
                                  if (!_punyaAnak) {
                                    _jumlahAnakController.clear();
                                  }
                                });
                              },
                              activeColor: const Color.fromARGB(
                                255,
                                255,
                                119,
                                164,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _jumlahAnakController,
                        decoration: customTextField(hintText: "Jumlah Anak"),
                        keyboardType: TextInputType.number,
                        enabled: _punyaAnak,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Apakah bersedia poligami?",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: customTextField(
                          hintText: "Apakah bersedia poligami?",
                        ),
                        initialValue: _mauPoligami,
                        items:
                            [
                              'Ya, saya bersedia',
                              'InsyaAllah, jika istrinya ridho',
                              'Saya harus meyakinkan keluarga',
                              'Kurang yakin, tolong yakinkan',
                              'Tidak mau',
                            ].map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          if (newValue == null) return;
                          setState(() {
                            _mauPoligami = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildPemahamanAgamaSection(),

              const SizedBox(height: 20),

              _buildDokumenSection(),

              const SizedBox(height: 20),

              _buildPersetujuanSection(),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : customButton(
                        width: 400,
                        text: "Simpan Profil",
                        onPressed: _simpanProfil,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
