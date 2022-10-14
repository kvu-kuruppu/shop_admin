import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:developer' as devtools show log;

import 'package:shop_admin/services/firebase_services.dart';
import 'package:shop_admin/widgets/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category';

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _categoryName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic img;
  String? fileName;

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
        firebase_storage.FirebaseStorage.instance.ref('category/$fileName');

    try {
      await ref.putData(img);
      await ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {
          _service.saveCategory(
            data: {
              'categoryName': _categoryName.text,
              'image': value,
              'active': true,
            },
            reference: _service.categories,
            docName: _categoryName.text,
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
      _categoryName.clear();
      img = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Categories
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                children: [
                  // Category Image
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
                            ? const Text('Category Image')
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
              // Category Name Input
              SizedBox(
                width: 200,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _categoryName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Category name is required*';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text('Enter Category Name'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
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
        ),
        const Divider(),
        // Category List
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Category List',
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
            reference: _service.categories,
          ),
        ),
      ],
    );
  }
}
