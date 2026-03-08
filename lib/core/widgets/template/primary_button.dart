import 'package:Quan_ly_thu_chi_PRM/init.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback onClick;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.color,
    required this.onClick,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          disabledBackgroundColor: AppColors.mainColor.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
