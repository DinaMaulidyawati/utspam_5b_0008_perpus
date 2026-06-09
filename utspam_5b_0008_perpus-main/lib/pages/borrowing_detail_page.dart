import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/borrowing.dart';
import '../helpers/database_helper.dart';
import 'borrow_form_page.dart';

class BorrowingDetailPage extends StatefulWidget {
  final int borrowingId;
  final User user;

  const BorrowingDetailPage({
    super.key,
    required this.borrowingId,
    required this.user,
  });

  @override
  State<BorrowingDetailPage> createState() => _BorrowingDetailPageState();
}

class _BorrowingDetailPageState extends State<BorrowingDetailPage> {
  Borrowing? borrowing;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBorrowing();
  }

  Future<void> _loadBorrowing() async {
    setState(() => isLoading = true);
    final loadedBorrowing = await DatabaseHelper.instance.getBorrowingById(
      widget.borrowingId,
    );
    setState(() {
      borrowing = loadedBorrowing;
      isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Colors.green;
      case 'selesai':
        return Colors.blue;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Icons.access_time_rounded;
      case 'selesai':
        return Icons.check_circle_rounded;
      case 'dibatalkan':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  Future<void> _cancelBorrowing() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembatalan'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan peminjaman ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed == true && borrowing != null) {
      try {
        await DatabaseHelper.instance.updateBorrowingStatus(
          borrowing!.id!,
          'dibatalkan',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Peminjaman berhasil dibatalkan'),
              backgroundColor: Colors.orange,
            ),
          );
          await _loadBorrowing();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal membatalkan peminjaman'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _editBorrowing() async {
    if (borrowing == null) return;
    final book = Book(
      id: borrowing!.bookId,
      title: borrowing!.bookTitle,
      genre: borrowing!.bookGenre,
      pricePerDay: borrowing!.bookPricePerDay,
      coverUrl: borrowing!.bookCover,
      synopsis: '',
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BorrowFormPage(
          user: widget.user,
          book: book,
          existingBorrowing: borrowing,
        ),
      ),
    );

    if (result == true) {
      await _loadBorrowing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Peminjaman'),
        elevation: 0,
        backgroundColor: const Color(0xFFE85D75),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : borrowing == null
          ? const Center(child: Text('Data tidak ditemukan'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            child: Image.network(
                              borrowing!.bookCover,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          borrowing!.bookTitle,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            borrowing!.bookGenre,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          borrowing!.status,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getStatusColor(borrowing!.status),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getStatusIcon(borrowing!.status),
                            color: _getStatusColor(borrowing!.status),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Status: ${borrowing!.status}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: _getStatusColor(borrowing!.status),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Peminjaman',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        _buildDetailCard(
                          icon: Icons.person_outline,
                          label: 'Nama Peminjam',
                          value: borrowing!.borrowerName,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),

                        _buildDetailCard(
                          icon: Icons.calendar_today_outlined,
                          label: 'Tanggal Mulai',
                          value: DateFormat(
                            'dd MMMM yyyy',
                          ).format(DateTime.parse(borrowing!.startDate)),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 12),

                        _buildDetailCard(
                          icon: Icons.access_time_outlined,
                          label: 'Lama Pinjam',
                          value: '${borrowing!.durationDays} hari',
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(height: 12),

                        _buildDetailCard(
                          icon: Icons.monetization_on_outlined,
                          label: 'Harga per Hari',
                          value:
                              'Rp ${borrowing!.bookPricePerDay.toStringAsFixed(0)}',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.payments_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Total Biaya',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Text(
                                'Rp ${borrowing!.totalCost.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (borrowing!.status.toLowerCase() == 'aktif') ...[
                          FilledButton.icon(
                            onPressed: _editBorrowing,
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Edit Peminjaman'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _cancelBorrowing,
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('Batalkan Peminjaman'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
