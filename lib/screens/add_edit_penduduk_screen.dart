import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/penduduk.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:another_flushbar/flushbar.dart';

class AddEditPendudukScreen extends StatefulWidget {
  final Penduduk? penduduk;
  const AddEditPendudukScreen({super.key, this.penduduk});

  @override
  State<AddEditPendudukScreen> createState() => _AddEditPendudukScreenState();
}

class _AddEditPendudukScreenState extends State<AddEditPendudukScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  late TextEditingController nikController;
  late TextEditingController namaController;
  late TextEditingController pekerjaanController;
  late TextEditingController statusKawinController;
  late TextEditingController jenisKelaminController;
  late TextEditingController tanggalLahirController;
  late TextEditingController agamaController;
  late TextEditingController tempatLahirController;
  late TextEditingController noHpController;
  late TextEditingController emailController;
  late TextEditingController createdAtController;
  late TextEditingController updatedAtController;

  DateTime birthDate = DateTime.now();

  final BaseColor = Colors.blue[900];

  String? selectedStatus;
  String? selectedGender;
  String? selectedAgama;
  bool isLoading = false;

  final List<String> statusList = [
    'Belum Kawin',
    'Kawin',
    'Cerai Hidup',
    'Cerai Mati',
  ];

  final List<String> genderList = [
    'Laki-laki',
    'Perempuan',
  ];

  @override
  void initState() {
    super.initState();
    nikController = TextEditingController(text: widget.penduduk?.nik);
    namaController = TextEditingController(text: widget.penduduk?.nama);
    pekerjaanController =
        TextEditingController(text: widget.penduduk?.pekerjaan);
    statusKawinController =
        TextEditingController(text: widget.penduduk?.statusNikah);
    jenisKelaminController =
        TextEditingController(text: widget.penduduk?.gender);
    birthDate = widget.penduduk?.tanggalLahir ?? DateTime.now();
    tanggalLahirController = TextEditingController(
        text: DateFormat('dd MMMM yyyy').format(birthDate));
    agamaController = TextEditingController(text: widget.penduduk?.agama);
    tempatLahirController =
        TextEditingController(text: widget.penduduk?.tempatLahir);
    noHpController = TextEditingController(text: widget.penduduk?.noHp);
    emailController = TextEditingController(text: widget.penduduk?.email);
    createdAtController = TextEditingController(
        text: DateFormat('dd MMMM yyyy')
            .format(widget.penduduk?.createdAt ?? DateTime.now()));
    updatedAtController = TextEditingController(
        text: DateFormat('dd MMMM yyyy')
            .format(widget.penduduk?.updatedAt ?? DateTime.now()));

    selectedStatus = widget.penduduk?.statusNikah;
    selectedGender = widget.penduduk?.gender;
    selectedAgama = widget.penduduk?.agama;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'), // Format Indonesia
      builder: (context, child) {
        // Gunakan null-aware operator untuk aman
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[900] ?? Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child ?? const SizedBox(), // Aman dari null
        );
      },
    );

    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
        tanggalLahirController.text =
            DateFormat('dd MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _savePenduduk() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Penduduk dataPenduduk = Penduduk(
        id: widget.penduduk?.id ?? '',
        nik: nikController.text,
        nama: namaController.text,
        gender: jenisKelaminController.text,
        pekerjaan: pekerjaanController.text,
        statusNikah: statusKawinController.text,
        tanggalLahir: birthDate,
        agama: agamaController.text,
        tempatLahir: tempatLahirController.text,
        noHp: noHpController.text,
        email: emailController.text,
        // pendidikan: pendidikanController.text,
        createdAt: widget.penduduk?.createdAt ?? DateTime.now(),
        updatedAt: widget.penduduk?.updatedAt ?? DateTime.now(),
      );

      try {
        if (widget.penduduk == null) {
          await _firestoreService.addPenduduk(dataPenduduk);
        } else {
          await _firestoreService.updatePenduduk(dataPenduduk);
        }

        if (mounted) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(
          //         'Data penduduk berhasil ${widget.penduduk == null ? 'ditambahkan' : 'diperbarui'}'),
          //     backgroundColor: Colors.green.shade600,
          //   ),
          // );

          // _showSuccessSnackBar('Data penduduk berhasil ${widget.penduduk == null ? 'ditambahkan' : 'diperbarui'}');

          Navigator.pop(context);

          Flushbar(
            message: 'Data penduduk berhasil ${widget.penduduk == null ? 'ditambahkan' : 'diperbarui'}',
            backgroundColor: Colors.green[600]!,
            margin: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(10),
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Terjadi kesalahan: $e'),
        //     backgroundColor: Colors.red,
        //   ),
        // );
          Flushbar(
            message: 'Terjadi kesalahan: $e',
            backgroundColor: Colors.red[600]!,
            margin: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(10),
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.penduduk == null ? 'Tambah Penduduk' : 'Edit Penduduk',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[900] ?? Colors.blue, Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      // Header
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_add_alt_1,
                              size: 50,
                              color: Colors.blue[900],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.penduduk == null
                                  ? 'Data Penduduk Baru'
                                  : 'Edit Data Penduduk',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Silakan isi data dengan lengkap',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 30),

                      _buildTextField(
                        controller: nikController,
                        label: 'NIK',
                        icon: Icons.credit_card,
                        hint: 'Masukkan NIK',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIK tidak boleh kosong';
                          }
                          if (value.length != 16) {
                            return 'NIK harus 16 digit';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 16, // <-- Tambahkan ini
                      ),

                      _buildTextField(
                        controller: namaController,
                        label: 'Nama Lengkap',
                        icon: Icons.person,
                        hint: 'Masukkan nama lengkap',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      _buildTextField(
                        controller: noHpController,
                        label: 'No. HP',
                        icon: Icons.phone,
                        hint: 'Masukkan nomor HP',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor HP tidak boleh kosong';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),

                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        icon: Icons.email,
                        hint: 'Masukkan email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),

                      _buildDropdown(
                        value: selectedGender,
                        label: 'Jenis Kelamin',
                        icon: Icons.wc,
                        hint: 'Pilih jenis kelamin',
                        items: genderList,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                            jenisKelaminController.text = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Pilih jenis kelamin' : null,
                      ),

                      _buildDropdown(
                        value: selectedAgama,
                        label: 'Agama',
                        icon: Icons.account_balance,
                        hint: 'Pilih agama',
                        items: [
                          'Islam',
                          'Kristen',
                          'Katolik',
                          'Hindu',
                          'Buddha',
                          'Konghucu'
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAgama = value!;
                            agamaController.text = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Pilih agama' : null,
                      ),

                      _buildTextField(
                        controller: tempatLahirController,
                        label: 'Tempat Lahir',
                        icon: Icons.location_on,
                        hint: 'Masukkan tempat lahir',
                      ),

                      _buildDatePicker(
                        controller: tanggalLahirController,
                        label: 'Tanggal Lahir',
                        icon: Icons.calendar_today,
                        hint: 'Pilih tanggal lahir',
                        onTap: () => _selectDate(context),
                      ),

                      _buildTextField(
                        controller: pekerjaanController,
                        label: 'Pekerjaan',
                        icon: Icons.work,
                        hint: 'Masukkan pekerjaan',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pekerjaan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      _buildDropdown(
                        value: selectedStatus,
                        label: 'Status Perkawinan',
                        icon: Icons.favorite,
                        hint: 'Pilih status perkawinan',
                        items: statusList,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                            statusKawinController.text = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Pilih status perkawinan' : null,
                      ),

                      const SizedBox(height: 24),

                      // Save Button
                      ElevatedButton(
                        onPressed: isLoading ? null : _savePenduduk,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Menyimpan...'),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.penduduk == null
                                        ? 'Simpan Data'
                                        : 'Perbarui Data',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 16),

                      // Cancel Button
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String label,
  //   required IconData icon,
  //   required String hint,
  //   String? Function(String?)? validator,
  //   TextInputType keyboardType = TextInputType.text,
  //   int maxLines = 1,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: TextFormField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         hintText: hint,
  //         prefixIcon: Icon(icon, color: Colors.blue[900]),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(color: Colors.blue[900] ?? Colors.blue),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide:
  //               BorderSide(color: Colors.blue[900] ?? Colors.blue, width: 2),
  //         ),
  //         filled: true,
  //         fillColor: Colors.grey.shade50,
  //         contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //       ),
  //       validator: validator,
  //       keyboardType: keyboardType,
  //       maxLines: maxLines,
  //     ),
  //   );
  // }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue[900]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue[900] ?? Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Colors.blue[900] ?? Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          counterText: '', // Menghilangkan teks penghitung karakter
        ),
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: [
          if (keyboardType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly,
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue[900]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue[900] ?? Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Colors.blue[900] ?? Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
        validator: validator,
        icon:
            Icon(Icons.arrow_drop_down, color: Colors.blue[900] ?? Colors.blue),
        isExpanded: true,
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildDatePicker({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue[900]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue[900] ?? Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Colors.blue[900] ?? Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: Icon(Icons.calendar_month, color: Colors.blue[900]),
        ),
        readOnly: true,
        onTap: onTap,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Tanggal lahir tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    nikController.dispose();
    namaController.dispose();
    pekerjaanController.dispose();
    statusKawinController.dispose();
    jenisKelaminController.dispose();
    tanggalLahirController.dispose();
    agamaController.dispose();
    tempatLahirController.dispose();
    noHpController.dispose();
    emailController.dispose();
    createdAtController.dispose();
    updatedAtController.dispose();
    super.dispose();
  }
}
