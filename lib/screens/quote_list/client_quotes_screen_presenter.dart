import '../../data/rest_ds.dart';
import 'package:flutterapp/models/quote.dart';

abstract class QuotesScreenContract {
  void onQuotesSuccess(List<Quote> quote);
  void onQuotesError(String errorTxt);
}

class QuotesScreenPresenter {
  String authToken;
  QuotesScreenContract _view;
  RestDatasource api = new RestDatasource();
  QuotesScreenPresenter(this._view, this.authToken);

  requestQuotes(creditId) {
    try {
      api
          .getQuotes(this.authToken, creditId)
          .then((List<Quote> quote) {
        print(quote);
        _view.onQuotesSuccess(quote);
      }).catchError(
              (handleError) => _view.onQuotesError(handleError.message));
    } catch (e) {
      print(e.toString());
    }
  }
}
