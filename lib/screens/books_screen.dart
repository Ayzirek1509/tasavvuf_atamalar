import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  static const books = [
    (
      'Tasavvuf Tarixi',
      'Nilufar Toychiyeva, I. Usmonov, A.Bahromov',
      'Tasavvuf tarixi, maktablari va asosiy tushunchalari haqida qo‘llanma.',
      'assets/images/tasavvuf_tarixi.png',
    ),
    (
      'Tasavvuf va Hozirgi Zamon',
      'Nilufar Tuychiyeva, Mirodil Haydarov',
      'Zamonaviy jamiyatda tasavvufiy qarashlarning o‘rni yoritilgan.',
      'assets/images/tasavvuf_hozirgi.png',
    ),
    (
      'Markaziy Osiyoda Qalandariylik Tarixi',
      'Nilufar Toychiyeva',
      'Markaziy Osiyodagi qalandariylik an’analari va tarixiga oid manba.',
      'assets/images/tasavvuf_osiyo.png',
    ),
    (
      'Tasavvuf Atamalari',
      'Nilufar Toychiyeva',
      'Izohli lug‘atga kiritilgan mavzular hanafiylik an’analari asosida shakllangan Movarounnahr tasavvufining bag‘rikeng mohiyatini tarixiy manbalar asosida ko‘rib chiqish va uning yuksak insoniy g‘oyalarini ilmiy tahlil etish nuqtai nazaridan yoritilgan. Zero, tasavvufga oid tushuncha va atamalarni noxolis talqin qilish orqali jamiyatda nosog‘lom qarashlar uyg‘otish xavfi bor ekan, birlamchi manbalar asosida yaratilgan tasavvufiy atamalarning izohi muhim ahamiyat kasb etadi. Izohli lug‘atda Markaziy Osiyo mintaqasiga xos bo‘lgan so‘fiy atamalarga urg‘u qaratish bilan bir qatorda, jahon tasavvufiga oid tushunchalarga ham o‘rin berilgan.\n\nUshbu nashr O‘zbekiston Respublikasi Vazirlar Mahkamasi huzuridagi Fan va texnologiyalarni rivojlantirishni muvofiqlashtirish qo‘mitasi tomonidan moliyalashtirilgan A1-044-raqamli «Movarounnahr tasavvuf ta’limotlari: asliyat va talqinlar, tarix va hozirgi zamon, tahlil va xulosalar» amaliy loyihasi doirasida amalga oshirilgan.\n\nO‘zbekiston Respublikasi Vazirlar Mahkamasi huzuridagi Din ishlari bo‘yicha qo‘mitaning 5303-sonli xulosasi asosida tayyorlandi.',
      'assets/images/tasavvuf_atamalar.jpg',
    ),
    (
      'Tasavvufga Kirish',
      'O‘quv qo‘llanma',
      'Mazkur darslikda tasavvuf tarixi, ta’limoti va g‘oyalari, tariqatlarning qadimdagi va hozirgi holatlari, mintaqaviy xususiyatlari, globallashuv sharoitida tariqatlar faollashuvi, soxta sufiylik, tariqatchilik va boshqa ko‘plab mavzular yoritilgan. Mazkur darslikni tuzishda manba va adabiyotlardan keng foydalanilgan. Darslik tavsiya etilgan adabiyotlar ro‘yxati, glossariy, mavzuga oid savollar, tayanch iboralar, mustaqil ish topshiriqlari bilan ta’minlangan.\n\nUshbu nashr O‘zbekiston Respublikasi Innovatsion rivojlanish vazirligi tomonidan moliyalashtirilgan № P3-20170930192-raqamli amaliy loyihasi doirasida amalga oshirildi.\n\nO‘zbekiston Respublikasi Oliy va o‘rta maxsus ta’lim vazirligining 2019-yil 27-dekabrdagi №1186-sonli buyrug‘iga asosan nashrga tavsiya etilgan.\n\nRo‘yxatga olish raqami №1186-011.\n\nO‘zbekiston Respublikasi Vazirlar Mahkamasi huzuridagi Din ishlari bo‘yicha qo‘mitaning 3311-sonli xulosasi asosida tayyorlandi.',
      'assets/images/tasavvuf_kirish.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.pageBg(context),
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Tasavvufiy asarlar',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        itemCount: books.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final b = books[index];

          return InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookDetailScreen(
                    title: b.$1,
                    author: b.$2,
                    desc: b.$3,
                    imagePath: b.$4,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.panelBg(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.stroke(context).withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.stroke(context).withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(2, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Hero(
                    tag: b.$4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 86,
                        height: 106,
                        color: AppColors.primaryGreen.withValues(alpha: 0.08),
                        child: Image.asset(
                          b.$4,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.$1,
                          textScaler: const TextScaler.linear(1),
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                            color: AppColors.mainText(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          b.$2,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textScaler: const TextScaler.linear(1),
                          style: TextStyle(
                            fontSize: 14.5,
                            color: AppColors.secondaryText(context),
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Batafsil o‘qish',
                          style: TextStyle(
                            color: AppColors.primaryGreen.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primaryGreen.withValues(alpha: 0.75),
                    size: 32,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookDetailScreen extends StatelessWidget {
  final String title;
  final String author;
  final String desc;
  final String imagePath;

  const BookDetailScreen({
    super.key,
    required this.title,
    required this.author,
    required this.desc,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.pageBg(context),
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(26, 18, 26, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: imagePath,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 190,
                    height: 240,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              textScaler: const TextScaler.linear(1),
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 30,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              author,
              textScaler: const TextScaler.linear(1),
              style: TextStyle(
                color: AppColors.secondaryText(context),
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              desc,
              textAlign: TextAlign.justify,
              textScaler: const TextScaler.linear(1),
              style: const TextStyle(
                color: Color(0xFF315B32),
                fontSize: 21,
                height: 1.65,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}