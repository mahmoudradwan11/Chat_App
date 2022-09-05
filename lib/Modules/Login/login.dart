import 'package:chat_app/Layout/Home.dart';
import 'package:chat_app/Modules/register/register.dart';
import 'package:chat_app/shared/Network/Local/cache_helper.dart';
import 'package:chat_app/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create:(context)=>LoginCubit(),
        child: BlocConsumer<LoginCubit,LoginState>(
        listener:(context,state){
      if(state is LoginSuccessState){
        CacheHelper.saveData(
          key:'uId',
          value:state.uid,
        ).then((value){
          navigateAndFinish(context,Home());
        });
      }
    },
    builder:(context,state){
    var cubit = LoginCubit.get(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOGIN',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30)
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Login now to Chats with friends',
                      style:
                      Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.grey,
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  textField(
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    show: false,
                    controller: emailController,
                    keyboard: TextInputType.emailAddress,
                    valid: (value) {
                      if (value.isEmpty) {
                        return 'Email Must not be Empty';
                      }
                      return null;
                    },
                    label: 'Email Address',
                    prefix: Icons.email_outlined,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  textField(
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    show: cubit.passwordShow,
                    suffix: cubit.suffixIcon,
                    suffixPress: () {
                      cubit.changePasswordIcon();
                    },
                    controller: passwordController,
                    keyboard: TextInputType.visiblePassword,
                    valid: (value) {
                      if (value.isEmpty) {
                        return 'Password is to short';
                      }
                      return null;
                    },
                    label: 'password',
                    prefix: Icons.lock_outline,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if(state is LoadingLogin)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 2,
                  ),
                  defButton(
                      function: (){
                        if (formKey.currentState!.validate()) {
                          cubit.loginUser(
                              email: emailController.text,
                              password: passwordController.text
                          );
                        }
                      },
                      text: 'LOGIN',
                      isUpper: true
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an Account?',style: Theme.of(context).textTheme.subtitle1,),
                      textButton(
                          text: 'Register ',
                          function: () {
                            navigateTo(context, RegisterScreen());
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    }
        )
    );
  }
}

