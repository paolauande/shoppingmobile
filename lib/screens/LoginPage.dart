import 'package:shoppingmobile/datas/user.dart';
import 'package:shoppingmobile/screens/BottomNavigationBarPage.dart';
import 'package:shoppingmobile/services/user_api.dart';
import 'package:shoppingmobile/widgets/alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';
import '../widgets/inputFields.dart';
import 'package:page_transition/page_transition.dart';
import './SignUpPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  var _isSecured = true;
  bool isLoading = false;

  setLoading(bool loaded) {
    setState(() {
      isLoading = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Text('Faça seu login', style: h3),
                        textInput('Usuário ou E-mail',
                            controller: _loginController,
                            validator: _validaLogin),
                        passwordInput('Senha', onPressed: () {
                          setState(() {
                            _isSecured = !_isSecured;
                          });
                        },
                            obscureText: _isSecured,
                            controller: _passController,
                            validator: _validaPass),
                        Align(
                          alignment: Alignment.topLeft,
                          child: FlatButton(
                            onPressed: () {},
                            child:
                                Text('Esqueceu a senha?', style: contrastText),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              _loginButton(context);
                            },
                            color: highlightColor,
                            padding: EdgeInsets.all(15),
                            shape: CircleBorder(),
                            child: isLoading
                                ? _circularLoading()
                                : Icon(Icons.arrow_forward, color: white),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: SignUpPage()));
                            },
                            child: Text('Não tem conta? Cadastre-se',
                                style: contrastTextBold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                width: double.infinity,
                decoration: authPlateDecoration,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  _loginButton(BuildContext context) async {
    setLoading(true);
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }

    String username = _loginController.text;
    String password = _passController.text;

    print("USUÁRIO: $username");

    User usuario = await UserApi.login(username, password);

    if (usuario != null) {
      var defineProfile = await UserApi.defineProfile();
      if (defineProfile != null) {
        await new Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigatioBarPage()));
      } else {
        setLoading(false);
        alert(context, "Perfil não cadastrado");
        return;
      }
    } else {
      setLoading(false);
      alert(context, "Login inválido. Verifique o usuário ou a senha. ");
      return;
    }
  }

  String _validaLogin(String text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Informe o usuário ou E-mail";
    } else if (text.contains("@")) {
      setLoading(false);
      return !EmailValidator.validate(text, true) ? 'E-mail inválido' : null;
    }
    return null;
  }

  String _validaPass(String text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Digite a senha";
    } else if (text.length < 6) {
      setLoading(false);
      return "A senha deve ter mais de 6 caracteres";
    }
    return null;
  }
}
