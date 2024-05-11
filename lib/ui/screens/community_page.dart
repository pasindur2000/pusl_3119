import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pano1/ui/screens/single3dmodel.dart';
import '../../constants.dart';
import '../../firebase_options.dart';

late User loggedinuser;
late String client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Community());
}

class Community extends StatefulWidget {
  @override
  gemlistview createState() => gemlistview();
}

class gemlistview extends State<Community> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference postsRef =
  FirebaseFirestore.instance.collection('posts');

  String searchValue = ''; // Track the search value

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      // final user = await _auth.currentUser();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedinuser = user;
        client = loggedinuser.email!;
        print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) {
                  // Update the search value when the user types
                  setState(() {
                    searchValue = value;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(width: 0.8),
                  ),
                  hintText: 'Search Here',
                  prefixIcon: Icon(
                    Icons.search,
                    size: 30.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('logs')
                    .snapshots(),
                //postsRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  // Filter the data based on the search value
                  final filteredData = snapshot.data!.docs.where((doc) {
                    final id = doc.id;

                    final search = searchValue.toLowerCase();
                    return id.contains(search);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final doc = filteredData[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3.0, // Increase the vertical space between items
                          horizontal: 10.0, // Add horizontal padding
                        ),
                        child: SizedBox(
                          height: 80, // Adjust the height of the card
                          child: Card(
                            color: Color(0xffEAECEB),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                leading: Icon(Icons.add),
                                title: GestureDetector(
                                  onTap: () {
                                int    newint = int.parse('${data['starcount']}') ;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Single3d(
                                          gemcode: '${data['scanid']}',
                                          ilink: '${data['plink']}',
                                          scount: newint,
                                        ),
                                      ),
                                    );
                                    print('${data['scanid']}');
                                    print(newint);
                                  },
                                  child: Ink(
                                    child: Text(
                                      doc.id,
                                      style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontSize: 16.0, // Decrease the font size
                                      ),
                                    ),
                                  ),
                                ),
                                trailing: Container(
                                  width: 40.0, // Adjust the width of the container
                                  height: 40.0, // Adjust the height of the container
                                  decoration: BoxDecoration(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
