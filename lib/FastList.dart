

import 'dart:io';

class FastList{

  List<String> entries;
  List<String> keys;

  FastList(List<String> entries){
    this.entries = entries;

    keys = entries.map((e) {
      return e.split("\t")[0];
    }).toList();
  }

  List<String> takeFirstElementsSplitContaining(String searchTerm, int amount){
    List<int> index = new List<int>();

    //No split in every iteration anymore, searching the key words directly instead
    //stops after 'amount' count of entries
    for(int i = 0; i < keys.length && index.length < amount; i++){
      if(keys[i].contains(searchTerm)){
        index.add(i);
      }
    }

    return index.map((e){
      return entries.elementAt(e);
    }).toList();
  }
}