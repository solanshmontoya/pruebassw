import '../../data/rest_ds.dart';
import '../../models/profile.dart';

abstract class ProfileScreenContract {
  void onProfileSuccess(Profile profile);
  void onProfileError(String errorTxt);
}

class ProfileScreenPresenter {
  String authToken;
  ProfileScreenContract _view;
  RestDatasource api = new RestDatasource();
  ProfileScreenPresenter(this._view, this.authToken);

  requestProfile() {
    try{
      api.getProfile(this.authToken).then((Profile profile) {
        _view.onProfileSuccess(profile);
      }).catchError((handleError) =>
          _view.onProfileError(handleError.message)
      );
    }catch(e){
      print(e.toString());
    }
  }
}