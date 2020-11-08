class VeggieRoutePath {
  final int id;
  final bool isUnknown;

  VeggieRoutePath.home()
      : id = null,
        isUnknown = false;

  VeggieRoutePath.details(this.id) : isUnknown = false;

  VeggieRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}