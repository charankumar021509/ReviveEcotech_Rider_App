import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'theme_controller.dart';

class HistoryOrderDetailsScreen extends StatelessWidget {
  final String pickupAddress;
  final String dropAddress;
  final String pickupDate;
  final String pickupTime;
  final String customerPhone;
  final List<dynamic> scrapItems;
  final String orderId;
  final String status; // "Completed" or "Declined"
  final String? completedAt;
  final String? customerName;

  static const _navy = Color(0xFF0B132B);
  static const _green = Color(0xFF10B981);
  static const _surface = Color(0xFF162032);
  static const _red = Colors.redAccent;

  const HistoryOrderDetailsScreen({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.pickupDate,
    required this.pickupTime,
    required this.customerPhone,
    required this.scrapItems,
    required this.orderId,
    required this.status,
    this.completedAt,
    this.customerName,
  });

  bool get isCompleted => status == 'Completed';

  Color get statusColor => isCompleted ? _green : _red;
  IconData get statusIcon =>
      isCompleted ? Icons.check_circle_rounded : Icons.cancel_rounded;
  String get statusLabel => isCompleted ? 'Completed' : 'Declined';

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
                    _buildStatusBanner(isDark),
                    const SizedBox(height: 20),
                    _buildTimeline(isDark),
                    const SizedBox(height: 20),
                    _buildAddressCard(isDark),
                    const SizedBox(height: 14),
                    _buildScheduleCard(isDark),
                    const SizedBox(height: 14),
                    _buildCustomerCard(isDark),
                    const SizedBox(height: 14),
                    _buildWasteCard(isDark),
                    const SizedBox(height: 14),
                    if (completedAt != null && completedAt!.isNotEmpty)
                      _buildCompletionCard(isDark),
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
      padding: const EdgeInsets.fromLTRB(8, 56, 20, 22),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0B132B), Color(0xFF0D1F3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [const Color(0xFF003856), statusColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(60)
                : statusColor.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'History Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                fontFamily: 'RedHatDisplay',
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white38, width: 1),
            ),
            child: Text(
              statusLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'RedHatDisplay',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════ STATUS BANNER ═══════════════
  Widget _buildStatusBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [
                  const Color(0xFF10B981).withAlpha(30),
                  const Color(0xFF059669).withAlpha(10)
                ]
              : [Colors.red.withAlpha(30), Colors.redAccent.withAlpha(10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withAlpha(80),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCompleted ? 'Pickup Completed' : 'Order Declined',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                    fontFamily: 'RedHatDisplay',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCompleted
                      ? 'This order was successfully completed.'
                      : 'This order was declined.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : Colors.black54,
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
    );
  }

  // ═══════════════ TIMELINE ═══════════════
  Widget _buildTimeline(bool isDark) {
    final steps = isCompleted
        ? [
            _TimelineStep(
                icon: Icons.add_circle_outline_rounded,
                label: 'Order Placed',
                done: true),
            _TimelineStep(
                icon: Icons.verified_outlined,
                label: 'Order Confirmed',
                done: true),
            _TimelineStep(
                icon: Icons.airport_shuttle_rounded,
                label: 'Pickup Started',
                done: true),
            _TimelineStep(
                icon: Icons.location_on_rounded,
                label: 'Reached Location',
                done: true),
            _TimelineStep(
                icon: Icons.task_alt_rounded,
                label: 'Pickup Completed',
                done: true),
          ]
        : [
            _TimelineStep(
                icon: Icons.add_circle_outline_rounded,
                label: 'Order Placed',
                done: true),
            _TimelineStep(
                icon: Icons.verified_outlined,
                label: 'Order Confirmed',
                done: true),
            _TimelineStep(
                icon: Icons.cancel_rounded,
                label: 'Order Declined',
                done: true,
                isError: true),
          ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? _surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark ? Colors.white12 : _green.withAlpha(40),
            width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(20)
                : _green.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Timeline',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
              fontFamily: 'RedHatDisplay',
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final isLast = i == steps.length - 1;
            return _buildTimelineStep(
                step: step, isLast: isLast, isDark: isDark);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required _TimelineStep step,
    required bool isLast,
    required bool isDark,
  }) {
    final dotColor = step.isError ? Colors.redAccent : _green;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: dotColor.withAlpha(20),
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: dotColor.withAlpha(60), blurRadius: 8),
                    ],
                  ),
                  child: Icon(step.icon, color: dotColor, size: 18),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            dotColor.withAlpha(80),
                            dotColor.withAlpha(20),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Label
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20, top: 6),
              child: Text(
                step.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0B132B),
                  fontFamily: 'RedHatDisplay',
                ),
              ),
            ),
          ),
          // Check icon
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(
              step.isError
                  ? Icons.close_rounded
                  : Icons.check_rounded,
              color: dotColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════ ADDRESS CARD ═══════════════
  Widget _buildAddressCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecor(isDark, _green),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Address Details', Icons.location_on_rounded, isDark),
          const SizedBox(height: 14),
          _infoRow(Icons.location_on_outlined, 'Pickup', pickupAddress, isDark),
          if (dropAddress.isNotEmpty) ...[
            const SizedBox(height: 10),
            _infoRow(Icons.flag_rounded, 'Drop-off', dropAddress, isDark,
                color: const Color(0xFF38BDF8)),
          ],
        ],
      ),
    );
  }

  // ═══════════════ SCHEDULE CARD ═══════════════
  Widget _buildScheduleCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecor(isDark, _green),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Pickup Schedule', Icons.calendar_today_rounded, isDark),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _scheduleChip(
                    Icons.calendar_today_rounded, 'Date', pickupDate, isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _scheduleChip(
                    Icons.access_time_rounded, 'Time', pickupTime, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════ CUSTOMER CARD ═══════════════
  Widget _buildCustomerCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecor(isDark, _green),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Customer Details', Icons.person_rounded, isDark),
          const SizedBox(height: 14),
          if (customerName != null && customerName!.isNotEmpty)
            _infoRow(Icons.badge_outlined, 'Name', customerName!, isDark),
          if (customerName != null && customerName!.isNotEmpty)
            const SizedBox(height: 10),
          _infoRow(Icons.phone_outlined, 'Phone', customerPhone, isDark),
        ],
      ),
    );
  }

  // ═══════════════ WASTE DETAILS CARD ═══════════════
  Widget _buildWasteCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecor(isDark, _green),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Waste Details', Icons.recycling_rounded, isDark),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: scrapItems.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
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

  // ═══════════════ COMPLETION CARD ═══════════════
  Widget _buildCompletionCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecor(isDark, statusColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isCompleted ? 'Completion Details' : 'Decline Details',
            isCompleted ? Icons.task_alt_rounded : Icons.info_outline_rounded,
            isDark,
            color: statusColor,
          ),
          const SizedBox(height: 14),
          _infoRow(
            isCompleted ? Icons.access_time_filled_rounded : Icons.cancel_outlined,
            isCompleted ? 'Completed At' : 'Declined At',
            completedAt!,
            isDark,
            color: statusColor,
          ),
        ],
      ),
    );
  }

  // ═══════════════ HELPERS ═══════════════
  BoxDecoration _cardDecor(bool isDark, Color accentColor) {
    return BoxDecoration(
      color: isDark ? _surface : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? Colors.white12 : accentColor.withAlpha(40),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black.withAlpha(20) : accentColor.withAlpha(15),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Widget _cardTitle(String title, IconData icon, bool isDark,
      {Color? color}) {
    final c = color ?? _green;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration:
              BoxDecoration(color: c.withAlpha(20), shape: BoxShape.circle),
          child: Icon(icon, color: c, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black54,
            fontFamily: 'RedHatDisplay',
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value, bool isDark,
      {Color? color}) {
    final c = color ?? _green;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: c, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : 'N/A',
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
    );
  }

  Widget _scheduleChip(
      IconData icon, String label, String value, bool isDark) {
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
              Icon(icon, color: _green, size: 14),
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
}

// ═══ Timeline step model ═══
class _TimelineStep {
  final IconData icon;
  final String label;
  final bool done;
  final bool isError;

  const _TimelineStep({
    required this.icon,
    required this.label,
    required this.done,
    this.isError = false,
  });
}
