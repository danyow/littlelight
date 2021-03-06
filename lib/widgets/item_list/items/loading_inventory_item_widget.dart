import 'package:flutter/material.dart';

class LoadingInventoryItemWidget extends StatelessWidget {
  LoadingInventoryItemWidget();
  

  @override
  Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          border: Border.all(
            color: Colors.blueGrey.shade900,
            width: 2,
            )
        ),
      );
    }
}
