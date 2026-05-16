import 'package:flutter/material.dart';
import 'theme_controller.dart';

class OrderCompleteScreen extends StatefulWidget {
  const OrderCompleteScreen({super.key});

  @override
  State<OrderCompleteScreen> createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen> {
  // ── Colors ──
  static const navy = Color(0xFF0B132B);
  static const green = Color(0xFF10B981);
  static const surface = Color(0xFF162032);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? navy : const Color(0xFFEDF4F0),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context, isDark),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _buildSuccessCard(isDark),
                      const SizedBox(height: 24),
                      _buildOrderDetailsCard(isDark),
                      const SizedBox(height: 40),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════ HEADER ═══════════════
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 56, 20, 40),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0B132B), Color(0xFF0D1F3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF003856), green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(60) : green.withAlpha(60),
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Home',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
              Text(
                'Order Complete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════ SUCCESS CARD ═══════════════
  Widget _buildSuccessCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? Colors.white12 : green.withAlpha(50), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(40) : green.withAlpha(20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: green.withAlpha(30),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: green.withAlpha(60), blurRadius: 20),
              ],
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 70,
              color: green,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Order Picked Up!',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0B132B),
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontFamily: 'RedHatDisplay',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You have completed the pickup successfully and items are verified.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontSize: 15,
              height: 1.5,
              fontFamily: 'RedHatDisplay',
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════ ORDER DETAILS CARD ═══════════════
  Widget _buildOrderDetailsCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white10 : green.withAlpha(30), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: green.withAlpha(20), shape: BoxShape.circle),
                child: const Icon(Icons.receipt_long_rounded, color: green, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'ORDER SUMMARY',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontFamily: 'RedHatDisplay',
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailRow('Order ID', '#12345**8', isDark),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white10, height: 1),
          ),
          _buildDetailRow('Customer', 'BHAI ON TOP', isDark),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white38 : Colors.black45,
            fontFamily: 'RedHatDisplay',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0B132B),
            fontFamily: 'RedHatDisplay',
          ),
        ),
      ],
    );
  }

  // ═══════════════ ACTION BUTTONS ═══════════════
  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [green, Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: green.withAlpha(80),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'DONE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.5,
                fontFamily: 'RedHatDisplay',
              ),
            ),
          ),
        ),
      ),
    );
  }
}