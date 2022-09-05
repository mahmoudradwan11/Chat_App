import 'package:chat_app/Models/UserData.dart';
import 'package:chat_app/Models/messagemodel.dart';
import 'package:chat_app/shared/colors.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
class ChatScreen extends StatelessWidget {
  UserData? userModel;
  var textController = TextEditingController();
  ChatScreen({Key? key,
    this.userModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return Builder(
        builder:(context)
        {
          ChatsCubit.get(context).getMessages(receiverId:userModel!.uid!);
          return BlocConsumer<ChatsCubit,ChatsState>(
            listener:(context,state){},
            builder:(context,state){
              var cubit = ChatsCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Row(
                    children:[
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage:NetworkImage(userModel!.image!),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Text(userModel!.name!),
                    ],
                  ),
                ),
                body:Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children:[
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder:(context,index){
                            var massage = cubit.messages[index];
                            if(cubit.userModel!.uid! == massage.senderId) {
                              return builtMyMessage(massage,context);
                            }
                            return builtMessage(massage,context);
                          },
                          separatorBuilder:(context,index)=>const SizedBox(
                            height: 15.0,
                          ),
                          itemCount:cubit.messages.length,
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:Colors.grey.withOpacity(0.3),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          children:[
                            Expanded(
                              child: TextFormField(
                                controller: textController,
                                decoration:const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message ... ',
                                ),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              color:defColor,
                              child: MaterialButton(
                                onPressed:(){
                                  cubit.sendMessage(
                                    receiverId:userModel!.uid!,
                                    dateTime:DateTime.now().toString(),
                                    text: textController.text,
                                  );
                                },
                                minWidth: 1.0,
                                child:const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }
  Widget builtMessage(MessageModel model,context)=>Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            child: Text(model.text!),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(DateFormat('KK:mm').format(DateTime.tryParse(model.dateTime!)!),style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
    Widget builtMyMessage(MessageModel model,context)=>Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration:BoxDecoration(
              color:defColor.withOpacity(0.2),
              borderRadius:const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(10.0),
                topEnd:Radius.circular(10.0),
                topStart: Radius.circular(10.0),
              ),
            ),
            padding:const EdgeInsets.symmetric(
              vertical:5.0,
              horizontal:10.0,
            ),
            child: Text(model.text!,style:Theme.of(context).textTheme.subtitle1,),

          ),
          Text(DateFormat('KK:mm').format(DateTime.tryParse(model.dateTime!)!,),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
