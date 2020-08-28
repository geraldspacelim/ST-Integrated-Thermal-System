class Glob {
  //One instance, needs factory 
  static Glob _instance;
  factory Glob() => _instance ??= new Glob._();
  Glob._();
  //

  int allCount = 0;
  int arrayCount1 = 0; 
  int arrayCount2 = 0;
}