import '../../data/rest_ds.dart';
import '../../models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(String token);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    try{
    api.login(username, password).then((String token) {
        _view.onLoginSuccess(token);

    }).catchError((handleError) => 
      _view.onLoginError(handleError.message)
    );
    }catch(e){
      print(e.toString());  
    }
  }

}