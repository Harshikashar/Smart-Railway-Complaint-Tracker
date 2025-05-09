// lib/screens/complaint_list_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Complaint {
  final String name;
  final String email;
  final String description;
  final String stationName;
  final String category;
  final String status;

  Complaint({
    required this.name,
    required this.email,
    required this.description,
    required this.stationName,
    required this.category,
    required this.status,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
  return Complaint(
    name: json['name'] ?? 'No Name',
    email: json['email'] ?? 'No Email',
    description: json['description'] ?? 'No Description',
    stationName: json['stationName'] ?? 'No Station',
    category: json['category'] ?? 'No Category',
    status: json['status'] ?? 'Pending',
  );
}

}

class ComplaintListScreen extends StatefulWidget {
  @override
  _ComplaintListScreenState createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends State<ComplaintListScreen> {
  late Future<List<Complaint>> complaints;

  @override
  void initState() {
    super.initState();
    complaints = fetchComplaints();
  }

  Future<List<Complaint>> fetchComplaints() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/complaints'));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((c) => Complaint.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load complaints');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Complaints')),
      body: FutureBuilder<List<Complaint>>(
        future: complaints,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Complaint c = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(c.name),
                    subtitle: Text('${c.category} @ ${c.stationName}'),
                    trailing: Text(c.status),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
