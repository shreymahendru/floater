import "package:flutter_test/flutter_test.dart";
import 'package:floater/src/validation.dart';

class TestVal {
  String firstName;
  String lastName;
  int age;
  List<int> scores;
  dynamic address;
  String phone;
  String email;
}

void main() {
  TestVal testVal;
  Validator<TestVal> validator;

  setUp(() {
    testVal = new TestVal();
    testVal.firstName = "John";
    testVal.lastName = "doh";
    testVal.age = 31;
    testVal.scores = [200, 400, 800];
    testVal.phone = "1112223456";
    testVal.email = "test@test.com";
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
      expect(validator.isValid, false, reason: "Should be true");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["age"], "Value cannot be less than 18",
      //     reason: "Should have a correct message");

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
      // expect(validator.errors["age"], "Value cannot be greater than 18",
      //     reason: "Should have a correct message");
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
      // expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
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
      // expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("age"), "Invalid value",
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
      // expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("age"), "Invalid value", reason: "Should have a correct message");
    });

    test("should pass when the given set empty", () {
      validator = new Validator<TestVal>();
      final setList = <int>[];
      validator.prop("age", (t) => t.age).isNotInNumbers(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    // test("should fail when the property of the object being validated is null and is in the given set", () {
    //   validator = new Validator<TestVal>();
    //   final setList = [1, 2, 3, null];
    //   validator.prop("age", (t) => t.age).isNotInNumbers(setList);
    //   testVal.age = null;
    //   validator.validate(testVal);
    //   expect(validator.isValid, false, reason: "Should be invalid");
    //   expect(validator.hasErrors, true, reason: "Should have error");
    //   expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
    // });
  });
}
