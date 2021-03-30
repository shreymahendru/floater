import "package:flutter_test/flutter_test.dart";
import 'package:floater/src/validation.dart';

class Stats {
  int stat1;
  int stat2;

  Stats(this.stat1, this.stat2);
}

class TestVal {
  String firstName;
  String? lastName;
  int age;
  int? height;
  List<int> scores;
  List<int>? oldScores;
  dynamic address;
  bool? active;
  Stats? stats;

  TestVal({
    required this.firstName,
    this.lastName,
    required this.age,
    this.height,
    required this.scores,
    this.oldScores,
    this.address,
    this.active,
  });
}

void main() {
  late TestVal testVal;
  late Validator<TestVal> validator;

  setUp(() {
    testVal = new TestVal(
      firstName: "John",
      lastName: "doh",
      age: 31,
      height: 6,
      scores: [200, 400, 800],
      oldScores: null,
      address: {"street": "15 Benton rd", "province": "ON"},
      active: true,
    );
  });

  group("hasMinValue", () {
    test("should pass when the property of the object being validated has value greater than 18",
        () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).hasMinValue(18);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated has value less than 18", () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).hasMinValue(18);
      testVal.age = 16;
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be false");
      expect(validator.hasErrors, true, reason: "Should have error");

      expect(validator.errors.getError("age"), "Value cannot be less than 18",
          reason: "Should have a correct message");
    });

    test("should pass when the property of the object being validated has value equal to 18", () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).hasMinValue(18);
      testVal.age = 18;
      validator.validate(testVal);
      expect(validator.isValid, true, reason: "Should be true");
    });

    test(
        "should pass when nullable property of the object being validated has value greater than 18",
        () {
      validator = new Validator<TestVal>();
      testVal.height = 20;
      validator.prop("height", (t) => t.height).hasMinValue(18);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when nullable property of the object being validated has value of null", () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).hasMinValue(18);
      testVal.height = null;
      validator.validate(testVal);

      expect(validator.isValid, true, reason: "Should be false");
      expect(validator.hasErrors, false, reason: "Should not have error");
    });

    test("should fail when nullable property of the object being validated has value less than 18",
        () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).hasMinValue(18);
      testVal.height = 16;
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be false");
      expect(validator.hasErrors, true, reason: "Should have error");

      expect(validator.errors.getError("height"), "Value cannot be less than 18",
          reason: "Should have a correct message");
    });

    test("should pass when nullable property of the object being validated has value equal to 18",
        () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).hasMinValue(18);
      testVal.height = 18;
      validator.validate(testVal);
      expect(validator.isValid, true, reason: "Should be true");
    });
  });

  group("hasMaxValue", () {
    test("should pass when the property of the object being validated has value is less than 18",
        () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).hasMaxValue(18);
      testVal.age = 16;
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated has value is greater than 18",
        () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).hasMaxValue(18);
      testVal.age = 26;
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be true");
      expect(validator.hasErrors, true, reason: "Should have error");

      expect(validator.errors.getError("age"), "Value cannot be greater than 18",
          reason: "Should have a correct message");
    });

    test("should pass when the property of the object being validated has value equal to 18", () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).hasMaxValue(18);
      testVal.age = 18;
      validator.validate(testVal);
      expect(validator.isValid, true, reason: "Should be true");
    });

    test("should pass when nullable property of the object being validated has value less than 18",
        () {
      validator = new Validator<TestVal>();
      testVal.height = 2;
      validator.prop("height", (t) => t.height).hasMaxValue(18);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when nullable property of the object being validated has value of null", () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).hasMaxValue(18);
      testVal.height = null;
      validator.validate(testVal);

      expect(validator.isValid, true, reason: "Should be false");
      expect(validator.hasErrors, false, reason: "Should not have error");
    });

    test(
        "should fail when nullable property of the object being validated has value is greater than 18",
        () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).hasMaxValue(18);
      testVal.height = 26;
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be true");
      expect(validator.hasErrors, true, reason: "Should have error");

      expect(validator.errors.getError("height"), "Value cannot be greater than 18",
          reason: "Should have a correct message");
    });

    test("should pass when nullable property of the object being validated has value equal to 18",
        () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).hasMaxValue(18);
      testVal.height = 18;
      validator.validate(testVal);
      expect(validator.isValid, true, reason: "Should be true");
    });
  });

  group("isIn", () {
    test("should pass when the property of the object being validated is in the given set", () {
      validator = new Validator<TestVal>();
      final setList = [12, 323, 18, 25, 31];
      validator.prop("age", (t) => t.age).isInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated is not in the given set", () {
      validator = new Validator<TestVal>();
      final setList = [1, 2, 3, 4];
      validator.prop("age", (t) => t.age).isInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");

      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should fail when the given set empty", () {
      validator = new Validator<TestVal>();
      final setList = <int>[];
      validator.prop("age", (t) => t.age).isInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");

      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should pass when nullable property of the object being validated is in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = [12, 323, 18, 25, 31];
      testVal.height = 323;
      validator.prop("height", (t) => t.height).isInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when nullable property of the object being validated is null", () {
      validator = new Validator<TestVal>();
      final setList = [12, 323, 18, 25, 31];
      testVal.height = null;
      validator.prop("height", (t) => t.height).isInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when nullable property of the object being validated is not in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = [1, 2, 3, 4];
      testVal.height = 323;
      validator.prop("height", (t) => t.height).isInNumbers(setList);

      validator.validate(testVal);

      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("height"), "Invalid value",
          reason: "Should have a correct message");
    });
  });

  group("isNotIn", () {
    test("should pass when the property of the object being validated is not in the given set", () {
      validator = new Validator<TestVal>();
      final setList = [12, 323, 18, 25];
      validator.prop("age", (t) => t.age).isNotInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated is in the given set", () {
      validator = new Validator<TestVal>();
      final setList = [1, 2, 3, 4, 31];
      validator.prop("age", (t) => t.age).isNotInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should pass when the given set empty", () {
      validator = new Validator<TestVal>();
      final setList = <int>[];
      validator.prop("age", (t) => t.age).isNotInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when nullable property of the object being validated is not in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = [12, 323, 18, 25];
      testVal.height = 213;
      validator.prop("height", (t) => t.height).isNotInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when the property is set to null", () {
      validator = new Validator<TestVal>();
      final setList = <int>[];
      testVal.height = null;
      validator.prop("height", (t) => t.height).isNotInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when nullable property of the object being validated is in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = [1, 2, 3, 4, 31];
      testVal.height = 2;
      validator.prop("height", (t) => t.height).isNotInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("height"), "Invalid value",
          reason: "Should have a correct message");
    });
  });
}
