
import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';  

@AutoRouterConfig()      
class AppRouter extends $AppRouter {      
    
  @override      
  List<AutoRoute> get routes => [   
    AutoRoute(
      initial: true,
      page: SplashRoute.page
    ),
    AutoRoute(
      page: OnBoardingRoute.page
    ),
    AutoRoute(
      page: SignInRoute.page,
      children: [
        
      ]
    ),
  ];
 }  