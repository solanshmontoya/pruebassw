import '../../data/rest_ds.dart';
import 'package:flutterapp/models/client_credit.dart';

abstract class ClientCreditScreenContract {
  void onCreditDetailSuccess(Credit credit);
  void onCreditDetailError(String errorTxt);
}

class ClientCreditScreenPresenter {
  String authToken;
  ClientCreditScreenContract _view;
  RestDatasource api = new RestDatasource();
  ClientCreditScreenPresenter(this._view, this.authToken);

  requestCreditsDetails(creditId) {
    try{
      api.getCreditDetail(this.authToken, creditId ).then((Credit credit) {
        _view.onCreditDetailSuccess(credit);
      }).catchError((handleError) => (
          _view.onCreditDetailError(handleError)
      )
      );
    }catch(e){
      print(e.toString());
    }
  }
}