import 'package:Quan_ly_thu_chi_PRM/core/widgets/responsive_layout.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/core/widgets/opacity_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/core/widgets/template/button_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/core/widgets/will_unfocus_form_scope.dart';

class FunctionScreenTemplate extends StatefulWidget {
  final Widget? screen;
  final String? title;
  final String? subtitle;
  final bool isShowAppBar;
  final bool isShowBottomButton;
  final String? titleButtonBottom;
  final VoidCallback? onClickBottomButton;
  final Widget? customBottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? background;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  final VoidCallback? onOpenDrawer;

  const FunctionScreenTemplate({
    super.key,
    this.screen,
    this.title,
    this.subtitle,
    this.isShowAppBar = true,
    this.isShowBottomButton = false,
    this.titleButtonBottom,
    this.onClickBottomButton,
    this.customBottomNavigationBar,
    this.floatingActionButton,
    this.background,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.onOpenDrawer,
  });

  @override
  State<FunctionScreenTemplate> createState() => _FunctionScreenTemplateState();
}

class _FunctionScreenTemplateState extends State<FunctionScreenTemplate>
    with WidgetsBindingObserver {
  bool isOpacity = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive) {
        setState(() => isOpacity = true);
      } else if (state == AppLifecycleState.resumed) {
        setState(() => isOpacity = false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillUnfocusFormScope(
      child: Stack(
        children: [
          if (widget.background != null)
            Positioned.fill(child: widget.background!),
          _buildScaffold(
            body: widget.screen ?? const SizedBox(),
            showAppBar: widget.isShowAppBar,
          ),
          if (isOpacity) const OpacityWidget(),
        ],
      ),
    );
  }

  Widget _buildScaffold({required Widget body, required bool showAppBar}) {
    return WillUnfocusFormScope(
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBodyBehindAppBar: widget.background != null,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          backgroundColor: widget.background != null
              ? Colors.transparent
              : widget.backgroundColor ?? AppColors.white,
          appBar: showAppBar
              ? CustomAppBar(
                  title: widget.title,
                  subtitle: widget.subtitle,
                  onOpenDrawer: widget.onOpenDrawer,
                )
              : null,

          body: ResponsiveLayout(child: body),

          bottomNavigationBar: widget.isShowBottomButton
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.customBottomNavigationBar ??
                        ButtonWidget(
                          title: widget.titleButtonBottom ?? 'Continue',
                          padding: AppPad.v24,
                          onPressed: widget.onClickBottomButton ?? () {},
                        ),
                  ],
                )
              : null,

          floatingActionButton: widget.floatingActionButton,
        ),
      ),
    );
  }
}
