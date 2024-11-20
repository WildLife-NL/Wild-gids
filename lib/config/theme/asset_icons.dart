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
}
