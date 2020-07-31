// public
import 'defensive.dart';
import 'extensions.dart';

class ValidationErrors {
  final _errors = <String, Object>{};

  Object getError(String propertyName) {
    if (propertyName == null || propertyName.trim().isEmpty) return null;
    propertyName = propertyName.trim();

    if (!propertyName.contains(".")) {
      if (this._errors.containsKey(propertyName)) return this._errors[propertyName];
      return null;
    }

    final split = propertyName.split(".");
    dynamic current = this._errors;

    for (var i = 0; i < split.length; i++) {
      if (current == null) return null;
      if (current is Map<String, dynamic>) {
        if (!(current as Map<String, dynamic>).containsKey(split[i])) return null;
        current = current[split[i]];
        continue;
      }
      if (current is ValidationErrors) return current.getError(split.sublist(i).join("."));

      // if the top level validation fails then error blow is thrown.
      // validate the top level first before validating a second level error. 

      throw Exception(
          "In Map $this the value for key = ${split.getRange(0, i).join(".")} expected Map<String, dynamic> or ValidationErrors got ${current.runtimeType} [$current]");
    }

    return current as Object;
  }

  void _setError(String propertyName, Object value) {
    this._errors.setValue(propertyName, value);
  }

  @override
  String toString() {
    return this._errors.toString();
  }
}

class Validator<T extends Object> {
  final _propertyValidators = <_InternalPropertyValidator<T, Object>>[];
  final _errors = ValidationErrors();
  var _hasErrors = false;
  var _isEnabled = true;

  bool get isValid => !this._hasErrors;
  bool get hasErrors => this._hasErrors;
  ValidationErrors get errors => this._errors;
  bool get hasRules => this._propertyValidators.isNotEmpty;
  bool get isEnabled => this._isEnabled;

  Validator({bool disabled = false}) {
    this._isEnabled = !disabled;
  }

  PropertyValidator<T, TProperty> prop<TProperty>(
      String propertyName, TProperty Function(T value) propertyFunc) {
    given(propertyName, "propertyName").ensureHasValue();
    given(propertyFunc, "propertyFunc").ensureHasValue();
    final propertyValidator =
        new _InternalPropertyValidator<T, TProperty>(propertyName, propertyFunc);
    this._propertyValidators.add(propertyValidator);
    this._errors._setError(propertyName, null); //[propertyName] = null;
    return propertyValidator;
  }

  void clearProp(String propertyName) {
    given(propertyName, "propertyName").ensureHasValue();
    final propertyValidator = this
        ._propertyValidators
        .firstWhere((t) => t.propertyName == propertyName, orElse: () => null);
    if (propertyValidator == null) return;

    this._propertyValidators.remove(propertyValidator);
    this._errors._setError(propertyName, null);
    // this._errors[propertyName] = null;
  }

  void validate(T value) {
    given(value, "value").ensureHasValue();
    this._hasErrors = false;
    if (this._isEnabled) {
      this._propertyValidators.forEach((t) {
        t.validate(value);
        if (t.hasError) {
          this._hasErrors = true;
          this._errors._setError(t.propertyName, t.error);
          // this._errors[t.propertyName] = t.error;
          return;
        }

        // this._errors[t.propertyName] = null;
        this._errors._setError(t.propertyName, null);
      });
    } else {
      // this._propertyValidators.forEach((t) => this._errors[t.propertyName] = null);
      this._propertyValidators.forEach((t) => this._errors._setError(t.propertyName, null));
    }
  }

  void enable() {
    this._isEnabled = true;
  }

  void disable() {
    this._isEnabled = false;
  }
}

// public
abstract class PropertyValidator<T, TProperty> {
  PropertyValidator<T, TProperty> isRequired();
  PropertyValidator<T, TProperty> isOptional();
  // ensureIsBoolean(): PropertyValidator<T, TProperty>;
  // ensureIsString(): PropertyValidator<T, TProperty>;
  // ensureIsNumber(): PropertyValidator<T, TProperty>;
  // ensureIsObject(): PropertyValidator<T, TProperty>;
  // ensureIsArray(): PropertyValidator<T, TProperty>;

