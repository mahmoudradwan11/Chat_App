import 'package:chat_app/Modules/Login/Cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class LoginCubit extends Cubit<LoginState>
{
  LoginCubit() : super(LoginInitState());
  static LoginCubit get(context)=>BlocProvider.of(context);
  IconData suffixIcon = Icons.visibility;
  bool passwordShow = true;
  void loginUser({required String email, required String password})
  {
    emit(LoadingLogin());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      print(value.user!.email);
      print(value.user!.uid);
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error){
      print(error.toString());
      emit(LoginFailedState(error));
    });
  }
  void changePasswordIcon()
  {
    passwordShow = !passwordShow;
    suffixIcon =
    passwordShow ? Icons.visibility : Icons.visibility_off_outlined;
    emit(ChangePasswordVisState());
  }
}