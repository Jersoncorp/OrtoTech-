import 'package:flutter/material.dart';
import 'daglat.dart';
import 'pagbaybay.dart';
import 'kambal_patinig.dart';

class SuriinPage extends StatefulWidget {
  const SuriinPage({super.key});

  @override
  _SuriinPageState createState() => _SuriinPageState();
}

class _SuriinPageState extends State<SuriinPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> tiles = [
    {'text': 'Kasong Kambal Patinig'},
    {'text': 'Daglat, Inisyals, Akronim'},
    {'text': 'Pagbaybay na Pasulat'},
  ];
  List<Map<String, dynamic>> filteredTiles = [];

  @override
  void initState() {
    super.initState();
    filteredTiles = List.from(tiles);
    _searchController.addListener(_filterTiles);
  }

  void _filterTiles() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTiles = tiles
          .where(
              (tile) => tile['text'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  void navigateToPage(BuildContext context, String text) {
    switch (text) {
      case 'Kasong Kambal Patinig':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KambalPatinigPage()),
        );
        break;
      case 'Daglat, Inisyals, Akronim':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DaglatPage()),
        );
        break;
      case 'Pagbaybay na Pasulat':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PagbaybayPage()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: const Text(
          'Suriin',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar with rounded corners and light background
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Hanapin Dito',
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 247, 250, 252),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
              ),
            ),
            const SizedBox(height: 20),
            // Display filtered tiles
            Expanded(
              child: filteredTiles.isEmpty
                  ? const Center(
                      child: Text(
                        'Walang natagpuang resulta.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTiles.length,
                      itemBuilder: (context, index) {
                        final tile = filteredTiles[index];
                        return buildTile(context, tile['text']);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(20),
        elevation: 15, // Increased elevation for stronger shadow
        shadowColor: const Color.fromARGB(255, 227, 213, 252)
            .withOpacity(0.4), // Adjusted shadow opacity for a softer shadow
        child: InkWell(
          onTap: () => navigateToPage(context, text),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 203, 202, 212),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
