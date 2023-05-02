import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/cubit/paymentCubit/paymentStates.dart';
import 'package:shop/remoteNetwork/paymentApi.dart';


class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(PaymentInitialStates());
  static PaymentCubit get(context) => BlocProvider.of(context);

  Future<void> getAuthToken() async {
    emit(PaymentAuthLoadingStates());
    Dio().post(PaymentApi.getAuthToken, data:{'api_key': PaymentApi.paymentApiKey,}
    ).then((value) {
      PaymentApi.paymentFirstToken = value.data['token'].toString();
      print('The token 🍅');
      emit(PaymentAuthSuccessStates());
    }).catchError((error) {
      print('Error in auth token 🤦‍♂️');
      emit(PaymentAuthErrorStates(error.toString()),);
    });
  }

  Future<void> getOrderRegistrationID({
    required String price,
  }) async {
    emit(PaymentOrderIdLoadingStates());
    Dio().post(PaymentApi.getOrderId, data:{
      'auth_token': PaymentApi.paymentFirstToken,
      "delivery_needed": "false",
      "amount_cents": price,
      "currency": "EGP",
      "items": [],
    }).then((value) {
      PaymentApi.paymentOrderId = value.data['id'].toString();
      getPaymentRequest(price);
      print('The order id 🍅 ');
      emit(PaymentOrderIdSuccessStates());
    }).catchError((error) {
      print('Error in order id 🤦‍♂️');
      emit(
        PaymentOrderIdErrorStates(error.toString()),
      );
    });


  }

  // for final request token

  Future<void> getPaymentRequest(
      String priceOrder,
      ) async {
    emit(PaymentRequestTokenLoadingStates());
    Dio().post(PaymentApi.getPaymentRequest, data:{
        "auth_token": PaymentApi.paymentFirstToken,
        "amount_cents": priceOrder,
        "expiration": 3600,
        "order_id": PaymentApi.paymentOrderId,
        "billing_data": {
          "apartment": "NA",
          "email": "NA",
          "floor": "NA",
          "first_name": "NA",
          "street": "NA",
          "building": "NA",
          "phone_number": "NA",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": "NA",
          "state": "NA"
        },
        "currency": "EGP",
        "integration_id": PaymentApi.integrationIdCard,
        "lock_order_when_paid": "false"
    }).then((value) {
      PaymentApi.finalToken = value.data['token'].toString();
      print('Final token 🚀 ');
      emit(PaymentRequestTokenSuccessStates());
    }).catchError((error) {
      print('Error in final token 🤦‍♂️');
      emit(PaymentRequestTokenErrorStates(error.toString()),);
    });
  }

  Future<void> getRefCode() async {
    emit(PaymentRefCodeLoadingStates());
    Dio().post(PaymentApi.getRefCode, data: {
      "source": {
        "identifier": "AGGREGATOR",
        "subtype": "AGGREGATOR",
      },
      "payment_token": PaymentApi.finalToken,
    },
    ).then((value) {
      PaymentApi.refCode = value.data['id'].toString();
      print('The ref code 🍅');
      emit(PaymentRefCodeSuccessStates());
    }).catchError((error) {
      print("Error in ref code 🤦‍♂️");
      emit(PaymentRefCodeErrorStates(error.toString()));
    });
  }
}