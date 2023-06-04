import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';

class OrienteeringExplanationSubPage extends StatelessWidget {
  const OrienteeringExplanationSubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oryantiring Nedir?'),
        centerTitle: true,
      ),
      body: Padding(
        padding: context.paddingNormalSymmetric,
        child: const SingleChildScrollView(
          child: Text("\t\tOrientiring, bireylerin harita ve pusula kullanarak belirli bir rota üzerinde hedef noktaları bulmaya çalıştığı bir yarış sporudur. Oyun, doğada veya belirlenmiş bir parkurda gerçekleştirilebilir ve genellikle açık arazilerde, ormanlarda veya dağlık bölgelerde yapılır.\n\n\t\tOrientiring'in temel amacı, belirlenmiş bir başlangıç noktasından başlayarak numaralandırılmış kontrol noktalarını bulmaktır. Bu kontrol noktaları, katılımcıların bir rotayı izleyerek hedef noktalara ulaşmalarını sağlayan genellikle turuncu-beyaz bayraklarla işaretlenmiş olabilir. Yarışmacılar, harita ve pusula kullanarak rotalarını planlar ve kontrol noktalarını takip ederler.\n\n\t\tOrientiring, hem bireysel olarak hem de takımlar halinde gerçekleştirilebilir. Bireysel yarışlarda, her yarışmacı kendi rotasını seçer ve kontrol noktalarını bulmaya çalışır. Takım yarışlarında ise takımlar genellikle iki veya daha fazla kişiden oluşur ve birlikte çalışarak kontrol noktalarını bulmaya çalışır.\n\n\t\tOrientiring'de katılımcılar, doğru rotayı seçmek ve en kısa sürede kontrol noktalarına ulaşmak için hız, navigasyon becerileri ve strateji kullanırlar. Haritalar, topografik detayları, ormanlık alanları, yolları ve diğer doğal özellikleri içerir. Yarışmacılar bu haritaları kullanarak kendilerine en uygun rotayı belirlerler.\n\n\t\tOrientiring yarışları, farklı zorluk seviyelerine sahip olabilir. Bazı yarışlar kısa mesafelerde gerçekleşirken, diğerleri daha uzun mesafeleri kapsayabilir. Ayrıca, zorlu parkurlar, gece yarışları ve engeller içeren yarışlar gibi farklı türde yarışlar da düzenlenebilir.\n\n\t\tOrientiring, doğayı keşfetmek, navigasyon becerilerini geliştirmek ve fiziksel dayanıklılığı artırmak isteyenler için heyecan verici bir spor olarak görülmektedir. Hem rekabetçi bir spor olarak hem de rekreasyonel amaçlarla yapılabilir."),
        ),
      ),
    );
  }
}
