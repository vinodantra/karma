// ignore_for_file: file_names

// Shared validators for use with Form / TextFormField across create/edit
// flows. These intentionally return `null` for valid input and a short
// human-readable message otherwise so they can be passed directly as the
// `validator:` argument of a `TextFormField`.

/// Returns `"$fieldName is required"` if [value] is null or blank, else null.
String? requiredField(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return "$fieldName is required";
  }
  return null;
}

/// Returns "Enter a valid phone number" if [value] does not contain exactly
/// 10 digits after stripping non-digit characters.
String? phoneField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Phone number is required";
  }
  final digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 10) {
    return "Enter a valid phone number";
  }
  return null;
}

/// Validates an email address. Treated as optional — returns null when
/// [value] is empty. Returns "Enter a valid email" when present but
/// malformed.
String? emailField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  final pattern = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$');
  if (!pattern.hasMatch(value.trim())) {
    return "Enter a valid email";
  }
  return null;
}

/// Returns "$fieldName must be at least $n characters" if the trimmed
/// length of [value] is less than [n]. An empty value is also rejected.
String? minLengthField(String? value, int n, String fieldName) {
  if (value == null || value.trim().length < n) {
    return "$fieldName must be at least $n characters";
  }
  return null;
}
