import 'package:flutter/material.dart';
import 'order_address_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final Map<String, List<Map<String, dynamic>>> schedules = {

      "2 Sep 2026": [

        {
          "customer": "Rahul Sharma",
          "time": "10:30 AM",
          "kg": "12.5 KG",
          "scrap": "Paper",
          "pickup": "Sector 21, Gandhinagar",
          "delivery": "Ahmedabad",
          "phone": "9876543210",
          "status": "Pending",
        },

        {
          "customer": "Amit Kumar",
          "time": "11:00 AM",
          "kg": "5 KG",
          "scrap": "Plastic",
          "pickup": "Sector 10, Gandhinagar",
          "delivery": "Ahmedabad",
          "phone": "9123456780",
          "status": "Accepted",
        },
      ],

      "5 Sep 2026": [

        {
          "customer": "Priya Patel",
          "time": "2:00 PM",
          "kg": "7 KG",
          "scrap": "Glass",
          "pickup": "Surat",
          "delivery": "Vadodara",
          "phone": "9988776655",
          "status": "Pending",
        },
      ],
    };

    return Scaffold(

      backgroundColor:
          const Color(0xFFFCF3E3),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF003856),

        centerTitle: true,

        title: const Text(
          "Orders Schedule",

          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(20),

        children:
            schedules.entries.map((entry) {

          final date = entry.key;
          final orders = entry.value;

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // DATE
              Text(
                date,

                style:
                    const TextStyle(
                  fontSize: 24,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(0xFF003856),
                ),
              ),

              const SizedBox(height: 15),

              // ORDERS
              ...orders.map((order) {

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            AddressScreen(

                          customer:
                              order[
                                  'customer'],

                          pickup:
                              order[
                                  'pickup'],

                          delivery:
                              order[
                                  'delivery'],

                          phone:
                              order[
                                  'phone'],

                          status:
                              order[
                                  'status'],
                        ),
                      ),
                    );
                  },

                  child: Container(

                    margin:
                        const EdgeInsets.only(
                            bottom: 15),

                    padding:
                        const EdgeInsets.all(
                            18),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                              0xC8A6CB4E),

                      borderRadius:
                          BorderRadius
                              .circular(
                                  20),
                    ),

                    child: Row(

                      children: [

                        SizedBox(
                          width: 85,

                          child: Text(
                            order['time'],

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,

                              color:
                                  Color(
                                      0xFF003856),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                order[
                                    'customer'],

                                style:
                                    const TextStyle(
                                  fontSize:
                                      20,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                  height:
                                      5),

                              Text(
                                "${order['kg']} • ${order['scrap']}",
                              ),

                              const SizedBox(
                                  height:
                                      5),

                              Text(
                                order[
                                    'pickup'],
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons
                              .arrow_forward_ios,
                          color:
                              Color(0xFF003856),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 25),
            ],
          );
        }).toList(),
      ),
    );
  }
}