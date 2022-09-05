import 'package:chat_app/shared/components.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatsCubit.get(context);
          var userModel = cubit.userModel;
          nameController.text = userModel!.name!;
          bioController.text  =userModel.bio!;
          phoneController.text = userModel.phone!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                if (state is UserUpdateLoading) const LinearProgressIndicator(),
                const SizedBox(
                  height: 10.0,
                ),
                    textField(
                      show: false,
                      controller:nameController,
                      keyboard:TextInputType.name,
                      valid:(value)
                      {
                        if(value.isEmpty)
                        {
                          return 'Name Must not be Empty';
                        }
                        return null;
                      },
                      label:'Name',
                      prefix:Icons.person,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    textField(
                      show: false,
                      controller:bioController,
                      keyboard:TextInputType.name,
                      valid:(value)
                      {
                        if(value.isEmpty)
                        {
                          return 'Bio Must not be Empty';
                        }
                        return null;
                      },
                      label:'Bio',
                      prefix:Icons.info,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    textField(
                      show: false,
                      controller:phoneController,
                      keyboard:TextInputType.phone,
                      valid:(value)
                      {
                        if(value.isEmpty)
                        {
                          return 'Phone Must not be Empty';
                        }
                        return null;
                      },
                      label:'Phone',
                      prefix:Icons.mobile_friendly,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children:[
                         Text(
                          'Mode',style:Theme.of(context).textTheme.subtitle1,
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed:(){
                          cubit.changeMode();
                        }, icon:const Icon(Icons.dark_mode),
                        ),
                      ],
                    ),
                    defButton(function:(){
                      cubit.updateUser(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                    }, text:'Update'),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defButton(function:(){
                      cubit.signOut(context);
                    }, text:'Logout'),
                    const SizedBox(
                      height: 20,
                    ),
              ]
              ),
            ),
          );
        }
        );
  }
}
