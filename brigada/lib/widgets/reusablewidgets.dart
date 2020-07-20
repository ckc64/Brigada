
import 'package:flutter/material.dart';


Widget HeaderTitle({Color textColor , double textSize}) {
  return Text('brigada',
              style: TextStyle(
                color: textColor,
                fontFamily: 'FredokaOne',
                fontSize: textSize,
              ),

              );
}

Widget subHeaderTitle({String txtTitle}){
  return Text(txtTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat-Regular',
                      fontSize: 16,
                
                    ),
                  );
                }

  Widget wideButton({String buttonText, onPressed}){
              return ButtonTheme(
                            minWidth: double.infinity,
                            height: 55,
                            
                            child: FlatButton(
                            shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                           
                          ),
                            color: Colors.deepOrange,
                            textColor: Colors.white,
                            splashColor: Colors.deepOrange[900],
                            
                            onPressed: onPressed,
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white
                              ),
                            ),
                          ),
                        );
  }


Widget appBar({String txtTitle}){
  return AppBar(
      title: Text(txtTitle, style: TextStyle(fontFamily: "Montserrat-Regular"),),
      
    );

}

Widget floatingActionButton(context,{onPressed}){
  return FloatingActionButton(
    backgroundColor: Colors.deepOrange,
    splashColor: Colors.deepOrange,
    child: Text("+",
    style: TextStyle(fontSize: 25),
    ),
      onPressed: onPressed,
  );
}

showDialogWarning(context,String text){
  return showDialog(context: context, builder: (context){
      return AlertDialog(
        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      
          content: new Text(text)
        ,
      
        );
    }
  );
  
  
}

