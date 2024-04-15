import 'package:flutter/material.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/my_text_field.dart';
import 'package:foodie_bell/Config/validations_field.dart';

TextEditingController forgetPassMobile = TextEditingController();
TextEditingController forgetPassSet = TextEditingController();
TextEditingController forgetPassEmailId = TextEditingController();

Widget forgetPassEmail() {
  return AllInputDesign(
    inputHeaderName: 'Email',
    controller: forgetPassEmailId,
    hintText: 'Email',
    cursorColor: Colors.black,
    fillColor: whiteColor,
    validatorFieldValue: 'Email',
    validator: validateEmailField,
    keyBoardType: TextInputType.text,
  );
}

Widget forgetPassEnter() {
  return AllInputDesign(
    inputHeaderName: 'Password',
    controller: forgetPassSet,
    hintText: 'Password',
    cursorColor: Colors.black,
    fillColor: whiteColor,
    obsecureText: true,
    validatorFieldValue: 'Password',
    validator: validatePassword,
    keyBoardType: TextInputType.text,
  );
}

Widget forgetPassOtp() {
  return AllInputDesign(
    inputHeaderName: 'OTP',
    controller: forgetPassMobile,
    hintText: 'Otp',
    cursorColor: Colors.black,
    fillColor: whiteColor,
    obsecureText: false,
    maxLength: 6,
    counterText: '',
    validatorFieldValue: 'Otp',
    validator: validateOtp,
    keyBoardType: TextInputType.number,
  );
}

Widget submitBtn(context, formKey, forgotPasswordStepOne) {
  return GestureDetector(
    onTap: () {
      if (formKey.currentState.validate()) {
        forgotPasswordStepOne();
      }
    },
    child: Container(
      alignment: Alignment.center,
      height: 55.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        // color: Colors.red,
        gradient: LinearGradient(
          colors: [
            Color(0xffDF6E3D),
            Color(0xffFA8B01),
          ],
          end: Alignment.centerRight,
          begin: Alignment.centerLeft,
          // tileMode: TileMode.repeated,
        ),
      ),
      child: Text(
        'Submit',
        style: TextStyle(
          color: whiteColor,
          fontSize: 15.0,
        ),
      ),
    ),
  );
}

Widget forgotPassBtn(context, formKey, forgotPasswordStepTwo) {
  return GestureDetector(
    onTap: () {
      if (formKey.currentState.validate()) {
        forgotPasswordStepTwo();
      }
    },
    child: Container(
      alignment: Alignment.center,
      height: 55.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        // color: Colors.red,
        gradient: LinearGradient(
          colors: [
            Color(0xffDF6E3D),
            Color(0xffFA8B01),
          ],
          end: Alignment.centerRight,
          begin: Alignment.centerLeft,
          // tileMode: TileMode.repeated,
        ),
      ),
      child: Text(
        'Reset',
        style: TextStyle(
          color: whiteColor,
          fontSize: 15.0,
        ),
      ),
    ),
  );
}
