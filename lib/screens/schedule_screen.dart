import 'package:flutter/material.dart';
import 'order_address_screen.dart';
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() =>
      _ScheduleScreenState();
}

class _ScheduleScreenState
    extends State<ScheduleScreen> {

  int currentStep = 0;

  final List<Map<String, dynamic>> steps = [

    {
      "title": "Order Accepted",
      "icon": Icons.check_circle,
    },

    {
      "title": "Pickup Started",
      "icon": Icons.inventory_2,
    },

    {
      "title": "On The Way",
      "icon": Icons.local_shipping,
    },

    {
      "title": "Completed",
      "icon": Icons.done_all,
    },
  ];

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
          "Order Status",

          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,

            fontFamily:
                'RedHatDisplay',
          ),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            Expanded(
              child: ListView.builder(

                itemCount: steps.length,

                itemBuilder:
                    (context, index) {

                  final step =
                      steps[index];

                  final isCompleted =
                      index <= currentStep;

                  return Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Column(
                        children: [

                          Container(
                            width: 40,
                            height: 40,

                            decoration:
                                BoxDecoration(
                              color:
                                  isCompleted
                                      ? Colors
                                          .green
                                      : Colors
                                          .grey,

                              shape: BoxShape
                                  .circle,
                            ),

                            child: Icon(
                              step['icon'],

                              color:
                                  Colors.white,
                            ),
                          ),

                          if (index !=
                              steps.length -
                                  1)

                            Container(
                              width: 4,
                              height: 70,

                              color:
                                  isCompleted
                                      ? Colors
                                          .green
                                      : Colors
                                          .grey
                                          .shade400,
                            ),
                        ],
                      ),

                      const SizedBox(
                          width: 20),

                      Expanded(
                        child: Container(

                          margin:
                              const EdgeInsets.only(
                                  bottom:
                                      20),

                          padding:
                              const EdgeInsets
                                  .all(20),

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

                          child: Text(
                            step['title'],

                            style:
                                const TextStyle(
                              fontSize:
                                  20,

                              fontWeight:
                                  FontWeight
                                      .bold,

                              fontFamily:
                                  'RedHatDisplay',
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  if (currentStep <
                      steps.length - 1) {

                    setState(() {

                      currentStep++;
                    });
                  }
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                          0xFF003856),

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            18),
                  ),
                ),

                child: Text(

                  currentStep ==
                          steps.length - 1

                      ? "Order Completed"

                      : "Next Step",

                  style:
                      const TextStyle(
                    color: Colors.white,

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,

                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}