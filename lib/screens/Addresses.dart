import 'package:shoppingmobile/datas/address.dart';
import 'package:shoppingmobile/datas/freight.dart';
import 'package:shoppingmobile/datas/freight_request.dart';
import 'package:shoppingmobile/services/address_api.dart';
import 'package:shoppingmobile/services/orders_api.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import 'package:shoppingmobile/widgets/sizes_helpers.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:shoppingmobile/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';

class Addresses extends StatefulWidget {
  @override
  _AddressesState createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  Future<List<Address>> list;
  String warning;
  displayRecord(String message) {
    setState(() {
      list = AddressApi.getUserAddresses();
      warning = message;
    });
  }

  @override
  void initState() {
    list = AddressApi.getUserAddresses();
    super.initState();
  }

  Widget _buildActions(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.add_circle,
          color: highlightColor,
        ),
        onPressed: () {
          add(this, context);
        });
  }

  edit(Address address, _AddressesState _addressesState,
      BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            new AddAddress(_addressesState, true, address));
    setState(() {});
  }

  delete(Address address, _AddressesState _addressesState,
      BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => new DeleteAddressDialog()
          .deleteDialog(context, _addressesState, address),
    );
    setState(() {});
  }

  add(_AddressesState _addressesState, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          new AddAddress(_addressesState, false, null),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 25),
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildActions(context),
            )),
        warning == null
            ? Text("")
            : Center(
                child: Text(
                warning,
                style: inkText,
                textAlign: TextAlign.center,
              )),
        Expanded(
          child: Center(
            child: FutureBuilder<List<Address>>(
                future: list,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    var addresses = snapshot.data;
                    return new Container(
                      height: SizeConfig.blockSizeVertical * 40,
                      child: ListView.builder(
                          itemCount: addresses == null ? 0 : addresses.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              elevation: 9,
                              margin: EdgeInsets.all(10),
                              child: new Container(
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
                                                new Text(
                                                    "${addresses[index].city} - ${addresses[index].state}",
                                                    style: h6),
                                                new Text(
                                                  "CEP: " +
                                                      addresses[index].cep,
                                                  style: h6,
                                                ),
                                                new Text(
                                                  "Bairro: ${addresses[index].neighborhood}",
                                                  style: h6,
                                                ),
                                                addresses[index].number == "0"
                                                    ? new Text(
                                                        "${addresses[index].street}",
                                                        style: h6)
                                                    : new Text(
                                                        "${addresses[index].street}," +
                                                            " Nº ${addresses[index].number.toString()}",
                                                        style: h6),
                                                addresses[index].complement ==
                                                        ""
                                                    ? Text("")
                                                    : new Text(
                                                        "Complemento: " +
                                                            addresses[index]
                                                                .complement,
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
                                              onPressed: () => edit(
                                                  addresses[index],
                                                  this,
                                                  context),
                                            ),
                                            new IconButton(
                                                icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: highlightColor),
                                                onPressed: () {
                                                  delete(addresses[index], this,
                                                      context);
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 0.0, 0.0)),
                            );
                          }),
                    );
                  } else {
                    return Center(
                        child:
                            Text("Adicione seu endereço!", style: alertText));
                  }
                }),
          ),
        ),
      ],
    );
  }
}

class AddAddress extends StatefulWidget {
  _AddressesState _addressesState;
  bool isEdit;
  Address address;
  AddAddress(this._addressesState, this.isEdit, this.address);
  @override
  _AddAddressState createState() =>
      _AddAddressState(_addressesState, isEdit, address);
}

