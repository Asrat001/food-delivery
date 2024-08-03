import 'package:flutter/material.dart';



class Utils {


  static Future<void> showDialogBox(
      BuildContext context, String title, Function callback) {
    return showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            shape:const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            title:Text(title , textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold,fontSize:18),),
            content:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: ()=>{callback()},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     const  Icon(Icons.location_on,color: Colors.black,size: 18,),
                      Text("Use current Location",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold,fontSize: 13),)
                    ],
                  ),
                ),
            
              ],
            ),
          );
        });

  }


}
