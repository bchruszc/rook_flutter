import 'package:flutter/material.dart';
import 'package:frideos_core/frideos_core.dart';

/// Generic provider gathered from
/// https://medium.com/flutter-community/simple-ways-to-pass-to-and-share-data-with-widgets-pages-f8988534bd5b

class InheritedProvider<T> extends InheritedWidget {
  final StreamedValue<T> inheritedData;

  InheritedProvider({
    Widget child,
    this.inheritedData,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedProvider oldWidget) =>
      inheritedData != oldWidget.inheritedData;

  static InheritedProvider<T> of<T>(BuildContext context) =>
      context.findAncestorWidgetOfExactType<InheritedProvider<T>>();
}
