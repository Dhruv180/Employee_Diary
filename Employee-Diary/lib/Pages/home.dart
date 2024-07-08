import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_project/Pages/employee.dart';
import 'package:crud_project/Services/authentication.dart'; // Import your authentication service

class Home extends StatefulWidget {
  final String userId;

  const Home({Key? key, required this.userId}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot> employeeStream;

  @override
  void initState() {
    super.initState();
    getEmployeeDetails();
  }

  void getEmployeeDetails() {
    // Update the stream to fetch employees for the current user
    employeeStream = FirebaseFirestore.instance
        .collection('employees')
        .where('userId', isEqualTo: widget.userId)
        .snapshots();
  }

  void logout() async {
    try {
      await AuthMethod().signOut(); // Call your signOut method from authentication service
      Navigator.pushReplacementNamed(context, '/login'); // Replace with your login route
    } catch (e) {
      print("Error signing out: $e");
      // Handle error signing out
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Employee page to add a new employee
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Employee(userId: widget.userId)),
          ).then((_) => getEmployeeDetails()); // Refresh employee list after adding
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "EMPLOYEE",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "  DETAILS",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder(
          stream: employeeStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No Employees found",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return EmployeeCard(
                  documentSnapshot: ds,
                  refreshEmployees: getEmployeeDetails,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final VoidCallback refreshEmployees;

  const EmployeeCard({
    Key? key,
    required this.documentSnapshot,
    required this.refreshEmployees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text("Name: ${documentSnapshot["Name"]}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Age: ${documentSnapshot["Age"]}"),
            Text("Location: ${documentSnapshot["location"]}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                navigateToEditScreen(context, documentSnapshot);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDeleteDialog(context, documentSnapshot.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateToEditScreen(BuildContext context, DocumentSnapshot ds) {
    TextEditingController nameController = TextEditingController(text: ds["Name"]);
    TextEditingController ageController = TextEditingController(text: ds["Age"].toString());
    TextEditingController locationController = TextEditingController(text: ds["location"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
              ),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _RangeTextInputFormatter(min: 1, max: 100),
              ],
              decoration: InputDecoration(
                labelText: "Age",
              ),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Location",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              String id = ds.id;
              Map<String, dynamic> updateInfo = {
                "Name": nameController.text.trim(),
                "Age": int.tryParse(ageController.text.trim()) ?? 0,
                "location": locationController.text.trim(),
              };
              if (updateInfo["Name"].isEmpty || updateInfo["Age"] == 0) {
                return;
              }
              await FirebaseFirestore.instance.collection('employees').doc(id).update(updateInfo);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Employee"),
        content: Text("Are you sure you want to delete this employee?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('employees').doc(id).delete();
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class _RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return TextEditingValue();
    }

    try {
      final number = int.parse(newValue.text);
      if (number < min || number > max) {
        return oldValue;
      }
      return newValue;
    } catch (e) {
      return oldValue;
    }
  }
}
