import 'package:flutter/services.dart';

/// Formata a entrada de um campo de CPF no padrão XXX.XXX.XXX-XX
/// enquanto o usuário digita, aceitando apenas dígitos.
class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final limitado = digits.length > 11 ? digits.substring(0, 11) : digits;

    final buffer = StringBuffer();
    for (var i = 0; i < limitado.length; i++) {
      buffer.write(limitado[i]);
      if (i == 2 || i == 5) {
        if (i != limitado.length - 1) buffer.write('.');
      } else if (i == 8) {
        if (i != limitado.length - 1) buffer.write('-');
      }
    }

    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
