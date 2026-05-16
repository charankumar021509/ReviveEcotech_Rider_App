import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme_controller.dart';

/// ================= APP COLORS =================
class AppColors {
  static const Color primaryGreen =
      Color(0xFF71B947);

  static const Color softBlack =
      Color(0xFF212121);

  static const Color lightGrey =
      Color(0xFFF5F5F5);

  static const Color darkBlue =
      Color(0xFF0F3653);
}

class OrderDetailsScreen
    extends StatefulWidget {
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
  State<OrderDetailsScreen>
      createState() =>
          _OrderDetailsScreenState();
}

class _OrderDetailsScreenState
    extends State<OrderDetailsScreen> {
  final TextEditingController
      otpController =
          TextEditingController();

  bool isVerifying = false;

  /// ================= NAVIGATE =================
  Future<void> _openMap() async {
    final Uri mapUri = Uri.parse(
      'google.navigation:q=${widget.latitude},${widget.longitude}',
    );

    await launchUrl(
      mapUri,
      mode: LaunchMode.externalApplication,
    );
  }

  /// ================= CALL CUSTOMER =================
  Future<void> _callCustomer() async {
    final phone =
        widget.customerPhone.trim();

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    await launchUrl(phoneUri);
  }

  /// ================= VERIFY OTP =================
  Future<void> _verifyOtp() async {
    if (otpController.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter OTP',
          ),
        ),
      );

      return;
    }

    setState(() {
      isVerifying = true;
    });

    try {
      final doc =
          await FirebaseFirestore
              .instance
              .collection('pickups')
              .doc(widget.orderId)
              .get();

      final data = doc.data();

      if (data == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Order not found',
            ),
          ),
        );

        setState(() {
          isVerifying = false;
        });

        return;
      }

     final firestoreOtp =
         data['pickupOtp']
             .toString();

     final enteredOtp =
         otpController.text
             .trim();

     if (enteredOtp !=
         firestoreOtp) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid OTP',
            ),
          ),
        );

        setState(() {
          isVerifying = false;
        });

        return;
      }

      await _completeOrder();

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isVerifying = false;
    });
  }

  /// ================= COMPLETE ORDER =================
  Future<void> _completeOrder() async {
    try {
      /// UPDATE FIRESTORE STATUS
      await FirebaseFirestore
          .instance
          .collection('pickups')
          .doc(widget.orderId)
          .update({
        'status': 'Completed',
        'completedAt':
            FieldValue.serverTimestamp(),
      });

      /// SEND CUSTOMER NOTIFICATION
      await FirebaseFirestore
          .instance
          .collection('notifications')
          .add({
        'userId': widget.userId,
        'title': 'Pickup Completed',
        'message':
            'Your pickup has been completed successfully.',
        'createdAt':
            DateTime.now().toString(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Order Completed Successfully',
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder:
          (context, value, child) {
        return Theme(
          data:
              Theme.of(context)
                  .copyWith(
            textTheme:
                Theme.of(context)
                    .textTheme
                    .apply(
                      fontFamily:
                          'RedHatDisplay',
                    ),
          ),
          child: Scaffold(
            backgroundColor:
                isDarkMode.value
                    ? const Color(
                        0xFF1E1E1E)
                    : Colors.white,
            body: SafeArea(
              child: ListView(
                padding:
                    const EdgeInsets.only(
                  bottom: 30,
                ),
                children: [
                  _buildHeader(
                      context),

                  _buildMap(),

                  _buildOrderId(),

                  const SizedBox(
                      height: 16),

                  _buildStatusChip(),

                  const SizedBox(
                      height: 16),

                  _buildAddressCard(
                    title:
                        'Pickup Address',
                    address:
                        widget
                            .pickupAddress,
                  ),

                  const SizedBox(
                      height: 10),

                  _buildAddressCard(
                    title:
                        'Drop-off Address',
                    address:
                        widget
                            .dropAddress,
                  ),

                  const SizedBox(
                      height: 16),

                  _buildTimeRow(
                    'Pickup Date',
                    widget
                        .pickupDate,
                  ),

                  _buildTimeRow(
                    'Pickup Time',
                    widget
                        .pickupTime,
                  ),

                  Divider(
                    height: 32,
                    color:
                        isDarkMode
                                .value
                            ? Colors
                                .white24
                            : Colors
                                .black12,
                  ),

                  _buildCustomerDetails(),

                  const SizedBox(
                      height: 16),

                  _buildCustomerOrder(),

                  const SizedBox(
                      height: 24),

                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                    ),
                    child:
                        _buildActionButtons(),
                  ),

                  const SizedBox(
                      height: 24),

                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                    ),
                    child:
                        _buildOtpCard(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader(
      BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Row(
        children: [
          IconButton(
            padding:
                EdgeInsets.zero,
            constraints:
                const BoxConstraints(),
            icon: Icon(
              Icons.arrow_back,
              color:
                  isDarkMode.value
                      ? Colors.white
                      : Colors.black,
            ),
            onPressed: () =>
                Navigator.pop(
                    context),
          ),

          const SizedBox(
              width: 8),

          Text(
            'Order Details',
            style: TextStyle(
              fontSize: 23,
              fontWeight:
                  FontWeight.bold,
              color:
                  isDarkMode.value
                      ? Colors.white
                      : AppColors
                          .softBlack,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= STATUS CHIP =================
  Widget _buildStatusChip() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Align(
        alignment:
            Alignment.centerLeft,
        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius:
                BorderRadius.circular(
                    30),
          ),
          child: const Text(
            'Out for Pickup',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  /// ================= MAP =================
  Widget _buildMap() {
    return Image.asset(
      'assets/images/dummy_map.jpg',
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  /// ================= ORDER ID =================
  Widget _buildOrderId() {
    return Padding(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          Expanded(
            child:
                SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child: Text(
                'Order ID ${widget.orderId}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      isDarkMode.value
                          ? Colors.white
                          : AppColors
                              .softBlack,
                ),
              ),
            ),
          ),

          const Icon(
            Icons.account_circle,
            color:
                AppColors
                    .primaryGreen,
            size: 40,
          ),
        ],
      ),
    );
  }

  /// ================= ADDRESS CARD =================
  Widget _buildAddressCard({
    required String title,
    required String address,
  }) {
    return Card(
      color:
          isDarkMode.value
              ? const Color(
                  0xFF2A2A2A)
              : AppColors.lightGrey,
      margin:
          const EdgeInsets.symmetric(
              horizontal: 16),
      elevation: 2,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
                14),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.location_on,
          color:
              AppColors
                  .primaryGreen,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight:
                FontWeight.w700,
            fontSize: 18,
            color:
                isDarkMode.value
                    ? Colors.white
                    : AppColors
                        .softBlack,
          ),
        ),
        subtitle: Padding(
          padding:
              const EdgeInsets.only(
            top: 6,
          ),
          child: Text(
            address,
            style: TextStyle(
              fontWeight:
                  FontWeight.w600,
              fontSize: 16,
              color:
                  isDarkMode.value
                      ? Colors.white70
                      : AppColors
                          .softBlack,
            ),
          ),
        ),
      ),
    );
  }

  /// ================= TIME ROW =================
  Widget _buildTimeRow(
      String label,
      String time) {
    return Padding(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 24,
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
              fontSize: 18,
              color:
                  isDarkMode.value
                      ? Colors.white
                      : AppColors
                          .softBlack,
            ),
          ),

          Text(
            time,
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 18,
              color:
                  isDarkMode.value
                      ? Colors.white
                      : AppColors
                          .softBlack,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CUSTOMER DETAILS =================
  Widget _buildCustomerDetails() {
    return Padding(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
              color:
                  isDarkMode.value
                      ? Colors.white
                      : AppColors
                          .softBlack,
            ),
          ),

          const SizedBox(
              height: 10),

          Text(
            'Phone: ${widget.customerPhone}',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w600,
              color:
                  isDarkMode.value
                      ? Colors.white70
                      : AppColors
                          .softBlack,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CUSTOMER ORDER =================
  Widget _buildCustomerOrder() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,
      children: [
        Padding(
          padding:
              const EdgeInsets
                  .symmetric(
            horizontal: 24,
          ),
          child: Text(
            'Waste / Order Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
              color:
                  isDarkMode.value
                      ? Colors.white
                      : AppColors
                          .softBlack,
            ),
          ),
        ),

        ...widget.scrapItems.map(
          (item) => _buildItem(
            item.toString(),
          ),
        ),
      ],
    );
  }

  /// ================= ITEM =================
  Widget _buildItem(
      String name) {
    return ListTile(
      contentPadding:
          const EdgeInsets
              .symmetric(
        horizontal: 24,
      ),
      visualDensity:
          const VisualDensity(
              vertical: -2),
      title: Text(
        name,
        style: TextStyle(
          fontWeight:
              FontWeight.w700,
          fontSize: 18,
          color:
              isDarkMode.value
                  ? Colors.white
                  : AppColors
                      .softBlack,
        ),
      ),
    );
  }

  /// ================= ACTION BUTTONS =================
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed:
                _openMap,
            style:
                ElevatedButton
                    .styleFrom(
              backgroundColor:
                  AppColors
                      .primaryGreen,
              padding:
                  const EdgeInsets
                      .symmetric(
                vertical: 16,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        12),
              ),
            ),
            child: const Text(
              'Navigate',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight
                        .w800,
                color:
                    Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(
            width: 16),

        Expanded(
          child: ElevatedButton(
            onPressed:
                _callCustomer,
            style:
                ElevatedButton
                    .styleFrom(
              backgroundColor:
                  AppColors.darkBlue,
              padding:
                  const EdgeInsets
                      .symmetric(
                vertical: 16,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        12),
              ),
            ),
            child: const Text(
              'Call Customer',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight
                        .w800,
                color:
                    Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ================= OTP CARD =================
  Widget _buildOtpCard() {
    return Card(
      elevation: 3,
      color:
          isDarkMode.value
              ? const Color(
                  0xFF2A2A2A)
              : Colors.white,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
                18),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(
                18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
              'OTP Verification',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
                color:
                    isDarkMode.value
                        ? Colors.white
                        : AppColors
                            .softBlack,
              ),
            ),

            const SizedBox(
                height: 10),

            Text(
              'Ask customer for OTP to complete pickup.',
              style: TextStyle(
                fontSize: 15,
                color:
                    isDarkMode.value
                        ? Colors.white70
                        : Colors.black54,
              ),
            ),

            const SizedBox(
                height: 20),

            TextField(
              controller:
                  otpController,
              keyboardType:
                  TextInputType.number,
              style: TextStyle(
                color:
                    isDarkMode.value
                        ? Colors.white
                        : Colors.black,
              ),
              decoration:
                  InputDecoration(
                hintText:
                    'Enter OTP',
                hintStyle:
                    TextStyle(
                  color:
                      isDarkMode.value
                          ? Colors.white54
                          : Colors.black45,
                ),
                filled: true,
                fillColor:
                    isDarkMode.value
                        ? Colors.black26
                        : Colors.grey
                            .shade100,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          14),
                  borderSide:
                      BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
            ),

            const SizedBox(
                height: 20),

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton(
                onPressed:
                    isVerifying
                        ? null
                        : _verifyOtp,
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.orange,
                  disabledBackgroundColor:
                      Colors.orange
                          .shade300,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 18,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),
                ),
                child:
                    isVerifying
                        ? const SizedBox(
                            height:
                                22,
                            width:
                                22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2.5,
                              color:
                                  Colors.white,
                            ),
                          )
                        : const Text(
                            'Verify OTP & Complete',
                            style:
                                TextStyle(
                              fontSize:
                                  18,
                              fontWeight:
                                  FontWeight
                                      .w800,
                              color:
                                  Colors.white,
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