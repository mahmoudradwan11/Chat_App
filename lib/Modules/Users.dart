import 'package:chat_app/Models/UserData.dart';
import 'package:chat_app/Modules/chats.dart';
import 'package:chat_app/shared/components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatsCubit.get(context);
          if (cubit.users.isEmpty) {
            return const Center(child: Text('No Users'));
          } else {
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  builtChatItem(cubit.users[index], context),
              separatorBuilder: (context, index) => builtDivider(),
              itemCount: cubit.users.length,
            );
          }
        }
    );
  }
  Widget builtChatItem(UserData model,context) =>InkWell(
    onTap:(){
      navigateTo(context, ChatScreen(
          userModel: model,
      )
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:[
          CircleAvatar(
            radius: 25.0,
            backgroundImage:NetworkImage(
                '${model.image}'
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.name}',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  height: 1.4,
                ),
              ),
              Text(
                '${model.bio}',
                style:
                const TextStyle(fontSize: 15,color: Colors.grey),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
