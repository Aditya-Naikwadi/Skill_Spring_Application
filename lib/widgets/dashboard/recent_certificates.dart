import 'package:flutter/material.dart';
import '../../models/certificate_model.dart';
import 'certificate_card.dart';

class RecentCertificates extends StatelessWidget {
  final List<CertificateModel> certificates;
  final Function(CertificateModel) onCertificateTap;

  const RecentCertificates({
    super.key,
    required this.certificates,
    required this.onCertificateTap,
  });

  @override
  Widget build(BuildContext context) {
    if (certificates.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Certificates',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all certificates
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240, // Height for certificate cards
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: certificates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final certificate = certificates[index];
              return CertificateCard(
                certificate: certificate,
                onTap: () => onCertificateTap(certificate),
              );
            },
          ),
        ),
      ],
    );
  }
}
