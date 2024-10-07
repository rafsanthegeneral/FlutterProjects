import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:kimproject/library/notification.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final LocalNotificationService service;
  late DatabaseReference _databaseRef;
  late DatabaseReference _databaseRef2;
  String? _howManyintruder = "0";
  String? _howManyKnown = "0";
  aboutAchivements(num, type) {
    return Row(
      children: [
        Text(
          num,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Soho",
          ),
          textAlign: TextAlign.center,
        ),
        Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              type,
              style: TextStyle(
                fontFamily: "Soho",
              ),
            ))
      ],
    );
  }

  mySpec(icon, text, link, text2, notiHead, notiBody) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(0),
        color: Color(0xff252525),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text2,
                style: const TextStyle(
                    fontSize: 16, fontFamily: "Soho", color: Colors.white),
                textAlign: TextAlign.center,
              ),
              IconButton(
                splashColor: Colors.green,
                iconSize: 50,
                icon: Icon(
                  icon,
                  color: Colors.white,
                ),
                onPressed: () async {
                  // await service.showNotification(
                  //     id: 0, title: notiHead, body: notiBody);

                  Navigator.pushNamed(context, link);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                text,
                style: const TextStyle(
                    fontSize: 16, fontFamily: "Soho", color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      height: 150,
      width: 105,
    );
  }

  notification() {
    service.showNotification(
        id: 0, title: "SuccessFull", body: "Login Succes Full");
  }

  Future<dynamic> notification2(getdate, ids) async {
    await service.showNotification(
        id: ids, title: getdate, body: "intruder Detected");
  }

// This Test Method For Database read once for Notification Show at once in same Page
  test() {
    _databaseRef = FirebaseDatabase.instance.ref('intruder');

    _databaseRef.once().then((DatabaseEvent snapshot) {
      setState(() {
        dynamic data = snapshot.snapshot.value;
        if (data != null) {
          Map<String, dynamic> mapData = Map<String, dynamic>.from(data);
          List<String> keys = mapData.keys.toList();
          _howManyintruder = keys.length.toString();
          for (int i = keys.length - 1; i >= 0;) {
            String key = keys[i];
            String date = data[key]["date"];
            //String image = data[key]["image"];
            //String type = data[key]["type"];
            print("=====>Fuking {$date} ,key => {$key},  i value ==>{$i}");
            notification2(date, i);

            //compute(notification2, date);
            break;
          }
        }
      });
    });
  }

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    notification(); // This is for intruder Detected Notification
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref('intruder');
    _databaseRef2 = FirebaseDatabase.instance.ref('knownperson');

    // that Have to be work
    // _databaseRef.once().then((DatabaseEvent snapshot) {
    //   setState(() {
    //     dynamic data = snapshot.snapshot.value;
    //     if (data != null) {
    //       Map<String, dynamic> mapData = Map<String, dynamic>.from(data);
    //       List<String> keys = mapData.keys.toList();
    //       _howManyintruder = keys.length.toString();
    //       for (int i = keys.length - 1; i >= 0;) {
    //         String key = keys[i];
    //         String date = data[key]["date"];
    //         String image = data[key]["image"];
    //         String type = data[key]["type"];
    //         print("=====>Fuking {$date} ,key => {$key},  i value ==>{$i}");
    //         // notification2(date, i);

    //         //compute(notification2, date);
    //         break;
    //       }
    //     }
    //   });
    // });
    _databaseRef.onValue.listen((event) {
      // null value protection
      if (event.snapshot.value != null) {
        setState(() {
          dynamic data = event.snapshot.value;
          // if (data != null) {
          //   data.forEach((key, value) {
          //     String date = value["date"];
          //     String image = value["image"];
          //     String type = value["type"];
          //   });
          // }
          if (data != null) {
            Map<String, dynamic> mapData = Map<String, dynamic>.from(data);
            List<String> keys = mapData.keys.toList();
            _howManyintruder = keys.length.toString();
            for (int i = keys.length - 1; i >= 0;) {
              String key = keys[i];
              String date = data[key]["date"];
              // String image = data[key]["image"];
              //String type = data[key]["type"];
              print("=====>{$date} ,key => {$key},  i value ==>{$i}");
              //test();
              notification2(date, i);

              //compute(notification2, date);
              break;
            }
          }
        });
      }
    });

    _databaseRef2.onValue.listen((event) {
      // null value protection
      if (event.snapshot.value != null) {
        setState(() {
          dynamic data = event.snapshot.value;
          // if (data != null) {
          //   data.forEach((key, value) {
          //     String date = value["date"];
          //     String image = value["image"];
          //     String type = value["type"];
          //   });
          // }
          if (data != null) {
            Map<String, dynamic> mapData = Map<String, dynamic>.from(data);
            List<String> keys = mapData.keys.toList();
            _howManyKnown = keys.length.toString();
          }
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: PopupMenuButton(
            color: Color.fromARGB(255, 20, 3, 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            icon: Icon(Icons.menu),
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextButton(
                        child: Text(
                          'LogOut',
                          style: TextStyle(
                            color: Color.fromARGB(255, 247, 246, 246),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/logout');
                        }),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: TextButton(
                        child: Text(
                          'About US',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 254, 254)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/about');
                        }),
                    value: 1,
                  )
                ]),
      ),
      body: SlidingSheet(
        //color: scrollSpec.overscrollColor ??
        // Theme.of(context).colorScheme.secondary
        elevation: 8,
        cornerRadius: 50,
        snapSpec: const SnapSpec(
          // Enable snapping. This is true by default.
          snap: true,
          // Set custom snapping points.
          snappings: [0.38, 0.7, 1.0],
          // Define to what the snappings relate to. In this case,
          // the total available space that the sheet can expand to.
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        // The body widget will be displayed under the SlidingSheet
        // and a parallax effect can be applied to it.
        body: Container(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 35),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Image.asset(
                      'images/cctv.png',
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.49),
                child: Column(
                  children: [
                    Text('FaceRecognization Project',
                        style: TextStyle(
                            fontFamily: "Soho",
                            color: Color.fromARGB(255, 8, 8, 8),
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Using CCTV',
                      style: TextStyle(
                          color: Color.fromARGB(255, 10, 8, 8),
                          fontFamily: "Soho",
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        builder: (context, state) {
          // This is the content of the sheet that will get
          // scrolled, if the content is bigger than the available
          // height of the sheet.
          return Container(
            margin: EdgeInsets.only(left: 20, top: 30, right: 20),
            height: 300,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      aboutAchivements('100%', ' Quality'),
                      aboutAchivements('100%', ' Cap intruder'),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Check Our Menu',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Soho",
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          mySpec(
                              FontAwesomeIcons.idCard,
                              'Total Known ',
                              '/knownpersone',
                              _howManyKnown,
                              "UpComing",
                              "Upcoming on Future Update"),
                          mySpec(
                              FontAwesomeIcons.userSecret,
                              "Intruder's",
                              '/unknownperson',
                              _howManyintruder,
                              "Intruder",
                              "Some Intruder Registered"),
                          // mySpec(FontAwesomeIcons.flag, 'AboutUS', '/aboutus',
                          //     '100'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