  PropertyValidator<T, TProperty> ensure(bool Function(TProperty t) validationPredicate);
  PropertyValidator<T, TProperty> useValidationRule(ValidationRule<TProperty> validationRule);
  PropertyValidator<T, TProperty> useValidator(Validator<TProperty> validator);

  PropertyValidator<T, TProperty> ensureT(bool Function(T value) validationPredicate);
  PropertyValidator<T, TProperty> when(bool Function(T value) conditionPredicate);
  PropertyValidator<T, TProperty> withMessage({String message, String Function() messageFunc});
}

// public
abstract class ValidationRule<T> {
  Object get error;
  bool validate(T value);

  factory ValidationRule(bool Function(T val) validationFunc, String error) {
    given(validationFunc, "validationFunc").ensureHasValue();
    given(error, "error").ensureHasValue();
    return new _ConcreteValidationRule(validationFunc, error);
  }
}

class _ConcreteValidationRule<T> implements ValidationRule<T> {
  final Object _error;
  final bool Function(T) _validate;

  @override
  Object get error => this._error;

  _ConcreteValidationRule(bool Function(T) validationFunc, Object error)
      : this._validate = validationFunc,
        this._error = error;

  @override
  bool validate(T value) {
    return this._validate(value);
  }
}

class _InternalPropertyValidator<T, TProperty> implements PropertyValidator<T, TProperty> {
  final String _propertyName;
  final TProperty Function(T) _propertyFunc;
  var _hasError = false;
  Object _error;
  final _validationRules = <_InternalPropertyValidationRule<T, TProperty>>[];
  _InternalPropertyValidationRule<T, TProperty> _lastValidationRule;
  bool Function(T) _conditionPredicate;
  var _overrideError = false;
  String _errorMessage;
  String Function() _errorMessageFunc;

  String get propertyName => this._propertyName;
  bool get hasError => this._hasError;
  dynamic get error => this._error;

  _InternalPropertyValidator(String propertyName, TProperty Function(T) propertyFunc)
      : this._propertyName = propertyName,
        this._propertyFunc = propertyFunc;

  void validate(T value) {
    this._hasError = false;
    this._error = null;

    if (this._conditionPredicate != null && !this._conditionPredicate(value)) return;

    final propertyVal = this._propertyFunc(value);

    for (var i = 0; i < this._validationRules.length; i++) {
      final validationRule = this._validationRules[i];
      var validationResult = true;

      try {
        validationResult = validationRule.validate(value, propertyVal);
      } catch (e) {
        if (e == "OPTIONAL") break;

        rethrow;
      }

      if (!validationResult) {
        this._hasError = true;
        // this._error = this._overrideError ? this._errorMessage : validationRule.error;
        var error = validationRule.error;
        if (this._overrideError && !validationRule.overrideError)
          error = this._errorMessageFunc != null ? this._errorMessageFunc() : this._errorMessage;
        this._error = error;
        break;
      }
    }
  }

  @override
  PropertyValidator<T, TProperty> isRequired() {
    this._lastValidationRule = new _InternalPropertyValidationRule<T, TProperty>();
    this._lastValidationRule.ensure((propertyValue) {
      if (propertyValue != null) {
        if (propertyValue is String) {
          return propertyValue.trim().isNotEmpty;
        }
        return true;
      }
      return false;
    });

    this._lastValidationRule.withMessage(message: "Required");
    this._validationRules.add(this._lastValidationRule);
    return this;
  }

  @override
  PropertyValidator<T, TProperty> isOptional() {
    this._lastValidationRule = new _InternalPropertyValidationRule<T, TProperty>();
    this._lastValidationRule.ensure((propertyValue) {
      if (propertyValue == null) throw "OPTIONAL";

      if (propertyValue is String && propertyValue.trim().isEmpty) throw "OPTIONAL";

      return true;
    });

    this._validationRules.add(this._lastValidationRule);
    return this;
  }

