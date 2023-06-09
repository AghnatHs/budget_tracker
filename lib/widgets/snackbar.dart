import 'package:flutter/material.dart';

SnackBar createSnackbar(String messages, {int? duration, SnackBarAction? actions}) {
  return SnackBar(
    actionOverflowThreshold: 1,
    behavior: SnackBarBehavior.floating,
    content: Text(messages),
    duration: Duration(seconds: duration ?? 1),
    action: actions,
  );
}
