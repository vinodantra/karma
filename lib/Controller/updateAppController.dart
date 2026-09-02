// ignore_for_file: file_names

import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:karma/Constants/Library.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:ota_update/ota_update.dart';

class UpdateAppController extends GetxController{

  RxBool isDownload =  false.obs;
  RxDouble progress = 0.0.obs;
  RxDouble percentage = 0.0.obs;
  RxString value1 = "".obs;
  Dio dio = Dio(BaseOptions(followRedirects: true, validateStatus: (status) {
    return status! < 500;  // Accept status codes < 500
  }));

  updateApp(){
    try {
      if (kDebugMode) {
        print("url:${DataInfo.downloadUrl.value}");
      }

      downloadAndInstallAPK();


    } catch (e) {
      if (kDebugMode) {
        print('Failed to make OTA update. Details: $e');
      }
    }

  }
  Future<void> requestPermissions() async {
    await Permission.storage.request();
    await Permission.requestInstallPackages.request();
  }
  Future<void> downloadAndInstallAPK() async {
    File? apkFile;
    try {
      await requestPermissions();

      final tempDir = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      final apkPath = '${tempDir.path}/karma.apk';
      apkFile = File(apkPath);

      final downloader = Dio(BaseOptions(
        followRedirects: true,
        validateStatus: (status) => status != null && status < 500,
      ));
      await downloader.download(
        DataInfo.downloadUrl.value.trim(),
        apkPath,
        onReceiveProgress: (count, total) {
          if (total <= 0) return;
          final value = count / total;
          isDownload.value = value > 0 && value < 1;
          value1.value = value.toString();
          try {
            percentage.value = double.parse((value * 100).toStringAsFixed(2));
            progress.value = value;
            update();
          } catch (e) {
            if (kDebugMode) print(e);
          }
        },
      );

      final expected = DataInfo.hashKey.value.trim();
      if (expected.isEmpty) {
        // Server did not provide a HASHKEY — fail closed: do not install
        // unverified binaries. Once the backend is rolled out everywhere,
        // this branch can be removed.
        if (kDebugMode) {
          print("APK update aborted: server returned empty HASHKEY.");
        }
        await _safeDelete(apkFile);
        CustomWidgets.snackBar(
            title: "Update unavailable. Please try again later.");
        return;
      }

      final actual = await _sha256OfFile(apkFile);
      if (actual.toLowerCase() != expected.toLowerCase()) {
        if (kDebugMode) {
          print("APK hash mismatch. expected=$expected actual=$actual");
        }
        await _safeDelete(apkFile);
        CustomWidgets.snackBar(
            title:
                "Update verification failed. Please retry from the Play Store.");
        return;
      }

      final result = await OpenFilex.open(apkPath);
      if (result.type != ResultType.done) {
        if (kDebugMode) {
          print("Installer open failed: ${result.type} ${result.message}");
        }
        CustomWidgets.snackBar(
            title: "Couldn't open the installer. Please enable "
                "\"Install unknown apps\" for this app and try again.");
      }
    } catch (e) {
      if (apkFile != null) await _safeDelete(apkFile);
      if (kDebugMode) print("Error downloading/installing APK: $e");
      CustomWidgets.snackBar(title: "Update download failed.");
    }
  }

  static Future<String> _sha256OfFile(File file) async {
    final bytes = await file.readAsBytes();
    final hash = await Sha256().hash(bytes);
    final buf = StringBuffer();
    for (final b in hash.bytes) {
      buf.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return buf.toString();
  }

  static Future<void> _safeDelete(File f) async {
    try {
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}

class ApkDownloader {
  static const platform = MethodChannel("apk_downloader");

  static Future<void> downloadAndInstall(String url) async {
    try {
      await platform.invokeMethod("downloadAndInstall", {"url": url});
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }
}