import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/subjects.dart';
import 'package:cached_network_image/cached_network_image.dart';

class subjectsList extends StatefulWidget {
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
          )
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
                            Text(
                              subjectList[index].subject_name.toString(),
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                            ),
                            Text(
                              "RM " + double.parse(subjectList[index].subject_price.toString()).toStringAsFixed(2),
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              subjectList[index].subject_sessions.toString() + " sessions",
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              "Rating: " + subjectList[index].subject_rating.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
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
}