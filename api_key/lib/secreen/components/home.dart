import 'package:flutter/material.dart';
import 'package:api_key/secreen/components/appbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:api_key/secreen/components/Drawer_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  final TextEditingController _searchController = TextEditingController();

  List meals = [];
  List filteredMeals = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    fetchMeal();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ initialize speech
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (error) {
       if(!mounted)return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${error.errorMsg}"),
            backgroundColor: Colors.red,
          ),
        );
      },
      onStatus: (status) {
        print('📢 Speech status: $status'); // ✅ watch this in console
      },
      debugLogging: true, // ✅ enables detailed logs
    );
    print('✅ Speech enabled: $_speechEnabled'); // ✅ check if true or false
    setState(() {});
  }

  // ✅ start listening
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  // ✅ stop listening
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  // ✅ handle speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _searchController.text = _lastWords;
    });
    searchMeals(_lastWords);
    _stopListening();
  }

  // ✅ fetch meals from API
  Future<void> fetchMeal() async {
    try {
      final response = await http
          .get(
            Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=a"),
          )
          .timeout(Duration(seconds: 10));
      final data = jsonDecode(response.body);
      setState(() {
        meals = data["meals"];
        filteredMeals = data["meals"];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load. Check internet connection."),
          backgroundColor: Colors.deepOrange,
        ),
      );
    }
  }

  // ✅ search/filter meals
  void searchMeals(String query) {
    setState(() {
      searchQuery = query;
      filteredMeals = meals.where((meal) {
        return meal["strMeal"].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // ✅ badge widget
  Widget _badge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withRed(4)),
      ),

      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ✅ ingredients builder
  Widget _buildIngredients(dynamic meal) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = meal["strIngredient$i"];
      final measure = meal["strMeasure$i"];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add("$measure $ingredient".trim());
      }
    }
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: ingredients
          .map(
            (item) => Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                "• $item",
                style: TextStyle(fontSize: 12, color: Colors.orange[800]),
              ),
            ),
          )
          .toList(),
    );
  }

  // ✅ skeleton card
  Widget _skeletonCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 160, height: 14, color: Colors.grey[300]),
              SizedBox(height: 8),
              Container(width: 100, height: 10, color: Colors.grey[200]),
              SizedBox(height: 8),
              Container(width: 80, height: 10, color: Colors.grey[200]),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      drawer: Drawer_page(),
      backgroundColor: Color(0xFFF5F5F5),
      appBar: MyAppbar(title: "Home page"),
      body: Column(
        children: [
          // ✅ search bar
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              controller: _searchController,
              onChanged: searchMeals,
              decoration: InputDecoration(
                hintText: _speechToText.isListening
                    ? "🎤 Listening..."
                    : "Search meals...",
                hintStyle: TextStyle(
                  color: _speechToText.isListening
                      ? Colors.deepOrange
                      : Colors.grey[400],
                ),
                prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            searchQuery = "";
                            filteredMeals = meals;
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: _speechToText.isListening
                    ? Colors.orange[50]
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.deepOrange, width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // ✅ listening indicator
          if (_speechToText.isListening)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.mic, color: Colors.deepOrange, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Listening... tap mic to stop",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // ✅ result counter
          if (!isLoading && !_speechToText.isListening)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${filteredMeals.length} meals found",
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  // ✅ show last voice search
                  if (_lastWords.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.mic, size: 13, color: Colors.grey[400]),
                        SizedBox(width: 4),
                        Text(
                          '"$_lastWords"',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

          // ✅ body content
          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => _skeletonCard(),
                  )
                : filteredMeals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 70,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 12),
                        Text(
                          "No meals found for",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "\"$searchQuery\"",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        // ✅ try voice search button
                        ElevatedButton.icon(
                          onPressed: _startListening,
                          icon: Icon(Icons.mic),
                          label: Text("Try Voice Search"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                meal['strMealThumb'],
                                width: 65,
                                height: 65,
                                fit: BoxFit.cover,
                                cacheWidth: 100,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  }
                                  return Container(
                                    width: 65,
                                    height: 65,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              meal["strMeal"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  _badge(
                                    meal["strCategory"],
                                    Colors.deepOrange,
                                  ),
                                  SizedBox(width: 6),
                                  _badge(meal["strArea"], Colors.teal),
                                ],
                              ),
                            ),
                            iconColor: Colors.deepOrange,
                            collapsedIconColor: Colors.grey,
                            children: [
                              Divider(height: 1, color: Colors.grey[200]),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        meal['strMealThumb'],
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      "🧂 Ingredients",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    _buildIngredients(meal),
                                    SizedBox(height: 14),
                                    Divider(color: Colors.grey[300]),
                                    SizedBox(height: 8),
                                    Text(
                                      "📋 Instructions",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      meal["strInstructions"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ✅ voice mic button
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isNotListening
            ? _startListening
            : _stopListening,
        backgroundColor: _speechToText.isListening
            ? Colors.red
            : Colors.deepOrange,
        tooltip: _speechToText.isListening
            ? 'Stop listening'
            : 'Search by voice',
        child: Icon(
          _speechToText.isNotListening ? Icons.mic : Icons.mic_none,
          color: Colors.white,
        ),
      ),
    );
  }
}
