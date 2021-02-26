import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:uuid/uuid.dart';
import 'package:yhwh/classes/VerseRaw.dart';
import 'package:yhwh/classes/hiveManagers/HighlighterManager.dart';
import 'package:yhwh/data/Define.dart';
import 'package:yhwh/data/valuesOfBooks.dart';
import 'package:yhwh/models/highlighterItem.dart';
import 'package:yhwh/pages/ReferencesPage.dart';

class BiblePageController extends GetxController {
  AutoScrollController autoScrollController;
  GetStorage getStorage = GetStorage();
  LazyBox highlighterBox;
  LazyBox highlighterOrderBox;

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
  void onReady() async {
    bookNumber = getStorage.read("bookNumber") ?? 1;
    chapterNumber = getStorage.read("chapterNumber") ?? 1;
    verseNumber = getStorage.read("verseNumber") ?? 1;
    
    fontSize = getStorage.read("fontSize") ?? 20.0;
    fontHeight = getStorage.read("fontHeight") ?? 1.8;
    fontLetterSeparation = getStorage.read("fontLetterSeparation") ?? 0;
    
    await updateVerseList();
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
      
      versesSelected.sort();
      update();
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
    List<int> highlightVerses = await HighlighterManager.getHighlightVersesInChapter(bookNumber, chapterNumber);
    versesRawList = [];

    // Crear versiculos
    for (int index = 0; index < valuesOfBooks[bookNumber -1][chapterNumber - 1]; index++) {
      versesRawList.add(
        VerseRaw(
          text: dataChapter[index]["text"],
          fontSize: fontSize,
          fontHeight: fontHeight,
          fontLetterSeparation: fontLetterSeparation,
          highlight: highlightVerses.contains(index + 1) ? true : false,
          colorHighlight: Colors.blue
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
      getStorage.write("chapterNumber", chapterNumber);
      getStorage.write("verseNumber", verseNumber);
    }

    else if (chapterNumber == namesAndChapters[bookNumber - 1][1]) {
      if (bookNumber < 66) {
        bookNumber += 1;
        chapterNumber = 1;
        verseNumber = 1;
        getStorage.write("bookNumber", bookNumber);
        getStorage.write("chapterNumber", chapterNumber);
        getStorage.write("verseNumber", verseNumber);
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
      getStorage.write("chapterNumber", chapterNumber);
    }

    else if (chapterNumber == 1)
    {
      if(bookNumber > 1)
      {
        bookNumber -= 1;
        chapterNumber = namesAndChapters[bookNumber - 1][1];
        getStorage.write("bookNumber", bookNumber);
        getStorage.write("chapterNumber", chapterNumber);
      }
    }

    versesSelected = [];
    selectionMode = false;
    await updateVerseList();
    update();
  }

  void referenceButtonOnTap(){
    Get.to(ReferencesPage());
  }

  void setReference(int bookNumber, int chapterNumber, int verseNumber) async {
    this.bookNumber = bookNumber;
    this.chapterNumber = chapterNumber;
    this.verseNumber = verseNumber;
    getStorage.write("bookNumber", bookNumber);
    getStorage.write("chapterNumber", chapterNumber);
    getStorage.write("verseNumber", verseNumber);

    versesSelected = [];
    await updateVerseList();
    update();
    
    autoScrollController.scrollToIndex(verseNumber - 1, duration: Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
  }

  void setReferenceSafeScroll(int bookNumber, int chapterNumber, int verseNumber) async{
    this.bookNumber = bookNumber;
    this.chapterNumber = chapterNumber;
    this.verseNumber = verseNumber;
    getStorage.write("bookNumber", bookNumber);
    getStorage.write("chapterNumber", chapterNumber);
    getStorage.write("verseNumber", verseNumber);

    versesSelected = [];
    await updateVerseList();
    update();
    
    autoScrollController.scrollToIndex(verseNumber - 1, duration: Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
    autoScrollController.scrollToIndex(verseNumber - 1, duration: Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
  }

  void addToHighlighter() async {
    var newHighlighterItem = HighlighterItem(
      book: bookNumber,
      chapter: chapterNumber,
      id: Uuid().v1(),
      color: Colors.red.value,
      verses: versesSelected
    );

    // add to database
    HighlighterManager.add(newHighlighterItem);

    // update RawVerses
    for(int verse in versesSelected){
      versesRawList[verse - 1].highlight = true;
      versesRawList[verse - 1].colorHighlight = Color(newHighlighterItem.color);
    }

    update();
    cancelSelectionModeOnTap();
  }

}