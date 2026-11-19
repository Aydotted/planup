import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tasks/presentation/controllers/task_controller.dart';

class DashboardAnalyticsScreen extends StatefulWidget {
  const DashboardAnalyticsScreen({super.key});

  @override
  State<DashboardAnalyticsScreen> createState() =>
      _DashboardAnalyticsScreenState();
}

class _DashboardAnalyticsScreenState extends State<DashboardAnalyticsScreen> {
  DateTime _customStart = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime _customEnd = DateTime(DateTime.now().year, DateTime.now().month, 1);

  // ------------------------------------------------------------
  // SHIFT COLORS (same as Calendar)
  // ------------------------------------------------------------
  // ignore: unused_field
  final Map<String, Color> _shiftColors = {
    "Long Day": Colors.orange,
    "Night": Colors.deepPurple,
    "Twilight": Colors.blue,
    "Off": Colors.green,
    "Free": Colors.grey,
  };

  // ------------------------------------------------------------
  // SUMMARY CALCULATOR
  // ------------------------------------------------------------
  Map<String, int> calculateSummary(
    Map<DateTime, String> shiftPattern,
    Map<DateTime, String> renewals,
    DateTime start,
    DateTime end,
  ) {
    final Map<String, int> summary = {
      "Long Day": 0,
      "Night": 0,
      "Twilight": 0,
      "Off": 0,
      "Free": 0,
      "Renewals": 0,
    };

    DateTime current = start;

    while (!current.isAfter(end)) {
      final clean = DateTime(current.year, current.month, current.day);

      // Renewals
      if (renewals.containsKey(clean)) {
        summary["Renewals"] = summary["Renewals"]! + 1;
      }

      // Shifts
      final shift = shiftPattern[clean];
      if (shift == null || shift.isEmpty) {
        summary["Free"] = summary["Free"]! + 1;
      } else {
        summary[shift] = summary[shift]! + 1;
      }

      current = current.add(const Duration(days: 1));
    }

    return summary;
  }

  // ------------------------------------------------------------
  // VERTICAL SUMMARY WIDGET
  // ------------------------------------------------------------
  Widget buildVerticalSummary(Map<String, int> summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: summary.entries.map((entry) {
        final schedule = entry.key;
        final count = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            "$schedule   $count",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    );
  }

  // ------------------------------------------------------------
  // DATE PICKERS
  // ------------------------------------------------------------
  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customStart,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _customStart = picked);
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customEnd,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _customEnd = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskController>();

    // You will later move shiftPattern + renewals into TaskController
    final shiftPattern = <DateTime, String>{}; // <-- Add this to provider later
    final renewals = <DateTime, String>{}; // <-- Add this to provider later

    // ------------------------------------------------------------
    // Monthly Summary
    // ------------------------------------------------------------
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final lastOfMonth = DateTime(now.year, now.month + 1, 0);

    final monthlySummary = calculateSummary(
      shiftPattern,
      renewals,
      firstOfMonth,
      lastOfMonth,
    );

    // ------------------------------------------------------------
    // Quarterly Summary
    // ------------------------------------------------------------
    int quarterStartMonth = ((now.month - 1) ~/ 3) * 3 + 1;
    final firstOfQuarter = DateTime(now.year, quarterStartMonth, 1);
    final lastOfQuarter = DateTime(now.year, quarterStartMonth + 3, 0);

    final quarterlySummary = calculateSummary(
      shiftPattern,
      renewals,
      firstOfQuarter,
      lastOfQuarter,
    );

    // ------------------------------------------------------------
    // Yearly Summary
    // ------------------------------------------------------------
    final firstOfYear = DateTime(now.year, 1, 1);
    final lastOfYear = DateTime(now.year, 12, 31);

    final yearlySummary = calculateSummary(
      shiftPattern,
      renewals,
      firstOfYear,
      lastOfYear,
    );

    // ------------------------------------------------------------
    // Custom Summary
    // ------------------------------------------------------------
    final customSummary = calculateSummary(
      shiftPattern,
      renewals,
      _customStart,
      _customEnd,
    );

    // ------------------------------------------------------------
    // UI STARTS HERE
    // ------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------------------
            // MONTHLY SUMMARY
            // ------------------------------------------------------------
            const Text(
              "Monthly Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildVerticalSummary(monthlySummary),
            const SizedBox(height: 30),

            // ------------------------------------------------------------
            // QUARTERLY SUMMARY
            // ------------------------------------------------------------
            Text(
              "Quarterly Summary (Q${((now.month - 1) ~/ 3) + 1})",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildVerticalSummary(quarterlySummary),
            const SizedBox(height: 30),

            // ------------------------------------------------------------
            // YEARLY SUMMARY
            // ------------------------------------------------------------
            Text(
              "${now.year} Summary",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildVerticalSummary(yearlySummary),
            const SizedBox(height: 30),

            // ------------------------------------------------------------
            // CUSTOM RANGE SUMMARY
            // ------------------------------------------------------------
            const Text(
              "Custom Range Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      "${_customStart.day}/${_customStart.month}/${_customStart.year}",
                    ),
                    subtitle: const Text("Start Date"),
                    onTap: pickStartDate,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      "${_customEnd.day}/${_customEnd.month}/${_customEnd.year}",
                    ),
                    subtitle: const Text("End Date"),
                    onTap: pickEndDate,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            buildVerticalSummary(customSummary),
          ],
        ),
      ),
    );
  }
}
