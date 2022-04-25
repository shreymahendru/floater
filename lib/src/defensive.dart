import 'extensions.dart';

/// Defensive
///
/// Takes arguments as parameter and can makes sure argument is not empty, null or different value.
/// Based on that you can throw [ErrorMessage].

abstract class Ensurer<T> {
  // Ensurer<T> ensureHasValue();
  Ensurer<T> ensure(bool Function(T t) func, [String? reason]);
}

/// [given] takes an argument of generic type and an argument name as parameter.
/// It checks the provided argument is empty or whiteSpace and throws
/// [ArgumentError] which passes the [message] describing the issue with an argument.
/// Only after passing this check, [given] proceeds to the next step where it returns the argument.
Ensurer<T> given<T>(T arg, String argName) {
  if (argName.isEmptyOrWhiteSpace) throw new ArgumentError("argName can't be empty");

  return new _EnsurerInternal(arg, argName.trim());
}

class _EnsurerInternal<T> extends Ensurer<T> {
  T _arg;
  String _argName;

  _EnsurerInternal(this._arg, this._argName);

  // @override
  // Ensurer<T> ensureHasValue() {
  //   if (this._arg == null) throw new ArgumentError(this._argName);

  //   if (this._arg is String && (this._arg as String).isEmptyOrWhiteSpace)
  //     throw new ArgumentError("Argument ${this._argName} does not not have a value");

  //   return this;
  // }

  @override

  /// [ensure] takes a boolean function and reason as parameter and checks the argument which is
  /// passed by [given]. If it's true, passes. Otherwise, throws an [ErrorMessage] with/without reason
  /// based on the error caused by the argument .
  Ensurer<T> ensure(bool Function(T) func, [String? reason]) {
    if (!func(this._arg)) {
      if (this._argName.toLowerCase() == "this")
        throw new StateError(reason != null && reason.isNotEmptyOrWhiteSpace
            ? "Current operation is invalid due to reason '${reason.trim()}'"
            : "Current operation is invalid");

      throw reason != null && reason.isNotEmptyOrWhiteSpace
          ? new ArgumentError("Argument '${this._argName}' is invalid due to reason '${reason.trim()}'")
          : new ArgumentError("Argument '${this._argName}' is invalid");
    }

    return this;
  }
}
