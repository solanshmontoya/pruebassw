import '../../data/rest_ds.dart';
import 'package:flutterapp/models/client_credit.dart';

abstract class CreditListScreenContract {
  void onClientCreditsSuccess(List<Credit> client_credits);
  void onClientCreditsError(String errorTxt);
}

class CreditListScreenPresenter {
  String authToken;
  CreditListScreenContract _view;
  RestDatasource api = new RestDatasource();
  CreditListScreenPresenter(this._view, this.authToken);

  requestCreditList(clientId) {
    try {
      api
          .getCreditList(this.authToken, clientId)
          .then((List<Credit> client_credits) {
        print(client_credits);
        _view.onClientCreditsSuccess(client_credits);
      }).catchError(
              (handleError) => _view.onClientCreditsError(handleError.message));
    } catch (e) {
      print(e.toString());
    }
  }
}
