import 'package:flutter/cupertino.dart';

/// Generic Extensions for Lists
extension ListExtension<T> on List<T> {
  /// Transforms the List of type [T] to a separated list of type [R].
  ///
  /// The resulting list is constructed using the given element and
  /// separator parameter functions
  List<R> separated<R>(
      {@required R element(T element, int index),
      @required R separator(int index)}) {
    return [
      for (var i = 0; i < length * 2 - 1; i++)
        i.isEven ? element(this[i ~/ 2], i ~/ 2) : separator(i)
    ];
  }

  int orderedInsert(T element, num valueFunction(T)) {
    print('ordered insert of $element');
    print('into: $this');

    if (isEmpty) {
      add(element);
      return 0;
    } else {
      for (var i = 0; i < length; i++) {
        if (valueFunction(element) < valueFunction(this[i])) {
          insert(i, element);
          return i - 1;
        }
      }
      add(element);
      return length - 1;
    }
  }

  /// Counts the the number of elements that matches the condition
  int count(bool condition(T element)) {
    return fold(0, (acc, element) => acc + (condition(element) ? 1 : 0));
  }
}
