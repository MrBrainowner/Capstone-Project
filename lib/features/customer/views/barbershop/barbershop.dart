import 'package:flutter/material.dart';

class BarbershopProfilePage extends StatelessWidget {
  final String barbershopName;
  final String barbershopAddress;
  final String barbershopImage;
  final double rating;
  final int reviewCount;
  final List<Map<String, String>> haircuts;

  const BarbershopProfilePage({
    super.key,
    required this.barbershopName,
    required this.barbershopAddress,
    required this.barbershopImage,
    required this.rating,
    required this.reviewCount,
    required this.haircuts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(barbershopName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Full-width Banner
            _buildBanner(),

            // Title, Address, and Rating
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    barbershopName,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    barbershopAddress,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      _buildRatingStars(rating),
                      const SizedBox(width: 8.0),
                      Text(
                        '($reviewCount Reviews)',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Haircuts Offered Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Haircuts Offered',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildHaircutList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Image.asset(
      barbershopImage,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200.0,
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20.0,
        );
      }),
    );
  }

  Widget _buildHaircutList(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: haircuts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 3 / 4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: (context, index) {
        return _buildHaircutCard(context, haircuts[index]);
      },
    );
  }

  Widget _buildHaircutCard(BuildContext context, Map<String, String> haircut) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.asset(
                haircut['image']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  haircut['name']!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  haircut['price']!,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
