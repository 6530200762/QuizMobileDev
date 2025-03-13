import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class updateForm extends StatefulWidget {
  @override
  State<updateForm> createState() => _updateFormState();
}

class _updateFormState extends State<updateForm> {
  CollectionReference RobotsCollection =
      FirebaseFirestore.instance.collection('Robots');

  @override
  Widget build(BuildContext context) {
    final RobotsData = ModalRoute.of(context)!.settings.arguments as dynamic;

    final nameController = TextEditingController(text: RobotsData['name']);
    final typeController = TextEditingController(text: RobotsData['type']);
    final yearController = TextEditingController(text: RobotsData['year']);

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
                  'Edit Robots',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Edit a new name',
                    icon: Icon(Icons.title),
                  ),
                ),
                TextFormField(
                  controller: typeController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Edit a new type',
                    icon: Icon(Icons.type_specimen),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: yearController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Edit a new year',
                    icon: Icon(Icons.numbers),
                  ),
                ),
                
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    RobotsCollection.doc(RobotsData.id).update({
                      'name': nameController.text,
                      'year': yearController.text
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
