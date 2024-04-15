import 'package:flutter/material.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/my_text_field.dart';
import 'package:foodie_bell/Config/validations_field.dart';
import 'package:foodie_bell/ForgetPassword/forgetPasswordOne.dart';

TextEditingController loginEmail = TextEditingController();
TextEditingController loginPassword = TextEditingController();
Widget signInEmail() {
  return AllInputDesign(
    inputHeaderName: 'Email',
    fillColor: whiteColor,
    controller: loginEmail,
    hintText: 'Email',
    cursorColor: Colors.black,
    validatorFieldValue: 'email',
    validator: validateEmailField,
    keyBoardType: TextInputType.emailAddress,
  );
}

Widget signInPassword() {
  return AllInputDesign(
    inputHeaderName: 'Password',
    controller: loginPassword,
    hintText: 'Password',
    cursorColor: Colors.black,
    fillColor: whiteColor,
    obsecureText: true,
    validatorFieldValue: 'password',
    validator: validatePassword,
    keyBoardType: TextInputType.text,
  );
}

Widget forgotPassword(context) {
  return Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordOne(),
          ),
        );
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 15.0,
        ),
      ),
    ),
  );
}

Widget loginBtn(context, formKey, signInRequest) {
  return GestureDetector(
    onTap: () {
      if (formKey.currentState.validate()) {
        signInRequest();
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
        'Login',
        style: TextStyle(
          color: whiteColor,
          fontSize: 15.0,
        ),
      ),
    ),
  );
}
