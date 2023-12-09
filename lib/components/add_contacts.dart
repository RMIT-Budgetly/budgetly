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
    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts(
        androidLocalizedLabels: true,
      );
      setState(
        () {
          _contacts = contacts.toList();
        },
      );
      widget.onContactSelected(_contacts);
    } else {
      setState(
        () {
          _contacts = [];
        },
      );
    }
  }

  void _showSelectedContactsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected Contacts'),
          content: _contacts.isEmpty
              ? const Text('No contacts selected.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _contacts.map((contact) {
                    return ListTile(
                      title: Text(contact.displayName ?? ''),
                      subtitle: Text(contact.phones?.isNotEmpty == true
                          ? contact.phones!.first.value ?? ''
                          : ''),
                      // You can display more contact details here
                    );
                  }).toList(),
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
              onPressed: () async {
                _getContacts();
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: TextButton(
              onPressed: () async {
                _showSelectedContactsDialog();
              },
              child: Text(
                _contacts.isNotEmpty ? "Contacts Selected" : "Select Contacts",
                style: TextStyle(
                  color: hintColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],
      ),
    );
  }
}
