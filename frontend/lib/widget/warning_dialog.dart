import 'package:flutter/material.dart';
import '../design_configs.dart';

void showWarningDialog(
    {
      required BuildContext context,
      required String title,
      required String content,
      required String actionText,
      required Function() function
    }
    ) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          insetPadding: const EdgeInsets.all(14),
          titlePadding: const EdgeInsets.all(5),
          title: Container(
            decoration: BoxDecoration(
              color: DesignConfigs.brownColor,
              borderRadius: BorderRadius.circular(3.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: DesignConfigs.whiteColor,
              ),
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: DesignConfigs.grayColor,
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
          backgroundColor: DesignConfigs.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: function,
                  child: Text(actionText),
                )
              ],
            )
          ],
        );
      }
  );
}