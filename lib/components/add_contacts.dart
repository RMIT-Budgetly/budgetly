import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactButton extends StatefulWidget {
  final void Function(List<Contact> contacts) onContactSelected;

  const AddContactButton({
    Key? key,
    required this.onContactSelected,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddContactButtonState createState() => _AddContactButtonState();
}

class _AddContactButtonState extends State<AddContactButton> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts(
        androidLocalizedLabels: true,
      );
      setState(
        () {
          _contacts = contacts.toList();
        },
      );
      widget.onContactSelected(_contacts);
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    } else {
      setState(
        () {
          _contacts = [];
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hintColor = _contacts.isNotEmpty
        ? Colors.black // Color when date and time are selected
        : Colors.black38; // Color when date and time are not selected

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              onPressed: _getContacts,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _contacts.isNotEmpty ? "Contacts selected" : "Select contacts",
                style: TextStyle(
                  color: hintColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
