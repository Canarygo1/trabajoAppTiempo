//
//  ChangeCityViewController.swift
//  WeatherApp
//


import UIKit
import Foundation

//Write the protocol declaration here:


protocol ChangeCityViewDelegate {
    func textoIntroducido(texto:String)
}
class ChangeCityViewController: UIViewController,UITextFieldDelegate {
    var Delegate:ChangeCityViewDelegate!
    //Declare the delegate variable here:

    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        //1 Get the city name the user entered in the text field
        let texto:String! = changeCityTextField.text
        //2 If we have a delegate set, call the method userEnteredANewCityName
        let replaced = texto.replacingOccurrences(of: " ", with: "")

        Delegate.textoIntroducido(texto: replaced)

              // go back to MainMenuView as the eyes of the user
            
            
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)

        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
