import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/routes/router.dart';
import 'package:ticket_app/firebase_options.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_bloc.dart';
import 'package:ticket_app/screen/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
          ),
          routes: routes,
          builder: (_, child) {
            return ChangeNotifierProvider(
              create: (context) => DataAppProvider(),
              child: BlocProvider(
                create: (context) => AuthBloc(),
                child: child,
              ),
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
