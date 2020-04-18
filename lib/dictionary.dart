import 'dart:io';

import 'package:dark_dictionary/FastList.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class Dictionary {
  FastList searchList;

  Dictionary() {
    loadDirectory();
  }

  loadDirectory() async {
    try {
      if (await Permission.storage.request().isGranted) {
        var file = await _localDicFile;

        if (!await file.exists()) {
          file = await FilePicker.getFile();

          //Move file to correct path
          final path = await _localPath;
          file.copy('$path/dic');
        }

        var entries = await file.readAsLines();
        searchList = FastList(entries);
      } else {
        print("No IO permission");
      }
    } catch (e) {
      print("Error reading the file ($e)");
      throw e;
    }
  }

  List<List<String>> searchDictionaryEntries(String searchTerm) {
    return searchList.takeFirstElementsSplitContaining(searchTerm, 10);
  }

  ListView buildContainerByResult(List<List<String>> result) {
    List<Widget> display = new List<Widget>();

    if (result.length == 0) {
      return ListView();
    }

    for(int i = 0; i < 4; i++){
      display.addAll(getFlatButtonsByList(result[i]));
    }

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: display,
        )
      ],
    );
  }

  List<FlatButton> getFlatButtonsByList(List<String> entriesOfSameType) {
    return entriesOfSameType.map((e) {
      return FlatButton(
        child: Text(
          e,
          textAlign: TextAlign.left,
        ),
        onPressed: () {/*TODO Anki support*/},
      );
    }).toList();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localDicFile async {
    final path = await _localPath;
    return File('$path/dic');
  }
}
