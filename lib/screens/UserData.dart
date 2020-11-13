import 'package:shoppingmobile/datas/user.dart';
import 'package:shoppingmobile/services/user_api.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:flutter/material.dart';

class UserData extends StatefulWidget {
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  Future<User> userData;
  displayRecord() {
    setState(() {
      userData = UserApi.getUserData();
    });
  }

  @override
  void initState() {
    userData = UserApi.getUserData();
    super.initState();
  }

  edit(User user, _UserDataState _userDataState, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            new EditUserDialog().editDialog(context, _userDataState, user));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<User>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data;
            return new Container(
              height: 150,
              child: ListView(
                  physics: new NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.all(10),
                      child: new Container(
                          height: 150,
                          margin: EdgeInsets.only(right: 18),
                          child: new Center(
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text("Nome: ${user.name}",
                                            style: h6),
                                        new Text(
                                          "Usuário: ${user.username}",
                                          style: h6,
                                        ),
                                        new Text(
                                          "Email: ${user.email}",
                                          style: h6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: highlightColor,
                                      ),
                                      onPressed: () =>
                                          edit(user, this, context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                    ),
                  ]),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class EditUserDialog {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  int userId;

  Widget editDialog(
      BuildContext context, _UserDataState _userDataState, User user) {
    nameController.text = (user == null ? "" : user.name);
    usernameController.text = (user == null ? "" : user.username);
    emailController.text = (user == null ? "" : user.email);

    return new AlertDialog(
      title: new Text('Editar Usuário', style: editarText),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Nome", nameController),
            getTextField("Usuário", usernameController),
            getTextField("Email", emailController),
            new GestureDetector(
              onTap: () async {
                var user = User.fromJson({
                  "name": nameController.text,
                  "login": usernameController.text,
                  "email": emailController.text,
                  "user_id": userId
                });
                await UserApi.editUserData(user);
                _userDataState.displayRecord();
                Navigator.of(context).pop();
              },
              child: new Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton("Atualizar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        style: h6,
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel) {
    var loginBtn = new Container(
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: highlightColor,
        borderRadius: new BorderRadius.all(const Radius.circular(4)),
      ),
      child: new Text(buttonLabel, style: whiteText),
    );
    return loginBtn;
  }
}
