import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/cubit/appCubit.dart';
import 'package:shop/cubit/shopCubit.dart';
import 'package:shop/cubit/states.dart';
import 'package:shop/modules/LoginScreen.dart';
import 'package:shop/Layouts/shopLayout.dart';
import 'package:shop/remoteNetwork/cacheHelper.dart';
import 'package:shop/remoteNetwork/dioHelper.dart';
import 'package:shop/shared/bloc_observer.dart';
import 'package:shop/shared/constants.dart';
import 'package:shop/shared/themes.dart';
import 'cubit/paymentCubit/paymentCubit.dart';
import 'modules/OnBoardingScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;

  bool? isDark = CacheHelper.getData('isDark');
  bool? isLang = CacheHelper.getData('isLang');

  bool? showOnBoard = CacheHelper.getData('ShowOnBoard');
  token = CacheHelper.getData('token');

  if (showOnBoard == false) {
    if (token != null)
      widget = splashScreen_layout();
    else
      widget = splashScreen_login();
  } else
    widget = splashScreen_onBording();
  runApp(MyApp(
    isLang: isLang,
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final bool? isLang;

  late final Widget startWidget;
  MyApp({this.isDark, required this.startWidget, this.isLang});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppCubit()
              ..changeMode(fromCache: isDark)
              ..changeLang(context: context, fromCache: isLang),
          ),
          BlocProvider(
              create: (context) => ShopCubit()
                ..getHomeData()
                ..getCategoryData()
                ..getFavoriteData()
                ..getProfileData()
                ..getCartData()
                ..getAddresses()),
          BlocProvider(create: (context) => PaymentCubit())
        ],
        child: BlocConsumer<AppCubit, ShopStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit cubit = AppCubit.get(context);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: startWidget,
                theme: lightMode(),
                darkTheme: darkMode(),
                themeMode: AppCubit.get(context).appMode,
              );
            }));
  }
}

Widget splashScreen_onBording() => SplashScreenView(
      navigateRoute: OnBoarding(),
      duration: 4000,
      imageSize: 200,
      imageSrc: "assets/images/ShopLogo.png",
      text: "  ",
      textType: TextType.ScaleAnimatedText,
      textStyle: TextStyle(
        fontSize: 38.0,
        color: Colors.blue[800],
        fontWeight: FontWeight.w900,
      ),
      backgroundColor: Colors.white,
    );

Widget splashScreen_layout() => SplashScreenView(
      navigateRoute: ShopLayout(),
      duration: 4000,
      imageSize: 200,
      imageSrc: "assets/images/ShopLogo.png",
      text: "  ",
      textType: TextType.ScaleAnimatedText,
      textStyle: TextStyle(
        fontSize: 38.0,
        color: Colors.blue[800],
        fontWeight: FontWeight.w900,
      ),
      backgroundColor: Colors.white,
    );

Widget splashScreen_login() => SplashScreenView(
      navigateRoute: LoginScreen(),
      duration: 4000,
      imageSize: 200,
      imageSrc: "assets/images/ShopLogo.png",
      text: "  ",
      textType: TextType.ScaleAnimatedText,
      textStyle: TextStyle(
        fontSize: 38.0,
        color: Colors.blue[800],
        fontWeight: FontWeight.w900,
      ),
      backgroundColor: Colors.white,
    );
