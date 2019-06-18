import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:present_sir/auth.dart';
import 'package:present_sir/models/subject.dart';
import 'package:present_sir/ui/calender.dart';
import 'package:present_sir/ui/splashscreen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic> _profile;
  var _db = Firestore.instance;
  List _subjects = [];
  bool _loading = false;
  final TextEditingController _nameEditingController =
      new TextEditingController();
  final TextEditingController _codeEditingController =
      new TextEditingController();

  @override
  initState() {
    super.initState();

    // Subscriptions are created here
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, AsyncSnapshot snapshot) {
        if (_loading) {
          return SplashScreen();
        }
        if (snapshot.hasData && _profile != null) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Present Sir"),
            ),
            body: Container(
              child: ListView.builder(
                itemCount: _profile['subjects'].length,
                itemBuilder: (BuildContext context, int index) {
                  Subject sub = Subject.fromMap(_profile['subjects'][index]);
                  _subjects.add(sub.toMap());
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(sub.code[0]),
                    ),
                    title: sub,
                    onTap: () {
                    },
                    onLongPress: () {},
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showForm(),
              child: Icon(Icons.add),
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: Text(_profile['email']),
                    accountName: Text(_profile['displayName']),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(_profile['photoURL']),
                    ),
                  ),
                  ListTile(
                    subtitle: Text("Subjects"),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Logout"),
                    leading: Icon(Icons.arrow_left),
                    onTap: () => authService.signOut(),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Login();
        }
      },
    );
  }

  void _showForm() {
    var alert = new AlertDialog(
      title: Text("Add new Subject"),
      content: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TextField(
            autofocus: true,
            controller: _nameEditingController,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "e.g. Database",
            ),
          ),
          TextField(
            autofocus: true,
            controller: _codeEditingController,
            decoration: InputDecoration(
              labelText: "Code",
              hintText: "e.g. DBMS",
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmit(
                _nameEditingController.text, _codeEditingController.text);
            _nameEditingController.clear();
            _codeEditingController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmit(String text, String text2) async {
    Subject sub = new Subject(text, text2, [], []);
    _subjects.add(sub.toMap());
    await _db
        .collection("users")
        .document(_profile['uid'])
        .updateData({'subjects': _subjects});
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () => authService.googleSignIn(),
          color: Colors.white,
          textColor: Colors.black,
          child: Text('Login with Google'),
        ),
      ),
    );
  }
}
