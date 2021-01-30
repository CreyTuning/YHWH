import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:yhwh/classes/VerseRaw.dart';
import 'package:yhwh/data/Define.dart';
import 'package:yhwh/data/valuesOfBooks.dart';
import 'package:yhwh/pages/ReferencesPage.dart';

class BiblePageController extends GetxController {

  AutoScrollController autoScrollController;
  int bookNumber = 1;
  int chapterNumber = 2;
  int verseNumber = 1;
  bool selectionMode = false;

  String bibleVersion = "RVR60";
  List<VerseRaw> versesRawList = [];
  List<int> versesSelected = [];

  double fontSize = 20.0;
  double fontHeight = 1.8;
  double fontLetterSeparation = 0.0;

  @override
  void onInit() {
    autoScrollController = AutoScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    bookNumber = GetStorage().read("bookNumber") ?? 1;
    chapterNumber = GetStorage().read("chapterNumber") ?? 1;
    verseNumber = GetStorage().read("verseNumber") ?? 1;
    
    fontSize = GetStorage().read("fontSize") ?? 20.0;
    fontHeight = GetStorage().read("fontHeight") ?? 1.8;
    fontLetterSeparation = GetStorage().read("fontLetterSeparation") ?? 0;
    
    updateVerseList();
    update();
    super.onReady();
  }

  void onVerseTap(int index){
    if(selectionMode){
      // Agregar o eliminar indices
      if(versesSelected.contains(index)){
        versesSelected.remove(index);
      } else {
        versesSelected.add(index);
      }

      // Activar o desactivar modo seleccion
      if(versesSelected.length != 0){
        selectionMode = true;
      } else {
        selectionMode = false;
      }
      
      update();
      print('versesSelected: $versesSelected');
    }
  }


  void onVerseLongPress(int index){
    if(!selectionMode){
      selectionMode = true;
      onVerseTap(index);
    } else {
      onVerseTap(index);
    }
  }

  void cancelSelectionModeOnTap(){
    versesSelected = [];
    selectionMode = false;
    update();
  }

  Future<void> updateVerseList() async {
    List dataChapter = await jsonDecode(await rootBundle.loadString('lib/bibles/$bibleVersion/${bookNumber}_$chapterNumber.json'))['verses'];
    versesRawList = [];

    for (int index = 0; index < valuesOfBooks[bookNumber -1][chapterNumber - 1]; index++) {
      versesRawList.add(
        VerseRaw(
          text: dataChapter[index]["text"],
          fontSize: fontSize,
          fontHeight: fontHeight,
          fontLetterSeparation: fontLetterSeparation
        )
      );
    }

    return;
  }

  void nextChapter() async {
    autoScrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);

    if (chapterNumber < namesAndChapters[bookNumber - 1][1]) {
      chapterNumber++;
      verseNumber = 1;
      GetStorage().write("chapterNumber", chapterNumber);
      GetStorage().write("verseNumber", verseNumber);
    }

    else if (chapterNumber == namesAndChapters[bookNumber - 1][1]) {
      if (bookNumber < 66) {
        bookNumber += 1;
        chapterNumber = 1;
        verseNumber = 1;
        GetStorage().write("bookNumber", bookNumber);
        GetStorage().write("chapterNumber", chapterNumber);
        GetStorage().write("verseNumber", verseNumber);
      }
    }

    versesSelected = [];
    selectionMode = false;
    await updateVerseList();
    update();
  }

  void previusChapter() async {
    autoScrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    
    if (chapterNumber > 1) {
      chapterNumber--;
      GetStorage().write("chapterNumber", chapterNumber);
    }

    else if (chapterNumber == 1)
    {
      if(bookNumber > 1)
      {
        bookNumber -= 1;
        chapterNumber = namesAndChapters[bookNumber - 1][1];
        GetStorage().write("bookNumber", bookNumber);
        GetStorage().write("chapterNumber", chapterNumber);
      }
    }

    versesSelected = [];
    selectionMode = false;
    await updateVerseList();
    update();
  }

  void referenceButtonOnTap(){
    Get.to(ReferencesPage(), transition: Transition.fadeIn, duration: Duration(milliseconds: 300), );
  }

  void setReference(int bookNumber, int chapterNumber, int verseNumber) async {
    this.bookNumber = bookNumber;
    this.chapterNumber = chapterNumber;
    this.verseNumber = verseNumber;
    GetStorage().write("bookNumber", bookNumber);
    GetStorage().write("chapterNumber", chapterNumber);
    GetStorage().write("verseNumber", verseNumber);

    versesSelected = [];
    await updateVerseList();
    update();
    
    autoScrollController.scrollToIndex(verseNumber - 1, duration: Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
  }

}