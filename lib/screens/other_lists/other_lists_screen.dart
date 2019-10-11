import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/auth.dart';
import 'package:flutterapp/screens/client_list/client_list_screen.dart';
import 'package:flutterapp/screens/login/login_screen_presenter.dart';
import 'package:flutterapp/screens/overdue_fees/overdue_fees_screen.dart';
import 'package:flutterapp/screens/total_charge/total_charge_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherLists extends StatefulWidget {
  final String zone;
  OtherLists({Key key, this.zone});
  @override
  _OtherListsState createState() => _OtherListsState();
}

class _OtherListsState extends State<OtherLists>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _closeSession() async {
    _sharedPreferences = await _prefs;
    _sharedPreferences.remove('auth_token');
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_OUT);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            settings: const RouteSettings(name: '/home'),
            builder: (context) => new SearchList(zone: widget.zone.toString())),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Otras Listas'),
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.home),
                  onPressed: () {
                    this._navigateToHome();
                  },
                ),
                new IconButton(
                  icon: new Icon(Icons.directions_run),
                  onPressed: () {
                    this._closeSession();
                  },
                ),
              ],
              pinned: true,
              floating: true,
              forceElevated: boxIsScrolled,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "Total Cobrado",
                    icon: Icon(Icons.monetization_on),
                  ),
                  Tab(
                    text: "Cuotas Vencidas",
                    icon: Icon(Icons.not_interested),
                  )
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            new TotalCharge(zone: widget.zone),
            new OverdueFeeds(zone: widget.zone),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
