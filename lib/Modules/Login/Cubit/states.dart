abstract class LoginState{}
class LoadingLogin extends LoginState{}
class LoginInitState extends LoginState{}
class LoginSuccessState extends LoginState{
  final String uid;
  LoginSuccessState(this.uid);
}
class LoginFailedState extends LoginState
{
  final String error;
  LoginFailedState(this.error);
}
class ChangePasswordVisState extends LoginState{}


