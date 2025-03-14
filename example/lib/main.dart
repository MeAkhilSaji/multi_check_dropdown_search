import 'package:flutter/material.dart';
import 'package:multi_check_dropdown_search/multi_check_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DropdownExampleScreen(),
    );
  }
}

class DropdownExampleScreen extends StatefulWidget {
  @override
  _DropdownExampleScreenState createState() => _DropdownExampleScreenState();
}

class _DropdownExampleScreenState extends State<DropdownExampleScreen> {
  List<Map<String, dynamic>> selectedItems = [];

  final List<Map<String, dynamic>> dropdownItems = [
    {"alias": "Option 1", "value": 1},
    {"alias": "Option 2", "value": 2},
    {"alias": "Option 3", "value": 3},
    {"alias": "Option 4", "value": 4},
    {"alias": "Option 5", "value": 5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MultiSelect Dropdown Example")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: MultiCheckDropdown(
              backgroundColor: Color(0xff555555),
              width: 200,
              height: 40,
              noResultMessageStyle: TextStyle(
                color: Colors.white,
              ),
              hintTextStyle: TextStyle(color: Colors.white, fontSize: 10),
              activeCheckColor: Colors.green,
              alias: "alias", // Column name to display
              fieldKey: "alias", // Key used for selection
              initialSelectedItems: selectedItems,

              items: List.from(
                  dropdownItems), // Pass a copy to avoid modifying original

              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedItems = selectedList;
                });
                print("Selected Items: $selectedList");
              },
              dropdownTextstyle: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Selected items array : " + selectedItems.toString())
        ],
      ),
    );
  }
}
