import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldType { email, password, text }

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextFieldType textFieldType;
  final TextEditingController textEditingController;
  final FormFieldValidator validator;
  final ValueChanged<String?> onSaved;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.textFieldType,
    required this.textEditingController,
    required this.validator,
    required this.onSaved,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool visiblePassword = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      visiblePassword = widget.textFieldType == TextFieldType.password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: TextFormField(
        obscureText: visiblePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (text) => {setState(() {})},
        controller: widget.textEditingController,
        onSaved: widget.onSaved,
        keyboardType: widget.textFieldType == TextFieldType.email
            ? TextInputType.emailAddress
            : TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 20, bottom: 10),
          alignLabelWithHint: true,
          labelText: widget.hintText,
          labelStyle: const TextStyle(
            color: Colors.black87,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
              width: 0.5,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
              width: 0.5,
            ),
          ),
          hintText: widget.hintText,
        ),
        style: const TextStyle(
          color: Colors.blue,
        ),
        validator: widget.validator,
      ),
    );
  }
}
