import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GlobalTextField extends StatefulWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? caption;
  final TextEditingController? controller;
  final int? max;
  final Color? color;
  final ValueChanged? onChanged;

  const GlobalTextField({
    super.key,
    this.hintText,
    this.keyboardType,
    this.prefixIcon,
    this.caption = "",
    this.controller,
    this.max,this.textInputAction, this.suffixIcon, this.color, this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GlobalTextFieldState createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  late MaskTextInputFormatter _maskFormatter;

  @override
  void initState() {
    super.initState();
    _maskFormatter = MaskTextInputFormatter(
      mask: '*#:@#',
      filter: {
        "*": RegExp(r'[0-2]'),
        "@": RegExp(r'[0-6]'),
        "#": RegExp(r'[0-9]'),
      },
    );
  }

  String? validateTime(String? input) {
    final timeRegex = RegExp(r'^([01]\d|2[0-4]):([0-5]\d)$');
    if (!timeRegex.hasMatch(input!)) {
      return 'Invalid time format';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.caption!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.caption?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          onChanged: widget.onChanged,
          controller: widget.controller,
          maxLines: widget.max,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          cursorColor: Colors.grey,
          cursorHeight: 25,
          inputFormatters: widget.keyboardType == TextInputType.number
              ? [_maskFormatter]
              : [],
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            suffixIcon: widget.suffixIcon != null
                ? Icon(
              widget.suffixIcon,
              color: Colors.blue,
            )
                : null,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
              widget.prefixIcon,
              color: Colors.grey,
            )
                : null,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          keyboardType: widget.keyboardType,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
