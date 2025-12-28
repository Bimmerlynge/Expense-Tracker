// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:expense_tracker/app/config/environment/environment.dart';
import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final versionResolverProvider = Provider<VersionResolver>(
  (ref) => VersionResolver(),
);

class VersionResolver {
  VersionResolver();

  Future<bool> checkForUpdate(BuildContext context) async {
    PackageInfo info = await PackageInfo.fromPlatform();
    String currentVersion = info.version;

    final gitVersion = await http.get(
      Uri.parse(Environment.gitUrl),
      headers: {'Authorization': 'Bearer ${Environment.gitToken}'},
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
      if (currentParts[i] > latestParts[i]) return false;
    }

    return false;
  }

  void _showUpdateDialog(BuildContext context, String downloadUrl) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.new_releases_outlined, color: AppColors.onPrimary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ny Opdatering!'),
            const SizedBox(height: 8),
            Divider(thickness: 1, color: AppColors.onPrimary),
          ],
        ),
        content: const Text(
          'En ny opdatering er tilgængelig. Installation påkrævet.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _performUpdate(context, downloadUrl),
                child: Text(
                  'Download',
                  style: TextStyle(color: AppColors.onPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _performUpdate(BuildContext context, String url) async {
    try {
      await _showProgressDialog(context, 'Downloading update...');
      await _downloadApk(url);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      debugPrint('Update failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update app')));
    }
  }

  Future<void> _downloadApk(String apkUrl) async {
    final uri = Uri.parse(apkUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _showProgressDialog(BuildContext context, String message) async {
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
