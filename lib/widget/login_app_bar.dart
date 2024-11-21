import 'package:flutter/material.dart';
import '../design_configs.dart';

PreferredSize loginAppBar() {
  return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration:  BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: DesignConfigs.grayColor,
                  offset: const Offset(0, 0),
                  blurRadius: 4
              )
            ]
        ),
        child: AppBar(
          leading: const Text(''),
          title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Pet Finder',
                style: TextStyle(
                    color: DesignConfigs.brownColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
              )
          ),
          centerTitle: true,
        ),
      )
  );
}
