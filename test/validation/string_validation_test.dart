import "package:flutter_test/flutter_test.dart";
import 'package:floater/src/validation.dart';

class TestVal {
  String firstName;
  String lastName;
  String age;
  List<dynamic> scores;
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
    testVal.age = "31";
    testVal.scores = [200, 400, 800];
    testVal.phone = "1112223456";
    testVal.email = "test@test.com";
  });

  group("hasMinLength", () {
    test("should pass when the property of the object being validated has length greater than 3",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMinLength(3);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated has length less than 3", () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMinLength(3);
      testVal.firstName = "Jo";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Min length of 3 required",
      //     reason: "Should have a correct message");
      expect(validator.errors.getError("firstName"), "Min length of 3 required",
          reason: "Should have a correct message");
    });

    test("should fail when the property of the object being validated is an empty string", () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMinLength(3);
      testVal.firstName = "";
      validator.validate(testVal);
      expect(validator.isValid, false);
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Min length of 3 required",
      //     reason: "Should have a correct message");
      expect(validator.errors.getError("firstName"), "Min length of 3 required",
          reason: "Should have a correct message");
    });

    // test("should fail when the property of the object being validated is null", ()
    // {
    //     validator = new Validator<TestVal>();
    //     validator.prop("firstName", (t) => t.firstName).hasMinLength(3);
    //     testVal.firstName = null;
    //     validator.validate(testVal);
    //    expect(validator.isValid, false);
    //    expect(validator.hasErrors, true, reason: "Should have error");
    //    expect(validator.errors["firstName"], "Invalid value", reason: "Should have a correct message");
    // });
  });

  group("hasMaxLength", () {
    test("should pass when the property of the object being validated has length less than 5", () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMaxLength(5);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated has length greater than 5",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMaxLength(5);
      testVal.firstName = "thisIsAVeryLongName";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Max length of 5 required",
      //     reason: "Should have a correct message");
      expect(validator.errors.getError("firstName"), "Max length of 5 required",
          reason: "Should have a correct message");
    });

    test("should pass when the property of the object being validated is an empty string", () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasMaxLength(5);
      testVal.firstName = "";
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    // test("should fail when the property of the object being validated is null", ()
    // {
    //     validator = new Validator<TestVal>();
    //     validator.prop("firstName", (t) => t.firstName).hasMaxLength(5);
    //     testVal.firstName = null;
    //     validator.validate(testVal);
    //    expect(validator.isValid, false);
    //    expect(validator.hasErrors, true, reason: "Should have error");
    //    expect(validator.errors["firstName"], "Invalid value", reason: "Should have a correct message");
    // });
  });

  group("hasExactLength", () {
    test("should pass when the property of the object being validated has length exactly 4", () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasExactLength(4);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated has length greater than 4",
        () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasExactLength(4);
      testVal.firstName = "thisIsAVeryLongName";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Exact length of 4 required",
      //     reason: "Should have a correct message");
      expect(validator.errors.getError("firstName"), "Exact length of 4 required",
          reason: "Should have a correct message");
    });

    test("should fail when the property of the object being validated has length less than 4", () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasExactLength(4);
      testVal.firstName = "Jo";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Exact length of 4 required",
      //     reason: "Should have a correct message");
      expect(validator.errors.getError("firstName"), "Exact length of 4 required",
          reason: "Should have a correct message");
    });

    test("should pass when the property of the object being validated is an empty string", () {
      validator = new Validator<TestVal>();
      validator.prop("firstName", (t) => t.firstName).hasExactLength(4);
      testVal.firstName = "";
      validator.validate(testVal);
      expect(validator.isValid, false);
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Exact length of 4 required",
      //     reason: "Should have a correct message");

      expect(validator.errors.getError("firstName"), "Exact length of 4 required",
          reason: "Should have a correct message");
    });

    // test("should fail when the property of the object being validated is null", ()
    // {
    //     validator = new Validator<TestVal>();
    //     validator.prop("firstName", (t) => t.firstName).hasExactLength(4);
    //     testVal.firstName = null;
    //     validator.validate(testVal);
    //    expect(validator.isValid, false);
    //    expect(validator.hasErrors, true, reason: "Should have error");
    //    expect(validator.errors["firstName"], "Invalid value", reason: "Should have a correct message");
    // });
  });

  group("isIn", () {
    test("should pass when the property of the object being validated is in the given set", () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "John"];
      validator.prop("firstName", (t) => t.firstName).isInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated is not in the given set", () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test"];
      validator.prop("firstName", (t) => t.firstName).isInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Invalid value",
      //     reason: "Should have a correct message");
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
      // expect(validator.errors["firstName"], "Invalid value",
      //     reason: "Should have a correct message");
      expect(validator.errors.getError("firstName"), "Invalid value",
          reason: "Should have a correct message");
    });

    test(
        "should pass when the property of the object being validated is in the given set(ignoreCase =true)",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "JOHN"];
      validator.prop("firstName", (t) => t.firstName).isInStrings(setList, true);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });
  });

  group("isNotIn", () {
    test("should pass when the property of the object being validated is not in the given set", () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test"];
      validator.prop("firstName", (t) => t.firstName).isNotInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated is in the given set", () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "John"];
      validator.prop("firstName", (t) => t.firstName).isNotInStrings(setList);
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Invalid value",
      //     reason: "Should have a correct message");
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

    // test("should fail when the property of the object being validated is null and is in the given set", ()
    // {
    //     validator = new Validator<TestVal>();
    //     final setList = ["Jo", "J", "test", null];
    //     validator.prop("firstName", (t) => t.firstName).isNotInStrings(setList);
    //     testVal.firstName = null;
    //     validator.validate(testVal);
    //    expect(validator.isValid, false, reason: "Should be invalid");
    //    expect(validator.hasErrors, true, reason: "Should have error");
    //    expect(validator.errors["firstName"], "Invalid value", reason: "Should have a correct message");
    // });

    test(
        "should fail when the property of the object being validated is in the given set(ignoreCase =true)",
        () {
      validator = new Validator<TestVal>();
      final setList = ["Jo", "J", "test", "JOHN"];
      validator.prop("firstName", (t) => t.firstName).isNotInStrings(setList, true);
      validator.validate(testVal);
      expect(validator.isValid, false);
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["firstName"], "Invalid value",
      //     reason: "Should have a correct message");
      expect(validator.errors.getError("firstName"), "Invalid value",
          reason: "Should have a correct message");
    });
  });

  group("containsOnlyNumbers", () {
    test("should pass when the property of the object being validated contain only numbers", () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).containsOnlyNumbers();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated contains no numbers", () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).containsOnlyNumbers();
      testVal.age = "noage";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should fail when the property of the object being validated contains numbers and letters",
        () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).containsOnlyNumbers();
      testVal.age = "25years";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should fail when the property of the object being validated is an empty string", () {
      validator = new Validator<TestVal>();
      validator.prop("age", (t) => t.age).containsOnlyNumbers();
      testVal.age = "";
      // JavaScript interprets an empty string as a 0, which then fails the isNAN test. As well as isFinite test.
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("age"), "Invalid value",
          reason: "Should have a correct message");
    });

    // test("should fail when the property of the object being validated is null", ()
    // {
    //     validator = new Validator<TestVal>();
    //     validator.prop("age", (t) => t.age).containsOnlyNumbers();
    //     testVal.age = null;
    //     validator.validate(testVal);
    //    expect(validator.isValid, false, reason: "Should be invalid");
    //    expect(validator.hasErrors, true, reason: "Should have error");
    //    expect(validator.errors["age"], "Invalid value", reason: "Should have a correct message");
    // });
  });

  group("isPhoneNumber", () {
    test("should pass when the property of the object being validated is a valid phone number", () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated contains lettets", () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      testVal.phone = "1sa4567292";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["phone"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("phone"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should fail when the property of the object being validated has length less than 10", () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      testVal.phone = "1232112";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["phone"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("phone"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should fail when the property of the object being validated has length greater than 10",
        () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      testVal.phone = "12321231231231212";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["phone"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("phone"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should fail when the property of the object being validated is an empty string", () {
      validator = new Validator<TestVal>();
      validator.prop("phone", (t) => t.phone).isPhoneNumber();
      testVal.phone = "";
      // JavaScript interprets an empty string as a 0, which then fails the isNAN test. As well as isFinite test.
      // but here it passes cause of the length check in the rule.
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["phone"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("phone"), "Invalid value",
          reason: "Should have a correct message");
    });

    // test("should fail when the property of the object being validated is null", ()
    // {
    //     validator = new Validator<TestVal>();
    //     validator.prop("phone", (t) => t.phone).isPhoneNumber();
    //     testVal.phone = null;
    //     validator.validate(testVal);
    //    expect(validator.isValid, false, reason: "Shoul be invalid");
    //    expect(validator.hasErrors, true, reason: "Should have error");
    //    expect(validator.errors["phone"], "Invalid value", reason: "Should have a correct message");
    // });
  });

  group("isEmail", () {
    test("should pass when the property of the object being validated is a valid email", () {
      validator = new Validator<TestVal>();
      validator.prop("email", (t) => t.email).isEmail();
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail when the property of the object being validated is a invalid email", () {
      validator = new Validator<TestVal>();
      validator.prop("email", (t) => t.email).isEmail();
      testVal.email = "test.com";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["email"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("email"), "Invalid value",
          reason: "Should have a correct message");
    });

    test("should fail when the property of the object being validated is a empty string", () {
      validator = new Validator<TestVal>();
      validator.prop("email", (t) => t.email).isEmail();
      testVal.email = "";
      validator.validate(testVal);
      expect(validator.isValid, false, reason: "Should be invalid");
      expect(validator.hasErrors, true, reason: "Should have error");
      // expect(validator.errors["email"], "Invalid value", reason: "Should have a correct message");
      expect(validator.errors.getError("email"), "Invalid value",
          reason: "Should have a correct message");
    });

    // test("should fail when the property of the object being validated is a empty string", ()
    // {
    //     validator = new Validator<TestVal>();
    //     validator.prop("email", (t) => t.email).isEmail();
    //     testVal.email = null;
    //     validator.validate(testVal);
    //    expect(validator.isValid, false, reason: "Should be invalid");
    //    expect(validator.hasErrors, true, reason: "Should have error");
    //    expect(validator.errors["email"], "Invalid value", reason: "Should have a correct message");
    // });

    test("should pass when the property of the object being validated is a valid email", () {
      validator = new Validator<TestVal>();
      validator.prop("email", (t) => t.email).isEmail();
      testVal.email = "test1.tester@mail.tester.ca";
      validator.validate(testVal);
      expect(validator.isValid, true);
    });
  });
}
