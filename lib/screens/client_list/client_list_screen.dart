import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/client_detail/client_detail_screen.dart';
import 'package:flutterapp/screens/other_lists/other_lists_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterapp/screens/client_list/client_list_screen_presenter.dart';
import 'package:flutterapp/models/client.dart';

class SearchList extends StatefulWidget {
  static String tag = 'clients';
  String zone;
  SearchList({Key key, this.zone}) : super(key: key);
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList>
    implements ClientListScreenContract {
  Widget appBarTitle = new Text(
    "Lista de Clientes",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<Client> _list;
  bool _isSearching;
  bool _success;
  String _searchText = "";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  ClientListScreenPresenter _presenter;

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });

    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = _sharedPreferences.getString('auth_token');
    _presenter = new ClientListScreenPresenter(this, authToken);
    _presenter.requestClientList(widget.zone);
  }

  @override
  void onClientListSuccess(List<Client> clients) {
    setState(() {
      _list = clients;
      _isSearching = false;
      _success = true;
    });
  }

  @override
  void onClientListError(String errorTxt) {
    int i = 0;
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _success = false;
    _list = [];
    _fetchSessionAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: _success
          ? new ListView(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              children: _isSearching ? _buildSearchList() : _buildList(),
            )
          : new Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new OtherLists(
                        zone: widget.zone)));
          }
        },
        backgroundColor: themeData.primaryColorDark,
        child: new Icon(
          Icons.add_to_photos,
          semanticLabel: 'Add',
        ),
      ),
    );
  }

  List<ChildItem> _buildList() {
    return _list
        .map((contact) => new ChildItem(contact, this._presenter))
        .toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list
          .map((contact) => new ChildItem(contact, this._presenter))
          .toList();
    } else {
      List<Client> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String name = _list.elementAt(i).name;
        String lastname = _list.elementAt(i).lastname;
        if (name.toLowerCase().contains(_searchText.toLowerCase()) ||
            lastname.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(_list.elementAt(i));
        }
      }
      return _searchList
          .map((contact) => new ChildItem(contact, this._presenter))
          .toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _searchQuery,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    labelText: "Buscar cliente",
                    labelStyle: new TextStyle(color: Colors.white)),
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Lista de Clientes",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}

class ChildItem extends StatelessWidget {
  final Client _client;
  final ClientListScreenPresenter _presenter;
  const ChildItem(this._client, this._presenter);
  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text('${this._client.lastname}, ${this._client.name}'),
        trailing: const Icon(Icons.arrow_right),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new ClientDetail(clientId: '${this._client.id}')));
        });
  }
}
