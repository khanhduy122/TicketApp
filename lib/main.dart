import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/components/routes/router.dart';
import 'package:ticket_app/firebase_options.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/auth/auth_bloc.dart';
import 'package:ticket_app/moduels/user/user_bloc.dart';
import 'package:ticket_app/screen/splash_screen/splash_screen.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  // final service = FlutterBackgroundService();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  // await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //         onStart: onStart,
  //         isForegroundMode: false,
  //         autoStart: false,
  //         autoStartOnBoot: false),
  //     iosConfiguration: IosConfiguration());
  runApp(const MyApp());
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("onbackground");
    print("Native called background task: $task");
    try {
      await FirebaseFirestore.instance
          .collection("Cinemas")
          .doc("An Giang")
          .collection("Galaxy")
          .doc("ChIJXzLHf9ZzCjERifaEdxV7owU")
          .collection("1-3-2024")
          .doc("CUZ1RsCfegXi3qsz6uQZ")
          .collection("18:00 - 20:12 - room2")
          .doc("A1")
          .update({"status": 0, "booked": ""});
    } catch (e) {
      print(e.toString());
      throw e;
    }
    Workmanager().cancelAll();
    print("success");
    return Future.value(true);
  });
}

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   Ticket? ticket;
//   int currentSecond = 300;
//   DartPluginRegistrant.ensureInitialized();
//   print("backgroud");
//   service.on('ticket').listen((event) {
//     ticket = Ticket.fromJson(event!);
//     print(ticket.toString());
//   });

//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     print("on Background service");
//     if (currentSecond == 0) {
//       await FirebaseFirestore.instance
//           .collection("Cinemas")
//           .doc("An Giang")
//           .collection("Galaxy")
//           .doc("ChIJXzLHf9ZzCjERifaEdxV7owU")
//           .collection("1-3-2024")
//           .doc("CUZ1RsCfegXi3qsz6uQZ")
//           .collection("18:00 - 20:12 - room2")
//           .doc("A1")
//           .update({"status": 0, "booked": ""});
//       timer.cancel();
//       print("delete success");
//       service.stopSelf();
//     } else {
//       currentSecond--;
//     }
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return ScreenUtilInit(
      designSize: size,
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
          ),
          routes: routes,
          builder: (_, child) {
            return ChangeNotifierProvider(
              create: (context) => DataAppProvider(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AuthBloc(),
                  ),
                  BlocProvider(
                    create: (context) => UserBloc(),
                  ),
                ],
                child: child!,
              ),
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
