import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BioSection extends StatelessWidget {
  const BioSection({super.key});

  Widget _bioTextBlock() => const Text(
    "Hi, my name is Naveen Chempodi.\nI'm a cinematographer based in Cochin, Kerala.",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      height: 1.6,
    ),
  );

  Widget _bioDescription() => const Text(
    "Over the past 8 years, I have brought stories to life as a cinematographer for commercials, "
        "short films, feature films, and musicals, partnering with renowned production houses and brands.",
    style: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      height: 1.6,
    ),
  );

  Widget _divider() => const Text(
    "-",
    style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
  );

  void _openWhatsApp() async {
    const phone = "+919995440788";
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
      const Text("Contact:",
          style: TextStyle(fontSize: 16, color: Colors.black87)),
      const SizedBox(height: 8),
      const Text("Phone: 9995407888",
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),
      const Text("Email: naveenchempodi@gmail.com",
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),
      const SizedBox(height: 12),
      const Text("Connect with me via :"),
      const SizedBox(height: 5),
      Row(
        children: [
          IconButton(
            icon:
            const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
            onPressed: _openWhatsApp,
            tooltip: "Chat on WhatsApp",
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.envelope, color: Colors.blue),
            onPressed: _launchEmail,
            tooltip: "Send mail",
          ),
        ],
      ),
    ],
  );

  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      "assets/images/image1.jpeg",
      "assets/images/image2.jpeg",
      "assets/images/image3.jpeg",
      "assets/images/image4.jpeg",
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 800;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isWide ? 100 : 20),
            child: isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Profile Image
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/images/image21.png",
                    fit: BoxFit.cover,
                    height: 400,
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
                  "assets/images/image21.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
                const SizedBox(height: 20),
                _bioTextBlock(),
                const SizedBox(height: 10),
                _bioDescription(),
                const SizedBox(height: 20),
                _divider(),
                const SizedBox(height: 20),
                _contactBlock(),
              ],
            ),
          ),
        );
      },
    );
  }


}
