import 'package:flutter/material.dart';

class Subject extends StatelessWidget {
  String _name;
  String _code;
  List _absentDates;
  List _presentDates;
  Subject(this._name,this._code,this._absentDates,this._presentDates);

  Subject.map(dynamic obj) {
    this._name = obj["name"];
    this._code = obj['code'];
    this._presentDates = obj['presentDates'];
    this._absentDates = obj['absentDates'];
  }

  String get name => _name;
  String get code => _code;
  List get absentDates => _absentDates;
  List get presentDates => _presentDates;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = _name;
    map['code'] = _code;
    map['absentDates'] = _absentDates;
    map['presentDates'] = _presentDates;
    return map;
  }

  Subject.fromMap(Map<dynamic, dynamic> map) {
    this._name = map["name"];
    this._absentDates = map['absentDates'];
    this._code = map['code'];
    this._presentDates = map['presentDates'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _name,
                style: TextStyle(
                    fontSize: 16.9,
                    fontWeight: FontWeight.bold,),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  "85% attandence",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}