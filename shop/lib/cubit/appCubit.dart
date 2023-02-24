import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/cubit/shopCubit.dart';
import 'package:shop/cubit/states.dart';
import 'package:shop/remoteNetwork/cacheHelper.dart';

import '../modules/myAccountScreen.dart';
import '../shared/constants.dart';

class AppCubit extends Cubit<ShopStates>{
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  bool isDark = false;
  ThemeMode appMode = ThemeMode.light;

  void changeMode({fromCache}) {

    if(fromCache == null)
      isDark =!isDark;
    else
      isDark = fromCache;

    CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
      if(isDark){
        appMode = ThemeMode.dark;
      }
      else{
        appMode = ThemeMode.light;
      }

      emit(ChangeModeState());
    });

  }

  bool isLang =false;
  void changeLang ({fromCache,required context}){
    if(fromCache == null)
      isLang =!isLang;
    else
      isLang = fromCache;

    CacheHelper.saveData(key: 'isLang', value: isLang).then((value) {
      if(isLang){
        lang = 'ar';
      }
      else{
        lang = 'en';
      }

      ShopCubit.get(context).getHomeData();
      ShopCubit.get(context).getFavoriteData();
      ShopCubit.get(context).getCartData();
      ShopCubit.get(context).getCategoryData();
      emit(ChangeLangState());
    });

  }
}