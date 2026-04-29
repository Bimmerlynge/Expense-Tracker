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

  Future<UpdateInfo> checkForUpdate(BuildContext context) async {
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

    return UpdateInfo(
      hasUpdate: isOutdated,
      downloadUrl: downloadUrl,
    );
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
}

class UpdateInfo {
  final bool hasUpdate;
  final String downloadUrl;

  UpdateInfo({
    required this.hasUpdate,
    required this.downloadUrl,
  });
}
