//import 'package:chat_app/Modules/spalesh.dart';
import 'package:chat_app/shared/Network/Local/cache_helper.dart';
import 'package:chat_app/shared/components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/states.dart';
import 'package:chat_app/shared/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Layout/Home.dart';
import 'Modules/Login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();
  uId = CacheHelper.getData(key: 'uId');
  bool? mode = CacheHelper.getData(key: 'mode');
  //var token = await FirebaseMessaging.instance.getToken();
  //print('Token = $token');
  print('Uid = $uId');
  Widget? widget;
  if (uId != null) {
    widget = Home();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    startWidget: widget,
    appMode: mode,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  final bool? appMode;
  const MyApp({Key? key, this.startWidget, this.appMode}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit()
        ..getUserData()
        ..getUsers()
        ..changeMode(fromShared: appMode),
      child: BlocConsumer<ChatsCubit, ChatsState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatsCubit.get(context);
          return MaterialApp(
              title: 'Chats',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              themeMode: cubit.dark ? ThemeMode.dark : ThemeMode.light,
              darkTheme: darkTheme,
              home: startWidget);
        },
      ),
    );
  }
}
