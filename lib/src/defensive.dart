abstract class Ensurer<T> {
  Ensurer<T> ensureHasValue();
  Ensurer<T> ensure(bool Function(T t) func, [String reason]);
}

Ensurer<T> given<T>(T arg, String argName) {
  if (argName == null || argName.trim().isEmpty) throw new ArgumentError("argName");

  return new _EnsurerInternal(arg, argName.trim());
}

class _EnsurerInternal<T> extends Ensurer<T> {
  T _arg;
  String _argName;

  _EnsurerInternal(T arg, String argName) {
    this._arg = arg;
    this._argName = argName;
  }

  @override
  Ensurer<T> ensureHasValue() {
    if (this._arg == null) throw new ArgumentError(this._argName);

    if (this._arg is String && (this._arg as String).trim().isEmpty)
      throw new ArgumentError("Argument ${this._argName} does not not have a value");

    return this;
  }

  @override
  Ensurer<T> ensure(bool Function(T) func, [String reason]) {
    if (func == null) throw new ArgumentError("func");

    if (this._arg == null) return this;

    if (!func(this._arg)) {
      if (this._argName.toLowerCase() == "this")
        throw new StateError(reason != null && reason.trim().isNotEmpty
            ? "Current operation is invalid due to reason '${reason.trim()}'"
            : "Current operation is invalid");

      throw reason != null && reason.trim().isNotEmpty
          ? new ArgumentError(
              "Argument '${this._argName}' is invalid due to reason '${reason.trim()}'")
          : new ArgumentError("Argument '${this._argName}' is invalid");
    }

    return this;
  }
}
