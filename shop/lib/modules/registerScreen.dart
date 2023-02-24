import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/Layouts/shopLayout.dart';
import 'package:shop/cubit/shopCubit.dart';
import 'package:shop/cubit/RegisterCubit.dart';
import 'package:shop/cubit/states.dart';
import 'package:shop/remoteNetwork/cacheHelper.dart';
import 'package:shop/shared/component.dart';
import 'package:shop/shared/constants.dart';

class RegisterScreen extends StatelessWidget {

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController confirmPassword = TextEditingController();
var signUpFormKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterCubit(),
        child:  BlocConsumer<RegisterCubit,ShopStates>(
            listener:(context,state){
              if(state is SignUpSuccessState)
                // ignore: curly_braces_in_flow_control_structures
                if(state.signUpUserModel.status) {
                  CacheHelper.saveData(
                      key: 'token',
                      value: state.signUpUserModel.data?.token,
                  ).then((value) {
                    token = state.signUpUserModel.data?.token;
                    name.clear();
                    phone.clear();
                    email.clear();
                    password.clear();
                    confirmPassword.clear();
                    navigateAndKill(context, ShopLayout());
                    ShopCubit.get(context).currentIndex = 0;
                    ShopCubit.get(context).getHomeData();
                    ShopCubit.get(context).getProfileData();
                    ShopCubit.get(context).getFavoriteData();
                    ShopCubit.get(context).getCartData();
                    ShopCubit.get(context).getAddresses();

                  });
                } else {
                  showToast(state.signUpUserModel.message);
                }
                } ,
            builder:(context,state)
            {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: signUpFormKey,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      [
                        Row(
                          children: [
                            SizedBox(height: 130,),
                            Image(image: AssetImage('assets/images/ShopLogo.png'),width: 40, height: 40,),
                            Text('ShopMart',style: TextStyle(fontSize: 20),),
                            Spacer(),
                            IconButton(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close))
                          ],
                        ),
                        Text('Create a ShopMart account',style: TextStyle(fontSize: 20,),),
                        SizedBox(height: 30,),
                        defaultFormField(
                            context: context,
                            controller: name,
                            label: 'Name',
                            prefix: Icons.person,
                            validate: (value)
                            {
                              if(value!.isEmpty) {
                                return 'Name field is required';
                              }
                            }
                        ),
                        SizedBox(height: 40,),
                        defaultFormField(
                            context: context,
                            controller: phone,
                            label: 'Phone',
                            keyboardType: TextInputType.phone,
                            prefix: Icons.phone,
                            validate: (value)
                            {
                              if(value!.isEmpty) {
                                return 'Phone field is required';
                              }
                            }
                        ),
                        SizedBox(height: 40,),
                        defaultFormField(
                            context: context,
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            label: 'Email Address',
                            prefix: Icons.email,
                            validate: (value)
                            {
                              if(value!.isEmpty) {
                                return 'Email Address must be filled';
                              }
                            }
                        ),
                        SizedBox(height: 40,),
                        defaultFormField(
                            context: context,
                            controller: password,
                            label: 'Password',
                            prefix: Icons.lock,
                            isPassword:RegisterCubit.get(context).showPassword,
                            validate: (value)
                            {
                              if(value!.isEmpty) {
                                return'Password must be filled';
                              }
                            },
                            onSubmit: (value) {},
                            suffix: RegisterCubit.get(context).suffixIcon,
                            suffixPressed: ()
                            {
                              RegisterCubit.get(context).changeSuffixIcon(context);
                            }
                        ),
                        SizedBox(height: 40,),
                        defaultFormField(
                            context: context,
                            controller: confirmPassword,
                            label: 'Confirm Password',
                            prefix: Icons.lock,
                            isPassword:RegisterCubit.get(context).showConfirmPassword,
                            validate: (value)
                            {
                              if(value!.isEmpty) {
                                return 'Password field is required';
                              } else if(value != password.text) {
                                return 'Password Don\'t Match';
                              }
                            },
                            suffix: RegisterCubit.get(context).confirmSuffixIcon,
                            suffixPressed: ()
                            {
                              RegisterCubit.get(context).changeConfirmSuffixIcon(context);
                            }
                        ),
                        SizedBox(height: 50,),
                        state is SignUpLoadingState ?
                        Center(child: CircularProgressIndicator())
                            :defaultButton(
                            onTap: ()
                            {
                              if(signUpFormKey.currentState!.validate())
                              {
                                RegisterCubit.get(context).signUp(
                                    name: name.text,
                                    phone: phone.text,
                                    email: email.text,
                                    password: password.text
                                );
                              }
                            },
                            text: 'Sign Up'
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    ),
    );
  }
  }
