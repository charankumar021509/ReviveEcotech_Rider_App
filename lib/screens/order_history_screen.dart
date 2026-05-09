import 'package:flutter/material.dart';
import 'profile_settings_screen.dart';
import 'order_details_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFFCF3E3),

      body: Column(
        children: [

          /// HEADER
          Container(
            height: 190,
            width: double.infinity,

            decoration: const BoxDecoration(
              color: Color(0xFF003856),

              borderRadius:
                  BorderRadius.only(
                bottomLeft:
                    Radius.circular(35),
                bottomRight:
                    Radius.circular(35),
              ),
            ),

            child: _buildHeader(),
          ),

          /// CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),

                child: Column(
                  children: [

                    _buildSearchBar(),

                    const SizedBox(
                        height: 20),

                    _buildHistorySection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader() {

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 40,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: const [

              Text(
                'Welcome back',

                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily:
                      'RedHatDisplay',
                ),
              ),

              SizedBox(height: 2),

              Text(
                'Bhai',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      'RedHatDisplay',
                ),
              ),

              SizedBox(height: 6),

              Row(
                children: [

                  Icon(
                    Icons
                        .workspace_premium,
                    color:
                        Colors.white70,
                    size: 16,
                  ),

                  SizedBox(width: 5),

                  Text(
                    'Priority',

                    style: TextStyle(
                      color:
                          Colors.white70,
                      fontFamily:
                          'RedHatDisplay',
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// PROFILE
          GestureDetector(
            onTap: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const ProfileSettingsScreen(),
                ),
              );
            },

            child: const CircleAvatar(
              radius: 35,
              backgroundColor:
                  Color(0xFFFCF3E3),

              child: Icon(
                Icons.person,
                size: 40,
                color:
                    Color(0xFF003856),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SEARCH BAR =================
  Widget _buildSearchBar() {

    return Row(
      children: [

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color:
                  const Color(0xFF2C2C2C),

              borderRadius:
                  BorderRadius.circular(
                      15),
            ),

            child: const TextField(
              style: TextStyle(
                  color: Colors.white),

              decoration: InputDecoration(
                hintText: 'Search here',

                hintStyle: TextStyle(
                    color:
                        Colors.white54),

                prefixIcon: Icon(
                  Icons.search,
                  color:
                      Colors.white54,
                ),

                border:
                    InputBorder.none,

                contentPadding:
                    EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 15),

        /// FILTER
        Container(
          padding:
              const EdgeInsets.all(5),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
                    15),

            border: Border.all(
              color:
                  Colors.grey.shade300,
            ),
          ),

          child:
              PopupMenuButton<String>(
            icon: const Icon(
              Icons.tune,
              color: Colors.black,
            ),

            onSelected: (value) {

              ScaffoldMessenger.of(
                      context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    '$value selected',
                  ),
                ),
              );
            },

            itemBuilder: (context) =>
                [

              const PopupMenuItem(
                value: 'Latest',
                child: Text('Latest'),
              ),

              const PopupMenuItem(
                value: 'Oldest',
                child: Text('Oldest'),
              ),

              const PopupMenuItem(
                value: 'Completed',
                child:
                    Text('Completed'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= HISTORY SECTION =================
  Widget _buildHistorySection() {

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: const [

              Text(
                'History',

                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      'RedHatDisplay',
                ),
              ),

              Row(
                children: [

                  Text(
                    'Sort by',

                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily:
                          'RedHatDisplay',
                    ),
                  ),

                  SizedBox(width: 5),

                  Text(
                    'Latest',

                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontFamily:
                          'RedHatDisplay',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          _buildHistoryItem(),

          const SizedBox(height: 15),

          _buildHistoryItem(),

          const SizedBox(height: 15),

          _buildHistoryItem(),

          const SizedBox(height: 15),

          _buildHistoryItem(),
        ],
      ),
    );
  }

  /// ================= HISTORY ITEM =================
  Widget _buildHistoryItem() {

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
            const Color(0xC8A6CB4E),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: const [

                Text(
                  'Customer #1',

                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Required to pick up: 13:10',

                  style: TextStyle(
                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Pick up Location',

                  style: TextStyle(
                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Delivery address',

                  style: TextStyle(
                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// DETAILS BUTTON
          ElevatedButton(
            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const OrderDetailsScreen(),
                ),
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.white,

              foregroundColor:
                  Colors.black,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .circular(20),
              ),
            ),

            child: const Text(
              'Details',

              style: TextStyle(
                fontFamily:
                    'RedHatDisplay',
              ),
            ),
          ),
        ],
      ),
    );
  }
}