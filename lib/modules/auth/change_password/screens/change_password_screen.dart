import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/widgets/change_password_form.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  @override
  void dispose() {
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(title: 'Change Password'),
          body: _Body(
            newPwController: _newPwController,
            confirmPwController: _confirmPwController,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TextEditingController newPwController;
  final TextEditingController confirmPwController;

  const _Body({
    required this.newPwController,
    required this.confirmPwController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChangePasswordForm(
              newPwController: newPwController,
              confirmPwController: confirmPwController,
            ),
          ],
        ),
      ),
    );
  }
}
