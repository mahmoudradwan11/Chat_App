import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit,ChatsState>(
        listener:(context,state){},
        builder:(context,state){
          var cubit = ChatsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title:Text(
                cubit.titles[cubit.screenIndex],
                style:const TextStyle(
                    fontSize: 20,
                ),
              ),
            ),
            body:cubit.screens[cubit.screenIndex],
            bottomNavigationBar:BottomNavigationBar(
              items:cubit.items,
              currentIndex: cubit.screenIndex,
              onTap:(index){
                cubit.changeIndex(index);
              },
            ),

          );
    },
    );
  }
}
