import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_contact_tracker/routes/contact_selection/searchable_contact_list/searchable_contact_list_bloc.dart';

class ContactSelectionSearchWidget extends StatefulWidget {
  ContactSelectionSearchWidget({Key key}) : super(key: key);

  @override
  _ContactSelectionSearchWidgetState createState() =>
      _ContactSelectionSearchWidgetState();
}

class _ContactSelectionSearchWidgetState
    extends State<ContactSelectionSearchWidget> {
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onType);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
          hintText: 'Kontakte suchen',
          hintStyle: TextStyle(
            color: Color(0xFF718096),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          fillColor: Color(0xFFF3F5FA),
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
              borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
              gapPadding: 0.0),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF63B3ED), width: 1.0),
              borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
              gapPadding: 0.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
              borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
              gapPadding: 0.0),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          )),
    );
  }

  void _onType() {
    BlocProvider.of<SearchableContactListBloc>(context)
        .add(SearchQueryChangedEvent(_searchController.text));
  }
}
