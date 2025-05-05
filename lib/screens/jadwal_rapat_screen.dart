import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class JadwalRapatScreen extends StatefulWidget {
  const JadwalRapatScreen({super.key});

  @override
  State<JadwalRapatScreen> createState() => _JadwalRapatScreenState();
}

class _JadwalRapatScreenState extends State<JadwalRapatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _jadwalRapat = [];
  String _filterStatus = "Semua";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _jadwalRapat = _getDummyJadwalRapat();
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getDummyJadwalRapat() {
    return [
      {
        'id': '1',
        'judul': 'Rapat Pembubaran Desa',
        'tanggal': DateTime.now().add(const Duration(days: 2)),
        'waktuMulai': '09:00',
        'waktuSelesai': '11:00',
        'lokasi': 'Balai Desa',
        'deskripsi': 'Tes.',
        'peserta': [
          'Kepala Desa',
          'Sekretaris Desa',
          'Ketua BPD',
          'Tokoh Masyarakat'
        ],
        'status': 'Akan Datang',
        'prioritas': 'Tinggi',
      },
      {
        'id': '2',
        'judul': 'Rapat Vaksin Berjamaah',
        'tanggal': DateTime.now().add(const Duration(days: 5)),
        'waktuMulai': '13:00',
        'waktuSelesai': '15:00',
        'lokasi': 'Posyandu Desa',
        'deskripsi': 'Tes.',
        'peserta': ['Bidan Desa', 'Kader Posyandu', 'Perwakilan Puskesmas'],
        'status': 'Akan Datang',
        'prioritas': 'Sedang',
      },
      {
        'id': '3',
        'judul': 'Rapat Kerja',
        'tanggal': DateTime.now().subtract(const Duration(days: 3)),
        'waktuMulai': '10:00',
        'waktuSelesai': '12:00',
        'lokasi': 'Balai Desa',
        'deskripsi': 'Tes.',
        'peserta': ['Kepala Desa', 'Perangkat Desa', 'BPD'],
        'status': 'Selesai',
        'prioritas': 'Tinggi',
        'notulensi': 'Sudah dibuat dan didistribusikan ke semua peserta rapat.',
      },
      {
        'id': '4',
        'judul': 'Rapat HUT',
        'tanggal': DateTime.now().add(const Duration(days: 10)),
        'waktuMulai': '15:00',
        'waktuSelesai': '17:00',
        'lokasi': 'Aula Desa',
        'deskripsi': 'Tes.',
        'peserta': ['Panitia HUT RI', 'Karang Taruna', 'Perangkat Desa'],
        'status': 'Akan Datang',
        'prioritas': 'Sedang',
      },
      {
        'id': '5',
        'judul': 'Rapat Penggelapan Uang',
        'tanggal': DateTime.now().subtract(const Duration(days: 10)),
        'waktuMulai': '08:00',
        'waktuSelesai': '12:00',
        'lokasi': 'Balai Desa',
        'deskripsi': 'Tes.',
        'peserta': [
          'Kepala Desa',
          'Bendahara Desa',
          'BPD',
          'Perwakilan Kecamatan'
        ],
        'status': 'Selesai',
        'prioritas': 'Tinggi',
        'notulensi': 'Sudah dibuat dan disetujui oleh Kepala Desa.',
      },
    ];
  }

  String _formatTanggal(DateTime tanggal) {
    final List<String> namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final List<String> namaHari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];

    int dayOfWeek = tanggal.weekday;

    return '${namaHari[dayOfWeek - 1]}, ${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  Color _getPrioritasColor(String prioritas) {
    switch (prioritas) {
      case 'Tinggi':
        return Colors.red;
      case 'Sedang':
        return Colors.orange;
      case 'Rendah':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Akan Datang':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredMeetings() {
    if (_filterStatus == "Semua") {
      return _jadwalRapat;
    } else {
      return _jadwalRapat
          .where((rapat) => rapat['status'] == _filterStatus)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jadwal Rapat'),
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
          elevation: 0,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.add),
          //     onPressed: () {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           content: Text('Fitur tambah rapat akan segera hadir'),
          //           behavior: SnackBarBehavior.floating,
          //         ),
          //       );
          //     },
          //     tooltip: 'Tambah Rapat',
          //   ),
          // ],
        ),
        body: _isLoading ? _buildLoadingView() : _buildContent(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur tambah rapat akan segera hadir'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          backgroundColor: Colors.blue[900],
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(
          child: _buildMeetingList(),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Jadwal Rapat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              _showFilterModal(context);
            },
            icon: const Icon(Icons.filter_list, color: Colors.white,),
            label: Text(
                _filterStatus == "Semua" ? "Filter" : "Filter: $_filterStatus"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[900],
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New method to show filter modal
  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Jadwal Rapat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Status Rapat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildFilterOption("Semua", context, setModalState),
                  _buildFilterOption("Akan Datang", context, setModalState),
                  _buildFilterOption("Selesai", context, setModalState),
                  _buildFilterOption("Dibatalkan", context, setModalState),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Terapkan Filter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // New method to build filter options in the modal
  Widget _buildFilterOption(
      String status, BuildContext context, StateSetter setModalState) {
    return InkWell(
      onTap: () {
        setModalState(() {
          setState(() {
            _filterStatus = status;
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      _filterStatus == status ? Colors.blue[900]! : Colors.grey,
                  width: 2,
                ),
              ),
              child: _filterStatus == status
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue[900],
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 15),
            Text(
              status,
              style: TextStyle(
                fontSize: 16,
                fontWeight: _filterStatus == status
                    ? FontWeight.bold
                    : FontWeight.normal,
                color:
                    _filterStatus == status ? Colors.blue[900] : Colors.black87,
              ),
            ),
            if (status != "Semua") ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(status),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusCount(status).toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method to count meetings by status
  int _getStatusCount(String status) {
    return _jadwalRapat.where((rapat) => rapat['status'] == status).length;
  }

  Widget _buildMeetingList() {
    final filteredMeetings = _getFilteredMeetings();

    if (filteredMeetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada jadwal rapat $_filterStatus',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredMeetings.length,
      itemBuilder: (context, index) {
        final meeting = filteredMeetings[index];
        return _buildMeetingCard(meeting, index);
      },
    );
  }

  Widget _buildMeetingCard(Map<String, dynamic> meeting, int index) {
    final tanggal = meeting['tanggal'] as DateTime;
    final waktuMulai = meeting['waktuMulai'];
    final waktuSelesai = meeting['waktuSelesai'];
    final prioritas = meeting['prioritas'];
    final status = meeting['status'];

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.1;
        final start = delay;
        final end = start + 0.4 > 1.0 ? 1.0 : start + 0.4;

        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  _showMeetingDetails(meeting);
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              meeting['judul'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
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
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTanggal(tanggal),
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$waktuMulai - $waktuSelesai WIB',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                meeting['lokasi'],
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getPrioritasColor(prioritas)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getPrioritasColor(prioritas),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.flag,
                                      size: 12,
                                      color: _getPrioritasColor(prioritas),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Prioritas $prioritas',
                                      style: TextStyle(
                                        color: _getPrioritasColor(prioritas),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 12,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${meeting['peserta'].length} Peserta',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMeetingDetails(Map<String, dynamic> meeting) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      meeting['judul'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(meeting['status']),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      meeting['status'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailItem(Icons.calendar_today, 'Tanggal',
                  _formatTanggal(meeting['tanggal'])),
              _buildDetailItem(Icons.access_time, 'Waktu',
                  '${meeting['waktuMulai']} - ${meeting['waktuSelesai']} WIB'),
              _buildDetailItem(Icons.location_on, 'Lokasi', meeting['lokasi']),
              _buildDetailItem(Icons.flag, 'Prioritas', meeting['prioritas'],
                  color: _getPrioritasColor(meeting['prioritas'])),
              const SizedBox(height: 10),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                meeting['deskripsi'],
                style: TextStyle(
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Peserta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (meeting['peserta'] as List).map<Widget>((peserta) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      peserta,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (meeting['status'] == 'Selesai' &&
                  meeting.containsKey('notulensi')) ...[
                const SizedBox(height: 15),
                const Text(
                  'Notulensi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  meeting['notulensi'],
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (meeting['status'] == 'Akan Datang')
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur edit rapat akan segera hadir'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Fitur undangan rapat akan segera hadir'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Bagikan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
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

  Widget _buildDetailItem(IconData icon, String label, String value,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: color ?? Colors.grey[600],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color ?? Colors.black87,
                  fontWeight:
                      color != null ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
