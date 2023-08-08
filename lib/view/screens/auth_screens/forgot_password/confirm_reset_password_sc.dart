import 'package:e_commerce_app/utils/constant_color.dart';
import 'package:e_commerce_app/view/screens/auth_screens/login_page_sc.dart';
import 'package:e_commerce_app/view/widgets/forgot_password_widgets/forgot_test_widget.dart';
import 'package:e_commerce_app/view/widgets/login_screen_widget/login_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../components/app_local.dart';

class ConfirmResetPasswordSc extends StatelessWidget {
  const ConfirmResetPasswordSc({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocale locale = AppLocale.of(context);
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 5.h),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 20.h,
              color: AppColor.kIconColor,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ForgotTextWidget(
              text: AppLocale.of(context).getTranslated('complete_pass_change_title')!,
              fontFamily: 'Times',
              fontWeight: FontWeight.bold,
              color: AppColor.kMainColor,
              size: 25.sp,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 2.5.h,
          ),
          ForgotTextWidget(
            text:
            AppLocale.of(context).getTranslated('complete_pass_change_desc')!,
            fontFamily: 'Times',
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            size: 12.sp,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          LoginButtonWidget(
            onPress: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginSc();
                  },
                ),
                (route) => true,
              );
            },
            textButton: AppLocale.of(context).getTranslated('complete_pass_change_button_text')!,
            buttonColor: AppColor.kMainColor,
            fixedSize: MaterialStatePropertyAll<Size>(Size(90.w, 6.h)),
          )
        ],
      )),
    );
  }
}