  @override
  PropertyValidator<T, TProperty> ensure(bool Function(TProperty) propertyValidationPredicate) {
    given(propertyValidationPredicate, "propertyValidationPredicate").ensureHasValue();
    this._lastValidationRule = new _InternalPropertyValidationRule<T, TProperty>();
    this._lastValidationRule.ensure(propertyValidationPredicate);
    this._validationRules.add(this._lastValidationRule);
    return this;
  }

  @override
  PropertyValidator<T, TProperty> ensureT(bool Function(T) valueValidationPredicate) {
    given(valueValidationPredicate, "valueValidationPredicate").ensureHasValue();
    this._lastValidationRule = new _InternalPropertyValidationRule<T, TProperty>();
    this._lastValidationRule.ensureT(valueValidationPredicate);
    this._validationRules.add(this._lastValidationRule);
    return this;
  }

  @override
  PropertyValidator<T, TProperty> useValidationRule(ValidationRule<TProperty> validationRule) {
    given(validationRule, "validationRule").ensureHasValue();
    this._lastValidationRule = new _InternalPropertyValidationRule<T, TProperty>();
    this._lastValidationRule.useValidationRule(validationRule);
    this._validationRules.add(this._lastValidationRule);
    return this;
  }

  @override
  PropertyValidator<T, TProperty> useValidator(Validator<TProperty> validator) {
    given(validator, "validator").ensureHasValue();
    this._lastValidationRule = new _InternalPropertyValidationRule<T, TProperty>();
    this._lastValidationRule.useValidator(validator);
    this._validationRules.add(this._lastValidationRule);
    return this;
  }

  @override
  PropertyValidator<T, TProperty> when(bool Function(T) conditionPredicate) {
    given(conditionPredicate, "conditionPredicate").ensureHasValue();
    if (this._lastValidationRule == null)
      this._conditionPredicate = conditionPredicate;
    else
      this._lastValidationRule.when(conditionPredicate);

    return this;
  }

  @override
  PropertyValidator<T, TProperty> withMessage({String message, String Function() messageFunc}) {
    if (message == null && messageFunc == null)
      throw new ArgumentError("Either message or messagefunc has to be provided");
    if (this._lastValidationRule == null) {
      this._overrideError = true;
      this._errorMessage = message;
      this._errorMessageFunc = messageFunc;
    } else
      this
          ._lastValidationRule
          .withMessage(message: message, messageFunc: messageFunc, overrideError: true);

    return this;
  }
}

class _InternalPropertyValidationRule<T, TProperty> {
  bool Function(TProperty) _tpropertyValidationPredicate;
  bool Function(T) _tValidationPredicate;
  ValidationRule<TProperty> _validationRule;
  Validator<TProperty> _validator;
  bool Function(T) _conditionPredicate;
  String _errorMessage;
  String Function() _errorFunc;
  var _overrideError = false;

  Object get error {
    if (this._validationRule != null && !this._overrideError)
      return this._validationRule.error;
    else if (this._validator != null && !this._overrideError)
      return this._validator.errors;
    else
      return this._errorFunc != null ? this._errorFunc() : this._errorMessage;
  }

  bool get overrideError => this._overrideError;

  void ensure(bool Function(TProperty) tpropertyValidationPredicate) {
    this._tpropertyValidationPredicate = tpropertyValidationPredicate;
    this._errorMessage = "Invalid value";
  }

  void ensureT(bool Function(T) tValidationPredicate) {
    this._tValidationPredicate = tValidationPredicate;
    this._errorMessage = "Invalid value";
  }

  void useValidationRule(ValidationRule<TProperty> validationRule) {
    this._validationRule = validationRule;
  }

