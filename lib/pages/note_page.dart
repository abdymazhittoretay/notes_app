// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  NotePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.black,
        actions: [
          TextButton(
              onPressed: () {
                _focusNode.unfocus();
              },
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              )),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: TextField(
            focusNode: _focusNode,
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type here",
                hintStyle: TextStyle(fontSize: 18.0)),
            maxLines:
                null, // Allows for unlimited lines (multi-line text input)
          ),
        ),
      ),
    );
  }
}
