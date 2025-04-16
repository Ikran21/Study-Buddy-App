// Updated MoreAboutYouScreen with working custom inputs, editable classes, availability, and study preferences
import 'package:flutter/material.dart';

class MoreAboutYouScreen extends StatefulWidget {
  @override
  _MoreAboutYouScreenState createState() => _MoreAboutYouScreenState();
}

class _MoreAboutYouScreenState extends State<MoreAboutYouScreen> {
  String? selectedSchool = 'Georgia State University';
  String? selectedYear;
  int? selectedAge;
  String? selectedAvailability;
  String? selectedStudyPreference;

  List<String> majors = [
    "Art", "Biology", "Chemistry", "Data Science", "Forensics",
    "Physics", "Computer Science", "Finance", "History", "Math",
    "Marketing"
  ];
  List<String> selectedMajors = [];

  List<String> availableClasses = ["CSC 1301", "CSC 1302", "CSC 2300"];
  List<String> selectedClasses = [];

  List<String> interests = ["Sports", "Games", "Dancing", "Music", "Reading", "Cooking", "Volunteering"];
  List<String> selectedInterests = [];

  List<String> years = ["Freshman", "Sophomore", "Junior", "Senior"];
  List<int> ages = List.generate(60, (index) => 18 + index);
  List<String> availabilityOptions = ["Morning", "Afternoon", "Evenings"];
  List<String> studyPreferences = ["Group Discussions", "Solo Study", "Tutoring"];

  final TextEditingController _customSchoolController = TextEditingController();
  bool isCustomSchool = false;

  @override
  void dispose() {
    _customSchoolController.dispose();
    super.dispose();
  }

  void _showCustomDialog({
    required String title,
    required Function(String) onSubmit,
  }) async {
    String input = '';
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          onChanged: (value) => input = value,
          decoration: InputDecoration(hintText: "Type here"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (input.isNotEmpty) onSubmit(input);
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Provide more Information"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter your School name"),
              isCustomSchool
                  ? TextField(
                      controller: _customSchoolController,
                      decoration: InputDecoration(
                        hintText: 'Enter School Name',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => setState(() => isCustomSchool = false),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedSchool,
                            items: ["Georgia State University"].map((school) {
                              return DropdownMenuItem(value: school, child: Text(school));
                            }).toList(),
                            onChanged: (val) => setState(() => selectedSchool = val),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => setState(() => isCustomSchool = true),
                        )
                      ],
                    ),
              SizedBox(height: 20),
              Text("Major"),
              Wrap(
                spacing: 8,
                children: [
                  ...majors.map((major) => ChoiceChip(
                        label: Text(major),
                        selected: selectedMajors.contains(major),
                        onSelected: (selected) {
                          setState(() {
                            selected ? selectedMajors.add(major) : selectedMajors.remove(major);
                          });
                        },
                      )),
                  InputChip(
  label: Text("Other"),
  avatar: Icon(Icons.add),
  onPressed: () async {
    final customMajor = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          title: Text('Enter Custom Major'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => input = value,
            decoration: InputDecoration(hintText: "Type your major"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, input),
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (customMajor != null && customMajor.isNotEmpty) {
      setState(() {
        majors.add(customMajor); // ✅ adds to chip list
        selectedMajors.add(customMajor); // ✅ automatically selects it
      });
    }
  },
),

                ],
              ),
              SizedBox(height: 20),
              Text("Year"),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedYear,
                hint: Text("Select Year"),
                onChanged: (val) => setState(() => selectedYear = val),
                items: years.map((year) => DropdownMenuItem(value: year, child: Text(year))).toList(),
              ),
              SizedBox(height: 20),
              Text("Age"),
              DropdownButton<int>(
                isExpanded: true,
                value: selectedAge,
                hint: Text("Select Age"),
                onChanged: (val) => setState(() => selectedAge = val),
                items: ages.map((age) => DropdownMenuItem(value: age, child: Text(age.toString()))).toList(),
              ),
              SizedBox(height: 20),
              Text("Classes"),
              ...availableClasses.map((className) => CheckboxListTile(
                    title: Text(className),
                    value: selectedClasses.contains(className),
                    onChanged: (checked) {
                      setState(() {
                        checked == true ? selectedClasses.add(className) : selectedClasses.remove(className);
                      });
                    },
                  )),
              TextButton(
                onPressed: () => _showCustomDialog(
                  title: 'Enter Custom Class',
                  onSubmit: (input) => setState(() => availableClasses.add(input)),
                ),
                child: Text("+ Add Other Class"),
              ),
              SizedBox(height: 20),
              Text("Other Interests"),
              Wrap(
                spacing: 8,
                children: [
                  ...interests.map((interest) => ChoiceChip(
                        label: Text(interest),
                        selected: selectedInterests.contains(interest),
                        onSelected: (selected) {
                          setState(() {
                            selected ? selectedInterests.add(interest) : selectedInterests.remove(interest);
                          });
                        },
                      )),
                  InputChip(
  label: Text("Other"),
  avatar: Icon(Icons.add),
  onPressed: () async {
    final customInterest = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          title: Text('Enter Custom Interest'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => input = value,
            decoration: InputDecoration(hintText: "Type your interest"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, input),
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (customInterest != null && customInterest.isNotEmpty) {
      setState(() {
        interests.add(customInterest); // ✅ show as chip
        selectedInterests.add(customInterest); // ✅ select it
      });
    }
  },
),

                ],
              ),
              SizedBox(height: 20),
              Text("Availability"),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedAvailability,
                hint: Text("Select Availability"),
                onChanged: (val) => setState(() => selectedAvailability = val),
                items: availabilityOptions.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
              ),
              SizedBox(height: 20),
              Text("Study Preferences"),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedStudyPreference,
                hint: Text("Select Study Preference"),
                onChanged: (val) => setState(() => selectedStudyPreference = val),
                items: studyPreferences.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("School: ${isCustomSchool ? _customSchoolController.text : selectedSchool}");
                    print("Majors: $selectedMajors");
                    print("Year: $selectedYear");
                    print("Age: $selectedAge");
                    print("Classes: $selectedClasses");
                    print("Interests: $selectedInterests");
                    print("Availability: $selectedAvailability");
                    print("Study Preference: $selectedStudyPreference");
                  },
                  child: Text("Continue"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
