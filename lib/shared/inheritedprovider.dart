import 'package:flutter/material.dart';
import 'package:frideos_core/frideos_core.dart';

/**
 * Generic provider
 */
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
    context
        .findAncestorWidgetOfExactType<InheritedProvider<T>>();
}
