import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DaglatPage extends StatefulWidget {
  const DaglatPage({super.key});

  @override
  _DaglatPageState createState() => _DaglatPageState();
}

class _DaglatPageState extends State<DaglatPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the Youtube Player Controller
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          'https://youtu.be/LCHGVX8QgQI?si=ArjJaSMTGkBdAUTY')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 244, 244),
      appBar: AppBar(
        title: const Text(
          "DAGLAT, INISYALS, AKRONIM",
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              onReady: () {},
            ),

            const SizedBox(height: 30),

            // Title and Intro Section
            _sectionTitle("Ano ang Daglat?", Colors.black),
            _sectionContent(
                "Ang lahat ng pagpapaikli sa mga pangngalan, pangalan man, titulo, o pantawag, ay tinatawag na daglát o abrebyasyon (abbreviation)."),
            _sectionContent(
                "Ito ay pananda na ginagamit upang maging malinaw ang kahulugan ng mga pangungusap. Tumutulong ito sa pagpapakilala ng mga kaisipan o kahulugan. Naghuhudyat din ito ng pagbabago ng bigkas at intonasyon."),

            const SizedBox(height: 20),
            // Inisyals Section
            _sectionTitle("Ano ang Inisyals?", Colors.black),
            _sectionContent(
                "Ang pagsulat lámang sa unang titik ng unang pangalan at/o apelyido ay higit na tinatawag na inísyals (nása anyong maramihan, dahil karaniwan itong binubuo ng dalawa o mahigit na titik)."),

            const SizedBox(height: 20),
            // Akronim Section
            _sectionTitle("Ano ang Akronim?", Colors.black),
            _sectionContent(
                "Ang mga inisyals ng pangalan ng kompanya, samahan, at katulad ay tinatawag na ákroním."),

            const SizedBox(height: 20),
            // Kontraksyon Section
            _sectionTitle("Ano ang Kontraksyon?", Colors.black),
            _sectionContent(
                "Ang pagpapaikli sa pamamagitan ng pag-aalis ng isa o mahigit na pantig."),

            const SizedBox(height: 20),
            // PANGALAN NG TAO Section
            _sectionTitle("PANGALAN NG TAO", Colors.black),
            _sectionContent(
                "Kapag buong pangalan ng tao ang dadaglatin, isinusulat ang inisyals sa malalaking titik nang walang tuldok at walang puwang sa pagitan ng mga titik. Kung ang una at gitnang pangalan lámang, ito ay isinusulat sa malaking titik at nilalagyan ng tuldok. Iminumungkahing alisan ng puwang ang pagitan ng tuldok sa unang titik at ng ikalawang titik bagaman may puwang ang pagitan ng tuldok sa ikalawang titik at ng apelyido."),
            _sectionContent(
                "Halimbawa:\nAlejandro G. Abadilla; AGA\nManuel L. Quezon; MLQ\nLope K. Santos; L.K. Santos\nClaro M. Recto; C.M. Recto"),

            const SizedBox(height: 20),
            // TITULO O KATUNGKULAN Section
            _sectionTitle("TITULO O KATUNGKULAN", Colors.black),
            _sectionContent(
                "Ang mga titulo at pantawag sa unahan ng pangalan ng tao ay dinadaglat at may tuldok kapag sinusundan ng buong pangalan; hindi dinadaglat kapag apelyido lámang ang kasunod."),
            _sectionContent(
                "Halimbawa:\nSen. Loren Legarda; Senador Legarda\nProp. Wilbert Lamarca; Propesor Lamarca\nGng. Milagros Romero; Ginang Romero\nSnr. Maria Dulce Roxas; Senyora Roxas\nDr. Purificacion Delima; Doktor Delima"),

            const SizedBox(height: 20),
            // PANGALAN NG KAPISANAN Section
            _sectionTitle("PANGALAN NG KAPISANAN", Colors.black),
            _sectionContent(
                "Katulad ng sa pangalan ng tao, ang mga pangalan ng ahensiya at organisasyon ay maaaring daglatin sa pamamagitan ng inisyals at akronim. Tradisyonal na unang mga titik ng buong pangalan ang ginagamit at nása malalaking titik."),
            _sectionContent(
                "Halimbawa:\nKKK (Kataas-taasang Kagalang-galang Katipunan)\nASEAN (Association of Southeast Asian Nations)\nKWF (Komisyon sa Wikang Filipino)\nPGH (Philippine General Hospital)\nFIT (Filipinas Institute of Translation, Inc)"),

            const SizedBox(height: 20),
            // DAGLAT AS KEMIKAL Section
            _sectionTitle("DAGLAT AS KEMIKAL", Colors.black),
            _sectionContent(
                "Ang mga kemikal ay may nakatakda nang daglat. Ito ay nakasulat nang isa, dalawa, o higit pang letra at hindi nilalagyan ng tuldok. Ang unang letra nitó ay nakasulat sa malaking titik."),
            _sectionContent(
                "Halimbawa:\nC – carbon\nH – hydrogen\nNa – sodium\nCl – chlorine"),

            const SizedBox(height: 20),
            // DAGLAT SA ORAS Section
            _sectionTitle("DAGLAT SA ORAS", Colors.black),
            _sectionContent(
                "Sa pagsulat ng oras, iminumungkahi ng gabay na ito na isulat ang daglat sa maliliit na titik at walang tuldok kapag kasunod ng numeral na oras."),
            _sectionContent(
                "Halimbawa:\n7 nu – ika-7 ng umaga\n12 nu – ika-12 ng tanghali\n2 nh – ika-2 ng hapon\n7 ng – ika-7 ng gabi\n12 ng – ika-12 ng hatinggabi"),

            const SizedBox(height: 20),
            // DAGLAT SA ARAW AT BUWAN Section
            _sectionTitle("DAGLAT SA ARAW AT BUWAN", Colors.black),
            _sectionContent(
                "Para sa daglat ng araw sa isang linggo at mga buwan sa isang taon, gamitin ang unang tatlong titik ng pangalan. Iminumungkahi ng gabay na ito ang sumusunod na daglat at hindi nilalagyan ng tuldok."),
            _sectionContent(
                "Halimbawa:\nEne – Enero\nPeb – Pebrero\nMar – Marso\nAbr – Abril\nMay – Mayo"),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method for creating section titles
  Widget _sectionTitle(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: color, width: 2)),
      ),
      child: Text(
        title,
        textAlign: TextAlign.justify, // Aligns the title to both sides
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: color,
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
