import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/cubit/states.dart';

import 'package:shop/models/searchModel/searchModel.dart';
import 'package:shop/remoteNetwork/dioHelper.dart';
import 'package:shop/remoteNetwork/endPoints.dart';
import 'package:shop/shared/constants.dart';

class SearchCubit extends Cubit<ShopStates> {
  SearchCubit() : super(InitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;
  void getSearchData(String searchText){
    emit(SearchLoadingState());
    DioHelper.postData(
        url: SEARCH,
        token: token,
        data: {
          'text':'$searchText',
        }
    ).then((value){
      searchModel = SearchModel.fromJson(value.data);
      print('Search '+searchModel!.status.toString());
      emit(SearchSuccessState());
    }).catchError((error){
      emit(SearchErrorState());
      print(error.toString());
    });
  }
}