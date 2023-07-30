import 'package:chat_gpt_clone/constants/constants.dart';
import 'package:chat_gpt_clone/widgets/drop_down.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> modalBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
        backgroundColor: scaffoldBackGroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                    child: Text(
                  'chooseModel',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
                Flexible(flex: 2, child: ModelsDropDownWidget()),
              ],
            ),
          );
        });
  }
}
