import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class BioSection extends StatelessWidget {
  const BioSection({super.key});
  Widget _bioTextBlock() =>  Text(
    "Hi,",
    style: GoogleFonts.lora(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.6,
    ),
  );
  Widget _bioText1Block() =>  Text(
    "I'm a cinematographer based in Cochin, Kerala.",
    style: GoogleFonts.lora(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.6,
    ),
  );

  Widget _bioDescription() =>  Text(
    "Over the past 8 years, I have brought stories to life as a cinematographer for commercials, "
        "short films, feature films, and musicals, partnering with renowned production houses and brands.",
    style: GoogleFonts.lora(
      fontSize: 16,
      color: Color.fromARGB(
          255, 44, 42, 42),
      height: 1.6,
    ),
  );

  Widget _divider() => const Text(
    "-",
    style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
  );

  void _openWhatsApp() async {
    const phone = "+919995407888";
    final url = Uri.parse("https://wa.me/$phone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch WhatsApp";
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'naveenchempodi@gmail.com',
      query: 'subject=Let\'s Connect&body=Hi Naveen,', // optional
    );

    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch $emailUri');
    }
  }

  Widget _contactBlock() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       Text("Connect with me via :",style: GoogleFonts.lora(fontSize: 14, color: Colors.black87, height: 1.6)),
      const SizedBox(height: 10),
      Row(
        children: [
              _buildContactRow(
                icon: FontAwesomeIcons.whatsapp,
                label: "WhatsApp",
                value: "9995407888",
                onTap: _openWhatsApp,
              ),
              const SizedBox(width: 25),
              _buildContactRow(
                icon: FontAwesomeIcons.envelope,
                label: "Email",
                value: "naveenchempodi@gmail.com",
                onTap: _launchEmail,
              ),
        ],
      ),
    ],
  );

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFC0C0C0), width: 1.2),
            ),
            child: FaIcon(icon, color: Color(0xFFC0C0C0), size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.akatab(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(
                      255, 44, 42, 42),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.akatab(
                  fontSize: 14,
                  color: Color.fromARGB(
                      255, 44, 42, 42),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 900;
        double leftRight = isWide ? constraints.maxWidth*0.15 :20;
        // Responsive image size based on screen width
        double imageHeight = isWide
            ? constraints.maxWidth * 0.35 // e.g., 35% of width on wide screens
            : constraints.maxWidth * 0.6; // 60% of width on small screens

        // Put an upper and lower bound for better UX
        imageHeight = imageHeight.clamp(200, 450); // min 200, max 450 px

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: leftRight,right: leftRight),
              child: isWide
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Profile Image
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      "assets/images/profile_picture.png",
                      fit: BoxFit.cover,
                      // height: imageHeight,
                    ),
                  ),
                  const SizedBox(width: 40),

                  // Right: Bio + Contact + BottomImageCarousel
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bioTextBlock(),
                        _bioText1Block(),
                        const SizedBox(height: 20),
                        _bioDescription(),
                        const SizedBox(height: 20),
                        _divider(),
                        const SizedBox(height: 20),
                        _contactBlock(),
                      ],
                    ),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/profile_picture.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: imageHeight,
                  ),
                  const SizedBox(height: 20),
                  _bioTextBlock(),
                  _bioText1Block(),
                  const SizedBox(height: 10),
                  _bioDescription(),
                  const SizedBox(height: 20),
                  _divider(),
                  const SizedBox(height: 20),
                  _contactBlock(),
                ],
              ),
            )
          ],
        );
      },
    );
  }


}
