import 'dart:convert';

import 'package:cd_project/screen/tableScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classDetails.dart';
import '../services.dart';

class EditScreen extends StatefulWidget {
 classDetails details ;
 String regno;

  EditScreen({Key? key,required this.details,required this.regno}) : super(key: key);
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  classDetails detail = new classDetails(regNo: "", course: "", stream: "", year: "", name: "") ;
  List<classDetails> det = [];
  get session => null;
  void initState() {
    // TODO: implement initState
    detail = widget.details;
    super.initState();
  }
  Future<void> getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Session session = new Session();
    print(widget.regno);
    Map body = {
      "regno" : widget.regno
    };
    var m = jsonEncode(body);
    Response r = await session.post(m, "/displaystudents");
    var bodyjson = jsonDecode(r.body);
    var body1 = bodyjson['details'];
    for(int i=0;i<body1.length;i++)
    {
      classDetails t =  new classDetails(regNo: body1[i]["regno"], name: body1[i]["name"], stream: body1[i]["stream"], year: body1[i]["year"],course: body1[i]["course"]);
      det.add(t);
    }
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff30475E),
        title: Text("Edit Details"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 350,
                child: TextField(
                  controller: TextEditingController(text: detail.name),
                  keyboardType: TextInputType.name,
                  onChanged: (String val)=>{
                    detail.name = val
                  },

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    labelText: "name",

                    labelStyle:
                    TextStyle(color: Color.fromARGB(255, 78, 50, 50), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
          ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 350,

                child: TextField(controller: TextEditingController(text: detail.regNo),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onChanged: (String val)=>{
                    detail.regNo = val
                  },
                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    labelText: "Registration Number",
                    labelStyle:
                    TextStyle(color: Color.fromARGB(255, 78, 50, 50), fontSize: 14, fontWeight: FontWeight.w400),
                  ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 350,

                child:TextField(controller: TextEditingController(text: detail.year),

                keyboardType: TextInputType.number,
                onChanged: (String val)=>{
                  detail.year = val
                },
                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  labelText: "Year",
                  labelStyle:
                  TextStyle(color: Color.fromARGB(255, 78, 50, 50), fontSize: 14, fontWeight: FontWeight.w400),
                ),),),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 350,

                child: TextField(controller: TextEditingController(text: detail.stream),

                  keyboardType: TextInputType.name,
                  onChanged: (String val)=>{
                    detail.stream = val
                  },
                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),

                    focusedBorder: OutlineInputBorder(

                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    labelText: "Stream",
                    labelStyle:
                    TextStyle(color: Color.fromARGB(255, 78, 50, 50), fontSize: 14, fontWeight: FontWeight.w400),
                  ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 350,


                child : TextField(controller: TextEditingController(text: detail.course),

                keyboardType: TextInputType.name,
                onChanged: (String val)=>{
                  detail.course = val
                },
                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  labelText: "Course",
                  labelStyle:
                  TextStyle(color: Color.fromARGB(255, 78, 50, 50), fontSize: 14, fontWeight: FontWeight.w400),
                ),


              ),
              ),
            ),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:Color(0xff30475E),
              ), onPressed: () async {
                Session session = new Session();

               Map body = {
                 'regno' : detail.regNo.toString(),
                 'course' : detail.course.toString(),
                 'stream' : detail.stream.toString(),
                 'year' : detail.year.toString(),
                 'name' : detail.name.toString()
               };

               var m = jsonEncode(body);

              Response r = await session.post(m, "/updatedetails");

              if(r.statusCode==200) {
                await getDetails();
                Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => TableScreen(
                                detail: det,
                                regno: widget.regno,
                              )),
                      (Route<dynamic> route) => false);
                }
              },
              child: Text("Submit"),
            ),
          )
        ],
      ),
    );
  }
}
