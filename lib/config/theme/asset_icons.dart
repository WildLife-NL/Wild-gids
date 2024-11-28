class AssetIcons {
  static const _path = 'assets/icons';

  // Add Font Awesome Icons like this
  // static const faAddressBook = '$_path/fa-address-book.svg';x`

  static const locationDot = '$_path/location-dot.svg';

  // Interaction types
  static const schademelding = '$_path/interaction-types/schademelding.svg';
  static const waarneming = '$_path/interaction-types/waarneming.svg';
  static const wildaanrijding = '$_path/interaction-types/wildaanrijding.svg';

  // Animal species
  static const evenhoevigen = '$_path/animal-species/evenhoevigen.svg';
  static const knaagdieren = '$_path/animal-species/knaagdieren.svg';
  static const roofdieren = '$_path/animal-species/roofdieren.svg';

  // Numbers
  static const nul = '$_path/numbers/0-solid.svg';
  static const one = '$_path/numbers/1-solid.svg';
  static const two = '$_path/numbers/2-solid.svg';
  static const three = '$_path/numbers/3-solid.svg';
  static const four = '$_path/numbers/4-solid.svg';
  static const five = '$_path/numbers/5-solid.svg';
  static const six = '$_path/numbers/6-solid.svg';
  static const seven = '$_path/numbers/7-solid.svg';
  static const eight = '$_path/numbers/8-solid.svg';
  static const nine = '$_path/numbers/9-solid.svg';

  static String getInteractionIcon(String name) {
    switch (name.toLowerCase()) {
      case 'waarneming':
        return AssetIcons.waarneming;
      case 'schademelding':
        return AssetIcons.schademelding;
      default:
        return AssetIcons.wildaanrijding;
    }
  }

  static String getAnimalSpeciesIcon(String name) {
    switch (name.toLowerCase()) {
      case 'evenhoevigen':
        return AssetIcons.evenhoevigen;
      case 'knaagdieren':
        return AssetIcons.knaagdieren;
      default:
        return AssetIcons.roofdieren;
    }
  }

  static String getNumberIcon(int number) {
    switch (number) {
      case 0:
        return AssetIcons.nul;
      case 1:
        return AssetIcons.one;
      case 2:
        return AssetIcons.two;
      case 3:
        return AssetIcons.three;
      case 4:
        return AssetIcons.four;
      case 5:
        return AssetIcons.five;
      case 6:
        return AssetIcons.six;
      case 7:
        return AssetIcons.seven;
      case 8:
        return AssetIcons.eight;
      case 9:
        return AssetIcons.nine;
      default:
        return AssetIcons.nul;
    }
  }
}
