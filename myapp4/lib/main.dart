import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'shopitem.dart';
import 'helloWord.dart';
import 'animatedList.dart';
import 'demo.dart';
import 'callNative.dart';
import 'dart:async';

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.products}) : super(key: key);

  final List<Product> products;
  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework will re-use the State object
  // instead of creating a new State object.

  @override
  _ShoppingListState createState() => new _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = new Set<Product>();
  BuildContext scaffoldContext;
  void _handleCartChanged(Product product, bool inCart) {
    /*
    setState(() {
      if (inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
    */
    setState(() {
      
    });
    int actid = product.actId;
    print("clicked item: " + actid.toString());
    switch (actid) {
      case 0:{ //演示一个HelloWorld
        MaterialPageRoute r = new MaterialPageRoute(builder: (context) => new MyApp());
        Navigator.push(context, r);
        break;
      }
      case 1:{ //演示一个HelloWorld
        MaterialPageRoute r = new MaterialPageRoute(builder: (context) => new HelloWorld());
        Navigator.push(context, r);
        break;
      }
      case 2:{ //一个动画
        MaterialPageRoute r = new MaterialPageRoute(builder: (context) => new AnimatedListSample());
        Navigator.push(context, r);
        break;
      }
      case 3:{ // Flutter调用本地
        MaterialPageRoute r = new MaterialPageRoute(builder: (context) => new MyBatteryHomePage());
        Navigator.push(context, r);
        break;
      }
      case 4:{ // 本地调用Flutter
        print('registNativeCall');
        MethodChannel channel = MethodChannel('samples.flutter.io/battery');
        channel.setMethodCallHandler(_platformCallHandler);
        break;
      }
      case 5:{ // 本地调用Flutter
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text("showdialog"),
            );
          }
        );
        break;
      }
      default:
    }
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "getName":
      return "Hello from Flutter";
      break;
    }
  }
  @override
  Widget build(BuildContext context) {

    scaffoldContext = context;

    Scaffold s = Scaffold(
      appBar: new AppBar(
        title: new Text('Shopping List'),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return new ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
    
    return s;
  }
}


void main() {
  runApp(new MaterialApp(
    title: 'Sh App',
    home: new ShoppingList(
      products: <Product>[
        new Product(name: 'GuideDemo', actId: 0),
        new Product(name: 'HelloWorld', actId: 1),
        new Product(name: 'AnimatedList', actId: 2),
        new Product(name: 'FlutterCallNative', actId: 3),
        new Product(name: 'NativeCallFlutter', actId: 4),
        new Product(name: 'ShowDialog', actId: 5),
      ],
    ),
  ));
}

