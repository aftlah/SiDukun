import 'package:flutter/material.dart';
import 'laporan_keuangan_screen.dart';
import 'laporan_penduduk_screen.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({Key? key}) : super(key: key);

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Kategori Laporan'),
            const SizedBox(height: 16),
            _buildReportCategories(),
            const SizedBox(height: 24),
            _buildSectionTitle('Laporan Terbaru'),
            const SizedBox(height: 16),
            _buildRecentReports(),
          ],
        ),
      ),
    );
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

  Widget _buildReportCategories() {
    final reportCategories = [
      {
        'title': 'Laporan Keuangan',
        'icon': Icons.monetization_on,
        'color': Colors.green,
        'description': 'Laporan pemasukan dan pengeluaran desa',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LaporanKeuanganScreen()),
            ),
      },
      {
        'title': 'Laporan Warga',
        'icon': Icons.people,
        'color': Colors.blue,
        'description': 'Laporan aktivitas dan kebutuhan warga',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LaporanPendudukScreen()),
            ),
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reportCategories.length,
      itemBuilder: (context, index) {
        final category = reportCategories[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: category['onTap'] as VoidCallback,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      size: 32,
                      color: category['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['title'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category['description'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentReports() {
    final recentReports = [
      {
        'title': 'Laporan Keuangan Q1 2023',
        'date': '15 April 2023',
        'type': 'Keuangan',
        'status': 'Selesai',
      },
      {
        'title': 'Laporan Bantuan Sosial',
        'date': '10 Maret 2023',
        'type': 'Warga',
        'status': 'Selesai',
      },
      {
        'title': 'Laporan Pembangunan Jalan',
        'date': '28 Februari 2023',
        'type': 'Keuangan',
        'status': 'Proses',
      },
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: recentReports.length,
        itemBuilder: (context, index) {
          final report = recentReports[index];
          final isFinance = report['type'] == 'Keuangan';

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isFinance
                        ? const LaporanKeuanganScreen()
                        : const LaporanPendudukScreen(),
                  ),
                );
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: isFinance
                    ? Colors.green.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                child: Icon(
                  isFinance ? Icons.monetization_on : Icons.people,
                  color: isFinance ? Colors.green : Colors.blue,
                ),
              ),
              title: Text(
                report['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${report['date']} • ${report['type']}'),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: report['status'] == 'Selesai'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report['status'] as String,
                  style: TextStyle(
                    color: report['status'] == 'Selesai'
                        ? Colors.green
                        : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
