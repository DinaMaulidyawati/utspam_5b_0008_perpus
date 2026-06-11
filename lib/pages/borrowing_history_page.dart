import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/borrowing.dart';
import '../helpers/database_helper.dart';
import 'borrowing_detail_page.dart';

class BorrowingHistoryPage extends StatefulWidget {
  final User user;

  const BorrowingHistoryPage({super.key, required this.user});

  @override
  State<BorrowingHistoryPage> createState() => _BorrowingHistoryPageState();
}

class _BorrowingHistoryPageState extends State<BorrowingHistoryPage> {
  List<Borrowing> borrowings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBorrowings();
  }

  Future<void> _loadBorrowings() async {
    setState(() => isLoading = true);
    final loadedBorrowings = await DatabaseHelper.instance
        .getBorrowingsByUserId(widget.user.id!);
    setState(() {
      borrowings = loadedBorrowings;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
        elevation: 0,
        backgroundColor: const Color(0xFFE85D75),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : borrowings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat peminjaman',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai pinjam buku sekarang!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadBorrowings,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: borrowings.length,
                itemBuilder: (context, index) {
                  final borrowing = borrowings[index];
                  return _buildBorrowingCard(borrowing);
                },
              ),
            ),
    );
  }

  Widget _buildBorrowingCard(Borrowing borrowing) {
    final startDate = DateTime.parse(borrowing.startDate);
    final formattedDate = DateFormat('dd MMM yyyy').format(startDate);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BorrowingDetailPage(
                borrowingId: borrowing.id!,
                user: widget.user,
              ),
            ),
          );

          if (result == true) {
            _loadBorrowings();
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  borrowing.bookCover,
                  width: 70,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 90,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.book,
                        size: 35,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      borrowing.bookTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            borrowing.borrowerName,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${borrowing.durationDays} hari',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              borrowing.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getStatusColor(borrowing.status),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(borrowing.status),
                                size: 14,
                                color: _getStatusColor(borrowing.status),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                borrowing.status,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: _getStatusColor(borrowing.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Rp ${borrowing.totalCost.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
