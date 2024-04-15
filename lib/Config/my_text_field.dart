import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodie_bell/Config/common_widgets.dart';

class AllInputDesign extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final controller;
  final prefixText;
  final fillColor;
  final enabled;
  final hintText;
  final inputHeaderName;
  final textInputAction;
  final prefixStyle;
  final validator;
  final errorText;
  final keyBoardType;
  final validatorFieldValue;
  final List<TextInputFormatter> inputFormatterData;
  final FormFieldSetter<String> onSaved;
  final obsecureText;
  final suffixIcon;
  final maxLength;
  final outlineInputBorderColor;
  final outlineInputBorder;
  final enabledBorderRadius;
  final focusedBorderRadius;
  final enabledOutlineInputBorderColor;
  final focusedBorderColor;
  final hintTextStyleColor;
  final counterText;
  final cursorColor;
  final textStyleColors;

  const AllInputDesign({
    Key key,
    this.textStyleColors,
    this.controller,
    this.cursorColor,
    this.textInputAction,
    this.outlineInputBorder,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.enabled,
    this.prefixText,
    this.fillColor,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.suffixIcon,
    this.hintText,
    this.inputHeaderName,
    this.validatorFieldValue,
    this.inputFormatterData,
    this.validator,
    this.onSaved,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.outlineInputBorderColor,
    this.enabledOutlineInputBorderColor,
    this.focusedBorderColor,
    this.hintTextStyleColor,
    this.counterText,
  }) : super(key: key);

  @override
  _AllInputDesignState createState() => _AllInputDesignState();
}

class _AllInputDesignState extends State<AllInputDesign> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          (widget.inputHeaderName != null) ? widget.inputHeaderName : '',
          style: labelHintFontStyle,
        ),
        heightSizedBox(7.0),
        TextFormField(
          cursorColor: widget.cursorColor ?? whiteColor,
          onSaved: widget.onSaved,
          style: TextStyle(
            color: widget.textStyleColors ?? Colors.black,
            // fontFamily: 'Nunito',
            fontWeight: FontWeight.w400,
          ),
          keyboardType: widget.keyBoardType,
          validator: widget.validator,
          controller: widget.controller,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatterData,
          obscureText:
              widget.obsecureText != null ? widget.obsecureText : false,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            counterText: widget.counterText,
            filled: true,
            fillColor: widget.fillColor ?? Color(0XFFF3F3F3),
            hintText: (widget.hintText != null) ? widget.hintText : '',
            hintStyle: TextStyle(
              color: widget.hintTextStyleColor ?? Colors.grey.shade400,
              fontSize: 17,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              // fontFamily: pCommonRegularFont,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: widget.suffixIcon != null ? widget.suffixIcon : Text(''),
            ),
            prefixText: (widget.prefixText != null) ? widget.prefixText : '',
            prefixStyle: widget.prefixStyle,
            errorText: widget.errorText,
            // errorStyle: TextStyle(fontFamily: pCommonRegularFont),
            contentPadding: const EdgeInsets.all(15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  widget.focusedBorderRadius ?? BorderRadius.circular(30),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? Colors.grey,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  widget.enabledBorderRadius ?? BorderRadius.circular(30),
              borderSide: BorderSide(
                color: widget.enabledOutlineInputBorderColor ?? Colors.grey,
                width: 1.0,
              ),
            ),
            border: widget.outlineInputBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: widget.outlineInputBorderColor ?? Colors.grey,
                    width: 1.0,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
