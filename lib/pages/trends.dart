import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/glass_card.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, String>> vendors = [
    {
      "name": "Ix Tech",
      "description":
          "Premium ASIC mining hardware and crypto infrastructure solutions.",
      "url": "https://ixtech.xyz",
      "logo": "assets/images/ixtech.png",
    },
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredVendors = vendors.where((vendor) {
      return vendor["name"]!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Page Title
          const Text(
            "Vendors",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Explore top vendors for mining hardware and equipment. "
            "Browse and purchase ASIC miners, GPUs, Power Supplies, "
            "cooling solutions, and more.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),

          // Search Bar
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search vendors...",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Vendor List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 14),
              itemCount: filteredVendors.length,
              itemBuilder: (context, index) {
                final vendor = filteredVendors[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    onTap: () => _launchURL(vendor["url"]!),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [

                          // Vendor Logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 55,
                              height: 55,
                              color: Colors.white.withOpacity(0.05),
                              child: Image.asset(
                                vendor["logo"]!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Vendor Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vendor["name"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  vendor["description"]!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.open_in_new,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
