import 'package:shoppingmobile/datas/category.dart';
import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/screens/ProductsByCategory.dart';
import 'package:shoppingmobile/services/category_api.dart';
import 'package:shoppingmobile/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmobile/widgets/config.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';
import 'package:shoppingmobile/widgets/colors.dart';
import 'package:shoppingmobile/widgets/styles.dart';
import 'package:shoppingmobile/widgets/sizes_helpers.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Future<List<Category>> _getCategories;

  @override
  void initState() {
    super.initState();
    checkUserSession();
    _getCategories = CategoryApi.getCategories();
  }

  checkUserSession() async {
    String token = await Login.getToken();
    bool isTokenExpired = await Login.isTokenExpired();
    if (token == null || isTokenExpired) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(),
      body: Container(
        child: headerTopCategories(),
      ),
    );
  }

  Widget headerTopCategories() {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            sectionHeader('Categorias', onViewMore: () {}),
            SizedBox(
                height: SizeConfig.blockSizeVertical * 80,
                child: FutureBuilder(
                    future: _getCategories,
                    builder: (context, catList) {
                      if (catList.data != null) {
                        return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 0.99),
                          itemCount: catList.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                headerCategoryItem(
                                    catList.data[index].name,
                                    Environment.URL_IMAGE_CATEGORIES +
                                        catList.data[index].image.toString(),
                                    onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return new ProductsByCategory(
                                            catList.data[index]);
                                      },
                                    ),
                                  );
                                })
                              ],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
          ]),
    );
  }

  Widget sectionHeader(String headerTitle, {onViewMore}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 15, top: 10),
            child: Text(headerTitle, style: h4),
          ),
        ),
      ],
    );
  }

  Widget headerCategoryItem(String name, String image, {onPressed}) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              width: 100,
              height: 100,
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
            name + ' ›',
            style: categoryText,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
