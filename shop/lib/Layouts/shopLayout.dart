import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/cubit/shopCubit.dart';
import 'package:shop/cubit/states.dart';

import 'package:shop/modules/SearchScreen.dart';
import 'package:shop/modules/notificationScreen.dart';

import 'package:shop/shared/constants.dart';

import '../cubit/paymentCubit/paymentCubit.dart';
import '../modules/toggleScreen.dart';


class ShopLayout extends StatelessWidget {
  bool showBottomSheet = false;

  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<ShopCubit,ShopStates>(
      listener:(context,state) {
      //   if(state is HomeSuccessState)
      //     int cartLen = ShopCubit.get(context).cartModel.data!.cartItems.length;
       },
      builder: (context,state) {
        ShopCubit cubit =  ShopCubit.get(context);
        return  Scaffold(
          appBar: AppBar(
            titleSpacing: 10,
            title: Row(
              children: const [
                Image(image: AssetImage('assets/images/ShopLogo.png'),width: 50, height: 50,),
                Text('ShopMart'),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    ShopCubit.get(context).getNotificationData();
                    navigateTo(context, NotificationScreen());
                  },
                  icon: const Icon(Icons.notifications_none_outlined)),
              IconButton(
                  onPressed: () {
                    navigateTo(context, SearchScreen(ShopCubit.get(context)));
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
          bottomSheet: showBottomSheet ?
          ShopCubit.get(context).cartModel.data!.cartItems.length!= 0 ? Container(
            width: double.infinity,
            height: 60,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 15),
            child: ElevatedButton(
              onPressed: (){
                PaymentCubit.get(context).getAuthToken().then((value) {
                  PaymentCubit.get(context).getOrderRegistrationID(
                    price: '${ShopCubit.get(context).cartModel.data!.total}',
                  ).then((value) {
                    navigateTo(context, const ToggleScreen());
                  });
                });

              },
              //shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              child: const Text('Check Out',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
            ),
          ) :Container(width: 0,height: 0,):Container(width: 0,height: 0,),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items:[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view),
                label: 'Categories',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'My Account',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: const [
                    Icon(Icons.shopping_cart_outlined),
                    //if(cartLength!= 0)
                    // CircleAvatar(backgroundColor: Colors.green,radius: 6,
                    //   child:Text('${ShopCubit.get(context).cartModel.data!.cartItems.length}',style: TextStyle(fontSize: 10,color: Colors.white),),),
                  ],
                ),
                label: 'Cart',
              ),
              ],
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              if (index == 3)
                showBottomSheet = true;
              else if(ShopCubit.get(context).cartModel.data!.cartItems.length == 0)
                showBottomSheet = false;
              else
                showBottomSheet = false;
              return cubit.changeBottomNav(index);
            },
          ),
        );
      },
    );
  }
}
