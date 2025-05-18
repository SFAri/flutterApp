import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/features/personalization/screens/address/add_new_address.dart';
import 'package:ecommerce/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  final ProfileController _profileController = ProfileController();
  final DeepCollectionEquality deepEq = const DeepCollectionEquality();
  List<Map<String, dynamic>>? userAddress;
  bool isLoading = false;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = Provider.of<SettingsProvider>(context);
    if (!deepEq.equals(userAddress, settings.userAddress)) {
      setState(() {
        userAddress = settings.userAddress;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final List<Map<String, dynamic>> fetchedData =
          await _profileController.fetchUserAddress();

      if (mounted) {
        Provider.of<SettingsProvider>(
          context,
          listen: false,
        ).setUserAddress(fetchedData);

        setState(() {
          isLoading = false;
          userAddress = fetchedData;
        });
      }
    } catch (e) {
      errorMessage = e.toString();
      print("Error fetching address: $errorMessage");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddNewAddressScreen()),
              ),
            },
        backgroundColor: CColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'Addresses',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            children:
                userAddress?.map((address) {
                  return CSingleAddress(
                    selectedAddress: address['isDefault'] == true,
                    userAddress: address,
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
    );
  }
}
