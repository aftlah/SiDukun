import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firestore_service.dart';
import '../models/penduduk.dart';
import '../widgets/penduduk_card.dart';
import 'add_edit_penduduk_screen.dart';
import 'package:intl/intl.dart'; // Added for DateFormat

class PendudukListScreen extends StatefulWidget {
  const PendudukListScreen({super.key});

  @override
  State<PendudukListScreen> createState() => _PendudukListScreenState();
}

class _PendudukListScreenState extends State<PendudukListScreen>
    with SingleTickerProviderStateMixin {
  final FirestoreService firestoreService = FirestoreService();
  List<Penduduk> pendudukList = []; // Define and initialize pendudukList
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Add filter state variables
  String _selectedGender = 'Semua';
  String _selectedMaritalStatus = 'Semua';
  String _selectedReligion = 'Semua'; // Added religion filter
  bool _isFilterActive = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterPenduduk(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  // Reset filters
  void _resetFilters() {
    setState(() {
      _selectedGender = 'Semua';
      _selectedMaritalStatus = 'Semua';
      _selectedReligion = 'Semua';
      _isFilterActive = false;
    });
  }

  void _applyFilters(String gender, String maritalStatus, String religion) {
    setState(() {
      _selectedGender = gender;
      _selectedMaritalStatus = maritalStatus;
      _selectedReligion = religion;
      _isFilterActive =
          gender != 'Semua' || maritalStatus != 'Semua' || religion != 'Semua';
    });
  }

  void _showPendudukDetails(BuildContext context, Penduduk penduduk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Penduduk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                // Make the content scrollable if it's too long
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem('NIK', penduduk.nik),
                        _buildDetailItem('Nama', penduduk.nama),
                        _buildDetailItem('Jenis Kelamin', penduduk.gender),
                        _buildDetailItem('Tempat Lahir', penduduk.tempatLahir),
                        _buildDetailItem(
                            'Tanggal Lahir', DateFormat('dd MMMM yyyy').format(penduduk.tanggalLahir)),
                        _buildDetailItem('Agama', penduduk.agama),
                        _buildDetailItem(
                            'Status Perkawinan', penduduk.statusNikah),
                        _buildDetailItem('Pekerjaan', penduduk.pekerjaan),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddEditPendudukScreen(penduduk: penduduk),
                          ),
                        ).then((_) {
                          // Refresh the list when returning from edit screen
                          setState(() {});
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Edit Data'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this method to the PendudukListScreen class
  // void _showPendudukDetails(BuildContext context, Penduduk penduduk) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Container(
  //           width: double.infinity,
  //           constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Header
  //               Container(
  //                 padding: const EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                   color: Colors.blue[900],
  //                   borderRadius: const BorderRadius.only(
  //                     topLeft: Radius.circular(20),
  //                     topRight: Radius.circular(20),
  //                   ),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     CircleAvatar(
  //                       backgroundColor: Colors.white,
  //                       child: Text(
  //                         penduduk.nama.isNotEmpty
  //                             ? penduduk.nama[0].toUpperCase()
  //                             : '?',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.blue[900],
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             penduduk.nama,
  //                             style: const TextStyle(
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                           Text(
  //                             'NIK: ${penduduk.nik}',
  //                             style: const TextStyle(
  //                               fontSize: 14,
  //                               color: Colors.white70,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     IconButton(
  //                       icon: const Icon(Icons.close, color: Colors.white),
  //                       onPressed: () => Navigator.pop(context),
  //                     ),
  //                   ],
  //                 ),
  //               ),

  //               // Content - Scrollable
  //               Flexible(
  //                 child: SingleChildScrollView(
  //                   padding: const EdgeInsets.all(16),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       _buildDetailSection('Informasi Pribadi', [
  //                         _buildDetailRow('Jenis Kelamin', penduduk.gender),
  //                         _buildDetailRow('Tempat Lahir', penduduk.tempatLahir),
  //                         _buildDetailRow(
  //                             'Tanggal Lahir',
  //                             DateFormat('dd MMMM yyyy')
  //                                 .format(penduduk.tanggalLahir)),
  //                         _buildDetailRow('Agama', penduduk.agama),
  //                         _buildDetailRow(
  //                             'Status Perkawinan', penduduk.statusNikah),
  //                         _buildDetailRow('Pekerjaan', penduduk.pekerjaan),
  //                       ]),
  //                       const SizedBox(height: 16),
  //                       _buildDetailSection('Alamat', [
  //                         // _buildDetailRow('Alamat', penduduk.alamat),
  //                         // _buildDetailRow(
  //                         //     'RT/RW', '${penduduk.rt}/${penduduk.rw}'),
  //                         // _buildDetailRow('Desa/Kelurahan', penduduk.desa),
  //                         // _buildDetailRow('Kecamatan', penduduk.kecamatan),
  //                         // _buildDetailRow('Kabupaten/Kota', penduduk.kabupaten),
  //                         // _buildDetailRow('Provinsi', penduduk.provinsi),
  //                       ]),
  //                     ],
  //                   ),
  //                 ),
  //               ),

  //               // Footer with buttons
  //               Padding(
  //                 padding: const EdgeInsets.all(16),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     OutlinedButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       style: OutlinedButton.styleFrom(
  //                         foregroundColor: Colors.blue[900],
  //                         side: BorderSide(color: Colors.blue[900]!),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       child: const Text('Tutup'),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     ElevatedButton.icon(
  //                       onPressed: () {
  //                         Navigator.pop(context); // Close the dialog
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (_) =>
  //                                 AddEditPendudukScreen(penduduk: penduduk),
  //                           ),
  //                         ).then((_) {
  //                           // Refresh the list when returning from edit screen
  //                           setState(() {});
  //                         });
  //                       },
  //                       icon: const Icon(Icons.edit, size: 18),
  //                       label: const Text('Edit Data'),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.blue[900],
  //                         foregroundColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Helper methods for the detail dialog
  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build detail items
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              // Refresh state
            });
            return Future.value();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppBar(),
              _buildSearchBar(),
              _buildActiveFilters(),
              _buildPendudukList(),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      foregroundColor: Colors.white,
      expandedHeight: 60.0,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.blue[900],
      title: const Text(
        'Data Penduduk',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari penduduk...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.blue[900]),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterPenduduk('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _filterPenduduk,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Filter button with indicator
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _showFilterOptions(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.filter_list,
                        color: _isFilterActive
                            ? Colors.blue[700]
                            : Colors.blue[900],
                        size: 24,
                      ),
                    ),
                  ),
                  if (_isFilterActive)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
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

  // Fixed active filters widget to prevent duplicate chips
  Widget _buildActiveFilters() {
    if (!_isFilterActive) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    List<Widget> filterChips = [];

    // Only add gender chip if it's not "Semua"
    if (_selectedGender != 'Semua') {
      filterChips.add(
        Chip(
          label: Text(_selectedGender),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedGender = 'Semua';
              _isFilterActive = _selectedMaritalStatus != 'Semua' ||
                  _selectedReligion != 'Semua';
            });
          },
          backgroundColor: Colors.blue[100],
          labelStyle: TextStyle(color: Colors.blue[900], fontSize: 12),
        ),
      );
    }

    // Add religion chip if it's not "Semua"
    if (_selectedReligion != 'Semua') {
      filterChips.add(
        Chip(
          label: Text(_selectedReligion),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedReligion = 'Semua';
              _isFilterActive = _selectedGender != 'Semua' ||
                  _selectedMaritalStatus != 'Semua';
            });
          },
          backgroundColor: Colors.blue[100],
          labelStyle: TextStyle(color: Colors.blue[900], fontSize: 12),
        ),
      );
    }

    // Add marital status chip if it's not "Semua"
    if (_selectedMaritalStatus != 'Semua') {
      filterChips.add(
        Chip(
          label: Text(_selectedMaritalStatus),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            setState(() {
              _selectedMaritalStatus = 'Semua';
              _isFilterActive =
                  _selectedGender != 'Semua' || _selectedReligion != 'Semua';
            });
          },
          backgroundColor: Colors.blue[100],
          labelStyle: TextStyle(color: Colors.blue[900], fontSize: 12),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Filter Aktif:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            // Use SingleChildScrollView to prevent horizontal overflow
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filterChips
                    .map((chip) => Padding(
                          padding:
                              const EdgeInsets.only(right: 8.0, bottom: 8.0),
                          child: chip,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendudukList() {
    return StreamBuilder<List<Penduduk>>(
      stream: firestoreService.getPenduduk(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Terjadi kesalahan saat memuat data',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.blue[200]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data penduduk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan data penduduk baru dengan menekan tombol + di bawah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final penduduk = snapshot.data!;

        var filteredPenduduk = penduduk;

        if (_selectedGender != 'Semua') {
          filteredPenduduk = filteredPenduduk
              .where((p) => p.gender == _selectedGender)
              .toList();
        }

        if (_selectedMaritalStatus != 'Semua') {
          filteredPenduduk = filteredPenduduk
              .where((p) => p.statusNikah == _selectedMaritalStatus)
              .toList();
        }

        // Add religion filter if implemented in your Penduduk model
        if (_selectedReligion != 'Semua') {
          filteredPenduduk = filteredPenduduk
              .where((p) => p.agama == _selectedReligion)
              .toList();
        }

        if (_searchQuery.isNotEmpty) {
          filteredPenduduk = filteredPenduduk
              .where((p) =>
                  p.nama.toLowerCase().contains(_searchQuery) ||
                  p.nik.toLowerCase().contains(_searchQuery))
              .toList();
        }

        if (filteredPenduduk.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    _isFilterActive
                        ? 'Tidak ada hasil untuk filter yang dipilih'
                        : 'Tidak ada hasil untuk "$_searchQuery"',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = filteredPenduduk[index];
                return _buildAnimatedPendudukCard(item, index);
              },
              childCount: filteredPenduduk.length,
            ),
          ),
        );
      },
    );
  }

  // Widget _buildAnimatedPendudukCard(Penduduk penduduk, int index) {
  //   final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
  //     CurvedAnimation(
  //       parent: _animationController,
  //       curve: Interval(
  //         (1 / 20) * index,
  //         1.0,
  //         curve: Curves.easeOut,
  //       ),
  //     ),
  //   );

  //   return FadeTransition(
  //     opacity: animation,
  //     child: SlideTransition(
  //       position: Tween<Offset>(
  //         begin: const Offset(0, 0.2),
  //         end: Offset.zero,
  //       ).animate(animation),
  //       child: Padding(
  //         padding: const EdgeInsets.only(bottom: 12.0),
  //         child: PendudukCard(
  //           penduduk: penduduk,
  //           onTap: () => _showPendudukDetails(
  //               context, penduduk), // Changed to show details
  //           onEdit: () => Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) => AddEditPendudukScreen(penduduk: penduduk),
  //             ),
  //           ).then((_) {
  //             // Refresh the list when returning from edit screen
  //             setState(() {});
  //           }),
  //           onViewDetails: () => _showPendudukDetails(
  //               context, penduduk), // New callback for view details
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // In the _buildAnimatedPendudukCard method of PendudukListScreen class
  Widget _buildAnimatedPendudukCard(Penduduk penduduk, int index) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          (1 / 20) * index,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: PendudukCard(
            penduduk: penduduk,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditPendudukScreen(penduduk: penduduk),
              ),
            ).then((_) {
              // Refresh the list when returning from edit screen
              setState(() {});
            }),
            onViewDetails: () => _showPendudukDetails(context, penduduk),
            onDelete: () {
              // Hapus dari database atau list
              firestoreService.deletePenduduk(penduduk.id).then((_) {
                setState(() {
                  pendudukList.remove(penduduk);
                });
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddEditPendudukScreen()),
      ).then((_) {
        // Refresh the list when returning from add screen
        setState(() {});
      }),
      backgroundColor: Colors.blue[900],
      icon: const Icon(Icons.person_add, color: Colors.white),
      label: const Text(
        'Tambah',
        style: TextStyle(color: Colors.white),
      ),
      elevation: 4,
    );
  }

  void _showFilterOptions(BuildContext context) {
    String tempGender = _selectedGender;
    String tempMaritalStatus = _selectedMaritalStatus;
    String tempReligion = _selectedReligion;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the modal to be larger
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                // Add padding to account for bottom inset (keyboard, etc.)
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Data Penduduk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Gender filter
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.male, color: Colors.blue[900], size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Jenis Kelamin',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              'Semua',
                              'Laki-laki',
                              'Perempuan',
                            ].map((option) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(option),
                                  selected: tempGender == option,
                                  selectedColor: Colors.blue[100],
                                  labelStyle: TextStyle(
                                    color: tempGender == option
                                        ? Colors.blue[900]
                                        : Colors.black,
                                  ),
                                  onSelected: (selected) {
                                    setModalState(() {
                                      tempGender = option;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.wc, color: Colors.blue[900], size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Agama',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // Religion filter
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              'Semua',
                              'Islam',
                              'Kristen',
                              'Katolik',
                              'Hindu',
                              'Buddha',
                              'Konghucu'
                            ].map((option) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(option),
                                  selected: tempReligion == option,
                                  selectedColor: Colors.blue[100],
                                  labelStyle: TextStyle(
                                    color: tempReligion == option
                                        ? Colors.blue[900]
                                        : Colors.black,
                                  ),
                                  onSelected: (selected) {
                                    setModalState(() {
                                      tempReligion = option;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Marital status filter
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite,
                                color: Colors.blue[900], size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Status Perkawinan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              'Semua',
                              'Belum Kawin',
                              'Kawin',
                              'Cerai Hidup',
                              'Cerai Mati'
                            ].map((option) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(option),
                                  selected: tempMaritalStatus == option,
                                  selectedColor: Colors.blue[100],
                                  labelStyle: TextStyle(
                                    color: tempMaritalStatus == option
                                        ? Colors.blue[900]
                                        : Colors.black,
                                  ),
                                  onSelected: (selected) {
                                    setModalState(() {
                                      tempMaritalStatus = option;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Batal',
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Apply filters and close modal
                            _applyFilters(
                                tempGender, tempMaritalStatus, tempReligion);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Terapkan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
