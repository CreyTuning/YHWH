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
      onDoubleTap: (){print(widget.text);},
      radius: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content,
      ),
    );
  }



  List<TextSpan> textToRichText(int verseNumber, String text)
  {
    List<TextSpan> list = [];
    List<String> splitText = text.replaceAll('ángel del SEÑOR', 'ángel de YHWH').
                                  replaceAll('Ángel del SEÑOR', 'Ángel de YHWH').
                                  replaceAll('angel del SEÑOR', 'angel de YHWH').
                                  replaceAll('Angel del SEÑOR', 'Angel de YHWH').
                                  replaceAll('palabra del SEÑOR', 'palabra de YHWH').
                                  replaceAll('Palabra del SEÑOR', 'Palabra de YHWH').
                                  replaceAll('trono del SEÑOR', 'trono de YHWH').
                                  replaceAll('Nombre del SEÑOR', 'Nombre de YHWH').
                                  replaceAll('el SEÑOR ([YHWH])', 'YHWH').
                                  replaceAll('El SEÑOR ([YHWH])', 'YHWH').
                                  replaceAll('Del SEÑOR', 'YHWH').
                                  replaceAll('del SEÑOR', 'YHWH').
                                  replaceAll('El SEÑOR', 'YHWH').
                                  replaceAll('el SEÑOR', 'YHWH').
                                  replaceAll('Al SEÑOR', 'A YHWH').
                                  replaceAll('al SEÑOR', 'a YHWH').
                                  replaceAll('Y YHWH', 'Mas YHWH').
                                  replaceAll('y YHWH', 'mas YHWH').
                                  replaceAll('DIOS', 'YHWH').
                                  split(' ');
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
      
      // Verificar si se activa el IsOpen
      if(element.contains('['))
        isOpen = true;


      if(isOpen)
      {
        if(element.contains('([') && element.contains('])')){
          if(!element.endsWith(')'))
          {
            list.add(
              TextSpan(
                text: element.substring(0, element.length - 1).replaceAll('[', '').replaceAll(']', ''),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                  fontFamily: 'Roboto-Italic'
                )
              )
            );

            list.add(
              TextSpan(
                text: element[element.length - 1] + ' ',
              )
            );
          }

          else{
            list.add(
              TextSpan(
                text: element.replaceAll('[', '').replaceAll(']', '') + ' ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                  fontFamily: 'Roboto-Italic'
                )
              )
            );
          }
          
        }

        else if(element.length >= 3 && element[1] == '['){
          
          list.add(
            TextSpan(
              text: element[0],
            )
          );
          
          list.add(
            TextSpan(
              text: element.substring(1, element.length - 1).replaceAll('[', '').replaceAll(']', '') + ' ',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText2.color,
                fontFamily: 'Roboto-Italic'
              )
            )
          );
        }

        else if(element.contains(']') && !element.endsWith(']')){
          list.add(
            TextSpan(
              text: element.substring(0, element.length - 2).replaceAll('[', '').replaceAll(']', ''),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText2.color,
                fontFamily: 'Roboto-Italic'
                // fontSize: widget.fontSize - 2,
                // fontStyle: FontStyle.italic,
              )
            )
          );

          list.add(
            TextSpan(
              text: element[element.length - 1] + ' '
            )
          );
        }

        else {
          list.add(
            TextSpan(
              text: element.replaceAll('[', '').replaceAll(']', '') + ' ',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText2.color,
                fontFamily: 'Roboto-Italic'
                // fontSize: widget.fontSize - 2,
                // fontStyle: FontStyle.italic,
              )
            )
          );
        }
        
        if(element.contains(']'))
          isOpen = false;
      }

      else{
        if(element == 'YHWH'|| element == 'SEÑOR')
        { 
          list.add(
            TextSpan(
              text: element + ' ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Baloo',
                height: 0
              )
            )
          );
        }

        else if(element == 'YHWH:' || element == 'YHWH,' || element == 'YHWH;' || element == 'YHWH.' || element == 'YHWH?' ||
              element == 'SEÑOR:' || element == 'SEÑOR,' || element == 'SEÑOR;' || element == 'SEÑOR.' || element == 'SEÑOR?')
        {
          list.add(
            TextSpan(
              text: element.substring(0, element.length - 1),
              style: TextStyle(
                // color: Colors.green,
                fontWeight: FontWeight.bold,
                fontFamily: 'Baloo',
                height: 0
              )
            )
          );

          list.add(
            TextSpan(
              text: element[element.length - 1] + ' '
            )
          );
        }
        
        else{
          list.add(
            TextSpan(
              text: element + ' ',
            )
          );
        }
      }
    });

    return list;
  }
}