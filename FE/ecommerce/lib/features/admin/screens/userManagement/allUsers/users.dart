import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/userManagement/detailUser/detail_user.dart';
import 'package:ecommerce/features/admin/screens/userManagement/widgets/paginated_table.dart';
import 'package:ecommerce/features/auth/controllers/user_controller.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

// StreamController<Map<String, dynamic>> streamController = StreamController<Map<String, dynamic>>();

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<dynamic> users = [];
  bool isLoading = true;
  String searchQuery = '';
  final UserAdminController userAdminController = UserAdminController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Fetch data:
  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await userAdminController.getUsers();
      if (response['status'] == 'success') {
        setState(() {
          users = response['data'];
        });
        print("users: ${users.join(',')}");
      } else {
        print('error');
      }
      
    } catch (e) {
      print('Error: $e'); // Handle errors here
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  // final DataTableSource _data = MyData();

  Map<String, dynamic>? selectedUser;

  @override
  Widget build(BuildContext context) {
    
    return isLoading 
    ? Center(child: CircularProgressIndicator(),)
    : Column(
      spacing: 20,
      children: [

        // Filter row:
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: [
            // 1. searchbar:
            SizedBox(
              height: 50,
              width: 200,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide()
                  )
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(
                onPressed: (){},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                icon: Icon(Icons.search),
              ),
            ),
            // 2. button desc/asc
            // SizedBox(
            //   height: 50,
            //   width: 100,
            //   child: TextButton(
            //     onPressed: (){},
            //     style: TextButton.styleFrom(
            //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.sort),
            //         Text('Desc'),
            //       ],
            //     )
            //   ),
            // ),
            // 3. button best-friend of shops desc according points
            SizedBox(
              height: 50,
              width: 150,
              child: TextButton(
                onPressed: (){},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopify_outlined),
                    Text('Loyal customers'),
                  ],
                )
              ),
            ),
          ],
        ),
        
        // User table:
        if (Responsive.isDesktop(context))
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: 1000,
              child: PaginatedTable(
                lists: users, 
                viewFunction: (item) {
                  streamController.add(DetailUserScreen(user: item));
                },
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Gender')),
                  // DataColumn(label: Text('Points')),
                  DataColumn(label: Text('Actions')),
                ], 
                columnKeys: ['fullName', 'email', 'phone', 'gender']
              ),
            )
          ),
        if (!Responsive.isDesktop(context))
            Container(
              height: 500,
              width: 480,
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      onTap: () {
                        streamController.add(DetailUserScreen(user:  users[index]));
                      },
                      internalAddSemanticForOnTap: false,
                      title: Text(user['fullName']!),
                      leading: Image.asset(CImages.avatar, width: 30,),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(user['email']!), // Existing email field
                          Text('${user['phone'] ?? 'N/A'}'), // New phone number field
                          // Text('Points: ${user['points'] ?? 0}'), // New points field
                        ],
                      ),
                      // trailing: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     DropdownButton<String>(
                      //       value: user['status'],
                      //       onChanged: (String? newValue) {
                      //         // Cập nhật trạng thái người dùng
                      //       },
                      //       items: <String>['Active', 'Banned']
                      //           .map<DropdownMenuItem<String>>((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: Text(value),
                      //         );
                      //       }).toList(),
                      //     ),
                      //     IconButton(
                      //       iconSize: 16,
                      //       style: IconButton.styleFrom(
                              
                      //       ),
                      //       onPressed: (){}, 
                      //       icon: Icon(Icons.delete, color: Colors.red,)
                      //     )
                      //   ],
                      // ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}