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

  TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.black,
        title: Text("Notes"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: fs.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List notesList = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = notesList[index];

                    String docID = document.id;

                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    String note = data["note"];
                    return ListTile(
                      title: Text(note),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
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
                                            )));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 28.0,
                              )),
                          IconButton(
                              onPressed: () {
                                fs.deleteNote(docID);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 28.0,
                              )),
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: Text("There are no Notes yet."));
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotePage(
                  controller: _noteController,
                  addNote: addNote,
                  docID: "",
                  updateNote: () {},
                ),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  // Functions
  void addNote() {
    if (_noteController.text.isNotEmpty) {
      fs.addNote(_noteController.text);
      _noteController.clear();
    }
  }
}
