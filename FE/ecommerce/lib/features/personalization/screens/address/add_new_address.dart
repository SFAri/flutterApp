import 'package:flutter/material.dart';
import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'Add new Address',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(CSizes.borderRadiusMd),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: CSizes.spaceBtwInputFields),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.mobile),
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(CSizes.borderRadiusMd),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: CSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.building_3),
                          labelText: 'Street',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(CSizes.borderRadiusMd),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: CSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.code),
                          labelText: 'Postal Code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(CSizes.borderRadiusMd),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ), // Row
                const SizedBox(height: CSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.building),
                          labelText: 'City',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(CSizes.borderRadiusMd),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: CSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.activity),
                          labelText: 'State',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(CSizes.borderRadiusMd),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ), // Row
                const SizedBox(height: CSizes.spaceBtwInputFields),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.global),
                    labelText: 'Country',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(CSizes.borderRadiusMd),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: CSizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
