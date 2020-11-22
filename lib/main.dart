import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  print('hello world');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Tracking(),
    );
  }
}

class Tracking extends StatefulWidget {
  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 0, 100, 0.8),
        title: Text(
          'Tracking',
          textScaleFactor: 2.5,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(children: [
            SizedBox(width: 60),
          ]),
          Center(
            child: Image.asset(
              "assets/dish.png",
              height: 300,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Location()),
                ),
              },
              child: Card(
                color: Color.fromRGBO(255, 0, 100, 1),
                child: Text(
                  'Location',
                  textScaleFactor: 5.0,
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Food()))
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Food()),
                // ),
              },
              child: Card(
                color: Color.fromRGBO(255, 0, 100, 1),
                child: Text(
                  'Food',
                  textScaleFactor: 5.0,
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Color.fromRGBO(255, 255, 255, 1),
        backgroundColor: Color.fromRGBO(255, 0, 100, 0.8),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraApp()),
          );
        },
        tooltip: 'Scan',
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}

class Location extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    var year = data['Time'].toDate().toString().substring(0, 4);
    var month = data['Time'].toDate().toString().substring(5, 7);
    var day = data['Time'].toDate().toString().substring(8, 10);
    var time = data['Time'].toDate().toString().substring(11, 16);
    var a = time + ' วันที่ ' + day + ' เดือน ' + month + ' ปี ' + year;

    return ListTile(
        title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          a,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          data['Name'],
          style: TextStyle(fontSize: 30),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Location').snapshots(),
      builder: (context, snapshot) {
        var a = snapshot.data.docs;
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Location",
              textScaleFactor: 2.5,
            ),
            backgroundColor: Color.fromRGBO(255, 0, 100, 0.8),
          ),
          body: ListView.builder(
            itemCount: a.length,
            itemBuilder: (context, index) => _buildListItem(context, a[index]),
          ),
        );
      },
    );
  }
}

class Food extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    var year = data['Time'].toDate().toString().substring(0, 4);
    var month = data['Time'].toDate().toString().substring(5, 7);
    var day = data['Time'].toDate().toString().substring(8, 10);
    var time = data['Time'].toDate().toString().substring(11, 16);
    var a = time + ' วันที่ ' + day + ' เดือน ' + month + ' ปี ' + year;

    return ListTile(
        title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          a,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          data['Name'],
          style: TextStyle(fontSize: 30),
        ),
      ],
    ));
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Food').snapshots(),
      builder: (context, snapshot) {
        var a = snapshot.data.docs;
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Food",
              textScaleFactor: 2.5,
            ),
            backgroundColor: Color.fromRGBO(255, 0, 100, 0.8),
          ),
          body: ListView.builder(
            itemCount: a.length,
            itemBuilder: (context, index) => _buildListItem(context, a[index]),
          ),
        );
      },
    );
  }
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        print('dfskljdsaf;kljdfskl;');
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('hello');
    if (!controller.value.isInitialized) {
      print('aa');
      return Container();
    }
    print('success');
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
