
// import 'package:flutter/material.dart';
// import 'package:multi_check_dropdown_search/multi_check_dropdown_search.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: Text("Multi-Check Dropdown Example")),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ExampleScreen(),
//         ),
//       ),
//     );
//   }
// }

// class ExampleScreen extends StatefulWidget {
//   @override
//   _ExampleScreenState createState() => _ExampleScreenState();
// }

// class _ExampleScreenState extends State<ExampleScreen> {
//   List<Map<String, dynamic>> items = [
//     {"id": 1, "label": "Option 1"},
//     {"id": 2, "label": "Option 2"},
//     {"id": 3, "label": "Option 3"},
//     {"id": 4, "label": "Option 4"},
//   ];

//   List<Map<String, dynamic>> selectedItems = [];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Select Items:", style: TextStyle(fontSize: 16)),
//         SizedBox(height: 10),
//         MultiSelectDropdown(
//           items: items,
//           onSelectionChanged: (selected) {
//             setState(() {
//               selectedItems = selected;
//             });
//           },
//           dropdownTextstyle: TextStyle(color: Colors.black),
//           backgroundColor: Colors.white,
//           hinttext: "Select options",
//         ),
//         SizedBox(height: 20),
//         Text(
//           "Selected: ${selectedItems.map((e) => e['label']).join(", ")}",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }
