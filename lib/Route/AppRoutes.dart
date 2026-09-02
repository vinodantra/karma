
// ignore_for_file: file_names


import 'package:karma/Application/AGH/AGHCheckIn.dart';
import 'package:karma/Application/AGH/AGHCompleted.dart';
import 'package:karma/Application/AGH/AGHDashboard.dart';
import 'package:karma/Application/AGH/AGHMemberLearn.dart';
import 'package:karma/Application/AGH/AGHNotifications.dart';
import 'package:karma/Application/AGH/AGHOutcome.dart';
import 'package:karma/Application/AGH/AGHScheduleSession.dart';
import 'package:karma/Application/Dashboard/DashboardNew.dart';
import 'package:karma/Constants/Library.dart';

class AppRoutes{
  static String loginPage  = "/login";
  static String dashboard  = "/dashboard";
  static String product = "/products";

  // Antra Golden Hour
  static String aghDashboard = "/agh";
  static String aghSchedule = "/agh/schedule";
  static String aghCheckIn = "/agh/check-in";
  static String aghOutcome = "/agh/outcome";
  static String aghCompleted = "/agh/completed";
  static String aghMemberLearn = "/agh/member-learn";
  static String aghNotifications = "/agh/notifications";

  static List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
   GetPage<SplashScreen>(name: "/", page: ()=> const SplashScreen(),transition: Transition.rightToLeft),
    GetPage<LoginPage>(name: "/login", page: ()=> const LoginPage(),transition: Transition.rightToLeft),
    GetPage<LoginPage>(name: "/dashboard", page: ()=> const DashboardNew(),transition: Transition.rightToLeft),
    GetPage<LoginPage>(name: "/products", page: ()=> const Products(),transition: Transition.rightToLeft),

    GetPage<void>(name: "/agh", page: ()=> const AGHDashboard(), transition: Transition.rightToLeft),
    GetPage<void>(name: "/agh/schedule", page: ()=> const AGHScheduleSession(), transition: Transition.rightToLeft),
    GetPage<void>(name: "/agh/check-in", page: ()=> const AGHCheckIn(), transition: Transition.rightToLeft),
    GetPage<void>(name: "/agh/outcome", page: ()=> const AGHOutcome(), transition: Transition.rightToLeft),
    GetPage<void>(name: "/agh/completed", page: ()=> const AGHCompletedPage(), transition: Transition.rightToLeft),
    GetPage<void>(name: "/agh/member-learn", page: ()=> const AGHMemberLearn(), transition: Transition.rightToLeft),
    GetPage<void>(name: "/agh/notifications", page: ()=> const AGHNotifications(), transition: Transition.rightToLeft),
  ];
}