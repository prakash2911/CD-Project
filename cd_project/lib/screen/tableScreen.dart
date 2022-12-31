import 'dart:convert';

import 'package:cd_project/screen/editScreen.dart';
import 'package:cd_project/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classDetails.dart';
class TableScreen extends StatefulWidget {
  List<classDetails> detail;
  String regno;
  TableScreen({Key? key,required this.detail,required this.regno}) : super(key: key);

  @override
  State<TableScreen> createState() => _TableScreenState();

}

class _TableScreenState extends State<TableScreen> {
  int? sortColumnIndex;
  bool isAscending = false;
  List<classDetails> details = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
     details = widget.detail;
    });
  }
  @override

  Future<void> getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Session session = new Session();
    details.clear();
    Map body = {
      "regno" : widget.regno
    };
    var m = jsonEncode(body);
    Response r = await session.post(m, "/displaystudents");

    var bodyjson = jsonDecode(r.body);
    var body1 = bodyjson["details"];
    for(int i=0;i<body1.length;i++)
    {
      classDetails t =  new classDetails(regNo: body1[i]["regno"], name: body1[i]["name"], stream: body1[i]["stream"], year: body1[i]["year"],course: body1[i]["course"]);
      details.add(t);
    }
  }


  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Student Details"),
        backgroundColor: Color(0xff181D31),
        actions: [
          IconButton(
              onPressed: () async {
                await getDetails();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () async {
            await getDetails();
          });
        },child:Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("asset/bg/admin-bg.jpg"),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 12,
            ),
            SingleChildScrollView(physics:AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child:buildDataTable(),)),
          ],
        ),
      ),


      ),
    );
  }
  Widget buildDataTable() {
    final columns = ['Reg No', 'Name' ,'Year' ,'Course','Stream'];
    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(details),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(

    label: Text(column),
    onSort: onSort,
  ))
      .toList();

  List<DataRow> getRows(List<classDetails> complaints) => complaints.map((classDetails complaint) {
    final cells = [complaint.regNo,complaint.name ,complaint.year,complaint.course ,complaint.stream];

    return DataRow(cells: getCells(cells),onLongPress: ()=>{Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
    builder: (context) => EditScreen(details: complaint,regno: widget.regno,)),
    (Route<dynamic> route) => false)});
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      details.sort((user1, user2) =>
          compareString(ascending, user1.regNo, user2.regNo));
    }
    else if(columnIndex == 1)
      details.sort((user1,user2)=> compareString(ascending, user1.name, user2.name));

    else if (columnIndex == 2) {
      details.sort((user1, user2) =>
          compareString(ascending, '${user1.year}', '${user2.year}'));
    }
    else if (columnIndex == 3) {
      details.sort((user1, user2) =>
          compareString(ascending, '${user1.course}', '${user2.course}'));
    }
    else if (columnIndex == 4) {
      details.sort((user1, user2) =>
          compareString(ascending, user1.stream, user2.stream));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);


}


