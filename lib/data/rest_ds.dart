import 'dart:async';
import 'package:flutterapp/models/fee.dart';
import 'package:http/http.dart' as http;
import 'package:flutterapp/utils/network_util.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/models/client.dart';
import 'package:flutterapp/models/client_detail.dart';
import 'package:flutterapp/models/client_credit.dart';
import 'package:flutterapp/models/profile.dart';
import 'package:flutterapp/models/quote.dart';
import 'dart:io';
import 'dart:convert';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "edison-prod.herokuapp.com";

  //static final BASE_URL = "http://172.20.10.2:8000";
  static final LOGIN_URL = "/accounts/api/login/";
  static final PROFILE_URL = "/accounts/api/users/me/";
  static final CLIENTS_URL = "/clients/api/clients/";
  static final CLIENT_DETAIL_URL = "/clients/api/clients/";
  static final CLIENT_CREDIT_URL = "/credits/api/credit/";
  static final CREDIT_DETAIL_URL = "/credits/api/credit/";
  static final QUOTES_URL = "/credits/api/quote/";
  static final OVERDUE_URL = "/credits/api/credit/";
  static final FEES_URL = "/credits/api/fee/";
  static final _API_KEY = "somerandomkey";

  Future<String> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password
    }).then((dynamic res) {
      if (res["non_field_errors"] != null) {
        throw new Exception(res["non_field_errors"][0]);
      }
      print('got token $res["key"]');
      return res["key"];
    });
  }

  Future<Profile> getProfile(String token) {
    Map<String, String> queryParameters = Map<String, String>();
    return _netUtil.get(PROFILE_URL, queryParameters, token).then((dynamic res) {
      return new Profile(res["username"], res["email"], res["first_name"],
          res["last_name"], res["profile"]);
    });
  }

  Future<List<Client>> getClients(String token, String zone) {
    Map<String, String> queryParameters = Map<String, String>();
    queryParameters.addAll({"zone_from":zone});
    return _netUtil.get(CLIENTS_URL, queryParameters, token).then((dynamic res) {
      final itemsTmp = res.map((i) => new Client.map(i));
      final items = itemsTmp.cast<Client>();
      return items.toList();
    });
  }

  Future<ClientDetailModel> getClientDetail(String token, String clientId) {
    Map<String, String> queryParameters = Map<String, String>();
    return _netUtil
        .get(CLIENT_DETAIL_URL + clientId + '/', queryParameters, token)
        .then((dynamic res) {
      return new ClientDetailModel(
          res["id"],
          res["name"],
          res["lastname"],
          res["dni"],
          res["address"],
          res["cellphone"],
          res["phone"],
          res["address_of_payment"],
          res["reference"],
          res["zone_from"],
          res["district"]
      );
    });
  }

  Future<List<Credit>> getCreditList(String token, int clientId) {
    Map<String, String> queryParameters = Map<String, String>();
    queryParameters.addAll({"client":clientId.toString()});
    return _netUtil
        .get(CLIENT_CREDIT_URL, queryParameters, token)
        .then((dynamic res) {
      final itemsTmp = res.map((i) => new Credit.map(i));
      final items = itemsTmp.cast<Credit>();
      return items.toList();
    });
  }

  Future<Credit> getCreditDetail(String token, String creditId) {
    Map<String, String> queryParameters = Map<String, String>();
    return _netUtil
        .get(CREDIT_DETAIL_URL + creditId + '/', queryParameters, token)
        .then((dynamic res) {
    });
  }

  Future<List<Quote>> getQuotes(String token, int creditId) {
    Map<String, String> queryParameters = Map<String, String>();
    queryParameters.addAll({"credit":creditId.toString()});
    return _netUtil
        .get(QUOTES_URL, queryParameters, token)
        .then((dynamic res) {
      final itemsTmp = res.map((i) => new Quote.map(i));
      final items = itemsTmp.cast<Quote>();
      return items.toList();
    });
  }

  Future<Map> postCharge(String token, dynamic charge, dynamic quoteId,
      dynamic arrears) {
    final JsonDecoder _decoder = new JsonDecoder();
    var  uri  =  new Uri.https(RestDatasource.BASE_URL,  FEES_URL);
    return http.post(uri.toString(), body: {
      "arrears": arrears.toString(),
      "quote": quoteId.toString(),
      "amount_received": charge.toString()
    }, headers: {
      'Authorization': 'token ${token}'
    }).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(statusCode);
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    }).then((res) {
      return res;
    });
  }

  Future<List<Fee>> getFees(String token, String created_at, String zone) {
    Map<String, String> queryParameters = Map<String, String>();
    queryParameters.addAll({"created_at":created_at, "quote__credit__client__zone_from": zone});

    return _netUtil
        .get(FEES_URL, queryParameters, token)
        .then((dynamic res) {
      final itemsTmp = res.map((i) => new Fee.map(i));
      final items = itemsTmp.cast<Fee>();
      return items.toList();
    });
  }
  
  Future<List<Credit>> getOverdueQuotes(String token, String zone) {
    Map<String, String> queryParameters = Map<String, String>();
    queryParameters.addAll({"client__zone_from": zone, "is_archived":"false", "due_date__lt": new DateTime.now().toString().substring(0, 11)});
    return _netUtil
        .get(OVERDUE_URL, queryParameters, token)
        .then((dynamic res) {
      final itemsTmp = res.map((i) => new Credit.map(i));
      final items = itemsTmp.cast<Credit>();
      return items.toList();
    });
  }
}
