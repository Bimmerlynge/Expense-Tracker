import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionResolver {
  final String owner = 'Bimmerlynge';
  final String repo = 'Expense-Tracker';

  VersionResolver();

  Future<bool> checkForUpdate(BuildContext context) async {
    PackageInfo info = await PackageInfo.fromPlatform();
    String currentVersion = info.version;

    final gitVersion = await http.get(
      Uri.parse('https://api.github.com/repos/$owner/$repo/releases/latest')
    );

    final data = jsonDecode(gitVersion.body);

    String latestVersion = (data['tag_name'] as String).replaceFirst('v', '');
    String downloadUrl = data['assets'][0]['browser_download_url'];

    bool isOutdated = _isAppOutdated(currentVersion, latestVersion);

    if (!isOutdated) return false;

    _showUpdateDialog(context, downloadUrl);
    return true;
  }

  bool _isAppOutdated(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (latestParts[i] > currentParts[i]) return true;
    }

    return false;
  }

  void _showUpdateDialog(BuildContext context, String downloadUrl) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Update Available"),
        content: const Text('A new version of the app is available. Update is required'),
        actions: [
          ElevatedButton(onPressed: () => performUpdate(context, downloadUrl), child: Text('Download Update'))
        ],
      )
    );
  }

  Future<void> performUpdate(BuildContext context, String url) async {
    try {
      await showProgressDialog(context, 'Downloading update...');
      await downloadApk(url);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      debugPrint('Update failed: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update app')));
    }
  }

  Future<void> downloadApk(String apkUrl) async {
    final uri = Uri.parse(apkUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> showProgressDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(message),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Please wait...'),
          ],
        ),
      ),
    );
  }
}