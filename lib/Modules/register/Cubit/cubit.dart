import 'package:chat_app/Models/UserData.dart';
import 'package:chat_app/Modules/register/Cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })
  {
    emit(RegisterLoad());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value)
    {
      print(value.user!.email);
      print(value.user!.uid);
      createUser(
        name: name,
        email: email,
        phone: phone,
        uid:value.user!.uid,
      );
      emit(RegisterSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(RegisterErrorState(error));
    });
  }
  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uid,
  })
  {
    UserData model = UserData(
      name: name,
      email: email,
      phone: phone,
      uid: uid,
      bio:'write your bio...',
      cover:'https://img.freepik.com/free-photo/smiley-little-boy-isolated-pink_23-2148984798.jpg?size=626&ext=jpg&ga=GA1.2.1415477105.1658320965',
      image:'https://img.freepik.com/free-photo/smiley-little-boy-isolated-pink_23-2148984798.jpg?size=626&ext=jpg&ga=GA1.2.1415477105.1658320965',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance.collection('Users').
    doc(uid).
    set(model.toMap()).
    then((value){
      emit(CreateUserSuccessState());
    }).catchError((error){
      emit(CreateUserErrorState(error.toString()));
    });
  }
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(RegisterChangePasswordVisibilityState());
  }
}