import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin/services/firebase_services.dart';

class MainCategoryWidgetList extends StatefulWidget {
  const MainCategoryWidgetList({Key? key}) : super(key: key);

  @override
  State<MainCategoryWidgetList> createState() => _MainCategoryWidgetListState();
}

class _MainCategoryWidgetListState extends State<MainCategoryWidgetList> {
  final FirebaseService _service = FirebaseService();
  Object? _selectedValue;
  QuerySnapshot? snapshot;

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  Widget _dropdownButton() {
    return DropdownButton(
      value: _selectedValue,
      hint: const Text('Select Category'),
      items: snapshot!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['categoryName'],
          child: Text(e['categoryName']),
        );
      }).toList(),
      onChanged: (selectedCategory) {
        setState(() {
          _selectedValue = selectedCategory;
        });
      },
    );
  }

  getCategoryList() {
    return _service.categories.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        snapshot == null
            ? const CircularProgressIndicator()
            : Row(
                children: [
                  _dropdownButton(),
                  const SizedBox(
                    width: 10,
                  ),
                  // Show All
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedValue = null;
                      });
                    },
                    child: const Text('Show All'),
                  ),
                ],
              ),
        StreamBuilder<QuerySnapshot>(
          stream: _service.mainCategory
              .where('category', isEqualTo: _selectedValue)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.red,
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Text("No Main Category Added");
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                ),
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return Card(
                    color: Colors.indigo.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          data['mainCategory'],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
