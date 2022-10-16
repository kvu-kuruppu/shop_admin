import 'package:flutter/material.dart';
import 'package:shop_admin/widgets/vendor/vendor_list.dart';
import 'package:shop_admin/widgets/vendor/vendor_widget.dart';

class VendorScreen extends StatefulWidget {
  static const String id = 'vendor';

  const VendorScreen({Key? key}) : super(key: key);

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  bool? _selectedButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Vendors
              const Text(
                'Vendors',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Row(
                children: [
                  // Approved
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedButton = true;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: _selectedButton == true
                          ? const Color.fromARGB(255, 5, 85, 9)
                          : const Color.fromARGB(255, 94, 72, 7),
                    ),
                    child: const Text(
                      'Approved',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Rejected
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedButton = false;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: _selectedButton == false
                          ? const Color.fromARGB(255, 5, 85, 9)
                          : const Color.fromARGB(255, 94, 72, 7),
                    ),
                    child: const Text(
                      'Rejected',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // All
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedButton = null;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: _selectedButton == null
                          ? const Color.fromARGB(255, 5, 85, 9)
                          : const Color.fromARGB(255, 94, 72, 7),
                    ),
                    child: const Text(
                      'All',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
        // Row Heading
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            children: const [
              RowHeader(text: 'LOGO', flex: 1),
              RowHeader(text: 'BUSINESS NAME', flex: 3),
              RowHeader(text: 'CITY', flex: 2),
              RowHeader(text: 'STATE', flex: 2),
              RowHeader(text: 'ACTION', flex: 1),
              RowHeader(text: 'VIEW MORE', flex: 1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          // child: VendorList(),
          child: VendorList(approveStatus: _selectedButton),
        ),
      ],
    );
  }
}
