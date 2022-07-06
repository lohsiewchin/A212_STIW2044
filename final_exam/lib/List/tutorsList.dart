import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/tutors.dart';

class tutorsList extends StatefulWidget {
  @override
  State<tutorsList> createState() => _tutorsListState();
}

class _tutorsListState extends State<tutorsList> {
  List <Tutor> tutorList = <Tutor>[];
  String search = "";
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var _tapPosition;
  var numofpage, curpage = 1;
  var color;
  
 @override
  void initState() {
    super.initState();
    _loadTutors(1, search);
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
        title: const Text('Tutors'),
      ),
      body: tutorList.isEmpty
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
            children: List.generate(tutorList.length, (index) {
              return InkWell(
                splashColor: Colors.amber,
                onTap: () => {_loadTutorDetails(index)},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // if you need this
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                      ),),
                  color: Colors.green[50],
                  child: Column(
                    children: [
                      Flexible(
                        flex: 5,
                        child: CachedNetworkImage(
                          imageUrl: CONSTANTS.server + "/MYTutor/users/assets/tutors/" + 
                          tutorList[index].tutor_id.toString() + '.jpg',

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
                              tutorList[index].tutor_name.toString(),
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                            ),
                            Text(
                              "Phone: " + tutorList[index].tutor_phone.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              "Email: " + tutorList[index].tutor_email.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ))
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
                    color = Colors.greenAccent[700];
                    } else {
                      color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                          onPressed: () => {_loadTutors(index + 1, "")},
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

  void _loadTutors(int pageno, String _search) {
     curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/MYTutor/users/php/tutors.php"),
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

        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
        } else {
          titlecenter = "No Tutor Available";
        }
        setState(() {});
      }else{
        //do something
      }
    });
  }

  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                          imageUrl: CONSTANTS.server + "/MYTutor/users/assets/tutors/" + 
                          tutorList[index].tutor_id.toString() + '.jpg',

                          width: resWidth,

                          placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                            const Icon(Icons.error)

                        ),

                Text(
                  tutorList[index].tutor_name.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Text("Tutor ID: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Text(
                        tutorList[index].tutor_id.toString()
                        ),
                    ],
                  ),

                  const Text(
                    "\nTutor Description: ",
                    style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                  Text(
                    tutorList[index].tutor_description.toString()
                    ),

                  const Text(
                    "\nPhone: ",
                    style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                  Text(
                    tutorList[index].tutor_phone.toString()
                    ),
                  
                  const Text(
                    "\nEmail: ",
                    style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                  Text(
                    tutorList[index].tutor_email.toString()
                    ),

                  const Text(
                    "\nSubject Owned: ",
                    style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                  Text(
                    tutorList[index].subject_owned.toString()
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
}