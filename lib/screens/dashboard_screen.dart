import 'dart:async';
import 'dart:math' show min;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pendataan_desa/screens/jadwal_rapat_screen.dart';
import 'package:pendataan_desa/screens/laporan_screen.dart';
import 'package:pendataan_desa/services/firestore_service.dart';
import 'penduduk_list_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'add_edit_penduduk_screen.dart';
// import '../models/penduduk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  String _username = "Admin";
  bool _isLoading = true;
  bool _isDataLoading = true;
  bool _isActivitiesLoading = true;

  late Timer _timer;
  late String _currentTime;

  List<Map<String, dynamic>> _recentActivities = [];

  int _totalPenduduk = 0;
  int _totalPendudukKawin = 0;
  int _totalPendudukPria = 0;
  int _totalPendudukWanita = 0;

  late Map<String, int> _stats;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();

    _updateTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });

    _stats = {
      "Total Penduduk": 0,
      "Penduduk Kawin": 0,
      "Penduduk Pria": 0,
      "Penduduk Wanita": 0,
    };

    _loadUserData();
    _fetchStatistics();
    _loadDummyData();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hours = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');
    final seconds = now.second.toString().padLeft(2, '0');

    setState(() {
      _currentTime = '$hours:$minutes:$seconds';
    });
  }

  Future<void> _loadUserData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _username = "Admin Desa";
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchStatistics() async {
    setState(() {
      _isDataLoading = true;
    });

    try {
      final pendudukStream = _firestoreService.getPenduduk();
      final List<Map<String, dynamic>>? pendudukList =
          await pendudukStream.first.then((pendudukList) =>
              pendudukList.map((penduduk) => penduduk.toMap()).toList());

      if (pendudukList != null) {
        int totalPenduduk = pendudukList.length;

        int totalKawin = 0;
        int totalPria = 0;
        int totalWanita = 0;

        for (var penduduk in pendudukList) {
          if (penduduk['statusNikah'] == 'Kawin') {
            totalKawin++;
          }

          if (penduduk['gender'] == 'Laki-laki') {
            totalPria++;
          } else if (penduduk['gender'] == 'Perempuan') {
            totalWanita++;
          }
        }

        if (mounted) {
          setState(() {
            _totalPenduduk = totalPenduduk;
            _totalPendudukKawin = totalKawin;
            _totalPendudukPria = totalPria;
            _totalPendudukWanita = totalWanita;

            _stats = {
              "Total Penduduk": _totalPenduduk,
              "Penduduk Nikah": _totalPendudukKawin,
              "Penduduk Pria": _totalPendudukPria,
              "Penduduk Wanita": _totalPendudukWanita,
            };

            _isDataLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isDataLoading = false;
          });
          _showErrorSnackBar('Gagal memuat data penduduk');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDataLoading = false;
        });
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  void _loadDummyData() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        final dummyActivities = [
          {
            'id': '1',
            'title': 'Penduduk Baru',
            'description': 'Data Altaf telah ditambahkan ke data penduduk',
            'timestamp': Timestamp.fromDate(
                DateTime.now().subtract(const Duration(minutes: 5))),
            'type': 'add',
          },
          {
            'id': '2',
            'title': 'Perubahan Data',
            'description': 'Data Altaf Fattah telah diperbarui',
            'timestamp': Timestamp.fromDate(
                DateTime.now().subtract(const Duration(hours: 2))),
            'type': 'update',
          },
          {
            'id': '3',
            'title': 'Penghapusan Data',
            'description': 'Data Nopal telah dihapus dari sistem',
            'timestamp': Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 1))),
            'type': 'delete',
          },
        ];

        setState(() {
          _recentActivities = dummyActivities;
          _isActivitiesLoading = false;
        });
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

// membersihkan resource atau objek yang tidak lagi diperlukan ketika sebuah widget dihapus dari widget tree. Ini adalah bagian dari siklus hidup widget StatefulWidget.
  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
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
        extendBodyBehindAppBar: true,
        body: _isLoading ? _buildLoadingView() : _buildDashboard(context),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: statusBarHeight),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[900] ?? Colors.blueAccent,
                Colors.blue[900]!.withOpacity(0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Dashboard SiDukun',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getCurrentDate(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),  
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.white.withOpacity(0.9),
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _currentTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
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
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await _fetchStatistics();
              _loadDummyData();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionTitle('Statistik Penduduk'),
                _isDataLoading ? _buildLoadingStats() : _buildStatisticsCards(),
                const SizedBox(height: 10),
                _buildSectionTitle('Menu Utama'),
                _buildMenuGrid(context),
                const SizedBox(height: 20),
                _buildSectionTitle('Aktivitas Terbaru'),
                const SizedBox(height: 6),
                _isActivitiesLoading
                    ? _buildLoadingActivities()
                    : _buildRecentActivity(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingStats() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Memuat data statistik...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingActivities() {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Memuat aktivitas terbaru...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  Widget _buildSectionTitle(String title) {
    return Row(
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        final entry = _stats.entries.elementAt(index);
        return _buildAnimatedStatCard(
          title: entry.key,
          value: entry.value,
          index: index,
          color: _getColorForIndex(index),
          icon: _getIconForStat(entry.key),
        );
      },
    );
  }

  Widget _buildAnimatedStatCard({
    required String title,
    required int value,
    required int index,
    required Color color,
    required IconData icon,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.2;
        final start = delay;

        final end = min(start + 0.4, 1.0);

        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.7),
                      color,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            icon,
                            color: Colors.white.withOpacity(0.8),
                            size: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      {
        'title': 'Data Penduduk',
        'icon': Icons.people,
        'color': Colors.blue,
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PendudukListScreen()),
            ),
      },
      {
        'title': 'Tambah Penduduk',
        'icon': Icons.person_add,
        'color': Colors.green,
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditPendudukScreen()),
            ),
      },
      {
        'title': 'Laporan',
        'icon': Icons.bar_chart,
        'color': Colors.orange,
        'onTap': () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LaporanScreen())),
      },
      {
        'title': 'Jadwal Rapat',
        'icon': Icons.event_note,
        'color': Colors.purple,
        // 'onTap': () {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Fitur Pengaturan akan segera hadir')),
        //   );
        // },
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const JadwalRapatScreen()),
            ),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildAnimatedMenuCard(
          title: item['title'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
          onTap: item['onTap'] as VoidCallback,
          index: index,
        );
      },
    );
  }

  Widget _buildAnimatedMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = 0.4 + (index * 0.1);
        final start = delay;

        final end = min(start + 0.4, 1.0);

        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity() {
    if (_recentActivities.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada aktivitas terbaru',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
          ),
        );

        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _recentActivities.map((activity) {
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getActivityColor(activity['type'])
                                .withOpacity(0.2),
                            child: Icon(
                              _getActivityIcon(activity['type']),
                              color: _getActivityColor(activity['type']),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            activity['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(activity['description']),
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(activity['timestamp']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (activity != _recentActivities.last) const Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      final formatter = DateFormat('dd MMM yyyy, HH:mm');
      return formatter.format(date);
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'add':
        return Icons.person_add;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.history;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'add':
        return Colors.green;
      case 'update':
        return Colors.blue;
      case 'delete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }

  IconData _getIconForStat(String statName) {
    switch (statName) {
      case 'Total Penduduk':
        return Icons.people;
      case 'Penduduk Nikah':
        return Icons.favorite;
      case 'Penduduk Pria':
        return Icons.man;
      case 'Penduduk Wanita':
        return Icons.woman;
      default:
        return Icons.analytics;
    }
  }
}
