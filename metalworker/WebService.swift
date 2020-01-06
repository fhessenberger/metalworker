//
//  WebService.swift
//  metalworker
//
//  Created by Felix on 06.01.20.
//  Copyright © 2020 scale. All rights reserved.
//

import Foundation
import SwiftSoup

private func getHtml(completionHandler: @escaping (String) -> Void) {
    let Url = String(format: "https://produkte.erstegroup.com/Retail/de/MarketsAndTrends/Currencies/Sites/EB_Fixings_and_Downloads/Coins_and_Precious_Metals/index.phtml")

    guard let serviceUrl = URL(string: Url) else { return }

    let session = URLSession.shared
    session.dataTask(with: URLRequest(url: serviceUrl)) { data, _, _ in
        if let data = data {
            completionHandler(String(data: data, encoding: .utf8)!)
        }
    }.resume()
}

private func getAmountFromRow(inTable table: Element, rowNumber: Int) -> Float {
    let amount = try? table
        .select("tr")
        .eq(rowNumber)
        .select("td")
        .eq(3)
        .text()
        .replacingOccurrences(of: ".", with: "")
        .replacingOccurrences(of: ",", with: ".")
    
    return Float(amount ?? "0") ?? 0
}

private let ITEMS = [
    (14, 2), // Goldbaren 100g
    (23, 1), // Gold-Dukaten 4-fach
    (22, 3), // Gold-Dukaten 1-fach
    (49, 1), // Kaenguruh Gold 1/10
    (9, 2), // Philharmoniker Gold 1/4 ATS 500
]

class WebService {

    func getCurrentAmount(completionHandler: @escaping ((Float?) -> Void)) {
        getHtml {
            do {
                let doc = try SwiftSoup.parse($0)

                guard
                    let table = try doc
                    .select("table.factsheet")
                    .first()
                else {
                    completionHandler(nil)
                    return
                }

                completionHandler(
                    ITEMS.reduce(0) { (acc, item) in
                        acc + getAmountFromRow(inTable: table, rowNumber: item.0) * Float(item.1)
                    }
                )
            } catch {
                completionHandler(nil)
                print(error)
            }
        }
    }
}
