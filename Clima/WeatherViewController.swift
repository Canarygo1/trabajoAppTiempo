//
//  ViewController.swift
//  WeatherApp
//

import CoreLocation
import UserNotifications
import UIKit
import Alamofire
import SwiftyJSON
class WeatherViewController: UIViewController,CLLocationManagerDelegate, ChangeCityViewDelegate{
    
    //Constants
    //https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?"
    //lat=+"35"&lon="139"&appid="b6907d289e10d714a6e88b30761fae22"
    let APP_ID = "7e4a7402aabe7364197d4082c043f03a"
    let locationManager = CLLocationManager()
    //TODO: Declare instance variables here
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        //TODO:Set up the location manager here.
//        let respuesta = getWeatherData()
        var location:CLLocation!
        location = locationManager.location
        getWeatherData(Float(location.coordinate.latitude), Float(location.coordinate.longitude))
    }
    
    //MARK: - Networking
    /***************************************************************/
//    "\(WEATHER_URL)lat=+\(latitud)&lon=\(longitud)&appid=\(APP_ID)" --> Llamada a APi
    //Write the getWeatherData method here:

    func getWeatherData(_ latitud:Float , _ longitud:Float) -> Void{
        Alamofire.request("\(WEATHER_URL)lat=\(latitud)&lon=\(longitud)&appid=\(APP_ID)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                self.parseJSON(JSON(responseData.result.value!))
                //mirar any type inicializate
            }
            else{
                self.cityLabel.text = "No disponible"
            }
        }
        
    }

    func getWeatherData(_ Ciudad:String) -> Void{
        Alamofire.request("\(WEATHER_URL)q=\(Ciudad)&appid=\(APP_ID)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                self.parseJSON(JSON(responseData.result.value!))
                print(responseData.result.value)
            }
            else{
                self.cityLabel.text = "No disponible"
            }
        }
        
    }
    //MARK: - JSON Parsing
    /***************************************************************/
    func parseJSON(_ json:JSON){
        let errorCodigo = json["cod"].intValue
        print("El codigo\(errorCodigo)")
        if errorCodigo == 400 || errorCodigo == 404 {
            self.cityLabel.text = "Datos Incorrectos"
        }
        else{
        let ciudad = json["name"].stringValue
        let temperatura = Int(json["main"]["temp"].doubleValue - 273.15)
        let codigo = json["weather"][0]["id"].intValue
        let Wheather = WeatherDataModel(ciudad,temperatura,codigo)
        update(Wheather)
        }
    }
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    func update(_ Weather:WeatherDataModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = Weather.ciudad
            self.temperatureLabel.text = ("\(Weather.temperatura)°")
            self.weatherIcon.image = UIImage(named:Weather.updateWeatherIcon(condition: Weather.codigo))
        }
    }
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        self.cityLabel.text="Localizacion no disponible"
    }
    
//    override func preparate(for segue)
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    func textoIntroducido(texto: String) {
        getWeatherData(texto)
    }
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DestinationView = segue.destination as? ChangeCityViewController{
            DestinationView.Delegate = self
        }
    }

}


