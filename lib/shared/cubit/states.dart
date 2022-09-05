abstract class ChatsState{}
class ChatInitState extends ChatsState{}
class ChangeScreen extends ChatsState{}
class UserUpdateError extends ChatsState{}
class UserUpdateLoading extends ChatsState{}
class GetUserSuccessState extends ChatsState{}
class GetUserErrorState extends ChatsState{
  final String error;

  GetUserErrorState(this.error);
}
class GetAllUsersSuccessState extends ChatsState {}
class LoadingGetAllUserDataState extends ChatsState {}
class GetAllUsersErrorState extends ChatsState {
  final String error;
  GetAllUsersErrorState(this.error);
}
class SendMessageSuccessState extends ChatsState{}
class SendMessageErrorState extends ChatsState{}
class GetMessageSuccessState extends ChatsState{}
class GetMessageErrorState extends ChatsState{}
class ChangeAppMode extends ChatsState{}