import 'dart:async';
import 'dart:convert';
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
import 'package:ticket_app/models/seat.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/auth/auth_bloc.dart';
import 'package:ticket_app/moduels/user/user_bloc.dart';
import 'package:ticket_app/screen/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final service = FlutterBackgroundService();

  await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: false,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration());

  runApp(const MyApp());
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugLog("start service");
  service.on("stopService").listen((event) {
    print("stop");
    service.stopSelf();
  });

  service.on("deleteTicket").listen((event) async {
    print(event.toString());
    try {
      for (var seat in event!["seats"]) {
        final response = await FirebaseFirestore.instance
            .collection("Cinemas")
            .doc(event["cityName"])
            .collection(event["cinemaType"])
            .doc(event["cinemaID"])
            .collection(event["date"])
            .doc(event["movieID"])
            .collection(event["showtimes"])
            .doc(seat)
            .get();
        if (response["booked"] == "") {
          await FirebaseFirestore.instance
              .collection("Cinemas")
              .doc(event["cityName"])
              .collection(event["cinemaType"])
              .doc(event["cinemaID"])
              .collection(event["date"])
              .doc(event["movieID"])
              .collection(event["showtimes"])
              .doc(seat)
              .update({"status": 0, "booked": ""});
        }
      }
    } catch (e) {
      debugLog(e.toString());
    }
    debugLog("success");
    service.stopSelf();
  });
}

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
