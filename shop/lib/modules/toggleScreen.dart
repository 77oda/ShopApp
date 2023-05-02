import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/ref_code_Screen.dart';
import 'package:shop/modules/visaScreen.dart';
import 'package:shop/shared/constants.dart';

import '../cubit/paymentCubit/paymentCubit.dart';
import '../cubit/paymentCubit/paymentStates.dart';
import '../remoteNetwork/paymentApi.dart';
import '../shared/component.dart';


class ToggleScreen extends StatelessWidget {
  const ToggleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<PaymentCubit, PaymentStates>(
        listener: (context, state) {
          if (state is PaymentRefCodeSuccessStates) {
            showSnackBar(
              context: context,
              text: "Success get ref code ",
              color: Colors.amber.shade400,
            );
            navigateAndKill(context, const ReferenceScreen());
          }
          if (state is PaymentRefCodeErrorStates) {
            showSnackBar(
              context: context,
              text: "Error get ref code ",
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          var cubit = PaymentCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 5,
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        cubit.getRefCode();
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(15.0),
                          border:
                          Border.all(color: Colors.black87, width: 2.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  const [
                            Image(
                              image: NetworkImage(PaymentImages.refCodeImage),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Payment with Ref code',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateAndKill(context, const VisaScreen());
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.black, width: 2.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Image(
                              image: NetworkImage(PaymentImages.visaImage),
                            ),
                            Text(
                              'Payment with visa',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}