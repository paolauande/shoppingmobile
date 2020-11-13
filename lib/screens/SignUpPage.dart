import 'package:shoppingmobile/screens/BottomNavigationBarPage.dart';
import 'package:shoppingmobile/services/user_api.dart';
import 'package:shoppingmobile/widgets/alert.dart';
import 'package:shoppingmobile/widgets/config.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';
import '../widgets/inputFields.dart';
import 'package:page_transition/page_transition.dart';
import './LoginPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _cellphoneController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confpassController = TextEditingController();

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
                      Text('Faça seu cadastro', style: h3),
                      textInput('Nome completo',
                          controller: _nameController, validator: _validaName),
                      textInput('Usuário',
                          controller: _loginController,
                          validator: _validaLogin),
                      numberInput('Telefone',
                          controller: _cellphoneController,
                          validator: _validaPhone),
                      cpfInput('CPF',
                          controller: _cpfController, validator: _validaCPF),
                      emailInput('E-mail',
                          controller: _emailController,
                          validator: _validaEmail),
                      passwordInput('Senha', onPressed: () {
                        setState(() {
                          _isSecured = !_isSecured;
                        });
                      },
                          obscureText: _isSecured,
                          controller: _passController,
                          validator: _validaPass),
                      passwordInput('Confirme a senha', onPressed: () {
                        setState(() {
                          _isSecured = !_isSecured;
                        });
                      },
                          obscureText: _isSecured,
                          controller: _confpassController,
                          validator: _confirmaPass),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          onPressed: () {
                            _registerButton(context);
                          },
                          color: highlightColor,
                          padding: EdgeInsets.all(13),
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
                                    child: LoginPage()));
                          },
                          child: Text('Já tem conta? Login',
                              style: contrastTextBold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //height: 700,
              width: double.infinity,
              decoration: authPlateDecoration,
            ),
          ],
        ),
      )),
    );
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  _registerButton(BuildContext context) async {
    setLoading(true);
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }

    String username = _loginController.text;
    String password = _passController.text;
    String name = _nameController.text;
    String email = _emailController.text;
    String cpf = _cpfController.text;
    cpf = cpf.replaceAll("-", "");
    cpf = cpf.replaceAll(".", "");
    String cellphone = _cellphoneController.text;

    print("login: $username, name: $name, email: $email");

    var login = await UserApi.signup(name, username, email, password, cpf,
        cellphone, Environment.USER_TYPE_ID, Environment.USER_SITUATION_ID);

    if (login != null) {
      var defineProfile = UserApi.defineProfile();
      if (defineProfile != null) {
        await new Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigatioBarPage()));
      }
    } else {
      setLoading(false);
      alert(context, "Verifique os dados inseridos.");
      return;
    }
  }

  String _validaName(text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Informe seu nome";
    } else if (text.trim().length < 8) {
      setLoading(false);
      return "Mínimo de 8 caracteres";
    }
    return null;
  }

  String _validaPhone(text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Informe o telefone";
    } else
      return null;
  }

  String _validaEmail(String text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Informe o E-mail";
    } else
      return !EmailValidator.validate(text, true) ? 'E-mail inválido' : null;
  }

  String _validaPass(String text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Digite a senha";
    } else if (text.trim().length < 6) {
      setLoading(false);
      return "Mínimo de 6 caracteres";
    }
    return null;
  }

  String _confirmaPass(String text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Digite a senha novamente";
    } else if (text.trim() != _passController.text.trim()) {
      setLoading(false);
      return "As senhas não são iguais";
    }
    return null;
  }

  String _validaLogin(String text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Digite um nome de usuário";
    } else if (text.trim().length < 3) {
      setLoading(false);
      return "Mínimo de 3 caracteres";
    }
    return null;
  }

  String _validaCPF(text) {
    if (text.isEmpty) {
      setLoading(false);
      return "Informe o CPF";
    } else
      return null;
  }
}
