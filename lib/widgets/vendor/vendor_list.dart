import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_admin/services/firebase_services.dart';

class VendorList extends StatelessWidget {
  const VendorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    Widget _vendorData({String? text, int? flex, Widget? widget}) {
      return Expanded(
        flex: flex!,
        child: Container(
          alignment: Alignment.centerLeft,
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: widget ?? Text(text!),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _service.vendor.orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something wrong!');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              Map<String, dynamic> dataa =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // logo
                  _vendorData(
                    flex: 1,
                    widget: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 50,
                      child: Image.network(
                        dataa['logo'],
                      ),
                    ),
                  ),
                  // businessName
                  _vendorData(
                    flex: 3,
                    text: snapshot.data!.docs[index]['businessName'],
                  ),
                  // city
                  _vendorData(
                    flex: 2,
                    text: snapshot.data!.docs[index]['cityValue'],
                  ),
                  // state
                  _vendorData(
                    flex: 2,
                    text: snapshot.data!.docs[index]['stateValue'],
                  ),
                  // action
                  _vendorData(
                    flex: 1,
                    widget: snapshot.data!.docs[index]['approved']
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                EasyLoading.show();
                                _service.updateData(
                                  data: {
                                    'approved': false,
                                  },
                                  reference: _service.vendor,
                                  docName: dataa['uid'],
                                );
                                EasyLoading.dismiss();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                EasyLoading.show();
                                _service.updateData(
                                  data: {
                                    'approved': true,
                                  },
                                  reference: _service.vendor,
                                  docName:dataa['uid'],
                                );
                                EasyLoading.dismiss();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 14, 7, 102),
                              ),
                              child: const Text(
                                'Approve',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                  // view more
                  _vendorData(
                    flex: 1,
                    widget: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 14, 7, 102),
                        ),
                        child: const Text(
                          'View More',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