  void useValidator(Validator<TProperty> validator) {
    this._validator = validator;
  }

  void when(bool Function(T) conditionPredicate) {
    this._conditionPredicate = conditionPredicate;
  }

  void withMessage({String message, String Function() messageFunc, bool overrideError = false}) {
    this._errorMessage = message;
    this._errorFunc = messageFunc;
    this._overrideError = overrideError;
  }

  bool validate(T value, TProperty propertyValue) {
    if (this._conditionPredicate != null && !this._conditionPredicate(value)) return true;

    if (this._tpropertyValidationPredicate != null)
      return this._tpropertyValidationPredicate(propertyValue);

    if (this._tValidationPredicate != null) return this._tValidationPredicate(value);

    if (this._validationRule != null) return this._validationRule.validate(propertyValue);

    if (this._validator != null) {
      this._validator.validate(propertyValue);
      return this._validator.isValid;
    }

    throw new Exception("Validate");
  }
}

// public
abstract class BaseValidationRule<T> implements ValidationRule<T> {
  final _validationRules = <ValidationRule<T>>[];
  dynamic _error;

  @override
  Object get error => this._error;

  @override
  bool validate(T value) {
    this._error = null;
    for (var i = 0; i < this._validationRules.length; i++) {
      if (this._validationRules[i].validate(value)) continue;
      this._error = this._validationRules[i].error;
      return false;
    }
    return true;
  }

  void addValidationRule(ValidationRule<T> validationRule) {
    this._validationRules.add(validationRule);
  }
}

// public
abstract class BaseNumberValidationRule<T extends num> extends BaseValidationRule<T> {}

class _NumberHasMinValue<T extends num> extends BaseNumberValidationRule<T> {
  _NumberHasMinValue(num minValue) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) => t == null || t >= minValue, "Value cannot be less than $minValue"));
  }
}

class _NumberHasMaxValue<T extends num> extends BaseNumberValidationRule<T> {
  _NumberHasMaxValue(num maxValue) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) => t == null || t <= maxValue, "Value cannot be greater than $maxValue"));
  }
}

class _NumberHasExactValue<T extends num> extends BaseNumberValidationRule<T> {
  _NumberHasExactValue(num exactValue) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) => t == null || t == exactValue, "Value has to be $exactValue"));
  }
}

class _NumberIsIn<T extends num> extends BaseNumberValidationRule<T> {
  _NumberIsIn(List<num> values) {
    this.addValidationRule(
        new _ConcreteValidationRule((t) => t == null || values.contains(t), "Invalid value"));
  }
}

class _NumberIsNotIn<T extends num> extends BaseNumberValidationRule<T> {
  _NumberIsNotIn(List<num> values) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) => t == null || values.every((u) => u != t), "Invalid value"));
  }
}

// public
abstract class BaseStringValidationRule extends BaseValidationRule<String> {
  bool isNumber(String value) {
    value = value.trim();
    if (value.isEmpty) return false;
    final parsed = num.tryParse(value);
    return parsed != null;
  }
}

class _StringHasMinLength extends BaseStringValidationRule {
  _StringHasMinLength(num minLength) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) => t == null || t.trim().length >= minLength, "Min length of $minLength required"));
  }
}

class _StringHasMaxLength extends BaseStringValidationRule {
  _StringHasMaxLength(num maxLength) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) => t == null || t.trim().length <= maxLength, "Max length of $maxLength required"));
  }
}

class _StringHasExactLength extends BaseStringValidationRule {
  _StringHasExactLength(num exactLength) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) => t == null || t.trim().length == exactLength,
        "Exact length of $exactLength required"));
  }
}

class _StringIsIn extends BaseStringValidationRule {
  _StringIsIn(List<String> values, [bool ignoreCase = false]) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) =>
            t == null ||
            (ignoreCase
                ? values.any((v) => v?.trim()?.toLowerCase() == t.trim().toLowerCase())
                : values.any((v) => v?.trim() == t.trim())),
        "Invalid value"));
  }
}

