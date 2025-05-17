import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart'; // Added for icons

class CSingleAddress extends StatefulWidget {
  const CSingleAddress({
    super.key,
    required this.selectedAddress,
    this.userAddress,
  });

  final bool selectedAddress;
  final Map<String, dynamic>? userAddress;

  @override
  State<CSingleAddress> createState() => _CSingleAddressState();
}

class _CSingleAddressState extends State<CSingleAddress> {
  final ProfileController _profileController = ProfileController();
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleDeteteAddress(String id, context) async {
    setState(() {
      isLoading = true;
    });

    try {
      await _profileController.deleteAddress(id);
      if (mounted) {
        CHelperFunctions.showSnackBar(
          'Address deleted successfully',
          context: context,
        );
        final List<Map<String, dynamic>> fetchedData =
            await _profileController.fetchUserAddress();

        Provider.of<SettingsProvider>(
          context,
          listen: false,
        ).setUserAddress(fetchedData);

        Navigator.of(context).pop();
      }
    } catch (e) {
      String errorMessage = e.toString();
      print("Error delete address: $errorMessage");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _setDefaultAddress(String id, context) async {
    setState(() {
      isLoading = true;
    });

    try {
      await _profileController.setDefaultAddress(id, true);
      if (mounted) {
        CHelperFunctions.showSnackBar(
          'Set default address successfully',
          context: context,
        );
        final List<Map<String, dynamic>> fetchedData =
            await _profileController.fetchUserAddress();

        Provider.of<SettingsProvider>(
          context,
          listen: false,
        ).setUserAddress(fetchedData);

        Navigator.of(context).pop();
      }
    } catch (e) {
      String errorMessage = e.toString();
      print("Error set default address: $errorMessage");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _confirmationDelete(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                handleDeteteAddress(id, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showGridActionsBottomSheet(
    BuildContext context,
    String id,
    bool isDefault,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              !isDefault
                  ? ListTile(
                    leading: const Icon(Iconsax.edit_copy),
                    title: const Text('Set as default address'),
                    onTap: () {
                      _setDefaultAddress(id, context);
                    },
                  )
                  : SizedBox.shrink(),
              ListTile(
                leading: const Icon(Iconsax.trash_copy, color: Colors.red),
                title: const Text(
                  'Delete Address',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _confirmationDelete(id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);
    final String fullAddress =
        '${widget.userAddress?['detailAddress']}, ${widget.userAddress?['ward']}, ${widget.userAddress?['district']}, ${widget.userAddress?['province']}';

    return InkWell(
      onLongPress: () {
        _showGridActionsBottomSheet(
          context,
          widget.userAddress?['_id'],
          widget.userAddress?['isDefault'],
        );
      },
      child: CRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(CSizes.md),
        width: double.infinity,
        backgroundColor:
            widget.selectedAddress
                ? CColors.primary.withOpacity(0.5)
                : Colors.transparent,
        borderColor:
            widget.selectedAddress
                ? Colors.transparent
                : dark
                ? CColors.lightGrey
                : CColors.grey,
        margin: const EdgeInsets.only(bottom: CSizes.spaceBtwItems),
        child: Stack(
          children: [
            Positioned(
              right: 5,
              top: 0,
              child: Icon(
                widget.selectedAddress ? Icons.check_circle : null,
                color:
                    widget.selectedAddress
                        ? dark
                            ? CColors.light
                            : CColors.dark
                        : null,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userAddress?['fullName'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: CSizes.sm / 2),
                Text(
                  widget.userAddress?['phone'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: CSizes.sm / 2),
                Text(
                  fullAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ), // Increased maxLines for address
              ],
            ),
          ],
        ),
      ),
    );
  }
}
