import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PagbaybayPage extends StatefulWidget {
  const PagbaybayPage({super.key});

  @override
  _PagbaybayPageState createState() => _PagbaybayPageState();
}

class _PagbaybayPageState extends State<PagbaybayPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the Youtube Player Controller
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          'https://youtu.be/TYbQw03pHdc?si=8pICt7KkVBtv-SD1')!,
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
          "PAGBAYBAY NA PASULAT",
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

            // Section 1: Prinsipyong "Kung Ano ang Bigkas, Siyang Sulat"
            _sectionTitle("Prinsipyong \"Kung Ano ang Bigkas, Siyang Sulat\""),
            _sectionContent(
                "Ang tuntuning ito ay nangangahulugang ang mga salita ay isinusulat batay sa paraan ng pagbigkas ng mga ito. Subalit, hindi ito laging nasusunod. Halimbawa, ang \"manga\" na ginamit noong ika-20 siglo ay pinaikli na ngayon bilang \"mga.\" Gayundin, may mga tuntunin para sa paggamit ng maikling \"ng\" at mahabang \"nang,\" na pinairal ng Balarila noong panahon ng Espanyol. Sa panahong iyon, ang mahabang \"nang\" lamang ang ginagamit."),

            const SizedBox(height: 20),
            // Section 2: 4.1 Gamit ng Walong Bagong Titik
            _sectionTitle("4.1 Gamit ng Walong Bagong Titik"),
            _sectionContent(
                "Ang modernisadong alpabeto ay may walong karagdagang titik: C, F, J, Ñ, Q, V, X, at Z. Ginagamit ang mga ito upang panatilihin ang orihinal na tunog ng mga salita mula sa katutubong wika at banyagang pinagmulan."),
            _sectionContent("Paggamit sa Katutubong Wika:\n"
                "F: alifuffug (Itawes), feyu (Kalinga), falendag (Tiruray)\n"
                "J: jambangán (Tausug), julúp (Tausug)\n"
                "V: vakul (Ivatan), vulan (Itawes), avid (Ivatan)\n"
                "Z: kazzing (Itawes), zigattu (Ibanag)"),
            _sectionContent("Halimbawa ng Pagwawasto:\n"
                "Noon: Ifugaw → Ipugaw, Ivatan → Ibatan\n"
                "Ngayon: Panatilihin ang orihinal na anyo: Ifugaw at Ivatan"),

            const SizedBox(height: 20),
            // Section 3: 4.2 Bagong Hiram na Salita
            _sectionTitle("4.2 Bagong Hiram na Salita"),
            _sectionContent(
                "Ang mga bagong titik ay ginagamit din sa mga bagong salitang hiniram mula sa banyagang wika."),
            _sectionContent("Mga Salitang Hindi Binabago:\n"
                "Ginagamit nang buo ang salita kung ito ay bagong hiram at hindi bahagi ng abakada.\n"
                "Halimbawa: fútbol, fertil, fósil, visa, zigzag"),
            _sectionContent("Mga Matagal Nang Ginagamit:\n"
                "Ang mga hiram na salitang matagal nang ginagamit ay hindi kailangang ibalik sa orihinal na baybay.\n"
                "Halimbawa: pórma mula sa forma, pírma mula sa firma, bintanà mula sa ventana, sapatos mula sa zapatos"),

            const SizedBox(height: 20),
            // Section 4: 4.3 Lumang Salitang Espanyol
            _sectionTitle("4.3 Lumang Salitang Espanyol"),
            _sectionContent(
                "Maraming salitang Espanyol ang isinabaybay sa abakada noong panahon ng kolonyalismo. Ito ay tinatawag na pagsasaabakada ng banyagang tunog."),
            _sectionContent("Halimbawa ng Pagsasaabakada:\n"
                "Vacación → bakasyón, Caballo → kabáyo, Candela → kandilà, Celaje → siláhis, ¿Cómo está? → kumustá"),
            _sectionContent(
                "Ang mga salitang ito ay bahagi na ng wikang Filipino at hindi kailangang baguhin pa."),

            const SizedBox(height: 20),
            // Section 5: 4.4 Di Binabagong Bagong Hiram
            _sectionTitle("4.4 Di Binabagong Bagong Hiram"),
            _sectionContent(
                "Ang mga bagong hiram na hindi matatagpuan sa mga diksyunaryong nabanggit sa seksyong 4.3 ay maaaring hiramin nang buo at walang pagbabago sa baybay. Kasama rito ang mga salitang mula sa Espanyol at Ingles tulad ng:"),
            _sectionContent("Espanyol:\n"
                "Fútbol\n"
                "Fertil\n"
                "Fósil\n"
                "Vísa\n"
                "Vertebrá\n"
                "Zígzag"),
            _sectionContent("Ingles:\n"
                "Fern\n"
                "Fólder\n"
                "Jam\n"
                "Jar\n"
                "Lével\n"
                "Énvoy\n"
                "Devélop\n"
                "Ziggúrat\n"
                "Zip\n"
                "Ang mga salitang ito ay tinatanggap nang walang pagbabago sa baybay sa Filipino."),

            const SizedBox(height: 20),
            // Section 6: 4.5 Problema sa C, Ñ, Q, at X
            _sectionTitle("4.5 Problema sa C, Ñ, Q, at X"),
            _sectionContent(
                "May ilang isyu sa paggamit ng apat na dagdag na titik na ito dahil sa mga kakaibang katangian ng kanilang tunog:"),
            _sectionContent("Titik C:\n"
                "May dalawang tunog: /K/ sa mga salitang tulad ng coche (kotse), /S/ sa mga salitang tulad ng ciudad (siyudad)"),
            _sectionContent("Titik Ñ:\n"
                "Pinalitan ito ng NY noong abakada. Halimbawa: doña → donya, piña → pinyá"),
            _sectionContent("Titik Q:\n"
                "Sa pagsasaabakada, pinalitan ang tunog nito ng: K sa queso (keso), KW sa quit (kwit), KY sa barbecue (barbikyú)"),
            _sectionContent("Titik X:\n"
                "Ginagamit lamang sa teknikal o siyentipikong katawagan: X-ray, oxygen\n"
                "Kapag pambalana, tinutumbasan ng KS: extra → ekstra"),

            const SizedBox(height: 20),
            // Section 1: Prinsipyong "Kung Ano ang Bigkas, Siyang Sulat"
            _sectionTitle("Prinsipyong \"Kung Ano ang Bigkas, Siyang Sulat\""),
            _sectionContent(
                "Ang tuntuning ito ay nangangahulugang ang mga salita ay isinusulat batay sa paraan ng pagbigkas ng mga ito. Subalit, hindi ito laging nasusunod. Halimbawa, ang \"manga\" na ginamit noong ika-20 siglo ay pinaikli na ngayon bilang \"mga.\" Gayundin, may mga tuntunin para sa paggamit ng maikling \"ng\" at mahabang \"nang,\" na pinairal ng Balarila noong panahon ng Espanyol. Sa panahong iyon, ang mahabang \"nang\" lamang ang ginagamit."),

            const SizedBox(height: 20),
            // Section 2: 4.1 Gamit ng Walong Bagong Titik
            _sectionTitle("4.1 Gamit ng Walong Bagong Titik"),
            _sectionContent(
                "Ang modernisadong alpabeto ay may walong karagdagang titik: C, F, J, Ñ, Q, V, X, at Z. Ginagamit ang mga ito upang panatilihin ang orihinal na tunog ng mga salita mula sa katutubong wika at banyagang pinagmulan."),
            _sectionContent("Paggamit sa Katutubong Wika:\n"
                "F: alifuffug (Itawes), feyu (Kalinga), falendag (Tiruray)\n"
                "J: jambangán (Tausug), julúp (Tausug)\n"
                "V: vakul (Ivatan), vulan (Itawes), avid (Ivatan)\n"
                "Z: kazzing (Itawes), zigattu (Ibanag)"),
            _sectionContent("Halimbawa ng Pagwawasto:\n"
                "Noon: Ifugaw → Ipugaw, Ivatan → Ibatan\n"
                "Ngayon: Panatilihin ang orihinal na anyo: Ifugaw at Ivatan"),

            const SizedBox(height: 20),
            // Section 3: 4.2 Bagong Hiram na Salita
            _sectionTitle("4.2 Bagong Hiram na Salita"),
            _sectionContent(
                "Ang mga bagong titik ay ginagamit din sa mga bagong salitang hiniram mula sa banyagang wika."),
            _sectionContent("Mga Salitang Hindi Binabago:\n"
                "Ginagamit nang buo ang salita kung ito ay bagong hiram at hindi bahagi ng abakada.\n"
                "Halimbawa: fútbol, fertil, fósil, visa, zigzag"),
            _sectionContent("Mga Matagal Nang Ginagamit:\n"
                "Ang mga hiram na salitang matagal nang ginagamit ay hindi kailangang ibalik sa orihinal na baybay.\n"
                "Halimbawa: pórma mula sa forma, pírma mula sa firma, bintanà mula sa ventana, sapatos mula sa zapatos"),

            const SizedBox(height: 20),
            // Section 4: 4.3 Lumang Salitang Espanyol
            _sectionTitle("4.3 Lumang Salitang Espanyol"),
            _sectionContent(
                "Maraming salitang Espanyol ang isinabaybay sa abakada noong panahon ng kolonyalismo. Ito ay tinatawag na pagsasaabakada ng banyagang tunog."),
            _sectionContent("Halimbawa ng Pagsasaabakada:\n"
                "Vacación → bakasyón, Caballo → kabáyo, Candela → kandilà, Celaje → siláhis, ¿Cómo está? → kumustá"),
            _sectionContent(
                "Ang mga salitang ito ay bahagi na ng wikang Filipino at hindi kailangang baguhin pa."),

            const SizedBox(height: 20),
            // Section 5: 4.4 Di Binabagong Bagong Hiram
            _sectionTitle("4.4 Di Binabagong Bagong Hiram"),
            _sectionContent(
                "Ang mga bagong hiram na hindi matatagpuan sa mga diksyunaryong nabanggit sa seksyong 4.3 ay maaaring hiramin nang buo at walang pagbabago sa baybay. Kasama rito ang mga salitang mula sa Espanyol at Ingles tulad ng:"),
            _sectionContent("Espanyol:\n"
                "Fútbol\n"
                "Fertil\n"
                "Fósil\n"
                "Vísa\n"
                "Vertebrá\n"
                "Zígzag"),
            _sectionContent("Ingles:\n"
                "Fern\n"
                "Fólder\n"
                "Jam\n"
                "Jar\n"
                "Lével\n"
                "Énvoy\n"
                "Devélop\n"
                "Ziggúrat\n"
                "Zip\n"
                "Ang mga salitang ito ay tinatanggap nang walang pagbabago sa baybay sa Filipino."),

            const SizedBox(height: 20),
            // Section 6: 4.5 Problema sa C, Ñ, Q, at X
            _sectionTitle("4.5 Problema sa C, Ñ, Q, at X"),
            _sectionContent(
                "May ilang isyu sa paggamit ng apat na dagdag na titik na ito dahil sa mga kakaibang katangian ng kanilang tunog:"),
            _sectionContent("Titik C:\n"
                "May dalawang tunog: /K/ sa mga salitang tulad ng coche (kotse), /S/ sa mga salitang tulad ng ciudad (siyudad)"),
            _sectionContent("Titik Ñ:\n"
                "Pinalitan ito ng NY noong abakada. Halimbawa: doña → donya, piña → pinyá"),
            _sectionContent("Titik Q:\n"
                "Sa pagsasaabakada, pinalitan ang tunog nito ng: K sa queso (keso), KW sa quit (kwit), KY sa barbecue (barbikyú)"),
            _sectionContent("Titik X:\n"
                "Ginagamit lamang sa teknikal o siyentipikong katawagan: X-ray, oxygen\n"
                "Kapag pambalana, tinutumbasan ng KS: extra → ekstra"),

            const SizedBox(height: 20),
            // Section 7: 4.6 Panghihiram Gamit ang 8 Bagong Titik
            _sectionTitle("4.6 Panghihiram Gamit ang 8 Bagong Titik"),
            _sectionContent(
                "Ginagamit ang walong bagong titik sa tatlong pagkakataon:"),
            _sectionContent(
                "Pangngalang Pantangi: Halimbawa: Charles, Jason, Jennifer, Santo Niño, Vancouver, Mexico"),
            _sectionContent(
                "Katawagang Siyentipiko o Teknikal: Halimbawa: carbon dioxide, x-axis, valence, zygote"),
            _sectionContent(
                "Salitang Mahirap Irespeling: Halimbawa: cauliflower, pizza, quiz, jaywalking, zebra"),

            const SizedBox(height: 20),
            // Section 8: 4.7 Eksperimento sa Ingles
            _sectionTitle("4.7 Eksperimento sa Ingles"),
            _sectionContent(
                "Pinapayagan at hinihikayat ang eksperimento sa pagsasa-Filipino ng ispeling ng mga hiram na salita mula sa Ingles at ibang banyagang wika upang mas madaling maintindihan ng mga mag-aaral."),
            _sectionContent(
                "Halimbawa: stand by → istámbay, school → iskúl, schedule → iskédyul, police → pulís, grocery → gróserí"),
            _sectionContent("Kailan Hindi Dapat Mag-Reispel:\n"
                "1. Nagiging katawa-tawa ang anyo sa Filipino (e.g., Coke → Kok).\n"
                "2. Mahihirapan basahin ang bagong anyo (e.g., dyuti-fri para sa “duty-free”).\n"
                "3. Nasisira ang kabuluhang pangkultura (e.g., feng shui → fung soy).\n"
                "4. Mas popular ang orihinal (e.g., Coke ay kilala kaysa Kok).\n"
                "5. Nagkakaroon ng kalituhan (e.g., pitsa → pizza)."),

            const SizedBox(height: 20),
            // Section 9: 4.8 Espanyol Muna, Bago Ingles
            _sectionTitle("4.8 Espanyol Muna, Bago Ingles"),
            _sectionContent(
                "Mas angkop gamitin ang Espanyol sa ilang hiram na salita kaysa Ingles, dahil mas akma ito sa bigkas at baybay ng Filipino."),
            _sectionContent(
                "Halimbawa: bagáhe (bagaje) kaysa baggage, gradwasyón (graduación) kaysa graduation, imáhen (imagen) kaysa image"),

            const SizedBox(height: 20),
            // Section 10: 4.9 Ingat sa “Siyókoy”
            _sectionTitle("4.9 Ingat sa “Siyókoy”"),
            _sectionContent(
                "Iwasan ang paggamit ng mga “siyokoy,” mga salitang mali ang baybay dahil sa kamangmangan sa Espanyol."),
            _sectionContent(
                "Halimbawa: konsernído (concerned) kaysa konsernado, imáhen (image) kaysa imahu"),

            const SizedBox(height: 20),
            // Section 11: 4.10 Eksperimento sa Espanyol
            _sectionTitle("4.10 Eksperimento sa Espanyol"),
            _sectionContent(
                "Ang mga neolohismo sa Espanyol ay ginagawa upang lumikha ng mga bagong salita na may partikular na kahulugan."),
            _sectionContent(
                "Halimbawa: kritiká (critique) kaysa kritikísmo (criticism), siyentísta (scientist) kaysa siyentípikó (scientific), sikolohísta (psychologist) kaysa sikólogó"),
            _sectionContent(
                "Mahalagang isaalang-alang ang mga katutubong wika sa paghahanap ng mga tamang termino (e.g., iláhás mula Ilonggo para sa wild)."),

            const SizedBox(height: 20),
            // Section 12: 4.11 Gamit ng Espanyol na Y
            _sectionTitle("4.11 Gamit ng Espanyol na Y"),
            _sectionContent(
                "Ang titik na Y sa Espanyol ay binibigkas tulad ng I sa Filipino. Ginagamit ito sa mga sumusunod na paraan:"),
            _sectionContent(
                "Pangalan ng lalaki at apelyido ng ina: Emilio Aguinaldo y Famy (pangalan at apelyido ng ina)."),
            _sectionContent(
                "Pagbibilang: Alas-dos y medya (ikalawa at kalahati), kuwarenta y singko (apatnapu’t lima), singkuwenta y tres (limampu’t tatlo)."),
            _sectionContent(
                "Nawawala ang Y kapag ang unang bilang ay nagtatapos sa E, tulad ng beynte dos (dalawampu’t dalawa)."),

            const SizedBox(height: 20),
            // Section 13: 4.12 Kaso ng Binibigkas na H sa Hiram sa Espanyol
            _sectionTitle("4.12 Kaso ng Binibigkas na H sa Hiram sa Espanyol"),
            _sectionContent("Sa Espanyol, hindi binibigkas ang titik H."),
            _sectionContent(
                "Halimbawa: hielo → yélo, hechura → itsúra, hacienda → asyénda"),
            _sectionContent(
                "Panatilihin ang H kapag may kahawig na katutubong salita na may ibang kahulugan:"),
            _sectionContent("Humáno (tao) – hindi pwedeng maging umáno."),
            _sectionContent(
                "Historia (kasaysayan) – ginagamit sa Filipino bilang historya (salaysay) at historyador (historyador)."),

            const SizedBox(height: 20),
            // Section 14: 4.13 Gamit ng J
            _sectionTitle("4.13 Gamit ng J"),
            _sectionContent(
                "Ginagamit ang titik J para sa tunog dyey, hindi para sa tunog ha sa mga hiram mula sa Espanyol."),
            _sectionContent(
                "Halimbawa (Katutubong Salita): jámbangán (Tausug), sínjal (Ibaloy)"),
            _sectionContent(
                "Halimbawa (Hiram na Salitang Ingles): jet, jam, jazz, jéster, jíngle, joy, enjóy"),
            _sectionContent(
                "Hiram mula sa Ingles na Hindi Gumagamit ng J: dyeneral (general), dyenereytor (generator), dyanitor (janitor)"),
          ],
        ),
      ),
    );
  }

  // Helper method for creating section titles
  Widget _sectionTitle(String title) {
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
