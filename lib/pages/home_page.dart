import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/note_page.dart';
import 'package:notes_app/services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService fs = FirestoreService();

  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: fs.getNotes(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List notesList = snapshot.data!.docs;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: notesList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = notesList[index];

                            String docID = document.id;

                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;

                            String note = data["note"];
                            Timestamp timestamp = data["timestamp"];
                            DateTime datetime = timestamp.toDate();
                            return GestureDetector(
                              onTap: () {
                                _noteController.text = note;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotePage(
                                              controller: _noteController,
                                              addNote: addNote,
                                              docID: docID,
                                              updateNote: () {
                                                fs.updateNote(docID,
                                                    _noteController.text);
                                              },
                                            ))).then((value) {
                                  _noteController.clear();
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: 10.0, right: 10.0),
                                child: ListTile(
                                  tileColor: Colors.grey[900],
                                  contentPadding: EdgeInsets.only(
                                      top: 5.0, left: 16.0, right: 16.0),
                                  title: Text(
                                    maxLines: 1,
                                    note,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "${datetime.day.toString().padLeft(2, "0")}.${datetime.month.toString().padLeft(2, "0")}.${datetime.year}",
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Stack(children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          notesList.length == 1
                              ? "${notesList.length} note"
                              : "${notesList.length} notes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotePage(
                                          controller: _noteController,
                                          addNote: addNote,
                                          docID: "",
                                          updateNote: () {})));
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.amber,
                            )),
                      ),
                    ]),
                  ],
                );
              } else {
                return Center(child: Text("There are no Notes yet."));
              }
            }),
      ),
    );
  }

  // Functions
  void addNote() {
    if (_noteController.text.isNotEmpty) {
      fs.addNote(_noteController.text);
    }
  }
}
