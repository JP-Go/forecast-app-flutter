import 'package:form_validation/form_validation.dart';

class FormTranslations {
  static final _translations = {
    "form_validation_currency": "{label} deve ser um valor monetário.",
    "form_validation_currency_positive":
        "{label} deve ser um valor monetário positivo",
    "form_validation_email": "{label} inválido",
    "form_validation_max_length":
        "{label} deve possuir no máximo {length} caracteres",
    "form_validation_max_number": "{label} não deve ser maior que {number}",
    "form_validation_min_length":
        "{label} deve possuir no mínimo {length} caracteres",
    "form_validation_min_number": "{label} não deve ser menor que {number}",
    "form_validation_number": "{label} deve ser um número",
    "form_validation_number_decimal": "{label} deve ser um número decimal",
    "form_validation_phone_number": "{label} inválido(a)",
    "form_validation_required": "{label} é obrigatório(a)",
  };

  static void translateToPTBR() {
    FormValidationTranslations.values.updateAll(
      (key, val) => FormTranslations._translations[key]!,
    );
  }
}
