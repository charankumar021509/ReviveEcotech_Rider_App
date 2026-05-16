import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/notification_service.dart';

class PickupTimerWidget
    extends StatefulWidget {

  const PickupTimerWidget({
    super.key,
  });

  @override
  State<PickupTimerWidget>
      createState() =>
          _PickupTimerWidgetState();
}

class _PickupTimerWidgetState
    extends State<PickupTimerWidget> {

  Timer? _timer;

  Duration remainingTime =
      Duration.zero;

  bool
      _pickupNotificationShown =
      false;

  @override
  void initState() {

    super.initState();

    _startPickupTimer();
  }

  void _startPickupTimer() {

    _timer?.cancel();

    _timer = Timer.periodic(

      const Duration(seconds: 1),

      (_) async {

        try {

          final snapshot =
              await FirebaseFirestore
                  .instance
                  .collection(
                      'pickups')
                  .where(
                    'status',
                    whereIn: [

                      'Confirmed',

                      'Out-for-Pickup',
                    ],
                  )
                  .orderBy(
                    'pickupDate',
                  )
                  .limit(1)
                  .get();

          if (snapshot
              .docs
              .isEmpty) {

            return;
          }

          final data =
              snapshot.docs.first
                  .data();

          final Timestamp?
              pickupTimestamp =
              data['pickupDate'];

          final pickupTimeSlot =
              data['pickupTimeSlot']
                      ?.toString() ??
                  '';

          if (pickupTimestamp ==
                  null ||
              pickupTimeSlot
                  .isEmpty) {

            return;
          }

          final pickupDate =
              pickupTimestamp
                  .toDate();

          final cleanedTime =
              pickupTimeSlot
                  .split('-')
                  .first
                  .trim();

          final isPM =
              cleanedTime
                  .contains(
                      'PM');

          final time =
              cleanedTime
                  .replaceAll(
                      'AM', '')
                  .replaceAll(
                      'PM', '')
                  .trim();

          final parts =
              time.split(':');

          int hour =
              int.parse(
                  parts[0]);

          final minute =
              int.parse(
                  parts[1]);

          if (isPM &&
              hour < 12) {

            hour += 12;
          }

          if (!isPM &&
              hour == 12) {

            hour = 0;
          }

          final pickupDateTime =
              DateTime(

            pickupDate.year,
            pickupDate.month,
            pickupDate.day,
            hour,
            minute,
          );

          final difference =
              pickupDateTime
                  .difference(
                      DateTime.now());

          if (!mounted) return;

          setState(() {

            remainingTime =
                difference;
          });

          if (difference
                  .inSeconds <=
              0) {

            if (!_pickupNotificationShown) {

              _pickupNotificationShown =
                  true;

              await NotificationService
                  .showLocalNotification(

                title:
                    'Pickup Time Reached',

                body:
                    'Order is ready for pickup',
              );
            }

          } else {

            _pickupNotificationShown =
                false;
          }

        } catch (e) {

          debugPrint(
            'Timer Error: $e',
          );
        }
      },
    );
  }

  String _formatDuration(
      Duration duration) {

    final hours =
        duration.inHours;

    final minutes =
        duration.inMinutes
            .remainder(60);

    final seconds =
        duration.inSeconds
            .remainder(60);

    return
        '${hours.toString().padLeft(2, '0')} : '
        '${minutes.toString().padLeft(2, '0')} : '
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {

    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.all(
              20),

      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),

      decoration:
          BoxDecoration(

        color:
            Colors.orange.shade100,

        borderRadius:
            BorderRadius.circular(
                20),
      ),

      child: Column(

        children: [

          const Text(

            'Next Pickup Timer',

            style: TextStyle(

              fontSize: 20,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
              height: 12),

          Text(

            _formatDuration(
                remainingTime),

            style: const TextStyle(

              fontSize: 32,

              fontWeight:
                  FontWeight.bold,

              color:
                  Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}