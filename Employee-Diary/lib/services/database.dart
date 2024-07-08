import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  
  // CREATE
  Future<void> addEmployeeDetails(Map<String, dynamic> employeeInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection("employees") // Ensure collection name matches Firestore
        .doc(id)
        .set(employeeInfoMap);
  }

  // READ
  Stream<QuerySnapshot> getEmployeeDetails() {
    return FirebaseFirestore.instance
        .collection("employees") // Ensure collection name matches Firestore
        .orderBy("createdAt", descending: true) // Assuming you have a "createdAt" field
        .snapshots();
  }

  // UPDATE
  Future<void> updateEmployeeDetail(String id, Map<String, dynamic> updateInfo) async {
    await FirebaseFirestore.instance
        .collection("employees") // Ensure collection name matches Firestore
        .doc(id)
        .update(updateInfo);
  }

  // DELETE
  Future<void> deleteEmployeeDetail(String id) async {
    await FirebaseFirestore.instance
        .collection("employees") // Ensure collection name matches Firestore
        .doc(id)
        .delete();
  }
}
