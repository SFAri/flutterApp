import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:ecommerce/features/shop/screens/checkout/controllers/coupon_controller.dart';
import 'package:ecommerce/features/shop/screens/checkout/controllers/order_controller.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/billing_information.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/coupon_code.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/success_screen.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/helpers/pricing_calculator.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart';
import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalPrice;
  final _formCheckoutKey = GlobalKey<FormState>();

  CartModel cart = CartModel();
  CheckoutScreen({super.key, required this.cart, required this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ProfileController _profileController = ProfileController();
  final OrderController _orderController = OrderController();
  final CouponController _couponController = CouponController();
  final TextEditingController _couponCodeController = TextEditingController();

  final DeepCollectionEquality deepEq = const DeepCollectionEquality();
  List<Map<String, dynamic>>? _userAddressList;
  List<Map<String, dynamic>>? _couponCodeList;
  Map<String, dynamic>? _selectedAddress;
  Map<String, dynamic>? _selectedCoupon;
  PaymentMethodType? _selectedPaymentMethod;

  bool validCouponCode = false;

  bool loggedIn = false;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initBillingData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = Provider.of<SettingsProvider>(context);
    if (!deepEq.equals(_userAddressList, settings.userAddress)) {
      setState(() {
        _userAddressList = settings.userAddress;
        _selectedAddress = _userAddressList?.firstWhereOrNull(
          (addr) => addr['isDefault'] == true,
        );
      });
    }
  }

  @override
  void dispose() {
    _couponCodeController.dispose();
    super.dispose();
  }

  Future<void> initBillingData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final isUserLoggedIn = await AuthService.isLoggedIn();
      if (!isUserLoggedIn) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final List<Map<String, dynamic>> userAddress =
          await _profileController.fetchUserAddress();

      final List<Map<String, dynamic>> couponCodes =
          await _couponController.fetchCouponCodeActive();

      if (mounted) {
        Provider.of<SettingsProvider>(
          context,
          listen: false,
        ).setUserAddress(userAddress);

        setState(() {
          isLoading = false;
          loggedIn = isUserLoggedIn;

          // Get default user address
          _userAddressList = userAddress;
          _selectedAddress = _userAddressList?.firstWhereOrNull(
            (addr) => addr['isDefault'] == true,
          );

          // Get coupon code list
          _couponCodeList = couponCodes;
          print(_couponCodeList);
          errorMessage = null;
        });
      }
    } catch (e) {
      print('Error during initBillingData: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> handleOrder() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> cartItems = [];
      for (var product in widget.cart.items) {
        Map<String, dynamic> cartItem = {};

        cartItem['productId'] = product.id;
        cartItem['productName'] = product.name;
        cartItem['variantId'] = product.variant.variantId;
        cartItem['quantity'] = product.quantity;
        cartItem['unitPrice'] = CPricingCalculator.calculateDiscount(
          product.variant.salePrice,
          product.discount,
        );
        cartItem['discountPerProduct'] = product.discount;

        print("cartItems: $cartItem");
        cartItems.add(cartItem);
      }

      // Validations
      if (_selectedAddress == null && loggedIn) {
        CHelperFunctions.showSnackBar(
          'Please select a shipping address.',
          context: context,
        );
        setState(() => isLoading = false);
        return;
      }
      if (_selectedPaymentMethod == null) {
        CHelperFunctions.showSnackBar(
          'Please select a payment method.',
          context: context,
        );
        setState(() => isLoading = false);
        return;
      }

      String couponCode = _selectedCoupon?["code"] ?? '';
      String paymentMethod = _selectedPaymentMethod.toString().split('.').last;
      String shippingAddressId = _selectedAddress?["_id"] ?? '';

      await _orderController.createOrder(
        cartItems,
        couponCode,
        paymentMethod,
        shippingAddressId,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => SuccessScreen(
                  image: 'assets/images/order/success.png',
                  title: 'Order Placed',
                  subTitle: 'Your order has been placed successfully!',
                  onPressed:
                      () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NavigationMenu(),
                        ),
                        (route) => false,
                      ),
                ),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error during order process: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handlePaymentMethodSelection(PaymentMethodType paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = CHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart Items
              CCartItems(cart: widget.cart, showButtonRemove: false),
              const SizedBox(height: CSizes.spaceBtwSections),

              // Coupon Text Field
              CCouponCode(
                dark: dark,
                onApply: (code) {
                  _selectedCoupon = _couponCodeList!.firstWhereOrNull(
                    (cp) =>
                        cp['code'].toString().toLowerCase() ==
                        code.toLowerCase(),
                  );

                  if (_selectedCoupon != null) {
                    setState(() {
                      validCouponCode = true;
                      _couponCodeController.text = code;
                    });

                    CHelperFunctions.showSnackBar(
                      "Coupon applied!",
                      context: context,
                    );
                    print('Coupon found: $code');
                  } else {
                    setState(() {
                      validCouponCode = false;
                      _couponCodeController.text = '';
                    });

                    CHelperFunctions.showSnackBar(
                      "Coupon not found!",
                      context: context,
                    );
                  }
                },
              ),
              SizedBox(height: CSizes.spaceBtwSections),

              // Billing Section
              CRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? CColors.grey : CColors.lightGrey,
                padding: EdgeInsets.all(CSizes.md),
                child: Column(
                  children: [
                    // Billing Information
                    validCouponCode
                        ? CBillingInfoSection(
                          cart: widget.cart,
                          coupon: _selectedCoupon,
                          onRemoveCoupon: () {
                            setState(() {
                              _selectedCoupon = null;
                              validCouponCode = false;
                              _couponCodeController.text = '';
                            });
                          },
                        )
                        : CBillingInfoSection(cart: widget.cart),
                    Divider(
                      color: CColors.grey,
                      thickness: 1,
                      height: CSizes.defaultSpace,
                    ),

                    // Payment Section
                    CBillingPaymentSection(
                      onPaymentMethodSelected: _handlePaymentMethodSelection,
                    ),
                    SizedBox(height: CSizes.spaceBtwItems),

                    // Address Section
                    CBillingAddressSection(
                      isLoggedIn: loggedIn,
                      address: _selectedAddress,
                    ),
                    SizedBox(height: CSizes.spaceBtwItems),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      // Elevated Button for Checkout
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(CSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () {
            handleOrder();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, CSizes.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(CSizes.buttonRadius),
            ),
            backgroundColor: CColors.primary,
            elevation: CSizes.buttonElevation,
          ),
          child: Text(
            'Order',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: CColors.textWhite),
          ),
        ),
      ),
    );
  }
}
