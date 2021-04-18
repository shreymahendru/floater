import "package:flutter_test/flutter_test.dart";
import 'package:floater/src/validation.dart';

class TestVal {
  String firstName;
  String? lastName;
  String email;
  String? email2;
  String phone;
  String? phone2;
  String age;
  String? height;

  TestVal({
    required this.firstName,
    this.lastName,
    required this.email,
    this.email2,
    required this.phone,
    this.phone2,
    required this.age,
    this.height,
  });
}

void main() {
  late TestVal testVal;
  late Validator<TestVal> validator;

  setUp(() {
    testVal = new TestVal(
      firstName: "John",
      lastName: "doh",
      phone: "1112223456",
      email: "test@test.com",
      age: "26",
      height: "6",
      phone2: "1231231234",
      email2: "test1@test.com",
    );
  });

  group("hasMinLength", () {
    test(
        "should pass when the property of the object being validated has length greater than 3",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMinLength(3);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated has length less than 3",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMinLength(3);
      testVal.firstName = "Jo";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("firstName"), "Min length of 3 required",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the property of the object being validated is an empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMinLength(3);
      testVal.firstName = "";
      validator.validate(testVal);
      expect(validator.isValid, false);
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("firstName"), "Min length of 3 required",
          reason: "Should have a correct message");
    });
    test(
        "should pass when nullable property of the object being validated has length greater than 3",
        () {
      validator = new Validator<TestVal>();
      testVal.lastName = "Joseph";

      validator.prop("lastName", (t) => t.lastName).hasMinLength(3);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should pass when nullable property of the object being validated is null",
        () {
      validator = new Validator<TestVal>();
      testVal.lastName = null;

      validator.prop("lastName", (t) => t.lastName).hasMinLength(3);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when nullable property of the object being validated has length less than 3",
        () {
      validator = new Validator<TestVal>();
      validator.prop("lastName", (t) => t.lastName).hasMinLength(3);
      testVal.lastName = "Jo";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("lastName"), "Min length of 3 required",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the nullable property of the object being validated is an empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("lastName", (t) => t.lastName).hasMinLength(3);
      testVal.lastName = "";
      validator.validate(testVal);
      expect(validator.isValid, false);
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("lastName"), "Min length of 3 required",
          reason: "Should have a correct message");
    });
  });

  group("hasMaxLength", () {
    test(
        "should pass when the property of the object being validated has length less than 5",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMaxLength(5);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated has length greater than 5",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMaxLength(5);
      testVal.firstName = "thisIsAVeryLongName";
      validator.validate(testVal);

      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("firstName"), "Max length of 5 required",
          reason: "Should have a correct message");
    });

    test(
        "should pass when the property of the object being validated is an empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMaxLength(5);
      testVal.firstName = "";
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should pass when nullable property of the object being validated has length less than 5",
        () {
      validator = new Validator<TestVal>();
      validator.prop("lastName", (t) => t.lastName).hasMaxLength(5);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should pass when nullable property of the object being validated is null",
        () {
      validator = new Validator<TestVal>();
      testVal.lastName = null;
      validator.prop("lastName", (t) => t.lastName).hasMaxLength(5);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when nullable property of the object being validated has length greater than 5",
        () {
      validator = new Validator<TestVal>();
      testVal.lastName = "thisIsAVeryLongName";
      validator.prop("lastName", (t) => t.lastName).hasMaxLength(5);
      validator.validate(testVal);

      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("lastName"), "Max length of 5 required",
          reason: "Should have a correct message");
    });

    test(
        "should pass when nullable property of the object being validated is an empty string",
        () {
      validator = new Validator<TestVal>();
      testVal.lastName = "";
      validator.prop("lastName", (t) => t.lastName).hasMaxLength(5);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });
  });

  group("hasExactLength", () {
    test(
        "should pass when the property of the object being validated has length exactly 4",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasExactLength(4);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated has length greater than 4",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasExactLength(4);
      testVal.firstName = "thisIsAVeryLongName";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(
          validator.errors.getError("firstName"), "Exact length of 4 required",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the property of the object being validated has length less than 4",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasExactLength(4);
      testVal.firstName = "Jo";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(
          validator.errors.getError("firstName"), "Exact length of 4 required",
          reason: "Should have a correct message");
    });

    test(
        "should pass when nullable property of the object being validated has length exactly 4",
        () {
      validator = new Validator<TestVal>();
      testVal.lastName = "Step";
      validator.prop("lastName", (t) => t.lastName).hasExactLength(4);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when nullable property of the object is null", () {
      validator = new Validator<TestVal>();
      testVal.lastName = null;
      validator.prop("lastName", (t) => t.lastName).hasExactLength(4);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when nullable property of the object being validated has length greater than 4",
        () {
      validator = new Validator<TestVal>();
      validator.prop("lastName", (t) => t.lastName).hasExactLength(4);
      testVal.lastName = "thisIsAVeryLongName";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(
          validator.errors.getError("lastName"), "Exact length of 4 required",
          reason: "Should have a correct message");
    });

    test(
        "should fail when nullable property of the object being validated has length less than 4",
        () {
      validator = new Validator<TestVal>();
      validator.prop("lastName", (t) => t.lastName).hasExactLength(4);
      testVal.lastName = "Jo";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(
          validator.errors.getError("lastName"), "Exact length of 4 required",
          reason: "Should have a correct message");
    });
  });

  group("isIn", () {
    test(
        "should pass when the property of the object being validated is in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "John"];
      validator.prop("firstName", (t) => t.firstName).isInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated is not in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test"];
      validator.prop("firstName", (t) => t.firstName).isInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("firstName"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should fail when the given set empty", () {
      validator = new Validator<TestVal>();
      final setList = <String>[];
      validator.prop("firstName", (t) => t.firstName).isInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("firstName"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should pass when the property of the object being validated is in the given set(ignoreCase =true)",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "JOHN"];
      validator
          .prop("firstName", (t) => t.firstName)
          .isInStrings(setList, true);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should pass when nullable property of the object being validated is in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "John"];
      testVal.lastName = "test";
      validator.prop("lastName", (t) => t.lastName).isInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when nullable property of the object is null", () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "John"];
      testVal.lastName = null;
      validator.prop("lastName", (t) => t.lastName).isInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when nullable property of the object being validated is not in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test"];
      validator.prop("lastName", (t) => t.lastName).isInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("lastName"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should pass when nullable property of the object being validated is in the given set(ignoreCase =true)",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "JOHN"];
      testVal.lastName = "jo";
      validator.prop("lastName", (t) => t.lastName).isInStrings(setList, true);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });
  });

  group("isNotIn", () {
    test(
        "should pass when the property of the object being validated is not in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test"];
      validator.prop("firstName", (t) => t.firstName).isNotInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated is in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "John"];
      validator.prop("firstName", (t) => t.firstName).isNotInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");

      expect(validator.errors.getError("firstName"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should pass when the given set empty", () {
      validator = new Validator<TestVal>();
      final setList = <String>[];
      validator.prop("firstName", (t) => t.firstName).isNotInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated is in the given set(ignoreCase =true)",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "JOHN"];
      validator
          .prop("firstName", (t) => t.firstName)
          .isNotInStrings(setList, true);
      validator.validate(testVal);
      expect(validator.isValid, false);
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("firstName"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should pass when nullable property of the object being validated is not in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test"];
      validator.prop("lastName", (t) => t.lastName).isNotInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when nullable property of the object is null", () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test"];
      testVal.lastName = null;
      validator.prop("lastName", (t) => t.lastName).isNotInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when nullable property of the object being validated is in the given set",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "John"];
      testVal.lastName = "John";
      validator.prop("lastName", (t) => t.lastName).isNotInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");

      expect(validator.errors.getError("lastName"), "Invalid value",
          reason: "Should have a correct message");
    });
    test(
        "should fail when nullable property of the object being validated is in the given set(ignoreCase =false)",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "JOHN"];
      testVal.lastName = "John";
      validator
          .prop("lastName", (t) => t.lastName)
          .isNotInStrings(setList, true);
      validator.validate(testVal);
      expect(validator.isValid, false);
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("lastName"), "Invalid value",
          reason: "Should have a correct message");
    });
  });

  group("containsOnlyNumbers", () {
    test(
        "should pass when the property of the object being validated contain only numbers",
        () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).containsOnlyNumbers();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated contains no numbers",
        () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).containsOnlyNumbers();
      testVal.age = "no-age";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the property of the object being validated contains numbers and letters",
        () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).containsOnlyNumbers();
      testVal.age = "25years";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the property of the object being validated is an empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).containsOnlyNumbers();
      testVal.age = "";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should pass when the property of the object being validated contain only numbers",
        () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).containsOnlyNumbers();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should pass when nullable property of the object is null", () {
      validator = new Validator<TestVal>();
      testVal.height = null;
      validator.prop("height", (t) => t.height).containsOnlyNumbers();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when nullable property of the object being validated contains no numbers",
        () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).containsOnlyNumbers();
      testVal.height = "no-height";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("height"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when nullable property of the object being validated contains numbers and letters",
        () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).containsOnlyNumbers();
      testVal.height = "25years";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("height"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when nullable property of the object being validated is an empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("height", (t) => t.height).containsOnlyNumbers();
      testVal.height = "";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("height"), "Invalid value",
          reason: "Should have a correct message");
    });
  });

  group("isPhoneNumber", () {
    test(
        "should pass when the property of the object being validated is a valid phone number",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated contains letters",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      testVal.phone = "1sa4567292";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("phone"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the property of the object being validated has length less than 10",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      testVal.phone = "1232112";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("phone"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the property of the object being validated has length greater than 10",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      testVal.phone = "12321231231231212";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("phone"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the property of the object being validated is an empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      testVal.phone = "";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("phone"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should pass when nullable property of the object being validated is a valid phone number",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone2", (t) => t.phone2).isPhoneNumber();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should pass when nullable property of the object being validated is null",
        () {
      validator = new Validator<TestVal>();
      testVal.phone2 = null;
      validator.prop("phone2", (t) => t.phone2).isPhoneNumber();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when nullable property of the object being validated contains letters",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone2", (t) => t.phone2).isPhoneNumber();
      testVal.phone2 = "1sa4567292";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("phone2"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when nullable property of the object being validated has length less than 10",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone2", (t) => t.phone2).isPhoneNumber();
      testVal.phone2 = "1232112";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("phone2"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when nullable property of the object being validated has length greater than 10",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone2", (t) => t.phone2).isPhoneNumber();
      testVal.phone2 = "12321231231231212";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("phone2"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when nullable property of the object being validated is an empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone2", (t) => t.phone2).isPhoneNumber();
      testVal.phone2 = "";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("phone2"), "Invalid value",
          reason: "Should have a correct message");
    });
  });

  group("isEmail", () {
    test(
        "should pass when the property of the object being validated is a valid email",
        () {
      validator = new Validator<TestVal>();
      validator.prop("email", (t) => t.email).isEmail();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when the property of the object being validated is a invalid email",
        () {
      validator = new Validator<TestVal>();
      validator.prop("email", (t) => t.email).isEmail();
      testVal.email = "test.com";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("email"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when the property of the object being validated is a empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("email", (t) => t.email).isEmail();
      testVal.email = "";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("email"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should pass when the property of the object being validated is a valid email",
        () {
      validator = new Validator<TestVal>();
      validator.prop("email", (t) => t.email).isEmail();
      testVal.email = "test1.tester@mail.tester.ca";
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should pass when nullable property of the object being validated is a valid email",
        () {
      validator = new Validator<TestVal>();
      validator.prop("email2", (t) => t.email2).isEmail();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should pass when nullable property of the object being validated is null",
        () {
      validator = new Validator<TestVal>();
      testVal.email2 = null;
      validator.prop("email2", (t) => t.email2).isEmail();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test(
        "should fail when nullable property of the object being validated is a invalid email",
        () {
      validator = new Validator<TestVal>();
      validator.prop("email2", (t) => t.email2).isEmail();
      testVal.email2 = "test.com";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("email2"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should fail when nullable property of the object being validated is a empty string",
        () {
      validator = new Validator<TestVal>();
      validator.prop("email2", (t) => t.email2).isEmail();
      testVal.email2 = "";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      expect(validator.errors.getError("email2"), "Invalid value",
          reason: "Should have a correct message");
    });
  });
}
