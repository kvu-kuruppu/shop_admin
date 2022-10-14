import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin/services/firebase_services.dart';

class CategoryWidgetList extends StatefulWidget {
  final CollectionReference? reference;
  const CategoryWidgetList({Key? key, this.reference}) : super(key: key);

  @override
  State<CategoryWidgetList> createState() => _CategoryWidgetListState();
}

class _CategoryWidgetListState extends State<CategoryWidgetList> {
  final FirebaseService _service = FirebaseService();
  Object? _selectedValue;
  QuerySnapshot? snapshot;

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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.reference == _service.subCategory && snapshot != null)
          Row(
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
              )
            ],
          ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: widget.reference!
              .where('mainCategoryName', isEqualTo: _selectedValue)
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
              return const Text("No Categories Added");
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Image.network(
                                data['image'],
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          Text(
                            widget.reference == _service.categories
                                ? data['categoryName']
                                : data['subCategoryName'],
                            textAlign: TextAlign.center,
                          ),
                        ],
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
