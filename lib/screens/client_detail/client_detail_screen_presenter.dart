import '../../data/rest_ds.dart';
import 'package:flutterapp/models/client_detail.dart';

abstract class ClientDetailScreenContract {
  void onClientDetailSuccess(ClientDetailModel client_detail);
  void onClientDetailError(String errorTxt);
}

class ClientDetailScreenPresenter {
  String authToken;
  ClientDetailScreenContract _view;
  RestDatasource api = new RestDatasource();
  ClientDetailScreenPresenter(this._view, this.authToken);

  requestClientDetails(clientId) {
    try{
      api.getClientDetail(this.authToken, clientId ).then((ClientDetailModel client_detail) {
        _view.onClientDetailSuccess(client_detail);
      }).catchError((handleError) => (
          print(handleError)
          //_view.onClientDetailError(handleError.message)
      )
      );
    }catch(e){
      print(e.toString());
    }
  }
}