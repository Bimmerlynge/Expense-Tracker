import 'package:expense_tracker/features/settings/components/category_chart_exclude_setting.dart';
import 'package:expense_tracker/features/settings/components/setting_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 32),
            SettingSection(
              title: 'Grafer',
              children: [CategoryChartExcludeSetting()],
            ),
          ],
        ),
      ),
    );
  }
}
