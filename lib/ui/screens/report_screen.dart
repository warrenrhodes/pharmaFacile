import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/sale_model.dart';
import '../../providers/sale_provider.dart';

enum ReportType { daily, weekly, monthly }

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  ReportType _reportType = ReportType.daily;
  DateTime _selectedDate = DateTime.now();

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'F',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE d MMMM y', 'fr_FR').format(date);
  }

  List<Sale> _getFilteredSales(List<Sale> sales) {
    final startOfDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    switch (_reportType) {
      case ReportType.daily:
        final endOfDay = startOfDay
            .add(const Duration(days: 1))
            .subtract(const Duration(milliseconds: 1));
        return sales.where((sale) {
          final saleDate = sale.createdAt;
          return saleDate.isAfter(
                startOfDay.subtract(const Duration(milliseconds: 1)),
              ) &&
              saleDate.isBefore(endOfDay.add(const Duration(milliseconds: 1)));
        }).toList();

      case ReportType.weekly:
        final startOfWeek = startOfDay.subtract(
          Duration(days: startOfDay.weekday - 1),
        );
        final endOfWeek = startOfWeek
            .add(const Duration(days: 7))
            .subtract(const Duration(milliseconds: 1));
        return sales.where((sale) {
          final saleDate = sale.createdAt;
          return saleDate.isAfter(
                startOfWeek.subtract(const Duration(milliseconds: 1)),
              ) &&
              saleDate.isBefore(endOfWeek.add(const Duration(milliseconds: 1)));
        }).toList();

      case ReportType.monthly:
        final startOfMonth = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          1,
        );
        final endOfMonth = DateTime(
          _selectedDate.year,
          _selectedDate.month + 1,
          0,
          23,
          59,
          59,
          999,
        );
        return sales.where((sale) {
          final saleDate = sale.createdAt;
          return saleDate.isAfter(
                startOfMonth.subtract(const Duration(milliseconds: 1)),
              ) &&
              saleDate.isBefore(
                endOfMonth.add(const Duration(milliseconds: 1)),
              );
        }).toList();
    }
  }

  String _getReportPeriodText() {
    switch (_reportType) {
      case ReportType.daily:
        return 'Rapport du ${_formatDate(_selectedDate)}';
      case ReportType.weekly:
        final startOfWeek = _selectedDate.subtract(
          Duration(days: _selectedDate.weekday - 1),
        );
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return 'Semaine du ${_formatDate(startOfWeek)} au ${_formatDate(endOfWeek)}';
      case ReportType.monthly:
        return DateFormat('MMMM y', 'fr_FR').format(_selectedDate);
    }
  }

  void _handlePrint() {
    // TODO: Implement print functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🖨️ Fonctionnalité d\'impression sera bientôt disponible',
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleExportPDF() {
    // TODO: Implement PDF export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '📄 Fonctionnalité d\'export PDF sera bientôt disponible',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(saleListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEBF8FF), // blue-50
              Colors.white,
              Color(0xFFF3E8FF), // purple-50
            ],
          ),
        ),
        child: SafeArea(
          child: salesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur: $e')),
            data: (sales) {
              final filteredSales = _getFilteredSales(sales);
              final totalRevenue = filteredSales.fold(
                0.0,
                (sum, sale) => sum + sale.totalPriceInUTC,
              );
              final totalItems = filteredSales.fold(
                0,
                (sum, sale) =>
                    sum +
                    sale.salesItems.fold(0, (sum, sale) => sum + sale.quantity),
              );

              // Group sales by product for top products analysis
              final Map<String, Map<String, dynamic>> productSales = {};

              for (final sale
                  in filteredSales.map((e) => e.salesItems).expand((e) => e)) {
                if (productSales.containsKey(sale.productId)) {
                  productSales[sale.productId]!['quantity'] += sale.quantity;
                  productSales[sale.productId]!['revenue'] += sale.total;
                } else {
                  productSales[sale.productId] = {
                    'name': sale.productName,
                    'quantity': sale.quantity,
                    'revenue': sale.total,
                  };
                }
              }

              final topProducts = productSales.values.toList()
                ..sort(
                  (a, b) =>
                      (b['quantity'] as int).compareTo(a['quantity'] as int),
                );

              return Column(
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFFA855F7).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 28,
                                  color: Colors.grey,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rapports de Vente',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  Text(
                                    'Analyser les performances',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFA855F7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _handleExportPDF,
                                icon: const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: const Text(
                                  'Export PDF',
                                  style: TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  backgroundColor: const Color(0xFFEF4444),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: _handlePrint,
                                icon: const Icon(
                                  Icons.print,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: const Text(
                                  'Imprimer',
                                  style: TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  backgroundColor: const Color(0xFF2563EB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Report Controls
                          Container(
                            margin: const EdgeInsets.only(bottom: 32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE9D5FF),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Type de Rapport:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(0xFFE5E7EB),
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          _buildReportTypeButton(
                                            ReportType.daily,
                                            '📅 Journalier',
                                          ),
                                          _buildReportTypeButton(
                                            ReportType.weekly,
                                            '📊 Hebdomadaire',
                                          ),
                                          _buildReportTypeButton(
                                            ReportType.monthly,
                                            '📈 Mensuel',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    const Text(
                                      'Sélectionner la Date:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFE5E7EB),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate: _selectedDate,
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now(),
                                          );
                                          if (date != null) {
                                            setState(
                                              () => _selectedDate = date,
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              color: Color(0xFF6B7280),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              DateFormat(
                                                'dd/MM/yyyy',
                                              ).format(_selectedDate),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF374151),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFF3E8FF),
                                        Color(0xFFDBEAFE),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFC084FC),
                                    ),
                                  ),
                                  child: Text(
                                    _getReportPeriodText(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7C3AED),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Summary Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCard(
                                  icon: Icons.trending_up,
                                  title: 'Chiffre d\'Affaires',
                                  value: _formatCurrency(totalRevenue),
                                  subtitle: 'Total des ventes',
                                  color: const Color(0xFF22C55E),
                                  bgColor: const Color(0xFFDCFCE7),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _buildSummaryCard(
                                  icon: Icons.description,
                                  title: 'Transactions',
                                  value: '${filteredSales.length}',
                                  subtitle: 'Nombre de ventes',
                                  color: const Color(0xFF2563EB),
                                  bgColor: const Color(0xFFDBEAFE),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _buildSummaryCard(
                                  icon: Icons.bar_chart,
                                  title: 'Articles Vendus',
                                  value: '$totalItems',
                                  subtitle: 'Quantité totale',
                                  color: const Color(0xFFA855F7),
                                  bgColor: const Color(0xFFF3E8FF),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Content Grid
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Products
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFFED7AA),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            '🏆 Produits les Plus Vendus',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      if (topProducts.isNotEmpty)
                                        ...topProducts
                                            .take(5)
                                            .map(
                                              (product) => Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  20,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFFFFF7ED),
                                                          Color(0xFFFEF3C7),
                                                        ],
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFFED7AA,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 48,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFFFB923C,
                                                                ),
                                                                Color(
                                                                  0xFFEA580C,
                                                                ),
                                                              ],
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${topProducts.indexOf(product) + 1}',
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            product['name']
                                                                as String,
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                  color: Color(
                                                                    0xFF1F2937,
                                                                  ),
                                                                ),
                                                          ),
                                                          Text(
                                                            '${product['quantity']} unités vendues',
                                                            style:
                                                                const TextStyle(
                                                                  color: Color(
                                                                    0xFFEA580C,
                                                                  ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          _formatCurrency(
                                                            product['revenue']
                                                                as double,
                                                          ),
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                                color: Color(
                                                                  0xFF1F2937,
                                                                ),
                                                              ),
                                                        ),
                                                        const Text(
                                                          'Revenus',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF6B7280,
                                                            ),
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                      else
                                        _buildEmptyState(
                                          Icons.bar_chart,
                                          'Aucune vente pour cette période',
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 32),

                              // Recent Sales
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFDBEAFE),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            '🕒 Ventes Récentes',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      if (filteredSales.isNotEmpty)
                                        SizedBox(
                                          height: 400,
                                          child: ListView.builder(
                                            itemCount: filteredSales
                                                .take(10)
                                                .length,
                                            itemBuilder: (context, index) {
                                              final sale = filteredSales[index];
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  20,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFFDBEAFE),
                                                          Color(0xFFDCFCE7),
                                                        ],
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF93C5FD,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            DateFormat(
                                                              'HH:mm',
                                                            ).format(
                                                              sale.createdAt,
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                  color: Color(
                                                                    0xFF1F2937,
                                                                  ),
                                                                ),
                                                          ),
                                                          Text(
                                                            '${sale.salesItems.length} article(s)',
                                                            style:
                                                                const TextStyle(
                                                                  color: Color(
                                                                    0xFF2563EB,
                                                                  ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          Text(
                                                            'Vendeur: ${sale.cashier}',
                                                            style:
                                                                const TextStyle(
                                                                  color: Color(
                                                                    0xFF6B7280,
                                                                  ),
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          _formatCurrency(
                                                            sale.totalPriceInUTC,
                                                          ),
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                                color: Color(
                                                                  0xFF1F2937,
                                                                ),
                                                              ),
                                                        ),
                                                        const Text(
                                                          'Validée',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF22C55E,
                                                            ),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      else
                                        _buildEmptyState(
                                          Icons.schedule,
                                          'Aucune vente pour cette période',
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReportTypeButton(ReportType type, String label) {
    final isSelected = _reportType == type;
    return GestureDetector(
      onTap: () => setState(() => _reportType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 40, color: const Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
