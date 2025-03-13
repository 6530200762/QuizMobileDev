import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addForm extends StatefulWidget {
  @override
  State<addForm> createState() => _addFormState();
}

class _addFormState extends State<addForm> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final yearController = TextEditingController();

  CollectionReference RobotsCollection =
      FirebaseFirestore.instance.collection('Robots');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 136, 137, 1),
        title: Center(
          child: Text(
            'Robots',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Column(
              children: [
                Text(
                  'New Robots',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Add a name',
                    icon: Icon(Icons.title),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: typeController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add a type',
                    icon: Icon(Icons.type_specimen),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: yearController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add a year',
                    icon: Icon(Icons.numbers),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    RobotsCollection.add({
                      'name': nameController.text,
                      'type': typeController.text,
                      'year': yearController.text
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Create new robot'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
