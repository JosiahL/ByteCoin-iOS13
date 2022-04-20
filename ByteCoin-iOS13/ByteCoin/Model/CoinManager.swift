//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
    func displayPrice(price: String, curr: String)
    func didFailWithError(_: CoinManager, error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F6C326A3-7467-4B32-82A4-4332F1B01D7B"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let url = "\(self.baseURL)/\(currency)/?apikey=\(self.apiKey)"
        if let safeUrl = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: safeUrl) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let rate = parseJSON(safeData) {
                        let roundedRate = String(format: "%.2f", rate)
                        delegate?.displayPrice(price: roundedRate, curr: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            return rate
        } catch {
            delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
    
}
