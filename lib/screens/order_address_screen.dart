import 'package:flutter/material.dart';
import 'schedule_screen.dart';

class AddressScreen extends StatelessWidget {

  final String customer;
  final String pickup;
  final String delivery;
  final String phone;
  final String status;

  const AddressScreen({
    super.key,
    required this.customer,
    required this.pickup,
    required this.delivery,
    required this.phone,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFFCF3E3),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF003856),

        elevation: 0,

        centerTitle: true,

        title: const Text(
          'Addresses',

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'RedHatDisplay',
          ),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Container(
          width: double.infinity,

          padding:
              const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color:
                const Color(0xC8A6CB4E),

            borderRadius:
                BorderRadius.circular(
                    20),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                customer,

                style:
                    const TextStyle(
                  fontSize: 28,

                  fontWeight:
                      FontWeight.bold,

                  fontFamily:
                      'RedHatDisplay',
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [

                  const Icon(
                    Icons.location_on,
                    color:
                        Color(0xFF003856),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Pickup: $pickup',

                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontFamily:
                            'RedHatDisplay',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  const Icon(
                    Icons.home,
                    color:
                        Color(0xFF003856),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Delivery: $delivery',

                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontFamily:
                            'RedHatDisplay',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  const Icon(
                    Icons.phone,
                    color:
                        Color(0xFF003856),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    phone,

                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontFamily:
                          'RedHatDisplay',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),

                child: Text(
                  status,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,

                    fontSize: 16,

                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  ElevatedButton.icon(
                    onPressed: () {},

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                              0xFF003856),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                    ),

                    icon: const Icon(
                      Icons.map,
                      color: Colors.white,
                    ),

                    label: const Text(
                      'Maps',

                      style: TextStyle(
                        color: Colors.white,
                        fontFamily:
                            'RedHatDisplay',
                      ),
                    ),
                  ),

                  ElevatedButton.icon(

                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              const ScheduleScreen(),
                        ),
                      );
                    },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                              0xFF003856),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                    ),

                    icon: const Icon(
                      Icons.timeline,
                      color: Colors.white,
                    ),

                    label: const Text(
                      'Timeline',

                      style: TextStyle(
                        color: Colors.white,
                        fontFamily:
                            'RedHatDisplay',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}