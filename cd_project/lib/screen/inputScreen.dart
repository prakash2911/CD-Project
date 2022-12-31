import 'dart:convert';

import 'package:cd_project/screen/tableScreen.dart';
import 'package:cd_project/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classDetails.dart';

class InputDetails extends StatefulWidget {
  const InputDetails({Key? key}) : super(key: key);
  @override
  State<InputDetails> createState() => _InputDetailsState();
}

class _InputDetailsState extends State<InputDetails> {
  String? year;
  List<classDetails> details = [];
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff30475E),
        title: Text("Fetch Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(40),
              child: SizedBox(
                width: 300,
                child: TextField(
                autofocus: true,
                  keyboardType: TextInputType.number,
                  autocorrect: false,

                  decoration: InputDecoration(
                    label: Text("Register Number"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person,color: Color(0xff30475E),),
                  ),
                  onChanged: (String val){
                    setState(() {
                      if(val!=Null) {
                        year = val;
                      }
                    });
                  },
                ),
              ),
            ),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xff30475E),
                ), onPressed: () async {

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("regno", year!);

                Session session = new Session();
                Map body = {"regno" : year };

                var m = jsonEncode(body);

                Response r = await session.post(m, "/displaystudents");
                print(r.body);
                var bodyjson = jsonDecode(r.body);
                if(bodyjson['status']=="true") {
                  var body1 = bodyjson["details"];
                  for (int i = 0; i < body1.length; i++) {
                    classDetails t = new classDetails(regNo: body1[i]["regno"],
                        name: body1[i]["name"],
                        stream: body1[i]["stream"],
                        year: body1[i]["year"],
                        course: body1[i]["course"]);
                    details.add(t);
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              TableScreen(detail: details, regno: year!,)),
                          (Route<dynamic> route) => false);
                }
                else{
                  EasyLoading.showToast("Invalid Register Number",duration: Duration(milliseconds: 400),dismissOnTap: true,toastPosition: EasyLoadingToastPosition.center);
                }
              },
              child: Text("Submit"),
              ),
            )
          ],
        ),
      ),


    );
  }
}
