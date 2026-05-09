import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> walletData = [
      {
        'customer': 'Customer #1',
        'amount': 250,
        'distance': '12 KM',
        'kg': '5 KG',
      },
      {
        'customer': 'Customer #2',
        'amount': 450,
        'distance': '20 KM',
        'kg': '8 KG',
      },
      {
        'customer': 'Customer #3',
        'amount': 320,
        'distance': '15 KM',
        'kg': '6 KG',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCF3E3),

      appBar: AppBar(
        backgroundColor: const Color(0xFF003856),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Wallet',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'RedHatDisplay',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // TOTAL WALLET CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF112237),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(80),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontFamily: 'RedHatDisplay',
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    '₹ 1,020',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RedHatDisplay',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // CUSTOMER LIST
            Expanded(
              child: ListView.builder(
                itemCount: walletData.length,
                itemBuilder: (context, index) {

                  final item = walletData[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: const Color(0xC8A6CB4E),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          item['customer'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RedHatDisplay',
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [

                            _buildInfoBox(
                              Icons.currency_rupee,
                              'Amount',
                              '₹ ${item['amount']}',
                            ),

                            _buildInfoBox(
                              Icons.location_on,
                              'Distance',
                              item['distance'],
                            ),

                            _buildInfoBox(
                              Icons.scale,
                              'Weight',
                              item['kg'],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: const Color(0xFF003856),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'RedHatDisplay',
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'RedHatDisplay',
            ),
          ),
        ],
      ),
    );
  }
}