import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class FilterOption {
  FilterOption(this.title, this.value);

  final String title;
  bool value;
}

class _SearchPageState extends State<SearchPage> {
  List<FilterOption> filterOptions = [
    FilterOption("No Kids Zone", false),
    FilterOption("Pet-Friendly", false),
    FilterOption("Free Breakfast", false),
  ];

  DateTime? checkInDate;

  bool isFilterExpanded = false;

  void handleSearchButtonPress() {
    String selectedFilters = "Selected Filters:\n";
    for (var option in filterOptions) {
      if (option.value) {
        selectedFilters += "${option.title}\n";
      }
    }

    String formattedDate = checkInDate != null
        ? DateFormat('yyyy-MM-d (E)').format(checkInDate!)
        : "Select Date";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Please check your choice"),
          content: Text("$selectedFilters\nCheck-in Date: $formattedDate"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Search"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'search',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isFilterExpanded = !isFilterExpanded;
              });
            },
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Select Filters",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                      isFilterExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (isFilterExpanded)
            Column(
              children: filterOptions.map((FilterOption option) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 16),
                  title: Row(
                    children: [
                      Checkbox(
                        value: option.value,
                        onChanged: (bool? value) {
                          setState(() {
                            option.value = value ?? false;
                          });
                        },
                      ),
                      Text(option.title),
                    ],
                  ),
                );
              }).toList(),
            ),
          Divider(),
          ListTile(
            title: Text(
              "Date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 16),
            title: Text(
              checkInDate != null
                  ? DateFormat('yyyy-MM-d (E)').format(checkInDate!)
                  : "Select Date",
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              final DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
              );
              if (selectedDate != null) {
                setState(() {
                  checkInDate = selectedDate;
                });
              }
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              handleSearchButtonPress();
            },
            child: Text("Search"),
          ),
        ],
      ),
    );
  }
}
