import 'package:flutter/material.dart';
import 'package:flutter_navigator_v2/data/veggie.dart';

class VeggieDetailsScreen extends StatelessWidget {
  final Veggie veggie;

  VeggieDetailsScreen({
    @required this.veggie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(veggie.name), backgroundColor: veggie.accentColor,),
      body: Container(
        color: veggie.accentColor,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (veggie != null) ...[
                Text(veggie.name, style: Theme.of(context).textTheme.headline6),
                Text(veggie.categoryName, style: Theme.of(context).textTheme.subtitle1),
              ],
            ],
          ),
        ),
      ),
    );
  }
}