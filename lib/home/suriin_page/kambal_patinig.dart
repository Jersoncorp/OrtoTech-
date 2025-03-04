import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class KambalPatinigPage extends StatefulWidget {
  const KambalPatinigPage({super.key});

  @override
  _KambalPatinigPageState createState() => _KambalPatinigPageState();
}

class _KambalPatinigPageState extends State<KambalPatinigPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the YouTube video controller with the YouTube video ID (from the URL)
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          'https://youtu.be/iWFVBe7xPmA?si=2VBowkmTXiwT9oxp')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false, // Video won't autoplay, you can change this to true
        mute: false, // Sound will be enabled by default
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 244, 244),
      appBar: AppBar(
        title: const Text(
          "KASONG KAMBAL PATINIG",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // YouTube Video Player Section
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              onReady: () {
                // You can handle video ready state if needed
              },
            ),

            const SizedBox(height: 30),

            // Title Text Section
            _sectionTitle("KASONG KAMBAL-PATINIG", Colors.black),
            const SizedBox(height: 20),

            // Description Section
            _sectionTitle("ANO ANG KAMBAL-PATINIG?", Colors.black),
            _sectionContent(
                "Ito ang magkasunod na patinig sa loob ng isang salita at ang maituturing na Kambal-Patinig ay ang mga hiram na salita mula sa Espanyol."),
            const SizedBox(height: 20),

            // Explanation of Traditional Spelling
            _sectionTitle(
                "DALAWANG (2) TRADISYONAL NA PAGSULAT SA TUNOG NG KAMBAL PATINIG:",
                Colors.black),
            _sectionContent(
                "1. Kapag naganap ang kambal-patinig sa unang pantig ng salita, mananatili ang kambal-patinig. Isinisingit ang W o Y at nagiging dalawang pantig."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "Buan - buWan\n"
                "Tuing - tuWing\n"
                "Tian - TiYan\n"
                "Sia - siYA\n"
                "Biak - biYak"),
            const SizedBox(height: 20),
            _sectionContent(
                "2. Kapag naganap ang kambal-patinig sa ikalawa o iba pang pantig ng salita, ang unang patinig ay iniaalis at pinapalitan ng W o Y."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "Tulia - TulYa\n"
                "Tilapia - TilapYa\n"
                "Saua - SaWa\n"
                "Pinaua - PinaWa"),
            const SizedBox(height: 20),

            _sectionContent(
                "Sapangkalahatan, nawawala ang unang patinig sa mga kambal-patinig na I +(A, E, O) at U + (A, E, O) kapag nasisingitan ng Y at W as pagsulat."),
            const SizedBox(height: 10),
            _sectionContent(
                "Nagiging Y ang orihinal na I at W ang orihinal na U sa diptonggo."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "Acacia - AkasYA\n"
                "Teniente - TenYEnte\n"
                "Perjuicio - perWIsyo\n"
                "Indibidual - indibidWAl"),
            const SizedBox(height: 20),

            _sectionTitle(
                "PARAAN NG PAGBABAYBAY NG MGA SALITANG HIRAM NA MAY KAMBAL-PATINIG",
                Colors.black),
            _sectionContent(
                "Patinig na Malakas- /A, E, O/ \nPatinig na Mahina- /U, I/- masasabing mahinang patinig kung naglalaho ang tunog na I at U kapag napapalitan ng tunog na /y, w/"),
            const SizedBox(height: 10),
            _sectionContent(
                "1. MALAKAS + MALAKAS (ae, ao, ea, eo, oe)- nanatili ang kambal patinig tuwing binabaybay."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "KASTILA                 FILIPINO\n"
                "teoria = teorya\n"
                "teatro = teatro\n"
                "maestro = maestro"),
            const SizedBox(height: 20),

            _sectionContent(
                "2. MAHINA + MALAKAS (ia, ie, io, ua, ue, uo)- napapalitan ang mahihinang patinig ng malapatinig na katinig tuwing binabaybay."),
            const SizedBox(height: 10),
            _sectionContent("u= w\n"
                "i= y"),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "KASTILA                 FILIPINO\n"
                "deciembre = disYembre\n"
                "barberia = barberYa\n"
                "virtual = birtWal"),
            const SizedBox(height: 20),

            _sectionTitle("APAT (4) NA KATALIWASAN SA PANGKALAHATANG TUNTUNIN",
                Colors.black),
            const SizedBox(height: 10),
            _sectionContent(
                "1) Kapag ang kambal-patinig ay sumusunod sa katinig sa unang pantig ng salita."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "tia - tiYA\n"
                "pieza - pIYEsa\n"
                "fuerza - pUWErsa\n"
                "buitre - bUWItre"),
            const SizedBox(height: 20),

            _sectionContent(
                "2) Kapag ang kambal-patinig ay sumusunod sa dalawa o mahigit pang kumpol-katinig (consonant cluster) sa loob ng salita."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "hostia - ostIYA\n"
                "inferno - impIYErno\n"
                "leccion - leksIYOn\n"
                "lenguaje - lenggUWAhe"),
            const SizedBox(height: 20),

            _sectionContent(
                "3) Kapag ang kambal-patinig ay sumusunod sa tunog na H."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "estrategia - estratihIYA\n"
                "colegio - kolehIYO\n"
                "region - rehIYOn"),
            const SizedBox(height: 20),

            _sectionContent(
                "4) Kapag ang kambal-patinig ay nása dulo ng salita at may diin ang bigkas sa unang patinig ang orihinal."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "economia - ekonomIYA\n"
                "filosofia - pilosopIYA\n"
                "Geografia - heograpIYA"),
            const SizedBox(height: 20),

            _sectionContent(
                "5.5 Malalakas na Patinig. Sa kabilâng dako, hindi nagdudulot ng ganitong sigalot ang mga kambal-patinig na may malakas na unang patinig (A, E, O)."),
            const SizedBox(height: 10),
            _sectionContent("Halimbawa:\n"
                "aórta (aorta), paráon (faraon), baúl (baul), haúla (haula)"),
          ],
        ),
      ),
    );
  }

  // Helper method for creating section titles
  Widget _sectionTitle(String title, Color black) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
      ),
      child: Text(
        title,
        textAlign: TextAlign.justify, // Aligns the title to both sides
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1.2,
          height: 1.4,
        ),
      ),
    );
  }

  // Helper method for creating section content
  Widget _sectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6.0, spreadRadius: 1.0)
          ],
        ),
        child: Text(
          content,
          textAlign: TextAlign.justify, // Aligns the content to both sides
          style:
              const TextStyle(fontSize: 18, color: Colors.black87, height: 1.6),
        ),
      ),
    );
  }
}
