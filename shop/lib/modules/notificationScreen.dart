import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/shopCubit.dart';
import '../cubit/states.dart';
import '../models/notifModel/notificationModel.dart';
import '../shared/constants.dart';

class NotificationScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ShopCubit,ShopStates>(
        listener: (context, state){},
        builder:(context, state) {


          return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  children: [
                    Image(image: AssetImage('assets/images/ShopLogo.png'),width: 50, height: 50,),
                    Text('ShopMart'),
                  ],
                ),
              ),
               body: state is NotificationLoadingState ?
               Center(child: CircularProgressIndicator()):
               ListView.separated(
                 physics: BouncingScrollPhysics(),
                   itemBuilder:(context,index) => buildNotificationItem(ShopCubit.get(context).notificationModel!.data!.data![index]),
                   separatorBuilder:(context,index) => myDivider(),
                   itemCount: ShopCubit.get(context).notificationModel!.data!.data!.length
               )


          );

        },


    );
  }


}

Widget buildNotificationItem(Data model ){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Row(
          children: [
            Icon(Icons.send),
            SizedBox(width: 7,),
            Text('${model.title}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ],
        ),
        SizedBox(height: 7,),
        Text('${model.message}',style: TextStyle(fontSize: 15,),),

      ],
    ),
  );
}
