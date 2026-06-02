String classLabel(String value) {
  switch (value) {
    case 'unacc':
      return 'No recomendable';
    case 'acc':
      return 'Aceptable';
    case 'good':
      return 'Bueno';
    case 'vgood':
      return 'Muy bueno';
    default:
      return value;
  }
}
