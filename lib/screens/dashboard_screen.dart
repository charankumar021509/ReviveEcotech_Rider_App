import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'orders_screen.dart';
import 'order_history_screen.dart';
import 'settings_screen.dart';
import 'profile_settings_screen.dart';
import 'order_details_screen.dart';
import 'theme_controller.dart';
import '../localization/app_localizations.dart';
import '../services/notification_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AppLocalizations lang;
  int _selectedIndex = 0;
  String riderName = 'Rider';
  bool isLoadingUser = true;

  bool isOnline = true;

  Timer? _timer;
  DateTime currentTime = DateTime.now();
  bool _pickupNotificationShown = false;

  // ── Animation controllers ──
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    fetchUserData();
    _startLiveTimer();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    // Start animations after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  void _startLiveTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        if (!mounted) return;
        setState(() {
          currentTime = DateTime.now();
        });

        try {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) return;

          final snapshot = await FirebaseFirestore.instance
              .collection('pickups')
              .where('status', isEqualTo: 'Confirmed')
              .where('agentId', isEqualTo: currentUser.uid)
              .get();

          if (snapshot.docs.isEmpty) return;

          final docs = snapshot.docs;
          docs.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;

            final dateA = _getPickupDateTime(
              pickupDate: dataA['pickupDate'],
              pickupTimeSlot: dataA['pickupTimeSlot']?.toString() ?? '',
            );
            final dateB = _getPickupDateTime(
              pickupDate: dataB['pickupDate'],
              pickupTimeSlot: dataB['pickupTimeSlot']?.toString() ?? '',
            );
            return dateA.compareTo(dateB);
          });

          final nearestOrder = docs.first.data() as Map<String, dynamic>;
          final pickupDateTime = _getPickupDateTime(
            pickupDate: nearestOrder['pickupDate'],
            pickupTimeSlot: nearestOrder['pickupTimeSlot']?.toString() ?? '',
          );

          final remainingSeconds = pickupDateTime.difference(currentTime).inSeconds;

          if (remainingSeconds <= 0 && !_pickupNotificationShown) {
            _pickupNotificationShown = true;
            await NotificationService.showLocalNotification(
              title: 'Pickup Time Reached',
              body: 'Order is ready for pickup',
            );
          }

          if (remainingSeconds > 0) {
            _pickupNotificationShown = false;
          }
        } catch (e) {
          debugPrint('Timer notification error: $e');
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('agents')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            riderName = doc['name'] ?? 'Rider';
            isLoadingUser = false;
          });
        }
      }
    } catch (e) {
      if(mounted) {
        setState(() {
          isLoadingUser = false;
        });
      }
    }
  }

  DateTime _getPickupDateTime({
    required dynamic pickupDate,
    required String pickupTimeSlot,
  }) {
    try {
      DateTime parsedDate;
      if (pickupDate is Timestamp) {
        parsedDate = pickupDate.toDate();
      } else {
        final dateParts = pickupDate.toString().split('-');
        parsedDate = DateTime(
          int.parse(dateParts[2]),
          int.parse(dateParts[1]),
          int.parse(dateParts[0]),
        );
      }

      String time = pickupTimeSlot;
      if (pickupTimeSlot.contains('-')) {
        time = pickupTimeSlot.split('-').first.trim();
      }

      final isPM = time.toLowerCase().contains('pm');
      time = time
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .replaceAll('am', '')
          .replaceAll('pm', '')
          .trim();

      final timeParts = time.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      return DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        hour,
        minute,
      );
    } catch (e) {
      return DateTime.now();
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '00h : 00m : 00s';
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '${hours}h : ${minutes}m : ${seconds}s';
  }

  String formatDate(dynamic date) {
    if (date == null) return '';
    if (date is Timestamp) {
      final converted = date.toDate();
      return "${converted.day}/${converted.month}/${converted.year}";
    }
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context); // assign FIRST before anything else

    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFEDF4F0),
          bottomNavigationBar: _buildBottomNavBar(isDark),
          body: Column(
            children: [
              _buildHeader(isDark),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(isDark),
                      const SizedBox(height: 24),
                      _buildBannerCard(),
                      const SizedBox(height: 24),
                      _buildStatsSection(isDark),
                      const SizedBox(height: 24),
                      Text(
                        lang.translate('today_activity') ?? 'Today\'s Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0B132B),
                          fontFamily: 'RedHatDisplay',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildActivitySection(isDark),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0B132B), Color(0xFF0D1F3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF003856), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(60) : const Color(0xFF10B981).withAlpha(60),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.translate('welcome') ?? 'Welcome',
                style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'RedHatDisplay'),
              ),
              const SizedBox(height: 2),
              Text(
                riderName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  setState(() => isOnline = !isOnline);
                  final u = FirebaseAuth.instance.currentUser;
                  if (u != null) {
                    await FirebaseFirestore.instance.collection('agents').doc(u.uid).update({'isOnline': isOnline});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOnline ? const Color(0xFF10B981).withAlpha(30) : Colors.redAccent.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isOnline ? const Color(0xFF10B981) : Colors.redAccent, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isOnline ? const Color(0xFF10B981) : Colors.redAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (isOnline) BoxShadow(color: const Color(0xFF10B981).withAlpha(100), blurRadius: 8),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: isOnline ? const Color(0xFF10B981) : Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RedHatDisplay',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
              ).then((_) => fetchUserData());
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF10B981).withAlpha(150), width: 2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF10B981).withAlpha(50), blurRadius: 15),
                ],
              ),
              child: const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFF162032),
                child: Icon(Icons.person, color: Colors.white, size: 28),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162032) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFF10B981).withAlpha(40),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(30) : const Color(0xFF10B981).withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontFamily: 'RedHatDisplay'),
        decoration: InputDecoration(
          hintText: lang.translate('search_orders') ?? 'Search Orders...',
          hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45, fontFamily: 'RedHatDisplay'),
          prefixIcon: Icon(Icons.search_rounded, color: isDark ? Colors.white54 : Colors.grey.shade400, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/globe_picture.jpg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withAlpha(20), Colors.black.withAlpha(180)],
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Revive EcoTech',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                fontFamily: 'RedHatDisplay',
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Smart Recycling Pickup System',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'RedHatDisplay',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(bool isDark) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pickups')
          .where('agentId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final docs = snapshot.data!.docs;
        final today = DateTime.now();

        int completedToday = 0;
        int pendingOrders = 0;
        int totalPickups = docs.length;

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final status = data['status']?.toString() ?? '';

          if (status == 'Confirmed') pendingOrders++;

          if (status == 'Completed') {
            final completedAt = data['completedAt'];
            if (completedAt is Timestamp) {
              final completedDate = completedAt.toDate();
              if (completedDate.year == today.year &&
                  completedDate.month == today.month &&
                  completedDate.day == today.day) {
                completedToday++;
              }
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.translate('overview') ?? 'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0B132B),
                fontFamily: 'RedHatDisplay',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    label: 'Completed\nToday',
                    value: completedToday.toString(),
                    icon: Icons.check_circle_rounded,
                    iconColor: const Color(0xFF10B981),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatCard(
                    label: 'Pending\nOrders',
                    value: pendingOrders.toString(),
                    icon: Icons.hourglass_empty_rounded,
                    iconColor: const Color(0xFFFFB347),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatCard(
                    label: 'Total\nPickups',
                    value: totalPickups.toString(),
                    icon: Icons.local_shipping_rounded,
                    iconColor: const Color(0xFF38BDF8),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162032) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFF10B981).withAlpha(50),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(20) : const Color(0xFF10B981).withAlpha(20),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withAlpha(20), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF0B132B),
              fontFamily: 'RedHatDisplay',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.black54,
              height: 1.3,
              fontFamily: 'RedHatDisplay',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(bool isDark) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Center(child: Text('Rider not logged in'));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pickups')
          .where('status', isEqualTo: 'Confirmed')
          .where('agentId', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        if (snapshot.data!.docs.isEmpty) return _buildNoActivityCard(isDark);

        final docs = snapshot.data!.docs;
        docs.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          final dateA = _getPickupDateTime(
            pickupDate: dataA['pickupDate'],
            pickupTimeSlot: dataA['pickupTimeSlot']?.toString() ?? '',
          );
          final dateB = _getPickupDateTime(
            pickupDate: dataB['pickupDate'],
            pickupTimeSlot: dataB['pickupTimeSlot']?.toString() ?? '',
          );
          return dateA.compareTo(dateB);
        });

        final order = docs.first;
        final data = order.data() as Map<String, dynamic>;
        final address = data['addressDetails'];

        final pickupDateTime = _getPickupDateTime(
          pickupDate: data['pickupDate'],
          pickupTimeSlot: data['pickupTimeSlot']?.toString() ?? '',
        );

        final isUpcoming = currentTime.isBefore(pickupDateTime);
        final remainingTime = pickupDateTime.difference(currentTime);

        if (isUpcoming) {
          return _buildUpcomingPickupCard(data: data, remainingTime: remainingTime, isDark: isDark);
        } else {
          return _buildActivePickupCard(order: order, data: data, address: address, isDark: isDark);
        }
      },
    );
  }

  Widget _buildUpcomingPickupCard({
    required Map<String, dynamic> data,
    required Duration remainingTime,
    required bool isDark,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162032) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFF10B981).withAlpha(50),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(30) : const Color(0xFF10B981).withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF10B981).withAlpha(20), shape: BoxShape.circle),
                child: const Icon(Icons.schedule_rounded, color: Color(0xFF10B981), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Upcoming Order',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0B132B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Pickup starts in:',
            style: TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'RedHatDisplay'),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDuration(remainingTime),
            style: TextStyle(
              color: isDark ? const Color(0xFF10B981) : const Color(0xFF003856),
              fontSize: 34,
              fontWeight: FontWeight.w900,
              fontFamily: 'RedHatDisplay',
              shadows: [
                if (isDark) Shadow(color: const Color(0xFF10B981).withAlpha(80), blurRadius: 15),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: isDark ? Colors.white12 : Colors.black12),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.person_outline, 'Customer', data['customerName'] ?? 'Customer', isDark),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.calendar_today_outlined, 'Date', formatDate(data['pickupDate']), isDark),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.access_time_outlined, 'Time', data['pickupTimeSlot'] ?? '', isDark),
        ],
      ),
    );
  }

  Widget _buildActivePickupCard({
    required QueryDocumentSnapshot order,
    required Map<String, dynamic> data,
    required dynamic address,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
              pickupAddress: address?['fullAddress']?.toString() ?? '',
              dropAddress: 'Revive EcoTech',
              pickupDate: formatDate(data['pickupDate']),
              pickupTime: data['pickupTimeSlot']?.toString() ?? '',
              customerPhone: data['customerPhone']?.toString() ?? '',
              scrapItems: data['scrapCategories'] as List? ?? [],
              orderId: order.id,
              latitude: (address?['latitude'] ?? 0.0).toDouble(),
              longitude: (address?['longitude'] ?? 0.0).toDouble(),
              userId: data['userId']?.toString() ?? '',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFF10B981).withAlpha(50), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withAlpha(40), shape: BoxShape.circle),
                  child: const Icon(Icons.airport_shuttle_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Active Pickup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'RedHatDisplay',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoRow(Icons.person, 'Customer', data['customerName'] ?? 'Customer', true, color: Colors.white),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.category, 'Items', (data['scrapCategories'] as List).join(', '), true, color: Colors.white),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, 'Address', address?['fullAddress'] ?? '', true, color: Colors.white),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Start Pickup',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    fontFamily: 'RedHatDisplay',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, bool isDark, {Color? color}) {
    final c = color ?? (isDark ? Colors.white70 : Colors.black87);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: c.withAlpha(150)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$title: ',
              style: TextStyle(color: c.withAlpha(150), fontSize: 14, fontFamily: 'RedHatDisplay'),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'RedHatDisplay'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoActivityCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162032) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFF10B981).withAlpha(40),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(20) : const Color(0xFF10B981).withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.coffee_rounded, size: 60, color: isDark ? Colors.white24 : Colors.black26),
          const SizedBox(height: 20),
          Text(
            'No Activity Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
              fontFamily: 'RedHatDisplay',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162032) : Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: isDark ? Colors.white12 : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF10B981),
          unselectedItemColor: isDark ? Colors.white30 : Colors.black38,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'RedHatDisplay', fontWeight: FontWeight.bold, fontSize: 12),
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())).then((_) => setState(() => _selectedIndex = 0));
            }
            if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen())).then((_) => setState(() => _selectedIndex = 0));
            }
            if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())).then((_) => setState(() => _selectedIndex = 0));
            }
          },
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_rounded), label: 'Orders'),
            const BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
            const BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}