import 'package:flutter/material.dart';

class OrderCompleteScreen extends StatefulWidget {
  const OrderCompleteScreen({super.key});

  @override
  State<OrderCompleteScreen> createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF3E3), // cream
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER + OVERLAY =================
            Stack(
              clipBehavior: Clip.none,
              children: [
                // 🔵 BLUE HEADER
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF003856),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: _buildHeaderContent(),
                ),

                // 🟦 OVERLAY ORDER COMPLETE CARD
                Positioned(
                  top: 160,
                  left: 25,
                  right: 25,
                  child: _buildOrderCompleteCard(),
                ),
              ],
            ),

            // ✅ RESPONSIVE SPACER (replaces hardcoded SizedBox)
            SizedBox(height: screenHeight * 0.28),

            // ⚪ ORDER DETAILS CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildOrderDetailsCard(),
            ),

            const SizedBox(height: 120), // Safe space above bottom nav
          ],
        ),
      ),

      // 🟢 BOTTOM NAV
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ================= HEADER CONTENT =================
  Widget _buildHeaderContent() {
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 30,
          right: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'RedHatDisplay',
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Bhai',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RedHatDisplay',
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFFFCF3E3),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFF003856),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= ORDER COMPLETE CARD =================
  Widget _buildOrderCompleteCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF112237),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(160),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                  // Later: pushReplacement to Dashboard
                },
              ),
              const Text(
                'ORDER COMPLETE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Container(
            height: 90,
            width: 90,
            decoration: const BoxDecoration(
              color: Color(0xFF71B947),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'You have completed the\norder Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'RedHatDisplay',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= ORDER DETAILS CARD =================
  Widget _buildOrderDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER DETAILS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'RedHatDisplay',
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Order ID', '12345**8'),
          const SizedBox(height: 15),
          _buildDetailRow('Customer', 'BHAI ON TOP'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'RedHatDisplay',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'RedHatDisplay',
          ),
        ),
      ],
    );
  }

  // ================= BOTTOM NAV BAR =================
  Widget _buildBottomNavBar() {
    final navBarItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.wallet_travel, 'label': 'Wallet'},
      {'icon': Icons.settings, 'label': 'Settings'},
      {'icon': Icons.history, 'label': 'History'},
    ];

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xC8A6CB4E),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(navBarItems.length, (index) {
          final item = navBarItems[index];
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: isSelected
                ? Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(
                        fontFamily: 'RedHatDisplay'),
                  ),
                ],
              ),
            )
                : Icon(
              item['icon'] as IconData,
              color: const Color(0xFF003856),
              size: 30,
            ),
          );
        }),
      ),
    );
  }
}
