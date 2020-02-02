class WeatherModel{
  final temp;
  final temp_min;
  final temp_max;
  final feels;
  final humidity;
  final visibility;

  double get getTemp => temp-272.5;
  double get getTempMax => temp_max-272.5;
  double get getTempMin => temp_min-272.5;
  double get getFeels => feels - 272.5;


  WeatherModel(this.temp, this.temp_min, this.temp_max, this.feels, this.humidity, this.visibility);

  factory WeatherModel.fromJson(Map<String, dynamic> json){
    return WeatherModel(
        json["temp"],
        json["temp_min"],
        json["temp_max"],
        json["feels_like"],
        json["humidity"],
        json["visibility"],
    );
  }
}