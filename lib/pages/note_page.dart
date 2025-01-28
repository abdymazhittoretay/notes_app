// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final void Function() addNote;
  final void Function() updateNote;
  final String docID;

  final FocusNode _focusNode = FocusNode();

  NotePage(
      {super.key,
      required this.controller,
      required this.addNote,
      required this.docID,
      required this.updateNote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow[700],
        surfaceTintColor: Colors.black,
        actions: [
          TextButton(
              onPressed: () {
                if (docID.isEmpty) {
                  addNote();
                } else {
                  updateNote();
                }
                _focusNode.unfocus();
              },
              child: Text(
                "Done",
                style: TextStyle(color: Colors.yellow[700], fontSize: 18.0),
              )),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: TextField(
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            focusNode: _focusNode,
            controller: controller,
            autofocus: true,
            cursorHeight: 30.0,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type here",
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey)),
            maxLines:
                null, // Allows for unlimited lines (multi-line text input)
          ),
        ),
      ),
    );
  }
}
