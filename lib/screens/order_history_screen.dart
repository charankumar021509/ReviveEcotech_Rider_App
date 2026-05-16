import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'profile_settings_screen.dart';
import 'history_order_details_screen.dart';
import 'theme_controller.dart';
import '../widgets/custom_bottom_navbar.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String selectedFilter = 'Completed';
  String selectedDateRange = 'All';

  static const _green = Color(0xFF10B981);
  static const _navy = Color(0xFF0B132B);
  static const _surface = Color(0xFF162032);

  final List<String> _dateRanges = ['All', '1 Week', '1 Month', '6 Months'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Get cutoff date for date range filter
  DateTime? _getDateCutoff() {
    final now = DateTime.now();
    switch (selectedDateRange) {
      case '1 Week':
        return now.subtract(const Duration(days: 7));
      case '1 Month':
        return DateTime(now.year, now.month - 1, now.day);
      case '6 Months':
        return DateTime(now.year, now.month - 6, now.day);
      default:
        return null; // All — no cutoff
    }
  }

  /// Extract a sortable DateTime from order data
  DateTime _getOrderTimestamp(Map<String, dynamic> data) {
    // Prefer completedAt, fall back to pickupDate
    final completedAt = data['completedAt'];
    if (completedAt is Timestamp) {
      return completedAt.toDate();
    }
    final pickupDate = data['pickupDate'];
    if (pickupDate is Timestamp) {
      return pickupDate.toDate();
    }
    return DateTime(2000); // fallback for missing dates
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final bool isDark = value;
        final bgColor = isDark ? _navy : const Color(0xFFEDF4F0);
        final cardColor = isDark ? _surface : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF0B132B);
        final subtextColor = isDark ? Colors.white70 : Colors.black87;

        return Scaffold(
          backgroundColor: bgColor,
          bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
          appBar: AppBar(
            backgroundColor: isDark ? _navy : const Color(0xFF003856),
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: SafeArea(
            child: Column(
              children: [
                /// ================= HEADER =================
                _buildHeaderSection(isDark),

                /// ================= CONTENT =================
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// Status Filter (Completed / Declined)
                          _buildStatusFilters(isDark),
                          const SizedBox(height: 16),

                          /// Date Range Filter Chips
                          _buildDateRangeChips(isDark),
                          const SizedBox(height: 20),

                          /// History List
                          _buildHistorySection(isDark, textColor, subtextColor, cardColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [_navy, Color(0xFF0D1F3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF003856), _green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(50) : _green.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 22),
          _buildSearchBar(isDark),
        ],
      ),
    );
  }

  // ═══════════════ HEADER ═══════════════
  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('agents')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              String name = 'Agent';
              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                name = data['name']?.toString() ?? 'Agent';
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order History',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'RedHatDisplay',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'RedHatDisplay',
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(60), width: 2),
              boxShadow: [
                BoxShadow(color: _green.withAlpha(40), blurRadius: 12),
              ],
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: isDark ? _surface : Colors.white.withAlpha(40),
              child: const Icon(Icons.person, size: 28, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════ SEARCH BAR ═══════════════
  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? _surface : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white12 : _green.withAlpha(40), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontFamily: 'RedHatDisplay',
        ),
        decoration: InputDecoration(
          hintText: 'Search order address...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.black45,
            fontFamily: 'RedHatDisplay',
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? _green : Colors.black45,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  // ═══════════════ STATUS FILTER BUTTONS ═══════════════
  Widget _buildStatusFilters(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.black.withAlpha(8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildFilterButton('Completed', Icons.check_circle_outline, _green, isDark),
          const SizedBox(width: 8),
          _buildFilterButton('Declined', Icons.cancel_outlined, Colors.red, isDark),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter, IconData icon, Color activeColor, bool isDark) {
    final bool isSelected = selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: activeColor.withAlpha(80), blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : (isDark ? Colors.white54 : Colors.black54),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : (isDark ? Colors.white54 : Colors.black54),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RedHatDisplay',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════ DATE RANGE CHIPS ═══════════════
  Widget _buildDateRangeChips(bool isDark) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _dateRanges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final label = _dateRanges[index];
          final isSelected = selectedDateRange == label;
          return GestureDetector(
            onTap: () => setState(() => selectedDateRange = label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? _green
                    : (isDark ? _surface : Colors.white),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? _green
                      : (isDark ? Colors.white12 : _green.withAlpha(40)),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: _green.withAlpha(60), blurRadius: 10, offset: const Offset(0, 4))]
                    : [],
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black54),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'RedHatDisplay',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════ EMPTY STATE ═══════════════
  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 80,
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: Icon(
                      selectedFilter == 'Completed' ? Icons.check_circle : Icons.cancel,
                      size: 40,
                      color: selectedFilter == 'Completed' ? _green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No $selectedFilter Orders",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0B132B),
                fontFamily: 'RedHatDisplay',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You don't have any ${selectedFilter.toLowerCase()} orders\nmatching this criteria.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white54 : Colors.black54,
                fontFamily: 'RedHatDisplay',
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(bool isDark, Color textColor, Color subtextColor, Color cardColor) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('pickups').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(child: Text("Error loading history: ${snapshot.error}", style: TextStyle(color: textColor))),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(child: CircularProgressIndicator(color: _green)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(isDark);
        }

        final dateCutoff = _getDateCutoff();

        final orders = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          /// STATUS FILTER
          bool matchesFilter = false;
          if (selectedFilter == 'Completed') {
            matchesFilter = (data['status'] == 'Completed') && (data['declinedStatus'] != true);
          } else {
            matchesFilter = data['declinedStatus'] == true;
          }

          /// SEARCH
          final address = data['addressDetails'];
          final fullAddress = address?['fullAddress']?.toString().toLowerCase() ?? '';
          final matchesSearch = fullAddress.contains(searchQuery);

          /// DATE RANGE FILTER
          bool matchesDate = true;
          if (dateCutoff != null) {
            final orderTime = _getOrderTimestamp(data);
            matchesDate = orderTime.isAfter(dateCutoff);
          }

          return matchesFilter && matchesSearch && matchesDate;
        }).toList();

        // ── SORT: newest first by completedAt / pickupDate ──
        orders.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          final timeA = _getOrderTimestamp(dataA);
          final timeB = _getOrderTimestamp(dataB);
          return timeB.compareTo(timeA); // descending
        });

        if (orders.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final data = order.data() as Map<String, dynamic>;
            final address = data['addressDetails'];
            final scrapCats = (data['scrapCategories'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [];

            final isCompleted = selectedFilter == 'Completed';
            final statusColor = isCompleted ? _green : Colors.redAccent;

            // Format completion date for the card
            String completionLabel = '';
            final cAt = data['completedAt'];
            if (cAt is Timestamp) {
              completionLabel = DateFormat('dd MMM yyyy, hh:mm a').format(cAt.toDate());
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? _surface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white12 : statusColor.withAlpha(40),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withAlpha(20) : statusColor.withAlpha(15),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCompleted ? Icons.assignment_turned_in_rounded : Icons.assignment_late_rounded,
                          color: statusColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['customerName']?.toString() ?? 'Customer Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontFamily: 'RedHatDisplay',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (completionLabel.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                completionLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                  fontFamily: 'RedHatDisplay',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withAlpha(80), width: 1),
                        ),
                        child: Text(
                          isCompleted ? 'Done' : 'Declined',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                            fontFamily: 'RedHatDisplay',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Scrap chips
                  if (scrapCats.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: scrapCats.map((cat) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _green.withAlpha(15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _green.withAlpha(60), width: 1),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isDark ? _green : const Color(0xFF059669),
                              fontFamily: 'RedHatDisplay',
                            ),
                          ),
                        )).toList(),
                      ),
                    ),

                  // Detail Rows
                  _buildDetailRow(Icons.location_on_outlined, address?['fullAddress']?.toString() ?? '', subtextColor),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.calendar_month_outlined,
                    data['pickupDate'] is Timestamp
                        ? "Date: ${DateFormat('dd/MM/yyyy').format((data['pickupDate'] as Timestamp).toDate())}"
                        : "Date: ${data['pickupDate'] ?? ''}",
                    subtextColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.access_time_outlined, "Time: ${data['pickupTimeSlot'] ?? ''}", subtextColor),

                  const SizedBox(height: 16),

                  // View Details Button
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        final completedTimestamp = data['completedAt'];
                        String completedStr = '';
                        if (completedTimestamp is Timestamp) {
                          completedStr = DateFormat('dd MMM yyyy, hh:mm a').format(completedTimestamp.toDate());
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoryOrderDetailsScreen(
                              pickupAddress: address?['fullAddress']?.toString() ?? '',
                              dropAddress: 'Revive EcoTech',
                              pickupDate: data['pickupDate'] != null
                                  ? DateFormat('dd/MM/yyyy').format((data['pickupDate'] as Timestamp).toDate())
                                  : '',
                              pickupTime: data['pickupTimeSlot']?.toString() ?? '',
                              customerPhone: data['customerPhone']?.toString() ?? '',
                              scrapItems: data['scrapCategories'] ?? [],
                              orderId: order.id,
                              status: data['declinedStatus'] == true ? 'Declined' : 'Completed',
                              completedAt: completedStr,
                              customerName: data['customerName']?.toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark ? _navy : const Color(0xFF003856),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF003856).withAlpha(40),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'RedHatDisplay',
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                          ],
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

  Widget _buildDetailRow(IconData icon, String text, Color subtextColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _green, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: subtextColor,
              fontSize: 13,
              fontFamily: 'RedHatDisplay',
              height: 1.4,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}