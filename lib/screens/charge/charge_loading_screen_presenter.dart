import '../../data/rest_ds.dart';
import 'package:flutterapp/models/quote.dart';

abstract class ChargeScreenContract {
  void onChargeSuccess(Map charge);
  void onChargeError(String errorTxt);
}

class ChargeScreenPresenter {
  String authToken;
  ChargeScreenContract _view;
  RestDatasource api = new RestDatasource();
  ChargeScreenPresenter(this._view, this.authToken);

  requestCharge(charge, quoteId, arrears) {
    try{
      api.postCharge(this.authToken, charge, quoteId, arrears).then((dynamic charge ) {
        _view.onChargeSuccess(charge);
      }).catchError((handleError) => (
          _view.onChargeError(handleError.message)
      )
      );
    }catch(e){
      print(e.toString());
    }
  }
}