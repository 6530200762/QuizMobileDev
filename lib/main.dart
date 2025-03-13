import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './addForm.dart';
import './updateForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int screenIndex = 0;

  //------ หน้าจอแต่ละหน้า ------
  final mobileScreens = [
    home(),
    image(),
  ];

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
      //------ เรียกหน้าจอแต่ละหน้าตาม Index ------
      body: mobileScreens[screenIndex],

      //------ floatingActionButton ------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            screenIndex = 1;
          });
          //------ ไปหน้า addForm ------
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => addForm()))
              .then((_) {
            setState(() {
              screenIndex = 0;
            });
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //------ bottomNavigationBar ------
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(99, 136, 137, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    //------ กำหนดค่า Index เมื่อมีการคลิก ------
                    screenIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  //------ ถ้า Index = 0 ให้ไอคอนสีเขียวเข้ม ถ้าไม่ใช้ไอคอนสีขาว ------
                  color: screenIndex == 0
                      ? Color.fromRGBO(18, 55, 42, 1)
                      : Colors.white,
                  // color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    screenIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.image,
                  color: screenIndex == 1
                      ? Color.fromRGBO(18, 55, 42, 1)
                      : Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}

//------------- Home page -------------
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  CollectionReference RobotsCollection =
      FirebaseFirestore.instance.collection('Robots');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: RobotsCollection.snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                var RobotsIndex = snapshot.data!.docs[index];

                //------------ สไลด์เมนู Slidable ------------
                return Slidable(
                  //------ startActionPane สไลด์จากด้านซ้ายมือ ------
                  startActionPane: ActionPane(motion: DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {},
                      backgroundColor: Colors.blue,
                      icon: Icons.share,
                      label: 'แชร์',
                    ),
                  ]),

                  //------ endActionPane สไลด์จากด้านขวามือ ------
                  endActionPane: ActionPane(motion: StretchMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => updateForm(),
                            settings: RouteSettings(arguments: RobotsIndex),
                          ),
                        );
                      },
                      backgroundColor: Colors.green,
                      icon: Icons.edit,
                      label: 'แก้ไข',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        RobotsCollection.doc(RobotsIndex.id).delete();
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'ลบ',
                    ),
                  ]),

                  //------ Minimalistic ListTile ------
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(
                        RobotsIndex['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        RobotsIndex['year'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}


//------------- Image page -------------
class image extends StatelessWidget {
  const image({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 136, 137, 1),
        title: Center(
          child: Text(
            'My Factory',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://i.kinja-img.com/image/upload/c_fill,h_900,q_60,w_1600/a7187b51d4a076bfe1702bbec0a1e0c4.jpg', // Replace with the path to your image
              height: 250, // Set the desired height of the image
              fit: BoxFit.cover, // Adjust the image to fit the container
            ),
            SizedBox(height: 20), // Space between the image and the text
            Text(
              'Welcome to the Robot Factory',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10), // Space between title and description
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Here we design and manufacture the most advanced robots, '
                'integrating cutting-edge technologies and precision engineering.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
