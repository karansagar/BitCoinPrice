//
//  ViewController.swift
//  BitCoinPrice
//
//  Created by Karan Sagar on 10/11/19.
//  Copyright © 2019 Karan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Outlets
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbole = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var finalURL = ""
    
    var currencySelected = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    //TODO: Place your 3 UIPickerView delegate methods here
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        currencySelected = currencySymbole[row]
        
        getBitcoinData(url: finalURL)

    }
    
    //MARK:- Networking
    
    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Sucess! got the Bitcoin Price data")
                    let bitCoinJSON: JSON = JSON(response.result.value!)
                    self.updateBitCoinData(json: bitCoinJSON)
                    
                } else {
                    print(" Error: \(String(describing: response.result.error))")
                    self.priceLabel.text = "Connection Issues"
                }
                
        }
    }
    
    //MARK:- JSON Parsing
    
    func updateBitCoinData(json: JSON) {
        if let bitcoinResult = json["ask"].double {
            priceLabel.text = currencySelected + String(bitcoinResult)
        } else {
            priceLabel.text = "Price Unavailable"
        }
    }
  

}

