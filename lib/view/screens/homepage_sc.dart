import 'package:e_commerce_app/core/utils/constants/app_routes.dart';
import 'package:e_commerce_app/repo/connectivity_status.dart';
import 'package:e_commerce_app/view/appbar_widget.dart';
import 'package:e_commerce_app/view/widgets/home_screen_widget/badges_cart_widget.dart';
import 'package:e_commerce_app/view/widgets/home_screen_widget/bottom_navigator_app_bar/home_bottom_bar.dart';
import 'package:e_commerce_app/view_model/favorite_view_model.dart';
import 'package:e_commerce_app/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../core/utils/constants/constant_color.dart';
import '../../repo/fuctions/exit_app_alert.dart';
import 'package:lottie/lottie.dart';

class HomepageSc extends StatelessWidget {
  HomepageSc({Key? key}) : super(key: key);
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    ProductViewModel productViewModel = context.watch<ProductViewModel>();
    FavoriteViewModel favoriteViewModel = context.read<FavoriteViewModel>();

    return Scaffold(
      key: favoriteViewModel.scaffoldMessengerKey,
      backgroundColor: AppColor.kBackgroundColor,
      appBar: productViewModel.currentIndexBar == 0 ||
              productViewModel.currentIndexBar == 1 ||
              productViewModel.currentIndexBar == 2
          ? AppbarWidget(
              userViewModel: productViewModel,
              appbarTitle: 'H-Store',
            )
          : null,
      body: WillPopScope(
        child: SafeArea(
          child: Consumer<ConnectivityStatus>(
            builder: (context, notify, child) {
              if (notify == ConnectivityStatus.wiFi ||
                  notify == ConnectivityStatus.cellular) {
                if (productViewModel.loading == true) {
                  return Center(
                    /// TODO: Handling status with Request file ----------------
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        AppColor.kMainColor,
                        BlendMode.srcIn,
                      ),
                      child: Lottie.asset(
                        'assets/lottie_files/loading_icon.json',
                        width: 15.h,
                        height: 15.h,
                      ),
                    ),
                  );
                }

                /// TODO: recoding when no internet and connect should be reload items
                if (productViewModel.userError.code != null) {
                  //productViewModel.refreshPage();
                  return const Text('Error in loading data');
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  //child: allScreensView.elementAt(productViewModel.currentIndexBar),
                  child: PageView(
                    controller: _pageController,
                    children: [
                      productViewModel.screensView.elementAt(productViewModel.currentIndexBar),
                    ],
                  ),
                );
              } else if (notify == ConnectivityStatus.offline) {
                return const Center(
                  child:
                      Text('Internet unavailable please check your connection'),
                );
              } else {
                return const Center(child: Text('Error Unknown'));
              }
            },
          ),
        ),
        onWillPop: () => exitAppAlert(context),
      ),
      bottomNavigationBar: const HomeBottomBarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.cart);
        },
        backgroundColor: AppColor.kIconColor,
        child: BadgesCartWidget(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
