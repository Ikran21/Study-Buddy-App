import 'package:flutter/material.dart';

class MoreAboutYouScreen extends StatefulWidget {
  @override
  _MoreAboutYouScreenState createState() => _MoreAboutYouScreenState();
}

class _MoreAboutYouScreenState extends State<MoreAboutYouScreen> {
  String? selectedSchool = 'Georgia State University';
  String? selectedYear;
  int? selectedAge;

  List<String> majors = [
    "Art", "Biology", "Chemistry", "Data Science", "Forensics",
    "Physics", "Computer Science", "Finance", "History", "Math",
    "Marketing"
  ];
  List<String> selectedMajors = [];

  List<String> availableClasses = ["CSC 1301", "CSC 1302", "CSC 2300"];
  List<String> selectedClasses = [];

  List<String> years = ["Freshman", "Sophomore", "Junior", "Senior"];
  List<int> ages = List.generate(60, (index) => 18 + index);

  List<String> interests = [
    "Sports", "Games", "Dancing", "Music", "Reading", "Cooking", "Volunteering"
  ];
  List<String> selectedInterests = [];

  final TextEditingController _customSchoolController = TextEditingController();
  bool isCustomSchool = false;

  @override
  void dispose() {
    _customSchoolController.dispose();
    super.dispose();
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
              Text("Enter your School name", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
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
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSchool = newValue;
                              });
                            },
                            items: <String>["Georgia State University"]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => setState(() => isCustomSchool = true),
                        )
                      ],
                    ),
              const SizedBox(height: 20),
              Text("Major", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ...majors.map((major) => ChoiceChip(
                        label: Text(major),
                        selected: selectedMajors.contains(major),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedMajors.add(major);
                            } else {
                              selectedMajors.remove(major);
                            }
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
                          selectedMajors.add(customMajor);
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Year", style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedYear,
                hint: Text("Select Year"),
                onChanged: (value) => setState(() => selectedYear = value),
                items: years.map((year) => DropdownMenuItem(
                  value: year,
                  child: Text(year),
                )).toList(),
              ),
              const SizedBox(height: 20),
              Text("Age", style: TextStyle(fontSize: 16)),
              DropdownButton<int>(
                isExpanded: true,
                value: selectedAge,
                hint: Text("Select Age"),
                onChanged: (value) => setState(() => selectedAge = value),
                items: ages.map((age) => DropdownMenuItem(
                  value: age,
                  child: Text(age.toString()),
                )).toList(),
              ),
              const SizedBox(height: 20),
              Text("Classes", style: TextStyle(fontSize: 16)),
              ...availableClasses.map((className) => CheckboxListTile(
                    title: Text(className),
                    value: selectedClasses.contains(className),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selectedClasses.add(className);
                        } else {
                          selectedClasses.remove(className);
                        }
                      });
                    },
                  )),
              const SizedBox(height: 20),
              Text("Other Interests", style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 8,
                children: [
                  ...interests.map((interest) => ChoiceChip(
                        label: Text(interest),
                        selected: selectedInterests.contains(interest),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedInterests.add(interest);
                            } else {
                              selectedInterests.remove(interest);
                            }
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
                          selectedInterests.add(customInterest);
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("School: ${isCustomSchool ? _customSchoolController.text : selectedSchool}");
                    print("Majors: $selectedMajors");
                    print("Year: $selectedYear");
                    print("Age: $selectedAge");
                    print("Classes: $selectedClasses");
                    print("Interests: $selectedInterests");
                  },
                  child: Text("Continue"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}