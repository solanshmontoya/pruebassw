import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutterapp/data/rest_ds.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();


  dynamic getData(url, params, token)  async  {
    var  httpClient  =  new  HttpClient();
    
    var  uri  =  new Uri.https(RestDatasource.BASE_URL,  url, params);
    var  request  =  await httpClient.getUrl(uri);    
    request.headers.add('Authorization', 'token $token');

    var  response  =  await request.close();
    var  responseBody  =  await response.transform(utf8.decoder).join();
    return  responseBody;
}

  Future<dynamic> get(String url, Map<String, String> params, String token) {
  
    print(url);
    return getData(url, params, token).then((dynamic rr){
       return _decoder.convert(rr);
    });

    // return _decoder.convert(test);
/*
    return http.get(url, headers: {'Authorization': "token $token"}).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
    */
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    
    var  uri  =  new Uri.https(RestDatasource.BASE_URL,  url);

    return http
        .post(uri.toString(), body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}