class _StringIsNotIn extends BaseStringValidationRule {
  _StringIsNotIn(List<String> values, [bool ignoreCase = false]) {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) =>
            t == null ||
            (ignoreCase
                ? values.every((v) => v?.trim()?.toLowerCase() != t.trim().toLowerCase())
                : values.every((v) => v?.trim() != t.trim())),
        "Invalid value"));
  }
}

class _StringContainsOnlyNumbers extends BaseStringValidationRule {
  _StringContainsOnlyNumbers() {
    this.addValidationRule(
        new _ConcreteValidationRule((t) => t == null || this.isNumber(t), "Invalid value"));
  }
}

class _StringIsPhoneNumber extends BaseStringValidationRule {
  _StringIsPhoneNumber() {
    this.addValidationRule(new _ConcreteValidationRule(
        (t) => t == null || (this.isNumber(t) && t.trim().length == 10), "Invalid value"));
  }
}

class _StringIsEmail extends BaseStringValidationRule {
  _StringIsEmail() {
    this.addValidationRule(new _ConcreteValidationRule((t) {
      final re = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      return t == null || re.hasMatch(t.trim());
    }, "Invalid value"));
  }
}

class _StringMatchesRegex extends BaseStringValidationRule {
  _StringMatchesRegex(RegExp regex) {
    this.addValidationRule(
        new _ConcreteValidationRule((t) => t == null || regex.hasMatch(t), "Invalid format"));
  }
}

// public
extension NumberPropertyValidatorExt<T, TProperty extends num> on PropertyValidator<T, TProperty> {
  PropertyValidator<T, TProperty> hasMinValue(TProperty minValue) {
    return this.useValidationRule(new _NumberHasMinValue(minValue));
  }

  PropertyValidator<T, TProperty> hasMaxValue(TProperty maxValue) {
    return this.useValidationRule(new _NumberHasMaxValue(maxValue));
  }

  PropertyValidator<T, TProperty> hasExactValue(TProperty exactValue) {
    return this.useValidationRule(new _NumberHasExactValue(exactValue));
  }

  PropertyValidator<T, TProperty> isInNumbers(List<TProperty> values) {
    return this.useValidationRule(new _NumberIsIn(values));
  }

  PropertyValidator<T, TProperty> isNotInNumbers(List<TProperty> values) {
    return this.useValidationRule(new _NumberIsNotIn(values));
  }
}

// public
extension StringPropertyValidatorExt<T> on PropertyValidator<T, String> {
  PropertyValidator<T, String> hasMinLength(num minLength) {
    return this.useValidationRule(new _StringHasMinLength(minLength));
  }

  PropertyValidator<T, String> hasMaxLength(num maxLength) {
    return this.useValidationRule(new _StringHasMaxLength(maxLength));
  }

  PropertyValidator<T, String> hasExactLength(num exactLength) {
    return this.useValidationRule(new _StringHasExactLength(exactLength));
  }

  PropertyValidator<T, String> isInStrings(List<String> values, [bool ignoreCase = false]) {
    return this.useValidationRule(new _StringIsIn(values, ignoreCase));
  }

  PropertyValidator<T, String> isNotInStrings(List<String> values, [bool ignoreCase = false]) {
    return this.useValidationRule(new _StringIsNotIn(values, ignoreCase));
  }

  PropertyValidator<T, String> containsOnlyNumbers() {
    return this.useValidationRule(new _StringContainsOnlyNumbers());
  }

  PropertyValidator<T, String> isPhoneNumber() {
    return this.useValidationRule(new _StringIsPhoneNumber());
  }

  PropertyValidator<T, String> isEmail() {
    return this.useValidationRule(new _StringIsEmail());
  }

  PropertyValidator<T, String> matchesRegex(RegExp regex) {
    return this.useValidationRule(new _StringMatchesRegex(regex));
  }
}
