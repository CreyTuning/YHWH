import 'package:flutter/material.dart';

class UiVerse extends StatefulWidget{
  final int number;
  final String text;
  final String title;

  final String fontFamily;
  final double fontSize;
  final double height;
  final double letterSeparation;

  final Color color;
  final Color colorOfNumber;

  final double separation;


  UiVerse({
    @required this.number,
    @required this.text,
    @required this.title,

    this.fontFamily = 'Roboto',
    this.fontSize = 20.0,
    this.height  = 1.8,
    this.letterSeparation = 0,

    this.color = const Color(0xff263238),
    this.colorOfNumber = const Color(0xaf37474F),

    this.separation = 5.0,
  });

  _UiVerseState createState() => _UiVerseState();
}

class _UiVerseState extends State<UiVerse>{
  @override
  Widget build(BuildContext context)
  {
    List<Widget> content = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RichText(
          softWrap: true,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,

          text: TextSpan(
            style: TextStyle(
                fontSize: this.widget.fontSize,
                color: this.widget.color,
                fontFamily: this.widget.fontFamily,
                height: this.widget.height,
                letterSpacing: this.widget.letterSeparation
            ),

            children: textToRichText(this.widget.number, this.widget.text) //[
          ),
        ),
      ),

      Divider(color: Color(0x00), height: widget.separation,)
    ];

    
    
    if(widget.title != null){
      content.insert(0,
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: ListTile(
            title: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
                height: widget.height
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      // onDoubleTap: (){print(widget.text);},
      // radius: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content,
      ),
    );
  }



  List<TextSpan> textToRichText(int verseNumber, String text){
    List<TextSpan> list = [];
    List<String> splitText = text.split(' '); //replaceAll('Del SEÑOR', 'YHWH').replaceAll('del SEÑOR', 'YHWH').replaceAll('El SEÑOR', 'YHWH').replaceAll('el SEÑOR', 'YHWH').replaceAll('Y YHWH', 'Mas YHWH').replaceAll('y YHWH', 'mas YHWH').
    bool isOpen = false;

    list.add(
      TextSpan( // Numero de versiculo
        text: verseNumber.toString() + ' ',
        style: TextStyle(
            color: this.widget.colorOfNumber,
            fontSize: this.widget.fontSize - 7.0
        )
      )
    );
    
    splitText.forEach((element) {
      
      if(element[0] == '[')
        isOpen = true;

      if(isOpen){
        list.add(
          TextSpan(
            text: element.replaceAll('[', '').replaceAll(']', '') + ' ',
            style: TextStyle(
              color: widget.color,
              fontStyle: FontStyle.italic,

            )
          )
        );
        
        if(element[element.length - 1] == ']')
          isOpen = false;
      }

      else{
        if(false) //element == 'SEÑOR' || element == 'YHWH'){
        { 
          list.add(
            TextSpan(
              text: element + ' ',
              style: TextStyle(
                // color: Colors.green,
                fontWeight: FontWeight.bold,
                fontFamily: 'Baloo'
              )
            )
          );
        }
        
        else{
          list.add(
            TextSpan(
              text: element + ' ',
              // style: TextStyle(color: Colors.green)
            )
          );
        }
      }
    });

    return list;
  }
}