import 'package:shoppingmobile/datas/category.dart';
import 'package:shoppingmobile/datas/productList.dart';
import 'package:shoppingmobile/datas/products.dart';
import 'package:shoppingmobile/screens/ProductPage.dart';
import 'package:shoppingmobile/services/product_api.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import 'package:shoppingmobile/widgets/sizes_helpers.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:shoppingmobile/widgets/config.dart';
import 'package:flutter/material.dart';

class ProductsByCategory extends StatelessWidget {
  final Category _category;
  ProductList _productList;
  ProductsByCategory(this._category);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            _category.name,
            style: z4,
            textAlign: TextAlign.center,
          ),
        ),
        body: FutureBuilder<ProductList>(
            future:
                ProductApi.getProductsByCategory(_category.id, _productList),
            builder: (context, snapshots) {
              if (snapshots.hasError)
                return Text(
                  "Ocorreu um erro",
                  style: alertText,
                );
              switch (snapshots.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (!snapshots.hasData ||
                      snapshots.data.products == null ||
                      snapshots.data.products.isEmpty) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            "Não há produtos nesta categoria",
                            style: alertText,
                          ),
                        ),
                        SizedBox(height: 100),
                        Center(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: highlightColor,
                            padding: EdgeInsets.all(13),
                            shape: CircleBorder(),
                            child: Text(
                              "voltar",
                              style: whiteText,
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return ProductListByCategory(_category, snapshots.data);
                  }
              }
            }));
  }
}

class ProductListByCategory extends StatefulWidget {
  final Category _category;
  final ProductList _productList;
  ProductListByCategory(this._category, this._productList);

  @override
  _ProductListByCategoryState createState() =>
      _ProductListByCategoryState(this._category, this._productList);
}

class _ProductListByCategoryState extends State<ProductListByCategory> {
  ProductList _productList;
  final Category _category;
  _ProductListByCategoryState(this._category, this._productList);
  ScrollController _scrollController = new ScrollController();
  String message = "";

  void _getMoreData() async {
    if (!_productList.isLoading) {
      setState(() {
        _productList.isLoading = true;
      });

      ProductApi.getProductsByCategory(_category.id, _productList)
          .then((onValue) {
        setState(() {
          _productList.isLoading = false;
          _productList = onValue;
        });
      });
    }
  }

  @override
  void initState() {
    if (_productList == null) {
      this._getMoreData();
    }

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          message = "Não há mais produtos";
        });
      }
    });
  }

  Widget _buildProgressIndicator(bool isLoading) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              height: SizeConfig.blockSizeVertical * 80,
              child: GridView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.80),
                itemCount: _productList.products.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == _productList.products.length) {
                    return _buildProgressIndicator(_productList.isLoading);
                  } else {
                    return _buildProducts(_productList.products[index]);
                  }
                },
              ))
        ]);
  }

  Widget _buildProducts(Product product) {
    return Column(
      children: <Widget>[
        allProductsByCat(
            product.name,
            Environment.URL_IMAGE_PRODUCTS + product.image.toString(),
            product.price, onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return new ProductPage(product: product);
              },
            ),
          );
        })
      ],
    );
  }

  Widget allProductsByCat(String name, String image, double price,
      {onPressed}) {
    return Expanded(
      //margin: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              width: 200,
              height: 150,
              child: RaisedButton(
                padding: EdgeInsets.all(5),
                color: highlightColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 30,
                onPressed: onPressed,
                child: Image.network(
                  image,
                  width: 150,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
              )),
          Text(
            name,
            style: foodNameText,
            textAlign: TextAlign.center,
          ),
          Text("R\$${price.toStringAsFixed(2)}", style: priceText),
        ],
      ),
    );
  }
}