class _AddAddressState extends State<AddAddress> {
  _AddressesState _addressesState;
  bool isEdit;
  Address address;
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int addressId;
  int userId;
  bool viewVisible = false;
  bool isLoading = false;
  Freight freight;
  _AddAddressState(this._addressesState, this.isEdit, this.address) {
    viewVisible = isEdit;
    addressId = address != null ? address.id : null;
    freight = null;
    if (address != null) {
      OrdersApi.getFreightByNeighborhood(address.neighborhood).then((onValue) {
        setState(() {
          freight = onValue;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Editar endereço' : 'Adicionar endereço',
              style: z4),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildSearchButton(),
                _buildResultForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: _searchLocation,
        child: isLoading
            ? _circularLoading()
            : Text(
                'Buscar localização',
                style: contrastText,
              ),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.all(const Radius.circular(4))),
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

  _searchLocation() async {
    setState(() {
      isLoading = true;
      address = null;
    });

    await AddressApi.getAddressByGeolocator().then((onValue) {
      setState(() {
        address = onValue;
        address.complement = '';
        address.number = '';
        isLoading = false;
        viewVisible = true;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
        viewVisible = true;
      });
    });
    if (address != null && address.neighborhood != null) {
      await OrdersApi.getFreightByNeighborhood(address.neighborhood)
          .then((onValue) {
        setState(() {
          freight = onValue;
        });
      });
    }
  }

  Widget _buildResultForm() {
    return Visibility(
      visible: viewVisible,
      child: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: _buildAddressFields(),
      ),
    );
  }

  Widget _buildAddressFields() {
    complementController.text = (address == null ? "" : address.complement);
    numberController.text = (address == null ? "" : address.number);

    return new Column(
        children: address != null && freight != null
            ? <Widget>[
                getAddressFromCEP(address.cep),
                getAddressFromCEP(address.street),
                SizedBox(
                  height: 10,
                ),
                getNumberFromUser("Digite o número", numberController),
                getAddressFromFreight(address.neighborhood),
                getComplementFromUser(
                    "Insira o complemento", complementController),
                getAddressFromCEP(address.city),
                getAddressFromCEP(address.state),
                new GestureDetector(
                  onTap: () async {
                    bool formOk = _formKey.currentState.validate();
                    if (!formOk) {
                      return;
                    }
                    address.complement = complementController.text;
                    address.number = numberController.text;
                    address.id = addressId;
                    await AddressApi.saveAddress(isEdit, address);
                    _addressesState.displayRecord("");
                    Navigator.of(context).pop();
                  },
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child:
                        saveAddressButton(isEdit ? "Atualizar" : "Adicionar"),
                  ),
                ),
              ]
            : address == null
                ? <Widget>[_buildWidget()]
                : <Widget>[
                    getAddressFromCEP(address.cep),
                    getAddressFromCEP(address.street),
                    SizedBox(
                      height: 10,
                    ),
                    getAddressFromFreight(address.neighborhood),
                    getAddressFromCEP(address.city),
                    getAddressFromCEP(address.state),
                  ]);
  }

  Widget _buildWidget() {
    return Container(
      child: Text(
        "Localização não encontrada. Tente novamente.",
        style: alertText,
      ),
    );
  }

  Widget getAddressFromCEP(String inputBoxName) {
    var field = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        readOnly: true,
        style: h6,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );
    return field;
  }

  Widget getAddressFromFreight(String inputBoxName) {
    var field = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          new TextFormField(
            readOnly: true,
            style: h6,
            decoration: new InputDecoration(
              hintText: inputBoxName,
            ),
          ),
          Container(
            alignment: Alignment(-1.0, -1.0),
            child: freight == null
                ? Column(
                    children: <Widget>[
                      Text("Ainda não estamos entregando no seu bairro!",
                          style: inkText),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(4))),
                            color: bgColor,
                            onPressed: () async {
                              String state = address.state;
                              String city = address.city;
                              String neighborhood = address.neighborhood;

                              FreightRequest freightRequest =
                                  await OrdersApi.requestFreight(
                                      state, city, neighborhood);

                              if (freightRequest != null) {
                                showDialog(
                                    context: context,
                                    child: new AlertDialog(
                                      title: Text(
                                        "Solicitação enviada!\nEstado: ${address.state}\nCidade: ${address.city}\nBairro: ${address.neighborhood}\nEstamos trabalhando para expandir nossa entrega, obrigado!",
                                        style: alertText,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            int count = 0;
                                            Navigator.of(context)
                                                .popUntil((_) => count++ >= 2);
                                          },
                                          child: Text(
                                            "ok",
                                            style: h6,
                                          ),
                                        ),
                                      ],
                                    ));
                              } else {
                                alert(context, "Ocorreu um erro.");
                              }
                            },
                            child: Text(
                              "Clique aqui e solicite a entrega",
                              style: inkText,
                            )),
                      )
                    ],
                  )
                : Text(""),
          ),
        ],
      ),
    );
    return field;
  }

  Widget getNumberFromUser(
      String inputBoxName, TextEditingController controller) {
    var field = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        validator: _validaNumber,
        keyboardType: TextInputType.number,
        controller: controller,
        style: priceText,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );
    return field;
  }

  String _validaNumber(text) {
    if (text.isEmpty) {
      return "Campo obrigatório. Caso não tenha número, digite 0.";
    } else
      return null;
  }

  Widget getComplementFromUser(
      String inputBoxName, TextEditingController controller) {
    var field = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: controller,
        style: priceText,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );
    return field;
  }

  Widget saveAddressButton(String buttonLabel) {
    var button = new Container(
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: highlightColor,
        borderRadius: new BorderRadius.all(const Radius.circular(4)),
      ),
      child: new Text(buttonLabel, style: whiteText),
    );
    return button;
  }
}

class DeleteAddressDialog {
  String message;
  Widget deleteDialog(
      BuildContext context, _AddressesState _addressesState, Address address) {
    return new AlertDialog(
      title: Text(
        "Deletar endereço?",
        style: alertText,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancelar",
            style: h6,
          ),
        ),
        FlatButton(
          onPressed: () async {
            message = "";
            await AddressApi.delete(address.id).then((value) {
              if (value == false) {
                message =
                    "Ops! O endereço não pôde ser excluído pois está associado a um pedido";
              }
              return;
            }).catchError((Object error) {
              print(error);
              return;
            });
            Navigator.of(context).pop();
            _addressesState.displayRecord(message);
          },
          child: Text(
            "Deletar",
            style: h6,
          ),
        )
      ],
    );
  }
}
