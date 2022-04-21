/// Extensions
///
/// [extension] enables some extra functionalities to already existing collections like [Map] and [List].
/// Some of the [extensions] are [MapStringDynamicExt], [ListExt] and [StringExt].
/// Each of these [extensions] can be used for specific tasks.

extension MapStringDynamicExt on Map<String, dynamic> {
  /// [getValue] is used in [Map] which takes [key] as the parameter returns the [value] of the [key], if the [key] is
  /// not empty or whiteSpace, otherwise returns null.
  T? getValue<T>(String key) {
    if (key.isEmptyOrWhiteSpace) return null;

    key = key.trim();

    if (!key.contains(".")) {
      if (this.containsKey(key)) return this[key] as T?;
      return null;
    }

    final split = key.split(".");
    dynamic current = this;

    for (var i = 0; i < split.length; i++) {
      if (current == null) return null;
      if (current is Map<String, dynamic>) {
        if (!current.containsKey(split[i])) return null;
        current = current[split[i]];
        continue;
      }

      throw Exception(
          "In Map $this the value for key = ${split.getRange(0, i).join(".")} expected Map<String, dynamic> got ${current.runtimeType} [$current]");
    }

    return current as T?;
  }

  /// [setValue] is also used in [Map] which takes [key] and [value] as the parameter assigns the [value],
  ///  which is passed in the parameter, to the [key], if the [key] is not empty or whiteSpace, otherwise returns.
  void setValue(String key, dynamic value) {
    if (key.isEmptyOrWhiteSpace) return;

    key = key.trim();

    if (!key.contains(".")) {
      this[key] = value;
      return;
    }

    final split = key.split(".");
    dynamic current = this;

    for (var i = 0; i < split.length - 1; i++) {
      dynamic next = current[split[i]];
      next ??= <String, dynamic>{};
      if (next is! Map<String, dynamic>) {
        throw Exception(
            "In Map $this the value for key = ${split.getRange(0, i + 1).join(".")} expected Map<String, dynamic> got ${next.runtimeType} [$next]");
      }
      current[split[i]] = next;
      current = next;
    }

    current[split[split.length - 1]] = value;
  }
}

typedef Predicate<T> = bool Function(T t);
typedef ValueFunction<T, TKey> = TKey Function(T t);

extension ListExt<T> on List<T> {
  /// [find] is used for finding the element from a [List]. It goes through each element in the [List] using
  /// for loop and checks the element matches. If the element found, returns the element. Else returns null.
  /// Basically, [find] will return the first element that matches.
  T? find(Predicate<T> predicate) {
    for (var element in this) {
      if (predicate(element)) return element;
    }

    return null;
  }

  /// [orderBy] is used to sort the [List] in ascending order.
  /// It is done by comparing the adjacent values in the [List].
  List<T> orderBy<TKey extends Comparable>(ValueFunction<T, TKey> valueFunc) {
    // given(valueFunc, "valueFunc").ensureHasValue();
    final internal = this.toList();

    internal.sort((a, b) {
      final valA = valueFunc(a);
      final valB = valueFunc(b);
      return valA.compareTo(valB);
    });
    return internal;
  }

  /// [orderByDesc] is used to sort the [List] in descending order.
  List<T> orderByDesc<TKey extends Comparable>(ValueFunction<T, TKey> valueFunc) {
    // given(valueFunc, "valueFunc").ensureHasValue();
    final internal = this.toList();

    internal.sort((a, b) {
      final valA = valueFunc(a);
      final valB = valueFunc(b);
      return valB.compareTo(valA);
    });
    return internal;
  }
}

// extension ListExtComparable<T> on List<Comparable<T>> {
//   List<T> orderBy() {
//     final internal = this.toList();
//     internal.sort((a, b) {
//       return a.compareTo(b as T);
//     });
//     return internal as List<T>;
//   }

//   List<T> orderByDesc() {
//     final internal = this.toList();
//     internal.sort((a, b) {
//       return b.compareTo(a as T);
//     });
//     return internal as List<T>;
//   }
// }

extension ListStringExt on List<String> {
  /// [orderBy] is used to sort the [ListStringExt] in ascending order.
  /// It is done by comparing the adjacent values in the [ListStringExt].
  List<String> orderBy() {
    final internal = this.toList();
    internal.sort((a, b) {
      return a.compareTo(b);
    });
    return internal;
  }

  /// [orderByDesc] is used to sort the [ListStringExt] in descending order.
  List<String> orderByDesc() {
    final internal = this.toList();
    internal.sort((a, b) {
      return b.compareTo(a);
    });
    return internal;
  }
}

extension ListNumExt on List<num> {
  /// [orderBy] is used to sort the [ListNumExt] in ascending order.
  /// It is done by comparing the adjacent values in the [ListNumExt].
  List<num> orderBy() {
    final internal = this.toList();
    internal.sort((a, b) {
      return a.compareTo(b);
    });
    return internal;
  }

  /// [orderByDesc] is used to sort the [ListNumExt] in descending order.
  List<num> orderByDesc() {
    final internal = this.toList();
    internal.sort((a, b) {
      return b.compareTo(a);
    });
    return internal;
  }
}

extension ListIntExt on List<int> {
  /// [orderBy] is used to sort the [ListIntExt] in ascending order.
  /// It is done by comparing the adjacent values in the [ListIntExt].
  List<int> orderBy() {
    final internal = this.toList();
    internal.sort((a, b) {
      return a.compareTo(b);
    });
    return internal;
  }

  /// [orderByDesc] is used to sort the [ListIntExt] in descending order.
  List<int> orderByDesc() {
    final internal = this.toList();
    internal.sort((a, b) {
      return b.compareTo(a);
    });
    return internal;
  }
}

extension ListDoubleExt on List<double> {
  /// [orderBy] is used to sort the [ListDoubleExt] in ascending order.
  /// It is done by comparing the adjacent values in the [ListDoubleExt].
  List<double> orderBy() {
    final internal = this.toList();
    internal.sort((a, b) {
      return a.compareTo(b);
    });
    return internal;
  }

  /// [orderByDesc] is used to sort the [ListDoubleExt] in descending order.
  List<double> orderByDesc() {
    final internal = this.toList();
    internal.sort((a, b) {
      return b.compareTo(a);
    });
    return internal;
  }
}

extension StringExt on String {
  bool get isEmptyOrWhiteSpace {
    return this.trim().isEmpty;
  }

  bool get isNotEmptyOrWhiteSpace {
    return !this.isEmptyOrWhiteSpace;
  }
}
