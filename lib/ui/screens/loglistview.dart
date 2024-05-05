import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pano1/ui/screens/single3dmodel.dart';
import '../../firebase_options.dart';


late User loggedinuser;
late String client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(gemlist());
}

class gemlist extends StatefulWidget {
  @override
  gemlistview createState() => gemlistview();
}

class gemlistview extends State<gemlist> {
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
      ///yata line eka chatgpt code ekk meka gatte uda line eke error ekk ena hinda hrytama scene eka terenne na
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedinuser = user;
        client = loggedinuser.email!;

        ///i have to call the getdatafrm the function here and parse client as a parameter

        print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFDBD6E5),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Gem Collection',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFFDBD6E5),
        ),
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

                      return Card(
                        color: Color(0xFFA888EB),
                        child: ListTile(
                          leading: Icon(Icons.add),
                          title: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Single3d(
                                        gemcode: '${data['scanid']}',ilink:'${data['plink']}' ,)),
                              );
                              print('${data['scanid']}');
                            },
                            child: Ink(
                              child: Text(
                                doc.id,
                                style: TextStyle(
                                  color: Color(0xFF43468E),
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          trailing: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(),
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