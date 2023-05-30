import 'package:flutter/material.dart';

SnackBar createSnackbar(String messages) {
  return SnackBar(
    content: Row(children: [Text(messages)],),
    duration: const Duration(seconds: 1),
  );
}
