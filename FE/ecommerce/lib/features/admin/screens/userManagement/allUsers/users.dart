import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/userManagement/detailUser/detail_user.dart';
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
  // final List<Map<String, dynamic>> users = [
  //   {
  //     'name': 'Mokhasiemov',
  //     'email': 'mokhasiemov@gmail.com',
  //     'phone': '123-456-7890',
  //     'points': 100,
  //     'addresses': ['123 Main St', '456 Elm St'],
  //     'orders': [
  //       {
  //         'id': '001',
  //         'orderDate': '2023-01-01',
  //         'deliveryDate': '2023-01-05',
  //         'status': 'Delivered',
  //         'total': '250.00'
  //       },
  //     ],
  //     'status': 'Active'
  //   },
  //   {
  //     'name': 'Jayden_Cr',
  //     'email': 'jaydencr@example.com',
  //     'phone': '987-654-3210',
  //     'points': 150,
  //     'addresses': ['789 Oak St'],
  //     'orders': [
  //       {
  //         'id': '002',
  //         'orderDate': '2023-02-01',
  //         'deliveryDate': '2023-02-05',
  //         'status': 'Pending',
  //         'total': '150.00'
  //       },
  //     ],
  //     'status': 'Active'
  //   },
  //   // Thêm người dùng khác ở đây
  // ];
  List<dynamic> users = [];
  // String selectedStatus = 'All';
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

  final DataTableSource _data = MyData();

  Map<String, dynamic>? selectedUser;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      spacing: 20,
      children: [
        // Header(title: 'User management'),
        // Divider(),
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
            SizedBox(
              height: 50,
              width: 100,
              child: TextButton(
                onPressed: (){},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sort),
                    Text('Desc'),
                  ],
                )
              ),
            ),
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
              child: PaginatedDataTable(
                rowsPerPage: 10,
                source: _data,
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Points')),
                  DataColumn(label: Text('Actions')),
                ], 
                header: const Center(child: Text('List users')),
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
                      title: Text(user['name']!),
                      leading: Image.asset(CImages.avatar, width: 30,),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(user['email']!), // Existing email field
                          Text('${user['phone'] ?? 'N/A'}'), // New phone number field
                          Text('Points: ${user['points'] ?? 0}'), // New points field
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<String>(
                            value: user['status'],
                            onChanged: (String? newValue) {
                              // Cập nhật trạng thái người dùng
                            },
                            items: <String>['Active', 'Banned']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          IconButton(
                            iconSize: 16,
                            style: IconButton.styleFrom(
                              
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.delete, color: Colors.red,)
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> users = [
    {
      'name': 'Mokhasiemov',
      'email': 'mokhasiemov@gmail.com',
      'phone': '123-456-7890',
      'points': 100,
      'addresses': ['123 Main St', '456 Elm St'],
      'orders': [
        {
          'id': '001',
          'orderDate': '2023-01-01',
          'deliveryDate': '2023-01-05',
          'status': 'Delivered',
          'total': '250.00'
        },
      ],
      'status': 'Active'
    },
    {
      'name': 'Jayden_Cr',
      'email': 'jaydencr@example.com',
      'phone': '987-654-3210',
      'points': 150,
      'addresses': ['789 Oak St'],
      'orders': [
        {
          'id': '002',
          'orderDate': '2023-02-01',
          'deliveryDate': '2023-02-05',
          'status': 'Pending',
          'total': '150.00'
        },
      ],
      'status': 'Active'
    },
    // Thêm người dùng khác ở đây
  ];

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(users[index]['name'])),
        DataCell(Text(users[index]['email'])),
        DataCell(Text(users[index]['phone'])),
        DataCell(Text(users[index]['points'].toString())),
        DataCell(
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){
                  streamController.add(DetailUserScreen(user: users[index]));
                },
                icon: Icon(Icons.remove_red_eye)
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.delete)
              )
            ]
          ),
        ),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
  
}