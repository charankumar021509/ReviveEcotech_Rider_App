import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme_controller.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String pickupAddress;
  final String dropAddress;
  final String pickupDate;
  final String pickupTime;
  final String customerPhone;
  final List<dynamic> scrapItems;
  final String orderId;
  final double latitude;
  final double longitude;
  final String userId;

  const OrderDetailsScreen({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.pickupDate,
    required this.pickupTime,
    required this.customerPhone,
    required this.scrapItems,
    required this.orderId,
    required this.latitude,
    required this.longitude,
    required this.userId,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isVerifying = false;

  // ── Colors ──
  static const _navy = Color(0xFF0B132B);
  static const _green = Color(0xFF10B981);
  static const _surface = Color(0xFF162032);

  /// ================= NAVIGATE =================
  Future<void> _openMap() async {
    final Uri mapUri = Uri.parse(
      'google.navigation:q=${widget.latitude},${widget.longitude}',
    );
    await launchUrl(mapUri, mode: LaunchMode.externalApplication);
  }

  /// ================= CALL CUSTOMER =================
  Future<void> _callCustomer() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: widget.customerPhone.trim());
    await launchUrl(phoneUri);
  }

  /// ================= VERIFY OTP =================
  Future<void> _verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    setState(() => isVerifying = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('pickups')
          .doc(widget.orderId)
          .get();

      final data = doc.data();

      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order not found')),
        );
        setState(() => isVerifying = false);
        return;
      }

      final firestoreOtp = data['pickupOtp'].toString();
      final enteredOtp = otpController.text.trim();

      if (enteredOtp != firestoreOtp) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
        setState(() => isVerifying = false);
        return;
      }

      await _completeOrder();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isVerifying = false);
  }

  /// ================= COMPLETE ORDER =================
  Future<void> _completeOrder() async {
    try {
      await FirebaseFirestore.instance
          .collection('pickups')
          .doc(widget.orderId)
          .update({
        'status': 'Completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': widget.userId,
        'title': 'Pickup Completed',
        'message': 'Your pickup has been completed successfully.',
        'createdAt': DateTime.now().toString(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order Completed Successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? _navy : const Color(0xFFEDF4F0),
          body: Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  children: [
                    _buildMapCard(isDark),
                    const SizedBox(height: 16),
                    _buildStatusAndId(isDark),
                    const SizedBox(height: 20),
                    _buildAddressCard(
                      isDark: isDark,
                      title: 'Pickup Address',
                      address: widget.pickupAddress,
                      icon: Icons.location_on_rounded,
                      iconColor: _green,
                    ),
                    const SizedBox(height: 12),
                    _buildAddressCard(
                      isDark: isDark,
                      title: 'Drop-off Address',
                      address: widget.dropAddress,
                      icon: Icons.flag_rounded,
                      iconColor: const Color(0xFF38BDF8),
                    ),
                    const SizedBox(height: 20),
                    _buildScheduleCard(isDark),
                    const SizedBox(height: 20),
                    _buildCustomerCard(isDark),
                    const SizedBox(height: 20),
                    _buildWasteCard(isDark),
                    const SizedBox(height: 24),
                    _buildActionButtons(isDark),
                    const SizedBox(height: 20),
                    _buildOtpCard(isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════ HEADER ═══════════════
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 56, 20, 20),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0B132B), Color(0xFF0D1F3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF003856), _green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(60) : _green.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          const Text(
            'Order Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: 'RedHatDisplay',
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════ MAP ═══════════════
  Widget _buildMapCard(bool isDark) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/dummy_map.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(80)],
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              left: 16,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pickup Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RedHatDisplay',
                      fontSize: 13,
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

  // ═══════════════ STATUS + ORDER ID ═══════════════
  Widget _buildStatusAndId(bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _green.withAlpha(20),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _green.withAlpha(100), width: 1.5),
            boxShadow: [
              BoxShadow(color: _green.withAlpha(30), blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _green,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: _green.withAlpha(120), blurRadius: 8)],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Out for Pickup',
                style: TextStyle(
                  color: _green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
            ],
          ),
        ),
        Text(
          '#${widget.orderId.length > 10 ? widget.orderId.substring(0, 10) : widget.orderId}...',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black45,
            fontFamily: 'RedHatDisplay',
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ═══════════════ ADDRESS CARD ═══════════════
  Widget _buildAddressCard({
    required bool isDark,
    required String title,
    required String address,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white12 : iconColor.withAlpha(40), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(20) : iconColor.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontFamily: 'RedHatDisplay',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.isNotEmpty ? address : 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0B132B),
                    fontFamily: 'RedHatDisplay',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════ SCHEDULE CARD ═══════════════
  Widget _buildScheduleCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? _surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white12 : _green.withAlpha(40), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(20) : _green.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pickup Schedule',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.black45,
              fontFamily: 'RedHatDisplay',
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _scheduleChip(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: widget.pickupDate,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _scheduleChip(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: widget.pickupTime,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scheduleChip({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? _navy : const Color(0xFFF0FAF6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green.withAlpha(30), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _green, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0B132B),
              fontFamily: 'RedHatDisplay',
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // ═══════════════ CUSTOMER CARD ═══════════════
  Widget _buildCustomerCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? _surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white12 : _green.withAlpha(40), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(20) : _green.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _green.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded, color: _green, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Details',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontFamily: 'RedHatDisplay',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.customerPhone,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0B132B),
                    fontFamily: 'RedHatDisplay',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _callCustomer,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _green,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: _green.withAlpha(80), blurRadius: 12)],
              ),
              child: const Icon(Icons.call_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════ WASTE DETAILS CARD ═══════════════
  Widget _buildWasteCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? _surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white12 : _green.withAlpha(40), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(20) : _green.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 5),
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
                decoration: BoxDecoration(color: _green.withAlpha(20), shape: BoxShape.circle),
                child: const Icon(Icons.recycling_rounded, color: _green, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Waste / Order Details',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0B132B),
                  fontFamily: 'RedHatDisplay',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.scrapItems.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _green.withAlpha(15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: _green.withAlpha(80), width: 1.2),
                ),
                child: Text(
                  item.toString(),
                  style: const TextStyle(
                    color: _green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'RedHatDisplay',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ═══════════════ ACTION BUTTONS ═══════════════
  Widget _buildActionButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            label: 'Navigate',
            icon: Icons.navigation_rounded,
            color: _green,
            onTap: _openMap,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _actionButton(
            label: 'Call Customer',
            icon: Icons.call_rounded,
            color: const Color(0xFF003856),
            onTap: _callCustomer,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: color.withAlpha(60), blurRadius: 14, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'RedHatDisplay',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════ OTP CARD ═══════════════
  Widget _buildOtpCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? _surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white12 : _green.withAlpha(50), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(30) : _green.withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: _green.withAlpha(20), shape: BoxShape.circle),
                child: const Icon(Icons.lock_outline_rounded, color: _green, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0B132B),
                        fontFamily: 'RedHatDisplay',
                      ),
                    ),
                    Text(
                      'Ask customer for OTP to complete pickup',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black45,
                        fontFamily: 'RedHatDisplay',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: isDark ? _navy : const Color(0xFFF0FAF6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _green.withAlpha(50), width: 1.5),
            ),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0B132B),
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'RedHatDisplay',
                letterSpacing: 4,
              ),
              decoration: InputDecoration(
                hintText: '- - - - - -',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white24 : Colors.black26,
                  fontSize: 20,
                  letterSpacing: 4,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: _green, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: isVerifying ? null : _verifyOtp,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: isVerifying
                      ? null
                      : const LinearGradient(
                          colors: [_green, Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  color: isVerifying ? _green.withAlpha(80) : null,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isVerifying
                      ? []
                      : [BoxShadow(color: _green.withAlpha(80), blurRadius: 14, offset: const Offset(0, 6))],
                ),
                child: Center(
                  child: isVerifying
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Verify OTP & Complete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'RedHatDisplay',
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}