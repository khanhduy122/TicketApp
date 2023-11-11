import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/routes/router.dart';
import 'package:ticket_app/firebase_options.dart';
import 'package:ticket_app/screen/auth/blocs/auth_bloc.dart';
import 'package:ticket_app/screen/main/main_screen.dart';
import 'package:ticket_app/screen/splash/splash_screen.dart';

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

    return ScreenUtilInit(
      designSize: size,
      minTextAdapt: true,
      builder: ( _, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFF0B0F2F)
          ),
          routes: routes,
          builder: (_, child) {
            return BlocProvider(
              create: (context) => AuthBloc(),
              child: child,
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}