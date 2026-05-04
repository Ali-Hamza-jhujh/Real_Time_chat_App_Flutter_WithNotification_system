import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:api_key/secreen/components/charapp.dart';
import 'package:api_key/secreen/components/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:api_key/secreen/components/profile.dart';

class Voice extends StatefulWidget {
  const Voice({super.key});

  @override
  _MyWidgetsDemoState createState() => _MyWidgetsDemoState();
}

class _MyWidgetsDemoState extends State<Voice> {
  final List<Widget> pages = [Home(), Chatapp()];
  // State variables
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  int isselected = 0;
  bool isChecked = false;
  bool isSwitched = false;
  bool isvalue = false;
  double isvalue1 = 10;
  int selectedValue = 10;
  String search = "";
  TextEditingController searchs = TextEditingController();
  double vol = 17;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widgets Demo")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TextField with required *
            Text(
              "Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Enter your Name",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: " *",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
              ),
            ),
            SizedBox(height: 30),

            // --- Checkbox
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val!;
                    });
                  },
                ),
                Text(
                  "Accept Terms & Conditions",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),

            // --- Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Dark mode"),
                Switch(
                  value: isSwitched,
                  onChanged: (val) {
                    setState(() {
                      isSwitched = val;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // --- Regular Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Regular Button Pressed!")),
                );
              },
              child: Text("Submit"),
            ),
            SizedBox(height: 20),

            // --- Icon Button
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Icon Button Pressed!")));
              },
              icon: Icon(Icons.thumb_up, color: Colors.blue),
              iconSize: 36,
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Card", style: TextStyle(fontWeight: FontWeight.w900)),
                    SizedBox(height: 20),
                    Text("Kia ho rha hy kia ker rahy ho"),
                    SizedBox(height: 20),
                    OutlinedButton(onPressed: () {}, child: Text("data")),
                  ],
                ),
              ),
            ),
            // --- Text Button
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Text Button Pressed!")));
              },
              child: Text("Click Me", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),

            // --- Outlined Button
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Outlined Button Pressed!")),
                );
              },
              child: Text("Outlined Button"),
            ),
            Slider(
              value: vol,
              min: 0,
              max: 100,
              onChanged: (val) {
                setState(() {
                  vol = val;
                });
              },
            ),

            // CircularProgressIndicator(color: Colors.red,)
            LinearProgressIndicator(value: 0.7),

            Chip(
              avatar: CircleAvatar(
                child: Text("D"),
                backgroundColor: Colors.indigo,
              ),
              label: Text("Flutter"),
              deleteIcon: Icon(Icons.close),
              onDeleted: () {},
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Delete?"),
                      content: Text("Are you sure?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Test Alertbox"),
            ),

            Stack(
              children: [
                Image.asset("assets/images/image1.JPG"),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Badge(child: Icon(Icons.message)),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "name",
                hintText: "Enter name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            SizedBox(height: 90),
            ElevatedButton(
              onPressed: () async {
                DateTime? Picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030),
                );
                setState(() {
                  selectedDate = Picked;
                });
              },
              child: Text("Date picker $selectedDate"),
            ),

            SizedBox(height: 90),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pick = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() {
                  selectedTime = pick;
                });
              },
              child: Text("Time picker ${selectedTime}"),
            ),

            SizedBox(height: 90),
            Checkbox(
              value: isvalue,
              onChanged: (value) => setState(() => isvalue = value!),
            ),

            SizedBox(height: 90),
            Switch(
              value: isvalue,

              onChanged: (value) => setState(() {
                isvalue = value;
              }),
            ),
            SizedBox(height: 20),
            Slider(
              value: isvalue1,
              min: 0,
              max: 100,
              onChanged: (value) => setState(() {
                isvalue1 = value;
              }),
            ),
            SizedBox(height: 20),
            RadioMenuButton(
              value: 10,
              groupValue: selectedValue,
              onChanged: (value) => setState(() {
                if (selectedValue == value) {
                  selectedValue = 0;
                } else {
                  selectedValue = value!;
                }
              }),
              child: Text("Ali hamza"),
            ),

            Chip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color.fromARGB(255, 142, 153, 218),
              avatar: CircleAvatar(
                backgroundImage: AssetImage("assets/images/image1.JPG"),
              ),
              label: Text("What is name"),
              deleteIcon: Icon(Icons.close),
              onDeleted: () {},
            ),
            SizedBox(height: 30),

            SizedBox(height: 30),
            Tooltip(
              message: "This is a tooltip", // Text shown on long press
              child: Icon(Icons.info), // Widget that triggers tooltip
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Profile()),
                );
              },
              child: Hero(
                tag: "Profile_image",
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/image1.JPG"),
                  radius: 40,
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              color: Colors.red,
              width: 100,
              height: 100,
            ),
            Wrap(
              spacing: 20,
              children: [
                Chip(label: Text("A")),
                Chip(label: Text("B")),
                Chip(label: Text("C")),
                Chip(label: Text("D")),
                Chip(label: Text("E")),
                Chip(label: Text("F")),
                Chip(label: Text("G")),
              ],
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset("assets/images/image1.JPG"),
            ),
            LayoutBuilder(
              builder: (context, Constraints) {
                if (Constraints.maxWidth > 400) {
                  return Text("Mobile secreen");
                } else {
                  return Text("Tablet secreen");
                }
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.list),
              title: Text("Fruits"),
              children: [
                ListTile(title: Text("Apple")),
                ListTile(title: Text("Banana")),
                ListTile(title: Text("Orange")),
              ],
            ),
            SearchBar(
              hintText: "Searching...",
              controller: searchs,
              leading: Icon(Icons.search),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              trailing: [
                IconButton(
                  onPressed: () {
                    searchs.clear();
                  },
                  icon: Icon(Icons.clear),
                ),
              ],
            ),
            Stepper(
  steps: [
    Step(title: Text('Step 1'), content: Text('Enter name')),
    Step(title: Text('Step 2'), content: Text('Enter email')),
    Step(title: Text('Step 3'), content: Text('Confirm details')),
  ],
  currentStep: 0,
  onStepContinue: () {},
  onStepCancel: () {},
),

InteractiveViewer(
  panEnabled: true,
  scaleEnabled: true,
  minScale: 0.5,
  maxScale: 4.0,
  child: Image.network(
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
  ),
),
SizedBox(height: 50,)
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("FAB Clicked!")));
        },
        child: Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
