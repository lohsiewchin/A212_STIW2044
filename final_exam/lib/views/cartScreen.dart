import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/cart.dart';
import '../models/reg.dart';
import 'paymentScreen.dart';

class cartScreen extends StatefulWidget {

  final Registration reg;
  const cartScreen({Key? key, required this.reg}) : super(key: key);

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  List<Cart> cartList = <Cart>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  double totalpayable = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
        ),
        body: cartList.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Text(titlecenter,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Expanded(
                        child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio: (1 / 1),
                            children: List.generate(cartList.length, (index) {
                              return InkWell(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1,
                                  ),),
                                  color: Colors.orange[50],
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/MYTutor/users/assets/courses/" +
                                          cartList[index].subject_id.toString() +
                                          '.png',
                                      
                                     height: screenHeight,
                                     width: resWidth,
                                     
                                     placeholder: (context, url) =>
                                     const CircularProgressIndicator(),
                                     errorWidget: (context, url, error) =>
                                     const Icon(Icons.error)
                                    ),
                                  ),
                    
            Flexible(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    children:[
                      Expanded(
                        flex: 7,
                        child: Column(children: [
                          Text(
                            cartList[index].subject_name.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Price: RM " +
                                double.parse(cartList[index].subject_price
                                .toString()).toStringAsFixed(2),
                                style: const TextStyle(fontSize: 13,)
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Total Price: RM " +
                                  double.parse(cartList[index].price_total
                                  .toString()).toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _updateCart(index, "-");
                                            },
                                            child: const Text("-")),
                                            Text(cartList[index].cart_qty
                                            .toString()),
                                            TextButton(
                                              onPressed: () {
                                                _updateCart(index, "+");
                                                },
                                                child: const Text("+")),
                                      ],
                                    ),
                                ],),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 3,
                            child: IconButton(
                              onPressed: () {
                                _deleteItem(index);
                                },
                                icon: const Icon(Icons.delete))),
                        ],
                      )
                    )         
                                           
                  ])));
                  }))),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Payable: RM " +
                            totalpayable.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: _onPaynowDialog,
                            child: const Text("Checkout"))
                          ],
                        ),
                      ),
                    )
                  ],
                )));
  }

  void _loadCart() {
     http.post(
        Uri.parse(CONSTANTS.server + "/MYTutor/users/php/load_cart.php"),
        body: {
          'email': widget.reg.email,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['cart'] != null) {
          cartList = <Cart>[];
          extractdata['cart'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
          int qty = 0;
          totalpayable = 0.00;
          for (var element in cartList) {
            qty = qty + int.parse(element.cart_qty.toString());
            totalpayable =
                totalpayable + double.parse(element.price_total.toString());
          }
          titlecenter = qty.toString() + " Products in your cart";
          setState(() {});
        }
      } else {
        titlecenter = "Your Cart is Empty 😞 ";
        cartList.clear();
        setState(() {});
      }
    });
  }

  void _updateCart(int index, String s) {
    if (s == "-") {
      if (int.parse(cartList[index].cart_qty.toString()) == 1) {
        _deleteItem(index);
      }
    }
    http.post(
        Uri.parse(CONSTANTS.server + "/MYTutor/users/php/update_cart.php"),
        body: {'cart_id': cartList[index].cart_id, 'operation': s}).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _deleteItem(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/MYTutor/users/php/delete_cart.php"),
        body: {
          'email': widget.reg.email,
          'cart_id': cartList[index].cart_id
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Delete Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Delete Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _onPaynowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Checkout",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => paymentScreen(
                            reg: widget.reg,
                            totalpayable: totalpayable)));
                _loadCart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}