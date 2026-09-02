// ignore_for_file: close_sinks, file_names, depend_on_referenced_packages, avoid_print
// ignore_for_file: invalid_return_type_for_catch_error, unnecessary_statements, unused_element, avoid_init_to_null,unused_field, unrelated_type_equality_checks, unused_local_variable, non_constant_identifier_names, missing_return, deprecated_member_use, must_be_immutable, unnecessary_brace_in_string_interps
import 'dart:io';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import '../Constants/Library.dart';

Future<void> backgroundHandler(RemoteMessage? message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notif = message?.notification;
  if (notif != null) {
    NotificationServices.showNotification(
      id: 1,
      title: notif.title ?? '',
      body: notif.body ?? '',
      payload: "",
    );
  }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("FirebaseMessaging.onMessageOpenedApp ${message.toString()}");
    }
  });
}

class NotificationServices {
  static final onNotifications = BehaviorSubject<String>();
  static Future<void> initialize() async {
    try{
      NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        //deviceID = await FirebaseMessaging.instance.getToken();
      }
    }catch(e){
      print(e);
    }
  }

  static final notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails(
      String title, String body) async {
    BigTextStyleInformation? bigTextStyleInformation;
    BigPictureStyleInformation? bigPictureStyleInformation;
    bigTextStyleInformation = BigTextStyleInformation(body,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true,
        htmlFormatContent: true);
    // final String largeIconPath = await _downloadAndSaveFile(icon, 'largeIcon');
    // if (Utilities.checkString(image)) {
    //   final String bigPicturePath =
    //   await _downloadAndSaveFile(image, 'bigPicture');
    //   bigPictureStyleInformation = BigPictureStyleInformation(
    //       FilePathAndroidBitmap(bigPicturePath),
    //       hideExpandedLargeIcon: false,
    //       contentTitle: '<b>$title</b>',
    //       htmlFormatContentTitle: true,
    //       summaryText: body,
    //       htmlFormatSummaryText: true);
    // } else {
    //   bigTextStyleInformation = BigTextStyleInformation(body,
    //       htmlFormatBigText: true,
    //       contentTitle: title,
    //       htmlFormatContentTitle: true,
    //       htmlFormatSummaryText: true,
    //       htmlFormatContent: true);
    // }

    return NotificationDetails(
        android: AndroidNotificationDetails('notification', 'channel name',
            playSound: true,
            priority: Priority.high,
            importance: Importance.max,
            ticker: 'ticker',
            showWhen: true,
           icon: "@drawable/ic_stat_logo",
           // largeIcon: FilePathAndroidBitmap(largeIconPath),
            fullScreenIntent: true,
            styleInformation: bigTextStyleInformation
            // styleInformation: Utilities.checkString(image)
            //     ? bigPictureStyleInformation
            //     : bigTextStyleInformation
        ),
        iOS: const DarwinNotificationDetails());
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<void> onDidReceiveBackgroundNotificationResponse(
      NotificationResponse details1,
      ) async {

  }

  static Future init(BuildContext context, {bool initScheduled = false}) async {
    try{
      const android = AndroidInitializationSettings("@mipmap/ic_launcher");
      const ios = DarwinInitializationSettings();
      const settings = InitializationSettings(android: android, iOS: ios);

      final details = await notification.getNotificationAppLaunchDetails();

      if (details != null && details.didNotificationLaunchApp) {
        final payloadString = details.notificationResponse?.payload?.toString();

        Map<String, dynamic> payload1 = {};

        if (payloadString != null) {
          try {
            payload1 = json.decode(payloadString);
          } catch (e) {
            if (kDebugMode) {
              print("Error payload: $e");
            }
          }
        }



        onNotifications.add(details.notificationResponse!.payload.toString());
      }
      await notification.initialize(
        settings,
        onDidReceiveNotificationResponse: (NotificationResponse details1) {
          final raw = details1.payload;
          if (raw == null || raw.isEmpty) return;
          try {
            final decoded = jsonDecode(raw);
            if (decoded is Map<String, dynamic>) {
              final code = decoded['code']?.toString();
            }
          } catch (e) {
            if (kDebugMode) print("notification payload parse error: $e");
          }
        },
        onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
      );
    }catch(e){
      print(e);
    }
  }

  static Future showNotification({
    int id = 0,
    required String title,
    required String body,

    required String payload,
  }) async =>
      notification.show(
          id, title, body, await _notificationDetails(title, body,),
          payload: "");


}
