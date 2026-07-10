import 'generator_utils.dart';
import '../../models/question.dart';
import 'dart:math' as math;

class ArithmeticGenerator {
  static Question generateArithmetic(String diff) {
    final level = {'easy': 1, 'medium': 2, 'hard': 3}[diff]!;
    final templates = <QGen>[];

    // ──── LEVEL 1: Easy ────

    // 1) Operasi dasar +, -, ×
    templates.add(() {
      final ops = ['+', '-', '×'];
      final op = pick(level >= 2 ? ops : ops.sublist(0, 2));
      int answer;
      String text;
      if (op == '+') {
        final a = rand(10, 99), b = rand(10, 99);
        answer = a + b;
        text = 'Berapa hasil dari $a + $b?';
      } else if (op == '-') {
        final a = rand(10, 99), b = rand(10, 99);
        final x = math.max(a, b), y = math.min(a, b);
        answer = x - y;
        text = 'Berapa hasil dari $x − $y?';
      } else {
        final a2 = rand(2, 25), b2 = rand(2, 12);
        answer = a2 * b2;
        text = 'Berapa hasil dari $a2 × $b2?';
      }
      return {'text': text, 'answer': answer, 'topic': 'Aritmetika Dasar'};
    });

    // 2) Diskon sederhana
    templates.add(() {
      final price = rand(5, 100) * 10000;
      final discountPct = pick([10, 20, 25, 30, 40, 50]);
      final discountAmount = price * discountPct ~/ 100;
      return {
        'text': 'Sebuah barang seharga Rp${fmt(price)} didiskon $discountPct%. Harga setelah diskon adalah…',
        'answer': price - discountAmount,
        'topic': 'Persentase & Diskon',
      };
    });

    // 3) Persentase dari bilangan
    templates.add(() {
      final percentage = rand(20, 80), total = rand(5, 50) * 10;
      final portion = (total * percentage / 100).round();
      return {
        'text': '$percentage% dari $total adalah…',
        'answer': portion,
        'topic': 'Persentase',
      };
    });

    // 4) Perbandingan umur
    templates.add(() {
      final a = rand(2, 5), b = rand(2, 5);
      final rA = a, rB = (a == b) ? b + 1 : b;
      final multiplier = rand(3, 10);
      final valA = rA * multiplier;
      return {
        'text': 'Perbandingan umur Andi dan Budi adalah $rA : $rB. Jika umur Andi $valA tahun, berapakah umur Budi?',
        'answer': rB * multiplier,
        'topic': 'Perbandingan',
      };
    });

    // 5) Akar kuadrat sempurna
    templates.add(() {
      final n = pick([4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225]);
      final answer = math.sqrt(n).toInt();
      return {
        'text': 'Berapa nilai dari √$n?',
        'answer': answer,
        'topic': 'Aritmetika Dasar',
      };
    });

    // 6) Pembagian sederhana
    templates.add(() {
      final b = rand(2, 12);
      final answer = rand(5, 50);
      final a = answer * b;
      return {
        'text': 'Berapa hasil dari $a ÷ $b?',
        'answer': answer,
        'topic': 'Aritmetika Dasar',
      };
    });

    // 7) Jumlah uang pecahan
    templates.add(() {
      final n5000 = rand(2, 8);
      final n2000 = rand(1, 10);
      final n1000 = rand(1, 15);
      final total = n5000 * 5000 + n2000 * 2000 + n1000 * 1000;
      return {
        'text': 'Budi memiliki $n5000 lembar uang Rp5.000, $n2000 lembar uang Rp2.000, dan $n1000 lembar uang Rp1.000. Total uang Budi adalah…',
        'answer': total,
        'topic': 'Aritmetika Dasar',
      };
    });

    // 8) Rata-rata sederhana
    templates.add(() {
      final count = rand(3, 5);
      final values = List.generate(count, (_) => rand(50, 100));
      final sum = values.reduce((a, b) => a + b);
      // pastikan habis dibagi
      final adjustedSum = (sum ~/ count) * count;
      final avg = adjustedSum ~/ count;
      final adjustedValues = [...values];
      adjustedValues[0] = adjustedValues[0] + (adjustedSum - sum);
      return {
        'text': 'Rata-rata dari ${adjustedValues.join(', ')} adalah…',
        'answer': avg,
        'topic': 'Statistika Dasar',
      };
    });

    // 9) Rasio bola dalam wadah
    templates.add(() {
      final red = rand(3, 15);
      final blue = rand(3, 15);
      final total = red + blue;
      return {
        'text': 'Sebuah wadah berisi $red bola merah dan $blue bola biru. Jumlah seluruh bola adalah…',
        'answer': total,
        'topic': 'Aritmetika Dasar',
      };
    });

    // 10) Kecepatan sederhana (easy)
    templates.add(() {
      final speed = pick([30, 40, 50, 60]);
      final distance = speed * rand(2, 5);
      final time = distance ~/ speed;
      return {
        'text': 'Sebuah sepeda melaju $speed km/jam. Untuk menempuh $distance km dibutuhkan waktu… jam',
        'answer': time,
        'topic': 'Jarak, Waktu, Kecepatan',
      };
    });

    if (level >= 2) {
      // ──── LEVEL 2: Medium ────

      // 11) Jarak = kecepatan × waktu
      templates.add(() {
        final speed = rand(40, 100), time = rand(2, 5);
        return {
          'text': 'Sebuah mobil melaju dengan kecepatan rata-rata $speed km/jam selama $time jam. Jarak yang ditempuh adalah… km',
          'answer': speed * time,
          'topic': 'Jarak, Waktu, Kecepatan',
        };
      });

      // 12) Operasi campuran
      templates.add(() {
        final a = rand(2, 9), b = rand(2, 9), c = rand(5, 25);
        return {
          'text': 'Hasil dari $a × $b + $c adalah…',
          'answer': a * b + c,
          'topic': 'Operasi Campuran',
        };
      });

      // 13) Pekerjaan bersama
      templates.add(() {
        final pairs = [[3, 6, 2], [6, 12, 4], [4, 12, 3], [10, 15, 6], [20, 30, 12]];
        final p = pick(pairs);
        return {
          'text': 'Andi dapat menyelesaikan pekerjaan dalam ${p[0]} hari, sedangkan Budi dapat menyelesaikannya dalam ${p[1]} hari. Jika mereka bekerja bersama-sama, pekerjaan tersebut akan selesai dalam… hari',
          'answer': p[2],
          'topic': 'Pekerjaan Bersama',
        };
      });

      // 14) Jual beli untung
      templates.add(() {
        final buy = rand(2, 10) * 50000;
        final profitPct = pick([10, 15, 20, 25]);
        final sell = buy + (buy * profitPct ~/ 100);
        return {
          'text': 'Seorang pedagang membeli barang seharga Rp${fmt(buy)} dan menjualnya kembali dengan keuntungan $profitPct%. Harga jual barang tersebut adalah…',
          'answer': sell,
          'topic': 'Jual Beli',
        };
      });

      // 15) Perbandingan selisih
      templates.add(() {
        final a = rand(2, 4), b = rand(5, 7);
        final multiplier = rand(2, 8) * 5;
        final difference = (b - a).abs() * multiplier;
        return {
          'text': 'Perbandingan uang Caca dan Doni adalah $a : $b. Jika selisih uang mereka adalah Rp${fmt(difference)}, berapakah jumlah uang mereka berdua?',
          'answer': (a + b) * multiplier,
          'topic': 'Perbandingan',
        };
      });

      // 16) Bunga tunggal
      templates.add(() {
        final principal = rand(1, 10) * 1000000;
        final interestRate = pick([5, 6, 8, 10, 12]);
        final years = pick([1, 2, 3]);
        final interest = principal * interestRate * years ~/ 100;
        return {
          'text': 'Rina menabung Rp${fmt(principal)} dengan bunga tunggal $interestRate% per tahun. Setelah $years tahun, total tabungannya menjadi…',
          'answer': principal + interest,
          'topic': 'Bunga Tunggal',
        };
      });

      // 17) Operasi campuran dengan kurung
      templates.add(() {
        final a = rand(2, 8), b = rand(3, 9), c = rand(2, 6);
        final answer = (a + b) * c;
        return {
          'text': 'Hasil dari ($a + $b) × $c adalah…',
          'answer': answer,
          'topic': 'Operasi Campuran',
        };
      });

      // 18) Soal cerita kelereng
      templates.add(() {
        final initial = rand(20, 50);
        final received = rand(5, 15);
        final lost = rand(1, 5);
        final answer = initial + received - lost;
        return {
          'text': 'Ani memiliki $initial kelereng. Ia diberi $received kelereng oleh temannya, kemudian $lost kelereng hilang. Jumlah kelereng Ani sekarang adalah…',
          'answer': answer,
          'topic': 'Soal Cerita',
        };
      });

      // 19) Jual beli rugi
      templates.add(() {
        final buy = rand(2, 10) * 50000;
        final lossPct = pick([5, 10, 15, 20]);
        final sell = buy - (buy * lossPct ~/ 100);
        return {
          'text': 'Seorang pedagang membeli barang seharga Rp${fmt(buy)} dan menjualnya dengan kerugian $lossPct%. Harga jual barang tersebut adalah…',
          'answer': sell,
          'topic': 'Jual Beli',
        };
      });

      // 20) Rata-rata dengan anggota baru
      templates.add(() {
        final n = rand(4, 8);
        final avg = rand(60, 85);
        final totalAwal = n * avg;
        final newScore = rand(avg + 5, 100);
        final newAvg = (totalAwal + newScore) ~/ (n + 1);
        return {
          'text': 'Rata-rata nilai $n siswa adalah $avg. Jika seorang siswa baru masuk dengan nilai $newScore, rata-rata baru menjadi…',
          'answer': newAvg,
          'topic': 'Statistika Dasar',
        };
      });

      // 21) Skala peta
      templates.add(() {
        final scale = pick([100000, 200000, 250000, 500000]);
        final mapCm = rand(2, 10);
        final actualDistCm = mapCm * scale;
        final actualDistKm = actualDistCm ~/ 100000;
        return {
          'text': 'Pada sebuah peta berskala 1 : ${fmt(scale)}, jarak dua kota adalah $mapCm cm. Jarak sebenarnya adalah… km',
          'answer': actualDistKm,
          'topic': 'Skala',
        };
      });

      // 22) Kecepatan rata-rata dua rute
      templates.add(() {
        final v1 = rand(40, 60);
        final t1 = rand(2, 3);
        final v2 = rand(60, 90);
        final t2 = rand(1, 2);
        final totalDist = v1 * t1 + v2 * t2;
        return {
          'text': 'Seorang pengemudi menempuh rute pertama $v1 km/jam selama $t1 jam, lalu rute kedua $v2 km/jam selama $t2 jam. Total jarak yang ditempuh adalah… km',
          'answer': totalDist,
          'topic': 'Jarak, Waktu, Kecepatan',
        };
      });

      // 23) Pajak / PPN
      templates.add(() {
        final price = rand(5, 50) * 100000;
        final taxRate = pick([10, 11]);
        final totalPrice = price + (price * taxRate ~/ 100);
        return {
          'text': 'Sebuah barang seharga Rp${fmt(price)} dikenakan PPN $taxRate%. Total yang harus dibayar adalah…',
          'answer': totalPrice,
          'topic': 'Persentase & Pajak',
        };
      });

      // 24) Campuran (mixing) - harga rata-rata
      templates.add(() {
        final price1 = rand(2, 5) * 10000;
        final qty1 = rand(2, 5);
        final price2 = rand(6, 10) * 10000;
        final qty2 = rand(2, 5);
        final totalPrice = price1 * qty1 + price2 * qty2;
        return {
          'text': 'Ibu membeli $qty1 kg beras seharga Rp${fmt(price1)}/kg dan $qty2 kg beras seharga Rp${fmt(price2)}/kg. Total belanja ibu adalah…',
          'answer': totalPrice,
          'topic': 'Soal Cerita',
        };
      });
    }

    if (level >= 3) {
      // ──── LEVEL 3: Hard ────

      // 25) Substitusi aljabar
      templates.add(() {
        final x = rand(3, 12);
        return {
          'text': 'Jika x = $x, maka nilai x² - 3x + 2 adalah…',
          'answer': x * x - 3 * x + 2,
          'topic': 'Aljabar',
        };
      });

      // 26) Berpapasan
      templates.add(() {
        final v1 = rand(40, 60), v2 = rand(40, 60);
        final timeHours = pick([1, 2, 3]);
        final dist = (v1 + v2) * timeHours;
        return {
          'text': 'Jarak kota A dan B adalah $dist km. Rina berangkat dari A ke B dengan kecepatan $v1 km/jam, dan disaat bersamaan Joni berangkat dari B ke A dengan kecepatan $v2 km/jam. Mereka akan berpapasan setelah… jam',
          'answer': timeHours,
          'topic': 'Kecepatan & Berpapasan',
        };
      });

      // 27) Perbandingan berbalik nilai
      templates.add(() {
        final t1 = pick([12, 15, 20, 24, 30]);
        final p1 = pick([10, 15, 20, 30]);
        final totalWork = t1 * p1;
        final validP2 = [10, 12, 15, 20, 24, 30].where((p) => p != p1 && totalWork % p == 0).toList();
        final p2 = validP2.isNotEmpty ? pick(validP2) : (p1 + 5);
        final t2 = (totalWork ~/ p2);
        return {
          'text': 'Suatu proyek dapat diselesaikan oleh $p1 pekerja dalam waktu $t1 hari. Jika proyek ingin diselesaikan dalam $t2 hari, berapakah banyak pekerja yang dibutuhkan?',
          'answer': p2,
          'topic': 'Perbandingan Berbalik Nilai',
        };
      });

      // 28) Pecahan bak mandi
      templates.add(() {
        return {
          'text': 'Sebuah bak mandi terisi air 1/3 bagian. Jika ditambahkan 15 liter air, bak tersebut menjadi terisi 1/2 bagian. Kapasitas total bak mandi tersebut adalah… liter',
          'answer': 90,
          'topic': 'Pecahan',
        };
      });

      // 29) Diskon bertingkat
      templates.add(() {
        final price = rand(2, 10) * 100000;
        final disc1 = pick([10, 20, 25]);
        final disc2 = pick([5, 10, 15]);
        final afterDisc1 = price - (price * disc1 ~/ 100);
        final afterDisc2 = afterDisc1 - (afterDisc1 * disc2 ~/ 100);
        return {
          'text': 'Sebuah barang seharga Rp${fmt(price)} mendapat diskon $disc1% + $disc2%. Harga akhir yang harus dibayar adalah…',
          'answer': afterDisc2,
          'topic': 'Diskon Bertingkat',
        };
      });

      // 30) Bunga majemuk 2 tahun
      templates.add(() {
        final principal = pick([1000000, 2000000, 5000000]);
        final interestRate = pick([10, 20, 25]);
        final afterYear1 = principal + (principal * interestRate ~/ 100);
        final afterYear2 = afterYear1 + (afterYear1 * interestRate ~/ 100);
        return {
          'text': 'Rp${fmt(principal)} didepositokan dengan bunga majemuk $interestRate% per tahun. Setelah 2 tahun, total simpanan menjadi…',
          'answer': afterYear2,
          'topic': 'Bunga Majemuk',
        };
      });

      // 31) Keuntungan dan modal
      templates.add(() {
        final sell = rand(5, 20) * 50000;
        final profitPct = pick([20, 25, 50]);
        // sell = buy + buy * profitPct/100 = buy * (100+profitPct)/100
        // buy = sell * 100 / (100+profitPct)
        final buy = sell * 100 ~/ (100 + profitPct);
        return {
          'text': 'Seorang pedagang menjual barang dengan harga Rp${fmt(sell)} dan mendapat keuntungan $profitPct%. Harga beli barang tersebut adalah…',
          'answer': buy,
          'topic': 'Jual Beli',
        };
      });

      // 32) Kecepatan menyusul
      templates.add(() {
        // Choose speed difference and head-start that guarantee catchUpTime >= 1 hour
        final speedDiff = pick([10, 15, 20, 25, 30]);
        final headStart = pick([1, 2, 3]);
        final catchUpTime = rand(1, 4); // catch-up time in hours (guaranteed >= 1)
        // initialDist = speedDiff * catchUpTime
        final initialDist = speedDiff * catchUpTime;
        // speedA * headStart = initialDist → speedA = initialDist / headStart
        final speedA = initialDist ~/ headStart;
        final speedB = speedA + speedDiff;
        return {
          'text': 'Mobil A berangkat dengan kecepatan $speedA km/jam. $headStart jam kemudian, mobil B menyusul dengan kecepatan $speedB km/jam. Mobil B akan menyusul mobil A setelah… jam',
          'answer': catchUpTime,
          'topic': 'Kecepatan & Menyusul',
        };
      });

      // 33) Himpunan gabungan
      templates.add(() {
        final totalStudents = rand(30, 50);
        final numA = rand(15, totalStudents - 5);
        final numB = rand(10, totalStudents - 5);
        final numBoth = rand(3, math.min(numA, numB));
        final numUnion = numA + numB - numBoth;
        final numNeither = totalStudents - numUnion;
        return {
          'text': 'Dari $totalStudents siswa, $numA suka matematika, $numB suka fisika, dan $numBoth suka keduanya. Banyak siswa yang tidak suka keduanya adalah…',
          'answer': numNeither > 0 ? numNeither : 0,
          'topic': 'Himpunan',
        };
      });

      // 34) Konversi satuan
      templates.add(() {
        final km = rand(2, 15);
        final m = rand(100, 900);
        final totalMeters = km * 1000 + m;
        return {
          'text': '$km km $m m = … meter',
          'answer': totalMeters,
          'topic': 'Konversi Satuan',
        };
      });

      // 35) Soal cerita umur
      templates.add(() {
        final childAge = rand(8, 15);
        final ageDiff = rand(20, 30);
        final fatherAge = childAge + ageDiff;
        final yearsAgo = rand(2, 5);
        final sumAgesBack = (fatherAge - yearsAgo) + (childAge - yearsAgo);
        return {
          'text': '$yearsAgo tahun yang lalu, jumlah umur ayah dan anak adalah $sumAgesBack tahun. Jika selisih umur mereka $ageDiff tahun, berapakah umur anak sekarang?',
          'answer': childAge,
          'topic': 'Soal Cerita Umur',
        };
      });
    }

    if (level >= 3) {
      // 36) Pekerjaan Bersama 3 orang
      templates.add(() {
        final data = pick([
          [12, 15, 20, 5],
          [6, 8, 24, 3],
          [10, 12, 15, 4]
        ]);
        return {
          'text': 'A, B, dan C masing-masing dapat menyelesaikan suatu pekerjaan dalam waktu ${data[0]}, ${data[1]}, dan ${data[2]} hari. Jika mereka bekerja bersama-sama, pekerjaan tersebut akan selesai dalam… hari',
          'answer': data[3],
          'topic': 'Pekerjaan Bersama',
        };
      });

      // 37) Bunga Tabungan Berjalan
      templates.add(() {
        final principal = pick([1200000, 2400000, 3600000]);
        final interestRate = pick([8, 10, 12]);
        final months = pick([3, 4, 6, 8, 9]);
        final interest = (principal * interestRate ~/ 100) * months ~/ 12;
        return {
          'text': 'Roni menabung sebesar Rp${fmt(principal)} di bank dengan bunga tunggal $interestRate% per tahun. Total tabungan Roni setelah $months bulan adalah…',
          'answer': principal + interest,
          'topic': 'Bunga Tabungan',
        };
      });

      // 38) Jual beli - mencari untung per unit
      templates.add(() {
        final dozens = rand(2, 5);
        final unitBuyPrice = pick([24000, 36000, 48000, 60000]);
        final profitPct = pick([10, 20, 25]);
        final totalBuyPrice = dozens * unitBuyPrice;
        final totalProfit = totalBuyPrice * profitPct ~/ 100;
        final totalSellPrice = totalBuyPrice + totalProfit;
        final pricePerUnit = totalSellPrice ~/ (dozens * 12);
        return {
          'text': 'Seorang pedagang membeli $dozens lusin buku dengan total harga Rp${fmt(totalBuyPrice)}. Jika ia menginginkan keuntungan total sebesar Rp${fmt(totalProfit)}, maka harga jual per buku adalah…',
          'answer': pricePerUnit,
          'topic': 'Jual Beli',
        };
      });

      // 39) Gaji dan Pengeluaran
      templates.add(() {
        final salary = rand(30, 80) * 100000;
        final rentPct = pick([20, 25, 30]);
        final foodPct = pick([30, 40]);
        final savingsPct = 100 - rentPct - foodPct;
        final savings = salary * savingsPct ~/ 100;
        return {
          'text': 'Gaji Doni sebulan adalah Rp${fmt(salary)}. Jika $rentPct% digunakan untuk bayar kost, $foodPct% untuk makan, dan sisanya ditabung, berapakah jumlah uang yang ditabung?',
          'answer': savings,
          'topic': 'Persentase & Pecahan',
        };
      });

      // 40) Kecepatan Menyusul beda waktu
      templates.add(() {
        final speedA = pick([40, 50, 60]);
        final speedB = speedA + pick([10, 20, 30]);
        final headStartMin = pick([15, 30, 45]);
        // Distance covered by car A when car B departs
        final initialDist = speedA * headStartMin / 60.0;
        final speedDiff = speedB - speedA;
        final catchUpHours = initialDist / speedDiff;
        final catchUpMin = (catchUpHours * 60).round();
        return {
          'text': 'Mobil A berangkat dengan kecepatan $speedA km/jam. $headStartMin menit kemudian, mobil B menyusul dari tempat yang sama dengan kecepatan $speedB km/jam. Mobil B akan menyusul mobil A dalam waktu… menit',
          'answer': catchUpMin,
          'topic': 'Kecepatan & Berpapasan',
        };
      });
    }

    final result = pick(templates)();
    final opts = makeDistractors(result['answer'] as num);
    return Question(
      text: result['text'] as String,
      opts: opts.map((o) => o.toString()).toList(),
      answer: (result['answer'] as num).toString(),
      topic: result['topic'] as String,
      tag: 'PROCGEN',
      difficulty: diff,
    );
  }

  // ─────────────────────────────────────────────────────
  // DERET ANGKA — diperkaya
  // ────────────────────────────────────────────────────
}