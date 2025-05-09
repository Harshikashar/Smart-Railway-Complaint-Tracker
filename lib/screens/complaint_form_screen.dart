import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComplaintFormScreen extends StatefulWidget {
  @override
  _ComplaintFormScreenState createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _category;
  String? _description;

  List<String> categories = ['Sanitation', 'Staff Behavior', 'Delay', 'Other'];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save all form field values

      final url = Uri.parse('http://192.168.57.95:8080/api/complaints');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _name,
          'email': _email,
          'category': _category,
          'description': _description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint Submitted Successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File New Complaint')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (value) => value!.isEmpty ? 'Name required' : null,
                onSaved: (value) => _name = value,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Email'),
                validator: (value) => value!.isEmpty ? 'Email required' : null,
                onSaved: (value) => _email = value,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Complaint Category'),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => _category = value,
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'Complaint Description'),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Description required' : null,
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Submit Complaint'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
