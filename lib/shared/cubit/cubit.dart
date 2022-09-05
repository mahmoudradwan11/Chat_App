import 'package:chat_app/Models/UserData.dart';
import 'package:chat_app/Models/messagemodel.dart';
import 'package:chat_app/Modules/Login/login.dart';
import 'package:chat_app/Modules/Users.dart';
import 'package:chat_app/Modules/settings.dart';
import 'package:chat_app/shared/Network/Local/cache_helper.dart';
import 'package:chat_app/shared/components.dart';
import 'package:chat_app/shared/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsCubit extends Cubit<ChatsState>
{
   ChatsCubit():super(ChatInitState());
   static ChatsCubit get(context)=>BlocProvider.of(context);
   bool dark = true;
   int screenIndex = 0;
   UserData? userModel;
   List<Widget>screens=
   [
      const UsersScreen(),
      SettingScreen(),
   ];
   List<String>titles = [
     'Users',
     'Setting',
   ];
   List<BottomNavigationBarItem>items = const
   [
     BottomNavigationBarItem(
         icon:Icon(
           Icons.person,
         ),
         label:'Users'
     ),
     BottomNavigationBarItem(
         icon:Icon(
           Icons.settings,
         ),
         label:'Setting'
     ),
   ];
   void changeIndex(int index)
   {
       screenIndex = index;
       emit(ChangeScreen());
   }
   void updateUser({
     required String name,
     required String phone,
     required String bio,
     String? cover,
     String? image,
   }) {
     emit(UserUpdateLoading());
     UserData model = UserData(
       name: name,
       phone: phone,
       bio: bio,
       email: userModel!.email,
       image: image ?? userModel!.image,
       cover: cover ?? userModel!.cover,
       uid: userModel!.uid,
       isEmailVerified: false,
     );
     FirebaseFirestore.instance
         .collection('Users')
         .doc(userModel!.uid)
         .update(model.toMap())
         .then((value) {
       getUserData();
     }).catchError((error) {
       emit(UserUpdateError());
     });
   }
   void getUserData() {
     FirebaseFirestore.instance.collection('Users').doc(uId).get().then((value) {
       print(value.data());
       userModel = UserData.fromJson(value.data()!);
       emit(GetUserSuccessState());
     }).catchError((error) {
       print(error);
       emit(GetUserErrorState(error.toString()));
     });
   }
   void signOut(context)
   {
     CacheHelper.removeData(key:'uId').then((value){
       if(value){
         navigateAndFinish(context,LoginScreen());
       }
     });
   }
   List<UserData> users = [];
   void getUsers() {
     emit(LoadingGetAllUserDataState());
     if (users.isEmpty) {
       FirebaseFirestore.instance.collection('Users').get().then((value) {
         value.docs.forEach((element) {
           users.add(UserData.fromJson(element.data()));
         });
         emit(GetAllUsersSuccessState());
       }).catchError((error) {
         print(error.toString());
         emit(GetAllUsersErrorState(error.toString()));
       });
     }
   }
   void sendMessage({
     required String receiverId,
     required String dateTime,
     required String text,})
   {
     MessageModel model = MessageModel(
       text: text,
       dateTime:dateTime,
       senderId: userModel!.uid,
       receiverId: receiverId,
     );
     FirebaseFirestore.instance.collection('Users').
     doc(userModel!.uid).
     collection('chats').
     doc(receiverId).
     collection('message').
     add(model.toMap()).
     then((value){
       emit(SendMessageSuccessState());
     }).catchError((error){
       emit(SendMessageErrorState());
     });
     FirebaseFirestore.instance.collection('Users').
     doc(receiverId).
     collection('chats').
     doc(userModel!.uid).
     collection('message').
     add(model.toMap()).
     then((value){
       emit(SendMessageSuccessState());
     }).catchError((error){
       emit(SendMessageErrorState());
     });
   }
   List<MessageModel> messages = [];
   void getMessages({required String receiverId})
   {
     FirebaseFirestore.instance
         .collection('Users')
         .doc(userModel!.uid)
         .collection('chats')
         .doc(receiverId)
         .collection('message')
         .orderBy('dateTime')
         .snapshots().
     listen((event) {
       messages = [];
       event.docs.forEach((element)
       {
         messages.add(MessageModel.fromJson(element.data()));
       });
       emit(GetMessageSuccessState());
     });
   }
   void changeMode({bool? fromShared}) {
     if (fromShared != null) {
       dark = fromShared;
       emit(ChangeAppMode());
     }
     else
     {
       dark = !dark;
       CacheHelper.putBoolData(key: 'mode', value:dark).then((value) {
         emit(ChangeAppMode());
       });
     }
   }
}