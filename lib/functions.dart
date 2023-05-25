String currencyFormat(String src, {required String prefix}) {
  List srcSplit = src.split('.');
  String afterComma = '';

  //check if it has decimal value
  if (srcSplit.length == 2) {
    afterComma = ',${srcSplit[1]}';
  } else {
    afterComma = '';
  }

  //add . to left (before decimal)
  List left = List.from(srcSplit[0].split('').reversed);
  List results = [];

  for (int i = 0; i < left.length; i++) {
    if ((i + 1) % 3 == 0) {
      results.add(left[i]);
      results.add('.');
    } else {
      results.add(left[i]);
    }
  }

  //remove . if it is in last
  if (results[results.length - 1] == '.') {
    results.removeLast();
  } else if (results[results.length - 1] == '-') {
    if (results[results.length - 2] == '.') {
      results.removeAt(results.length - 2);
    }
  }

  prefix == 'expense' ? prefix = '-Rp' : prefix = '+Rp';

  //result
  results = List.from(results.reversed);
  results.remove('-');

  return prefix + results.join() + afterComma;
}
