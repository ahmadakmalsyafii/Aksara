import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscure = false,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.obscure
            ? IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
