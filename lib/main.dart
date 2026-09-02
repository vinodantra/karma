import 'dart:developer';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:karma/Controller/NotificationListProvider.dart';
import '../../Constants/Library.dart';
import 'Controller/NotificationListController.dart';
import 'Controller/notificationService.dart';

import 'Services/db_helper.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  storeNotification(message);

  // NotificationServices.showNotification(
  //   id: 1,
  //   title: message.notification!.title!,
  //   body: message.notification!.body!,
  //
  //   payload: "",
  // );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    storeNotification(message);
    if (kDebugMode) {
      log("FirebaseMessaging.onMessageOpenedApp ${message.toString()}");
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsService().init();
  /*
  options: const FirebaseOptions(apiKey: "AIzaSyBs5ey-pyxz-SzS1OtdPBV4XsUxguJ5koA",
      appId: "1:760938335592:android:f7ac8acdea0d6214a81add", messagingSenderId: "760938335592", projectId: "karma-tracking")
  */

  // Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyBs5ey-pyxz-SzS1OtdPBV4XsUxguJ5koA",
  //     appId: "1:760938335592:android:f7ac8acdea0d6214a81add", messagingSenderId: "760938335592", projectId: "karma-tracking"));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  // tz.initializeTimeZones();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();

  InitialBindings().dependencies();

  runApp(const MyApp());

  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const MyApp(), // Wrap your app
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    NotificationServices.init(context);
    NotificationServices.initialize();
    FirebaseMessaging.onMessage.listen((RemoteMessage? event) {
      if (event != null) {
        if (event.notification != null) {
          storeNotification(event);

          NotificationServices.showNotification(
            id: 1,
            title: event.notification!.title!,
            body: event.notification!.body!,
            payload: "",
          );
        }
      }
    });

    // NotificationServices.onNotifications.stream.listen(onClickNotification);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (kDebugMode) {
        log("FirebaseMessaging.getInitialMessage ${message.toString()}");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print("App is in resumed state");
      }

      getData();
      // Your logic here: refresh data, resume animations, etc.
    }
    // if(state == AppLifecycleState.inactive || state == AppLifecycleState.hidden   || state == AppLifecycleState.paused){
    //   await PrefsService().init();
    //   getData();
    // }
    // if (kDebugMode) {
    //   print(state.name);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppThemeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationListProvider(),
        ),
      ],
      child: SafeArea(
        top: false,
        child: GetMaterialApp(
          navigatorKey: DataInfo.navKey,
          debugShowCheckedModeBanner: false,
          // useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          // builder: DevicePreview.appBuilder,

          title: 'Karma',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          getPages: AppRoutes.routes,

          initialBinding: InitialBindings(),

          // localizationsDelegates: const [
          //   // GlobalMaterialLocalizations.delegate,
          //   // MonthYearPickerLocalizations.delegate,
          // ],
        ),
      ),
    );
  }

  getData() async {
    try {
      if (!context.mounted) return;
      await Future.delayed(const Duration(seconds: 2));
      int unreadCount = await DBHelper().getUnreadCount();

      List<dynamic> list = PrefsService().getNotificationData();
      DataInfo.navKey.currentContext!
          .read<NotificationListProvider>()
          .updateNotificationData(list: list, count: unreadCount);
      Get.find<DashboardController>().getNotificationListData();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
