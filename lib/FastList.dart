

import 'dart:io';

class FastList{

  List<String> entries;
  var keys;

  FastList(List<String> entries){
    this.entries = entries;

    keys = entries.map((e) {
      return e.split("\t")[0];
    });
  }

  List<String> takeFirstElementsSplitContaining(String searchTerm, int amount){
    List<int> index;

    //No split in every iteration anymore, searching the key words directly instead
    //stops after 'amount' count of entries
    for(int i = 0; i < keys.length && index.length < amount; i++){
      if(keys[i].contains(searchTerm)){
        index.add(i);
      }
    }
    
    print("I have " + index.length.toString());

    return index.map((e){
      entries.elementAt(e);
    }).toList();
  }
}