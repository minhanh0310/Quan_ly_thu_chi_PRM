import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/core/theme/app_input_decoration.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final Color color;

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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        onChanged: onChanged,
        style: AppTextStyle.s14.copyWith(
          color: Color(0xff343434),
        ),
        decoration: AppInputDecoration.roundBorder.copyWith(
          hintText: hintText,
          hintStyle: AppTextStyle.s14.copyWith(
            color: AppColors.lightGray,
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
