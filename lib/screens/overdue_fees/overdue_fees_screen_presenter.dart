import 'package:flutterapp/models/client_credit.dart';
import '../../data/rest_ds.dart';

abstract class OverdueFeesContract {
  void onOverdueFeesSuccess(List<Credit> credit);
  void onOverdueFeesError(String errorTxt);
}

class OverdueFeesScreenPresenter {
  String authToken;
  OverdueFeesContract _view;
  RestDatasource api = new RestDatasource();
  OverdueFeesScreenPresenter(this._view, this.authToken);

  requestOverdueFees(zone) {
    try {
      api
          .getOverdueQuotes(this.authToken, zone)
          .then((List<Credit> credit) {
        _view.onOverdueFeesSuccess(credit);
      }).catchError(
              (handleError) => _view.onOverdueFeesError(handleError.message));
    } catch (e) {
      print(e.toString());
    }
  }
}
