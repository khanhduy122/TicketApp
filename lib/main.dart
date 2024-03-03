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
import 'package:workmanager/workmanager.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  runApp(const MyApp());
}

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("onbackground");
    print("Native called background task: $task");
    Map<String, dynamic> ticket = inputData!;
    try {
      for (var seat in ticket["seats"]) {
        debugLog("${ticket["cityName"]} - ${ticket["cinemaType"]} - ${ticket["cinemaID"]} - ${ticket["date"]} - ${ticket["movieID"]} - ${ticket["showtimes"]} - $seat");
        final response = await FirebaseFirestore.instance
                                .collection("Cinemas")
                                .doc(ticket["cityName"])
                                .collection(ticket["cinemaType"])
                                .doc(ticket["cinemaID"])
                                .collection(ticket["date"])
                                .doc(ticket["movieID"])
                                .collection(ticket["showtimes"])
                                .doc(seat).get();
        if(response["booked"] == ""){
          await FirebaseFirestore.instance
                                .collection("Cinemas")
                                .doc(ticket["cityName"])
                                .collection(ticket["cinemaType"])
                                .doc(ticket["cinemaID"])
                                .collection(ticket["date"])
                                .doc(ticket["movieID"])
                                .collection(ticket["showtimes"])
                                .doc(seat)
                                .update({"status": 0, "booked": ""});
        }
      }
    } catch (e) {
      debugLog(e.toString());
    }
    

    print("success");
    return Future.value(true);
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
