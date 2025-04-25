import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class DetailUserScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const DetailUserScreen({super.key, required this.user});

  @override
  State<DetailUserScreen> createState() => _DetailUserScreenState();
  
}

class _DetailUserScreenState extends State<DetailUserScreen>{
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController pointController;
  // late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    pointController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    pointController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 20,
          children: [
            Header(title: 'Detail user'),
            Divider(),

            CircleAvatar(
              radius: 50,
              child: Image.asset(CImages.avatar),
            ),

            Wrap(
              direction: Axis.horizontal,
              spacing: 50,
              runSpacing: 10,
              children: [
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 30,
                      children: [
                        Text('Basic information:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 270,
                          child: Divider(thickness: 2)
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      width: 450,
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Enter fullname',
                          label: Text('Fullname'),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 450,
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Enter Email',
                          label: Text('Email'),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 450,
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Enter Phone number',
                          label: Text('Phone Num'),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 30,
                      children: [
                        Text('Address:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 350,
                          child: Divider(thickness: 2)
                        )
                      ],
                    ),
                    WAddressCard(address: '123 Tran Hung Dao', type: 'Home',),
                    WAddressCard(address: '456 Quang Trung', type: 'Company',),
                    WAddressCard(address: '789 Nguyen Thi Thap', type: 'Home',),
                  ],
                ),
              ],
            ),

            // Row button:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: Text('Cancel')
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_outlined),
                        Text('Update'),
                      ],
                    )
                  ),
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
  
}

class WAddressCard extends StatelessWidget {
  const WAddressCard({
    super.key,
    required this.address,
    required this.type,
  });
  final String address;
  final String type;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: ListTile(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey)
        ),
        onTap: (){},
        leading: Icon(Icons.holiday_village),
        title: Text(address),
        subtitle: Text(type),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.edit) 
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.delete, color: Colors.red,) 
            ),
          ],
        ),
      ),
    );
  }
}