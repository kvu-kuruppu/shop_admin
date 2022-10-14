import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_admin/services/firebase_services.dart';
import 'package:shop_admin/widgets/main_category_widget.dart';

class MainCategoryScreen extends StatefulWidget {
  static const String id = 'main-category';

  const MainCategoryScreen({Key? key}) : super(key: key);

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _mainCategory = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Object? _selectedValue;
  bool _noCategorySelected = false;
  QuerySnapshot? snapshot;

  clear() {
    setState(() {
      _selectedValue = null;
      _mainCategory.clear();
    });
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  getCategoryList() {
    return _service.categories.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
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
          _noCategorySelected = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Categories
          const Text(
            'Main Categories',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
          const Divider(),
          snapshot == null
              ? const CircularProgressIndicator()
              : _dropdownButton(),
          const SizedBox(
            height: 8,
          ),
          // No Category Selected
          if (_noCategorySelected == true)
            const Text(
              'No Category Selected',
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(
            height: 10,
          ),
          // Main Category Input
          SizedBox(
            width: 200,
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _mainCategory,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Main Category is required*';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text('Enter Main Category Name'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              // Cancel
              TextButton(
                onPressed: clear,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.withOpacity(0.1)),
                  side: MaterialStateProperty.all(
                    const BorderSide(color: Colors.red),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              // Save
              TextButton(
                onPressed: () {
                  if (_selectedValue == null) {
                    setState(() {
                      _noCategorySelected = true;
                    });
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show();
                    _service.saveCategory(
                      data: {
                        'category': _selectedValue,
                        'mainCategory': _mainCategory.text,
                        'approved': true,
                      },
                      reference: _service.mainCategory,
                      docName: _mainCategory.text,
                    ).then((value) {
                      clear();
                      EasyLoading.dismiss();
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
                  side: MaterialStateProperty.all(
                    const BorderSide(color: Colors.blue),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const Divider(),
          // Category List
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Main Category List',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
          ),
          const Divider(),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: MainCategoryWidgetList(),
            ),
          ),
        ],
      ),
    );
  }
}
