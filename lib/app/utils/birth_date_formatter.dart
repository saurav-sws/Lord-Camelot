import 'package:flutter/services.dart';

class BirthDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text.length > newValue.text.length) {
      if (oldValue.text.length > 0 &&
          (oldValue.selection.end == 6 || oldValue.selection.end == 9) &&
          oldValue.selection.baseOffset == oldValue.selection.extentOffset) {
        final newText =
            oldValue.text.substring(0, oldValue.selection.end - 2) +
            oldValue.text.substring(oldValue.selection.end);
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: oldValue.selection.end - 2,
          ),
        );
      }

      return newValue;
    }

    // Only allow digits
    String newText = newValue.text.replaceAll(RegExp(r'[^\d-]'), '');

    // If the user is manually typing dashes, don't duplicate them
    if (newValue.text.length > oldValue.text.length &&
        newValue.text.endsWith('-') &&
        (newValue.text.length == 5 || newValue.text.length == 8)) {
      return newValue;
    }

    // Build the formatted text with dashes
    String formattedText = '';
    int selectionIndex = newValue.selection.end;
    int digitCount = 0;

    // Process each character
    for (int i = 0; i < newText.length; i++) {
      if (newText[i] == '-') continue; // Skip existing dashes

      // Add dashes automatically after year and month
      if (digitCount == 4 || digitCount == 6) {
        formattedText += '-';
        if (newValue.selection.end > formattedText.length - 1) {
          selectionIndex++;
        }
      }

      formattedText += newText[i];
      digitCount++;
    }

    // Limit to 10 characters (YYYY-MM-DD)
    if (formattedText.length > 10) {
      formattedText = formattedText.substring(0, 10);
      if (selectionIndex > formattedText.length) {
        selectionIndex = formattedText.length;
      }
    }

    // Ensure selection index is valid
    if (selectionIndex < 0) selectionIndex = 0;
    if (selectionIndex > formattedText.length)
      selectionIndex = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
