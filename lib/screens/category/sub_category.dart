import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:developer' as devtools show log;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:shop_admin/services/firebase_services.dart';
import 'package:shop_admin/widgets/category_widget.dart';

class SubCategoryScreen extends StatefulWidget {
  static const String id = 'sub-category';

  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _subCategoryName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic img;
  String? fileName;
  Object? _selectedValue;
  bool _noCategorySelected = false;
  QuerySnapshot? snapshot;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        img = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    } else {
      devtools.log('Cancelled');
    }
  }

  saveImgToDB() async {
    EasyLoading.show();

    var ref =
        firebase_storage.FirebaseStorage.instance.ref('subCategory/$fileName');

    try {
      await ref.putData(img);
      await ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {
          _service.saveCategory(
            data: {
              'subCategoryName': _subCategoryName.text,
              'mainCategoryName': _selectedValue,
              'image': value,
              'active': true,
            },
            reference: _service.subCategory,
            docName: _subCategoryName.text,
          ).then((value) {
            clear();
            EasyLoading.dismiss();
          });
        }
        return value;
      });
    } on FirebaseException catch (e) {
      clear();
      EasyLoading.dismiss();
      devtools.log(e.toString());
    }
  }

  clear() {
    setState(() {
      _subCategoryName.clear();
      img = null;
      _selectedValue = null;
    });
  }

  @override
  void initState() {
    getMainCategoryList();
    super.initState();
  }

  getMainCategoryList() {
    return _service.mainCategory.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  Widget _dropdownButton() {
    return DropdownButton(
      value: _selectedValue,
      hint: const Text('Select Main Category'),
      items: snapshot!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['mainCategory'],
          child: Text(e['mainCategory']),
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
          // Sub Categories
          const Text(
            'Sub Categories',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    // Sub Category Image
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Center(
                          child: img == null
                              ? const Text('Sub Category Image')
                              : Image.memory(img, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    // Upload Image
                    ElevatedButton(
                      onPressed: pickImage,
                      child: const Text('Upload Image'),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    snapshot == null
                        ? const CircularProgressIndicator()
                        : _dropdownButton(),
                    const SizedBox(
                      height: 8,
                    ),
                    // No Main Category Selected
                    if (_noCategorySelected == true)
                      const Text(
                        'No Main Category Selected',
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
                          controller: _subCategoryName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Sub Category is required*';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Enter Sub Category Name'),
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
                        img == null
                            ? Container()
                            : TextButton(
                                onPressed: clear,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red.withOpacity(0.1)),
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
                        img == null
                            ? Container()
                            : TextButton(
                                onPressed: () {
                                  if (_selectedValue == null) {
                                    setState(() {
                                      _noCategorySelected = true;
                                    });
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    saveImgToDB();
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.withOpacity(0.1)),
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
                  ],
                ),
              ],
            ),
          ),
          // Sub Category List
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sub Category List',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CategoryWidgetList(
              reference: _service.subCategory,
            ),
          ),
        ],
      ),
    );
  }
}
