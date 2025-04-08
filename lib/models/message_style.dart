enum MessageStyle {
  parcheminDAntan, // Parchemin d’Antan
  feuilleClassique, // Feuille Classique
  voileDeSoie, // Voile de Soie
  rouleauScelle, // Rouleau Scellé
  ecritVintage, // Écrit Vintage
  soieArdente, // Soie Ardente
  papierOriginal, // Style par défaut

  // Premium
  veloursNoir,
  feuilleOr,
  plumeRouge,
  shibari,
  chaine,
  collier,
}

extension MessageStyleDetails on MessageStyle {
  String get label {
    switch (this) {
      case MessageStyle.parcheminDAntan:
        return "Parchemin d’Antan";
      case MessageStyle.feuilleClassique:
        return "Feuille Classique";
      case MessageStyle.voileDeSoie:
        return "Voile de Soie";
      case MessageStyle.rouleauScelle:
        return "Rouleau Scellé";
      case MessageStyle.ecritVintage:
        return "Écrit Vintage";
      case MessageStyle.soieArdente:
        return "Soie Ardente";
      case MessageStyle.papierOriginal:
        return "Papier Original";
      case MessageStyle.veloursNoir:
        return "Velours Noir";
      case MessageStyle.feuilleOr:
        return "Feuille d’Or";
      case MessageStyle.plumeRouge:
        return "Plume Rouge";
      case MessageStyle.shibari:
        return "Cordes Shibari";
      case MessageStyle.chaine:
        return "Chaînes";
      case MessageStyle.collier:
        return "Collier";
    }
  }

  String get assetPath {
    switch (this) {
      case MessageStyle.parcheminDAntan:
        return "assets/parcheminantique.png";
      case MessageStyle.feuilleClassique:
        return "assets/feuilleclassique.png";
      case MessageStyle.voileDeSoie:
        return "assets/voiledesoie.png";
      case MessageStyle.rouleauScelle:
        return "assets/rouleauscelle.png";
      case MessageStyle.ecritVintage:
        return "assets/ecritvintage.png";
      case MessageStyle.soieArdente:
        return "assets/soieardente.png";
      case MessageStyle.papierOriginal:
        return "assets/fondjournal.png";

      case MessageStyle.veloursNoir:
        return "assets/veloursnoir.png";
      case MessageStyle.feuilleOr:
        return "assets/feuilleor.png";
      case MessageStyle.plumeRouge:
        return "assets/plumerouge.png";
      case MessageStyle.shibari:
        return "assets/shibari.png";
      case MessageStyle.chaine:
        return "assets/chaine.png";
      case MessageStyle.collier:
        return "assets/collier.png";
    }
  }

  /// Si cette texture est réservée aux membres premium
  bool get isPremium {
    switch (this) {
      case MessageStyle.veloursNoir:
      case MessageStyle.feuilleOr:
      case MessageStyle.plumeRouge:
      case MessageStyle.shibari:
      case MessageStyle.chaine:
      case MessageStyle.collier:
        return true;
      default:
        return false;
    }
  }
}
