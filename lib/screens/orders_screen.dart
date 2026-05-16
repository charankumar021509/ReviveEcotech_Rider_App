import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'order_details_screen.dart';
import 'theme_controller.dart';
import '../widgets/custom_bottom_navbar.dart';
import 'dashboard_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Colors ──
    const navy = Color(0xFF0B132B);
    const green = Color(0xFF10B981);

    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final bool isDark = value;
        final bgColor = isDark ? navy : const Color(0xFFEDF4F0);
        final textColor = isDark ? Colors.white : navy;
        final subtextColor = isDark ? Colors.white70 : Colors.black87;

        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: bgColor,
            bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
            body: SafeArea(
              child: Column(
                children: [
                  /// ================= PREMIUM HEADER =================
                  _buildHeader(context, isDark),

                  /// ================= TAB CONTENT =================
                  Expanded(
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildOrdersList(
                          context: context,
                          status: 'Pending',
                          buttonText: 'Accept',
                          nextStatus: 'Confirmed',
                          isDark: isDark,
                          textColor: textColor,
                          subtextColor: subtextColor,
                        ),
                        _buildOrdersList(
                          context: context,
                          status: 'Confirmed',
                          buttonText: 'Start Pickup',
                          nextStatus: 'Out-for-Pickup',
                          isDark: isDark,
                          textColor: textColor,
                          subtextColor: subtextColor,
                        ),
                        _buildOrdersList(
                          context: context,
                          status: 'Out-for-Pickup',
                          buttonText: 'View Details',
                          nextStatus: '',
                          isDark: isDark,
                          textColor: textColor,
                          subtextColor: subtextColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    const navy = Color(0xFF0B132B);
    const green = Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [navy, Color(0xFF0D1F3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF003856), green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(60) : green.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    );
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Orders Schedule",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'RedHatDisplay',
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer to balance back button
              ],
            ),
          ),
          const SizedBox(height: 20),
          TabBar(
            indicatorColor: green,
            indicatorWeight: 4,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
            labelColor: green,
            unselectedLabelColor: Colors.white60,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontFamily: 'RedHatDisplay', fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'RedHatDisplay', fontSize: 14),
            tabs: const [
              Tab(text: "Pending"),
              Tab(text: "Confirmed"),
              Tab(text: "Pickup"),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════ EMPTY STATE ═══════════════
  Widget _buildEmptyState(String status, bool isDark) {
    const green = Color(0xFF10B981);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  Icons.content_paste_rounded,
                  size: 90,
                  color: isDark ? Colors.white10 : Colors.black.withAlpha(10),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: green, shape: BoxShape.circle),
                    child: const Icon(Icons.search_rounded, size: 28, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No $status Orders",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF0B132B),
              fontFamily: 'RedHatDisplay',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You don't have any ${status.toLowerCase()} orders\nat the moment.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.black45,
              fontFamily: 'RedHatDisplay',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════ ORDERS LIST ═══════════════
  Widget _buildOrdersList({
    required BuildContext context,
    required String status,
    required String buttonText,
    required String nextStatus,
    required bool isDark,
    required Color textColor,
    required Color subtextColor,
  }) {
    final currentUser = FirebaseAuth.instance.currentUser;
    const green = Color(0xFF10B981);
    const surface = Color(0xFF162032);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('agents').doc(currentUser!.uid).get(),
      builder: (context, agentSnapshot) {
        if (agentSnapshot.hasError) {
          return Center(child: Text("Error: ${agentSnapshot.error}", style: TextStyle(color: textColor)));
        }
        if (!agentSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: green));
        }

        final agentData = agentSnapshot.data!.data() as Map<String, dynamic>;
        final isOnline = agentData['isOnline'] ?? true;

        if (!isOnline && status == 'Pending') {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.red.withAlpha(20), shape: BoxShape.circle),
                  child: const Icon(Icons.portable_wifi_off_rounded, color: Colors.redAccent, size: 50),
                ),
                const SizedBox(height: 20),
                Text(
                  'You are offline',
                  style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'RedHatDisplay'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Go online from the dashboard\nto see new orders.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontFamily: 'RedHatDisplay'),
                ),
              ],
            ),
          );
        }

        return StreamBuilder<QuerySnapshot>(
          stream: status == 'Pending'
              ? FirebaseFirestore.instance.collection('pickups').where('status', isEqualTo: status).snapshots()
              : FirebaseFirestore.instance.collection('pickups').where('status', isEqualTo: status).where('agentId', isEqualTo: currentUser.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: green));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState(status, isDark);
            }

            final orders = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final declinedBy = List<String>.from(data['declinedBy'] ?? []);
              return !declinedBy.contains(currentUser.uid);
            }).toList();

            orders.sort((a, b) {
              final dataA = a.data() as Map<String, dynamic>;
              final dataB = b.data() as Map<String, dynamic>;
              return _getPickupDateTime(dataA).compareTo(_getPickupDateTime(dataB));
            });

            if (orders.isEmpty) {
              return _buildEmptyState(status, isDark);
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
              physics: const BouncingScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final data = order.data() as Map<String, dynamic>;
                final address = data['addressDetails'] as Map<String, dynamic>?;
                final canStartPickup = DateTime.now().isAfter(_getPickupDateTime(data));
                final scrapCats = (data['scrapCategories'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? surface : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: isDark ? Colors.white12 : green.withAlpha(40), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withAlpha(30) : green.withAlpha(15),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: (isDark ? Colors.black : Colors.green).withAlpha(20), shape: BoxShape.circle),
                            child: const Icon(Icons.eco_rounded, color: green, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['customerName']?.toString() ?? "New Order",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                    fontFamily: 'RedHatDisplay',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (scrapCats.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: scrapCats.map((cat) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: green.withAlpha(15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: green.withAlpha(60), width: 1),
                                      ),
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: isDark ? green : const Color(0xFF059669),
                                          fontFamily: 'RedHatDisplay',
                                        ),
                                      ),
                                    )).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(color: Colors.white10, height: 1),
                      ),
                      
                      // Details
                      _buildDetailRow(Icons.location_on_rounded, address?['fullAddress']?.toString() ?? '', subtextColor),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMiniDetail(
                              Icons.calendar_today_rounded, 
                              data['pickupDate'] is Timestamp 
                                  ? DateFormat('dd MMM yyyy').format((data['pickupDate'] as Timestamp).toDate())
                                  : data['pickupDate'] ?? '',
                              isDark
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildMiniDetail(Icons.access_time_filled_rounded, data['pickupTimeSlot'] ?? '', isDark),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Buttons
                      if (status == 'Pending')
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await FirebaseFirestore.instance.collection('pickups').doc(order.id).update({
                                    'declinedBy': FieldValue.arrayUnion([currentUser.uid]),
                                    'declinedStatus': true,
                                    'declinedAt': FieldValue.serverTimestamp(),
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Declined'), backgroundColor: Colors.redAccent));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withAlpha(20),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.redAccent.withAlpha(60), width: 1.5),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Decline',
                                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'RedHatDisplay'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final orderRef = FirebaseFirestore.instance.collection('pickups').doc(order.id);
                                  bool accepted = false;
                                  
                                  await FirebaseFirestore.instance.runTransaction((transaction) async {
                                    final snapshot = await transaction.get(orderRef);
                                    final orderData = snapshot.data();
                                    if (orderData?['agentId'] != null) return;
                                    
                                    transaction.update(orderRef, {
                                      'status': 'Confirmed',
                                      'agentId': currentUser.uid,
                                      'acceptedAt': FieldValue.serverTimestamp(),
                                    });
                                    accepted = true;
                                  });
                                  
                                  if (!accepted) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order already accepted by another rider'), backgroundColor: Colors.orange));
                                    return;
                                  }
                                  
                                  await FirebaseFirestore.instance.collection('notifications').add({
                                    'userId': data['userId'],
                                    'title': 'Order Accepted',
                                    'message': 'Your order has been accepted by the rider.',
                                    'createdAt': DateTime.now().toString(),
                                  });
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Accepted Successfully'), backgroundColor: green));
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    final tabController = DefaultTabController.of(context);
                                    if (tabController != null) tabController.animateTo(1);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [green, Color(0xFF059669)]),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [BoxShadow(color: green.withAlpha(60), blurRadius: 10, offset: const Offset(0, 4))],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'RedHatDisplay'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        GestureDetector(
                          onTap: status == 'Confirmed' 
                              ? (canStartPickup ? () async {
                                  final otp = 1000 + (DateTime.now().millisecondsSinceEpoch % 9000);
                                  await FirebaseFirestore.instance.collection('pickups').doc(order.id).update({
                                    'status': nextStatus,
                                    'pickupOtp': otp,
                                    'pickupStartedAt': FieldValue.serverTimestamp(),
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pickup Started Successfully\nOTP: $otp'), backgroundColor: green));
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    final tabController = DefaultTabController.of(context);
                                    if (tabController != null) tabController.animateTo(2);
                                  });
                                } : null)
                              : () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsScreen(
                                    pickupAddress: address?['fullAddress']?.toString() ?? '',
                                    dropAddress: 'Revive EcoTech',
                                    pickupDate: data['pickupDate'] != null 
                                        ? DateFormat('dd/MM/yyyy').format((data['pickupDate'] as Timestamp).toDate()) 
                                        : '',
                                    pickupTime: data['pickupTimeSlot']?.toString() ?? '',
                                    customerPhone: data['customerPhone']?.toString() ?? '',
                                    scrapItems: data['scrapCategories'] ?? [],
                                    orderId: order.id,
                                    latitude: (address?['latitude'] ?? 0.0).toDouble(),
                                    longitude: (address?['longitude'] ?? 0.0).toDouble(),
                                    userId: data['userId']?.toString() ?? '',
                                  )));
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: status == 'Confirmed' 
                                  ? (canStartPickup ? green : Colors.grey.withAlpha(50))
                                  : const Color(0xFF003856),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: status == 'Confirmed' && canStartPickup
                                  ? [BoxShadow(color: green.withAlpha(60), blurRadius: 10, offset: const Offset(0, 4))]
                                  : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  buttonText,
                                  style: TextStyle(
                                    color: (status == 'Confirmed' && !canStartPickup) ? Colors.white38 : Colors.white, 
                                    fontWeight: FontWeight.w900, 
                                    fontSize: 16, 
                                    fontFamily: 'RedHatDisplay'
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios_rounded, 
                                  color: (status == 'Confirmed' && !canStartPickup) ? Colors.white24 : Colors.white, 
                                  size: 16
                                ),
                              ],
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
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color subtextColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: const Color(0xFF10B981).withAlpha(15), shape: BoxShape.circle),
          child: const Icon(Icons.location_pin, color: Color(0xFF10B981), size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: subtextColor, fontSize: 13, fontFamily: 'RedHatDisplay', height: 1.4, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniDetail(IconData icon, String value, bool isDark) {
    const navy = Color(0xFF0B132B);
    const green = Color(0xFF10B981);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? navy : const Color(0xFFF0FAF6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: green, size: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : navy,
                fontFamily: 'RedHatDisplay',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static DateTime _getPickupDateTime(Map<String, dynamic> data) {
    try {
      final pickupDate = data['pickupDate'];
      final pickupTime = data['pickupTimeSlot']?.toString() ?? '';
      DateTime date;
      if (pickupDate is Timestamp) {
        date = pickupDate.toDate();
      } else {
        date = DateTime.now();
      }
      final cleanedTime = pickupTime.split('-').first.trim();
      final isPM = cleanedTime.toLowerCase().contains('pm');
      final time = cleanedTime.replaceAll(RegExp(r'[a-zA-Z]'), '').trim();
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      int minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      if (isPM && hour < 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      return DateTime.now();
    }
  }
}