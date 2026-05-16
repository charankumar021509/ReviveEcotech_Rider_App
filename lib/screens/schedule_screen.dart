import 'package:flutter/material.dart';
import 'theme_controller.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int currentStep = 0;

  // ── Colors ──
  static const navy = Color(0xFF0B132B);
  static const green = Color(0xFF10B981);
  static const surface = Color(0xFF162032);

  final List<Map<String, dynamic>> steps = [
    {
      "title": "Order Accepted",
      "subtitle": "The customer's order is confirmed",
      "icon": Icons.check_circle_rounded,
    },
    {
      "title": "Pickup Started",
      "subtitle": "Rider is heading to the location",
      "icon": Icons.inventory_2_rounded,
    },
    {
      "title": "On The Way",
      "subtitle": "Items are being transported",
      "icon": Icons.local_shipping_rounded,
    },
    {
      "title": "Completed",
      "subtitle": "Pickup successfully finished",
      "icon": Icons.done_all_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? navy : const Color(0xFFEDF4F0),
          body: Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 100),
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    final isCompleted = index <= currentStep;
                    final isLast = index == steps.length - 1;
                    final isCurrent = index == currentStep;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline line + dot
                          SizedBox(
                            width: 36,
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isCompleted ? green.withAlpha(25) : (isDark ? Colors.white10 : Colors.black.withAlpha(5)),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isCompleted ? green : (isDark ? Colors.white24 : Colors.black12),
                                      width: 2,
                                    ),
                                    boxShadow: isCompleted
                                        ? [BoxShadow(color: green.withAlpha(60), blurRadius: 8)]
                                        : [],
                                  ),
                                  child: Icon(
                                    step['icon'],
                                    color: isCompleted ? green : (isDark ? Colors.white24 : Colors.black26),
                                    size: 18,
                                  ),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      width: 2,
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            isCompleted ? green : (isDark ? Colors.white10 : Colors.black12),
                                            (index + 1 <= currentStep) ? green : (isDark ? Colors.white10 : Colors.black12),
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
                          const SizedBox(width: 20),
                          // Label Card
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isDark ? surface : Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isCurrent
                                        ? green.withAlpha(80)
                                        : (isDark ? Colors.white10 : green.withAlpha(20)),
                                    width: isCurrent ? 2 : 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isCurrent
                                          ? green.withAlpha(30)
                                          : Colors.black.withAlpha(isDark ? 30 : 10),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step['title'],
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        color: isCompleted
                                            ? (isDark ? Colors.white : const Color(0xFF0B132B))
                                            : (isDark ? Colors.white38 : Colors.black38),
                                        fontFamily: 'RedHatDisplay',
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      step['subtitle'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isCompleted
                                            ? (isDark ? Colors.white54 : Colors.black54)
                                            : (isDark ? Colors.white24 : Colors.black26),
                                        fontFamily: 'RedHatDisplay',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildActionButton(isDark),
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
                colors: [navy, Color(0xFF0D1F3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF003856), green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
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
          const Text(
            'Order Status',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: 'RedHatDisplay',
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════ ACTION BUTTON ═══════════════
  Widget _buildActionButton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            if (currentStep < steps.length - 1) {
              setState(() => currentStep++);
            } else {
              Navigator.pop(context);
            }
          },
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
            child: Center(
              child: Text(
                currentStep == steps.length - 1 ? "FINISH" : "NEXT STEP",
                style: const TextStyle(
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
      ),
    );
  }
}