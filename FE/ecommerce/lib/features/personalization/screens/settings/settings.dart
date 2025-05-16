import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/common/widgets/layout/primary_header_container.dart';
import 'package:ecommerce/common/widgets/list_titles/settings_menu_title.dart';
import 'package:ecommerce/common/widgets/list_titles/user_profile_title.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/auth/login_page.dart';
import 'package:ecommerce/features/personalization/screens/address/address.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/features/personalization/screens/settings/widgets/language_selection_dialog.dart';
import 'package:ecommerce/features/shop/screens/order/order.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/local_storage/storage_utility.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ProfileController _profileController = ProfileController();
  bool? loggedIn;
  bool isLoading = false;
  late List<String> languages;
  Map<String, dynamic>? userData;
  String? errorMessage;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    languages = ['English', 'Vietnamese'];
  }

  @override
  void initState() {
    super.initState();
    checkLoginAndFetchProfile();
  }

  Future<void> checkLoginAndFetchProfile() async {
    setState(() {
      isLoading = true;
    });

    final localStorage = CLocalStorage.instance();
    const userKey = 'user_profile';

    try {
      final isUserLoggedIn = await AuthService.isLoggedIn();

      if (!isUserLoggedIn) {
        setState(() {
          loggedIn = isUserLoggedIn;
          isLoading = false;
        });
        return;
      }

      setState(() {
        loggedIn = isUserLoggedIn;
      });

      // Try getting cached data first
      final cachedUser = await localStorage.readData<Map<String, dynamic>>(
        userKey,
      );
      if (cachedUser != null) {
        setState(() {
          userData = cachedUser;
          isLoading = false;
        });
        return;
      }

      // If not cached, fetch from API
      final fetchedUser = await _profileController.fetchProfile();
      await localStorage.writeData(userKey, fetchedUser);

      setState(() {
        userData = fetchedUser;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> logoutUser() async {
    final localStorage = CLocalStorage.instance();
    await localStorage.deleteData('user_profile');
    await AuthService.clearToken();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
      CHelperFunctions.showSnackBar('Logout successfully', context: context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationMenu()),
      );
    }
  }

  void handleLogOut() async {
    await logoutUser();
  }

  // Dialog chọn ngôn ngữ
  void _showLanguageSelectionDialog(SettingsProvider settingsProvider) {
    // Lấy locale hiện tại từ Provider để biết ngôn ngữ nào đang được chọn
    Locale currentLocale = settingsProvider.appLocale;
    print('current locale ------- $currentLocale');
    String currentSelectedLanguage = getLanguageSelected(settingsProvider);

    showModalBottomSheet(
      context: context,
      builder:
          (context) => LanguageSelectionDialog(
            languages: languages,
            currentLanguage: currentSelectedLanguage,
            onLanguageSelected: (locale) {
              settingsProvider.changeLocale(locale);
            },
          ),
    );
  }

  // Hàm lấy tên ngôn ngữ được chọn
  String getLanguageSelected(SettingsProvider settingsProvider) {
    String selectedLanguage;
    switch (settingsProvider.appLocale.languageCode) {
      case 'en':
        selectedLanguage = 'English';
        break;
      case 'vi':
        selectedLanguage = 'Vietnamese';
        break;
      default:
        selectedLanguage = 'English';
        break;
    }
    return selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi từ SettingsProvider
    // Dùng context.watch để widget này tự động build lại khi state thay đổi
    final settingsProvider = context.watch<SettingsProvider>();
    String displayLanguage = getLanguageSelected(settingsProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // -- Header
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  // -- AppBar
                  CAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: CSizes.spaceBtwSections),

                  // -- Login User
                  loggedIn == null
                      ? SizedBox.shrink()
                      : loggedIn!
                      ? CUserProfileTitle(userData: userData) // Profile title
                      : TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Login / Sign Up',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                  const SizedBox(height: CSizes.spaceBtwSections),
                ],
              ),
            ),
            // -- Body
            Padding(
              padding: EdgeInsets.all(CSizes.spaceBtwItems),
              child: Column(
                children: [
                  // -- Account Settings
                  CSectorHeading(
                    title: 'Account Settings',
                    padding: 0,
                    textColor: Colors.white,
                    showActionButton: false,
                  ),
                  SizedBox(height: CSizes.spaceBtwSections),

                  CSettingsMenuTitle(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Order Management',
                    subTitle: 'View and manage your orders',
                    onTap:
                        () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OrderScreen()),
                          ),
                        },
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.truck_copy,
                    title: 'Address book',
                    subTitle: 'Set shopping delivery addresses',
                    onTap:
                        () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserAddressScreen(),
                            ),
                          ),
                        },
                  ),

                  CSettingsMenuTitle(
                    icon: Iconsax.lovely_copy,
                    title: 'My Wishlist',
                    subTitle: 'View and manage your wishlist',
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.star_1_copy,
                    title: 'My Reviews',
                    subTitle: 'View and manage your reviews',
                  ),
                  CSettingsMenuTitle(
                    icon: Icons.payment_outlined,
                    title: 'My Payment Methods',
                    subTitle: 'View and manage your payment methods',
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.discount_shape_copy,
                    title: 'Hot Promotions',
                    subTitle:
                        'View and manage your coupons, offers and discounts',
                  ),

                  // -- App Settings
                  SizedBox(height: CSizes.spaceBtwSections),
                  CSectorHeading(
                    title: 'App Settings',
                    padding: 0,
                    textColor: Colors.white,
                    showActionButton: false,
                  ),
                  SizedBox(height: CSizes.spaceBtwSections),

                  CSettingsMenuTitle(
                    icon: Iconsax.notification_1_copy,
                    title: 'Notifications',
                    subTitle: 'Turn on/off your notifications',
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.safe_home_copy,
                    title: 'Safe Mode',
                    subTitle: 'Set shopping safe mode',
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.language_square_copy,
                    title: 'Change language',
                    subTitle: 'Change your language',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: CSizes.sm),
                          child: Text(
                            displayLanguage,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap:
                        () => _showLanguageSelectionDialog(
                          context.read<SettingsProvider>(),
                        ),
                  ),
                  CSettingsMenuTitle(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Terms and Policies',
                    subTitle: 'View our terms and policies',
                  ),

                  // -- Logout Button
                  SizedBox(height: CSizes.spaceBtwSections),
                  loggedIn == null
                      ? SizedBox.shrink()
                      : loggedIn!
                      ? SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: isLoading ? null : handleLogOut,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                CSizes.borderRadiusMd,
                              ),
                            ),
                          ),

                          child:
                              isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                  : Text(
                                    'Logout',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: Colors.black),
                                  ),
                        ),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
