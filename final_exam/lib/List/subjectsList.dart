import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/reg.dart';
import '../models/subjects.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../views/cartScreen.dart';

class subjectsList extends StatefulWidget {
  final Registration reg;
  const subjectsList({Key? key, required this.reg}) : super(key: key);

  @override
  State<subjectsList> createState() => _subjectsListState();
}

class _subjectsListState extends State<subjectsList> {
  
  List <Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var _tapPosition;
  var numofpage, curpage = 1;
  var color;
  int cart = 0;

  TextEditingController searchController = TextEditingController();
  String search = "";
  
 @override
  void initState() {
    super.initState();
    _loadSubjects(1, search);
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
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => cartScreen(reg : widget.reg)));
                _loadSubjects(1, search);
                _loadMyCart();
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.reg.cart.toString(),
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: subjectList.isEmpty
      ? Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Center(
              child: Text(titlecenter,
              style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      )
      : Column(children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 1,
            childAspectRatio: (1 / 1),
            children: List.generate(subjectList.length, (index) {
              return InkWell(
                splashColor: Colors.amber,
                onTap: () => {_loadSubjectDetails(index)},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // if you need this
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                      ),),
                  color: Colors.blue[50],
                  child: Column(
                    children: [
                      Flexible(
                        flex: 5,
                        child: CachedNetworkImage(
                          imageUrl: CONSTANTS.server + "/MYTutor/users/assets/courses/" + 
                          subjectList[index].subject_id.toString() + '.png',

                          height: screenHeight,
                          width: resWidth,

                          placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                            const Icon(Icons.error)
                        ),),
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
                                      subjectList[index].subject_name.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                    ),
                                    Text(
                                        "RM " + double.parse(subjectList[index].subject_price.toString()).toStringAsFixed(2),
                                        style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                        subjectList[index].subject_sessions.toString() + " sessions",
                                        style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                        "Rating: " + subjectList[index].subject_rating.toString(),
                                        style: const TextStyle(fontSize: 16),
                                    ),  
                                  ]),
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 3,
                              child: IconButton(
                                onPressed: () {
                                  _addtoCartDialog(index);
                                },
                                icon: const Icon(Icons.shopping_cart))),
                          ],
                        )
                      )
                    ],
                  )),
              );
            }))),

            SizedBox(
              height: 30,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: numofpage,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if ((curpage - 1) == index) {
                    color = Colors.blueAccent[700];
                    } else {
                      color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                          onPressed: () => {_loadSubjects(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
            );
                },
              ),
            ),
          ]),
  );
  }

  void _loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/MYTutor/users/php/subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
        }
        setState(() {});
      }else{
        //do something
      }
    });
  }

  _loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subject Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                          imageUrl: CONSTANTS.server + "/MYTutor/users/assets/courses/" + 
                          subjectList[index].subject_id.toString() + '.png',

                          width: resWidth,

                          placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                            const Icon(Icons.error)

                        ),
                
                Text(
                  subjectList[index].subject_name.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("\nSubject Description: ",
                      style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                  Text(
                      subjectList[index].subject_description.toString()
                      ),

                  const Text("\nPrice: " ,
                      style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                  Text("RM " +
                      double.parse(subjectList[index].subject_price.toString()).toStringAsFixed(2),
                      ),

                  const Text("\nRating: " ,
                      style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                  Text(
                    subjectList[index].subject_rating.toString(),
                      ),

                 const Text("\nSubject Sessions: " ,
                      style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                  Text(
                    subjectList[index].subject_sessions.toString()+ " sessions"
                      ),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              SizedBox(
                width: screenWidth / 1,
                child: ElevatedButton(
                  onPressed: () {
                    _addtoCartDialog(index);
                  },
                  child: const Text("Add to cart"))),
            ],
          );
        });
  }

  void _loadSearchDialog() {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              labelText: 'Search',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  void _loadMyCart() {
    http.post(
          Uri.parse(
              CONSTANTS.server + "/MYTutor/users/php/load_mycartqty.php"),
          body: {
            "email": widget.reg.email.toString(),
          }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      ).then((response) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          print(jsondata['data']['carttotal'].toString());
          setState(() {
            widget.reg.cart = jsondata['data']['carttotal'].toString();
          });
        }
      });
  }

  void _addtoCart(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/MYTutor/users/php/insert_cart.php"),
        body: {
          "email": widget.reg.email.toString(),
          "subject_id": subjectList[index].subject_id.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.reg.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Added Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _addtoCartDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Add to cart",
            ),
            content: const Text(
                "Are you sure you want to add the subject to your cart?"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _addtoCart(index);
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}