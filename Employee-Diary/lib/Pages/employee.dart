import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crud_project/services/database.dart';
import 'package:random_string/random_string.dart';

class Employee extends StatefulWidget {
  final String userId;

  const Employee({Key? key, required this.userId}) : super(key: key);

  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Employee Form",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name (max 20 characters)',
              ),
              maxLength: 20,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Only allows alphabets and spaces
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Age",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter age (0-100)',
              ),
              maxLength: 3,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 20),
            Text(
              "Location",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter location',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addEmployee();
                },
                child: Text(
                  "ADD",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addEmployee() async {
    String id = randomAlphaNumeric(10);
    String name = nameController.text.trim();
    String age = ageController.text.trim();
    String location = locationController.text.trim();

    // Validate inputs
    if (name.isEmpty || age.isEmpty || location.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    int? ageValue = int.tryParse(age);
    if (ageValue == null || ageValue < 0 || ageValue > 100) {
      Fluttertoast.showToast(
        msg: "Please enter a valid age (0-100)",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Add employee details to Firestore
    Map<String, dynamic> employeeInfoMap = {
      "Name": name,
      "Age": ageValue,
      "location": location,
      "userId": widget.userId, // Include userId in employee data
    };

    try {
      await DatabaseMethods().addEmployeeDetails(employeeInfoMap, id);
      Fluttertoast.showToast(
        msg: "Employee details added successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Clear text fields after successful addition
      nameController.clear();
      ageController.clear();
      locationController.clear();
      Navigator.pop(context); // Return to previous screen (Home) after adding
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to add employee details. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
