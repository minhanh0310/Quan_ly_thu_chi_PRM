import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/core/theme/app_input_decoration.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final Color color;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.color = const Color(0xff1D1E20),
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tự động thêm icon mắt nếu là password field
    Widget? effectiveSuffixIcon = widget.suffixIcon;

    if (widget.isPassword) {
      effectiveSuffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.lightGray,
          size: 20,
        ),
        onPressed: _togglePasswordVisibility,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : widget.obscureText,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        style: AppTextStyle.s14.copyWith(color: Color(0xff343434)),
        decoration: AppInputDecoration.roundBorder.copyWith(
          hintText: widget.hintText,
          hintStyle: AppTextStyle.s14.copyWith(color: AppColors.lightGray),
          suffixIcon: effectiveSuffixIcon,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
