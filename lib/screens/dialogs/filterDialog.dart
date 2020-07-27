import 'package:facial_capture/models/filter.dart';
import 'package:flutter/material.dart'; 

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _array; 
  String _filter; 
  String _sort;

  @override
  void initState() {
    _array = '1';
    _filter = 'temperature';
    _sort  = 'ascending'; 
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
       body: Container(
         padding: EdgeInsets.all(20),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          IconButton(
            icon: Icon(Icons.close),
            iconSize: 30,
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context, new Filter(array: null, filter: null, sort: null)); 
            },
          ),
          SizedBox(height: 20,),
           Text(
             'Filter And Sort',
             style: TextStyle(
               fontSize: 50,
               fontWeight: FontWeight.bold,
               letterSpacing: 1.5
             ),
           ),
           SizedBox(height: 20,),
           Text(
             'View',
             style: TextStyle(
               fontSize: 30,
               fontWeight: FontWeight.bold,
               letterSpacing: 1
             ),
           ),
             RadioListTile(
              title: const Text('Array 1'),
              value: "1",
              activeColor: Colors.blue,
              groupValue: _array,
              onChanged: (value) {
                setState(() {
                  _array = value;
                });
              },
            ),
             RadioListTile(
              title: const Text('Array 2'),
              value: "2",
              activeColor: Colors.blue,
              groupValue: _array,
              onChanged: (value) {
                setState(() {
                  _array = value;
                });
              },
            ),
            RadioListTile(
              title: const Text('Default'),
              value: "default",
              activeColor: Colors.blue,
              groupValue: _array,
              onChanged: (value) {
                setState(() {
                  _array = value;
                });
              },
            ), 
            SizedBox(height: 15,),
            const Divider(
              color: Colors.grey,
              // height: 20,
              indent: 20,
              endIndent: 20,
              thickness: 1,
            ),
            SizedBox(height: 15,),
          Text(
             'Filter',
             style: TextStyle(
               fontSize: 30,
               fontWeight: FontWeight.bold,
               letterSpacing: 1
             ),
           ),
           RadioListTile(
              title: const Text('Temperature'),
              value: "temperature",
              activeColor: Colors.blue,
              groupValue: _filter,
              onChanged: (value) {
                setState(() {
                  _filter = value;
                });
              },
            ),
            RadioListTile(
              title: const Text('Datetime'),
              value: "datetime",
              activeColor: Colors.blue,
              groupValue: _filter,
              onChanged: (value) {
                setState(() {
                  _filter = value;
                });
              },
            ),
              SizedBox(height: 15,),
            const Divider(
              color: Colors.grey,
              // height: 20,
              indent: 20,
              endIndent: 20,
              thickness: 1,
            ),
            SizedBox(height: 15,),
            Text(
             'Sort',
             style: TextStyle(
               fontSize: 30,
               fontWeight: FontWeight.bold,
               letterSpacing: 1
             ),
           ),
             RadioListTile(
              title: const Text('Ascending'),
              value: "ascending",
              activeColor: Colors.blue,
              groupValue: _sort,
              onChanged: (value) {
                setState(() {
                  _sort = value;
                });
              },
            ),
              RadioListTile(
              title: const Text('Descending'),
              value: "descending",
              activeColor: Colors.blue,
              groupValue: _sort,
              onChanged: (value) {
                setState(() {
                  _sort = value;
                });
              },
            ),
            SizedBox(height: 100,),
             Center(
               child: Container(
                 width: 600,
                 height: 40,
                 child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    Navigator.pop(context, new Filter(array: _array, filter: _filter, sort: _sort)); 
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Apply",
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                    )),
            ),
               ),
             ),
          ],
         ),
       ),
    );
  }
}