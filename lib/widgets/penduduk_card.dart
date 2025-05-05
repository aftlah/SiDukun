// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/penduduk.dart';

// class PendudukCard extends StatelessWidget {
//   final Penduduk penduduk;
//   final VoidCallback onTap;
//   final VoidCallback? onViewDetails;

//   const PendudukCard({
//     super.key,
//     required this.penduduk,
//     required this.onTap,
//     this.onViewDetails,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildAvatar(),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           penduduk.nama,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         _buildInfoRow(
//                           Icons.credit_card,
//                           'NIK: ${penduduk.nik}',
//                         ),
//                         const SizedBox(height: 4),
//                         _buildInfoRow(
//                           Icons.calendar_today,
//                           'Lahir: ${DateFormat('dd MMM yyyy').format(penduduk.tanggalLahir)}',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildDetailItem(
//                       icon: Icons.wc,
//                       label: 'Jenis Kelamin',
//                       value: penduduk.gender,
//                     ),
//                   ),
//                   Expanded(
//                     child: _buildDetailItem(
//                       icon: Icons.favorite,
//                       label: 'Status',
//                       value: penduduk.statusNikah,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildDetailItem(
//                       icon: Icons.home,
//                       label: 'Tempat Lahir',
//                       value: penduduk.tempatLahir,
//                     ),
//                   ),
//                   Expanded(
//                     child: _buildDetailItem(
//                       icon: Icons.account_balance,
//                       label: 'Agama',
//                       value: penduduk.agama,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: _buildInfoRow(
//                   Icons.work,
//                   'Pekerjaan: ${penduduk.pekerjaan}',
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   // Adjusted View Details button to align left
//                   TextButton.icon(
//                     onPressed: onViewDetails ?? () {},
//                     icon: Icon(Icons.visibility,
//                         size: 18, color: Colors.green[700]),
//                     label: Text(
//                       'Lihat Detail',
//                       style: TextStyle(color: Colors.green[700]),
//                     ),
//                   ),
//                   const Spacer(), // Push other buttons to the right
//                   TextButton.icon(
//                     onPressed: onTap,
//                     icon: Icon(Icons.edit, size: 18, color: Colors.blue[900]),
//                     label: Text(
//                       'Edit',
//                       style: TextStyle(color: Colors.blue[900]),
//                     ),
//                   ),

//                   const SizedBox(width: 8),

//                   TextButton.icon(
//                     onPressed: () {
//                       // Add your delete action here
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Konfirmasi Hapus'),
//                           content: const Text(
//                               'Apakah Anda yakin ingin menghapus data ini?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text('Batal'),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 // Perform delete action here
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text('Hapus'),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.delete_outline,
//                         size: 18, color: Colors.red),
//                     label: const Text(
//                       'Hapus',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAvatar() {
//     return CircleAvatar(
//       radius: 30,
//       backgroundColor: Colors.blue[100],
//       child: Text(
//         penduduk.nama.isNotEmpty ? penduduk.nama[0].toUpperCase() : '?',
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: Colors.blue[900],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           icon,
//           size: 16,
//           color: Colors.grey[600],
//         ),
//         const SizedBox(width: 6),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.grey[800],
//               fontSize: 14,
//             ),
//             maxLines: maxLines,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailItem({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.blue[50],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             size: 16,
//             color: Colors.blue[900],
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import '../models/penduduk.dart';

class PendudukCard extends StatelessWidget {
  final Penduduk penduduk;
  final VoidCallback onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback onDelete;

  const PendudukCard({
    super.key,
    required this.penduduk,
    required this.onTap,
    required this.onDelete,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          penduduk.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.credit_card,
                          'NIK: ${penduduk.nik}',
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.calendar_today,
                          'Lahir: ${DateFormat('dd MMM yyyy', 'id_ID').format(penduduk.tanggalLahir)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.wc,
                      label: 'Jenis Kelamin',
                      value: penduduk.gender,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.favorite,
                      label: 'Status',
                      value: penduduk.statusNikah,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.home,
                      label: 'Tempat Lahir',
                      value: penduduk.tempatLahir,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.account_balance,
                      label: 'Agama',
                      value: penduduk.agama,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildInfoRow(
                  Icons.work,
                  'Pekerjaan: ${penduduk.pekerjaan}',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onViewDetails ?? () {},
                    icon: Icon(Icons.visibility,
                        size: 18, color: Colors.green[700]),
                    label: Text(
                      'Lihat Detail',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onTap,
                    icon: Icon(Icons.edit, size: 18, color: Colors.blue[900]),
                    label: Text(
                      'Edit',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.orange),
                              const SizedBox(width: 8),
                              const Text('Konfirmasi Hapus'),
                            ],
                          ),
                          content: const Text(
                            'Apakah Anda yakin ingin menghapus data ini?.',
                            style: TextStyle(fontSize: 14),
                          ),
                          actionsPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          actions: [
                            OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon:
                                  const Icon(Icons.close, color: Colors.grey),
                              label: const Text('Batal',
                                  style: TextStyle(color: Colors.grey)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                onDelete();

                                // Show flushbar on top
                                Flushbar(
                                  message: 'Data berhasil dihapus',
                                  backgroundColor: Colors.red[600]!,
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: BorderRadius.circular(10),
                                  duration: const Duration(seconds: 2),
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.white),
                                  flushbarPosition: FlushbarPosition.TOP,
                                ).show(context);
                              },
                              icon: const Icon(Icons.delete,
                                  color: Colors.white),
                              label: const Text('Hapus'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.red),
                    label: const Text(
                      'Hapus',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blue[100],
      child: Text(
        penduduk.nama.isNotEmpty ? penduduk.nama[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[800], fontSize: 14),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.blue[900]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
