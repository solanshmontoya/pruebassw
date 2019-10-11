import 'package:flutter/material.dart';
import 'package:flutterapp/screens/charge/charge_fail_screen.dart';
import 'package:flutterapp/screens/charge/charge_success_screen.dart';
import 'package:flutterapp/screens/client_list/client_list_screen.dart';
import 'package:flutterapp/screens/client_detail/client_detail_screen.dart';
import 'package:flutterapp/screens/credit_list/credit_list_screen.dart';
import 'package:flutterapp/screens/credit_detail/credit_detail_screen.dart';
import 'package:flutterapp/screens/quote_detail/quote_detail_screen.dart';
import 'package:flutterapp/screens/total_charge/total_charge_screen.dart';
import 'package:flutterapp/screens/login/login_screen.dart';
import 'package:flutterapp/screens/profile/profile_screen.dart';
import 'package:flutterapp/screens/splash/splash_screen.dart';
import 'package:flutterapp/screens/other_lists/other_lists_screen.dart';
import 'package:flutterapp/screens/quote_list/client_quotes_screen.dart';
import 'package:flutterapp/screens/charge/charge_loading_screen.dart';

final routes = {
  '/login':         (context) => new LoginScreen(),
  '/profile':         (context) => new ProfileScreen(),
  '/home':         (BuildContext context) => new SearchList(),
  '/detail':       (BuildContext context) => new ClientDetail(),
  '/credits':       (BuildContext context) => new CreditList(),
  '/creditDetail':       (BuildContext context) => new ClientCreditDetail(),
  '/totalCharge':       (BuildContext context) => new TotalCharge(),
  '/other_list':     (BuildContext context) => new OtherLists(),
  '/quotes':     (BuildContext context) => new QuotesList(),
  '/quoteDetail':     (BuildContext context) => new QuoteDetail(),
  '/chargeLoading': (BuildContext context) => new ChargeLoading(),
  '/chargeSuccess': (BuildContext context) => new ChargeSuccess(),
  '/chargeFail': (BuildContext context) => new ChargeFail(),
  '/' :          (BuildContext context) => new SplashScreen(),
};