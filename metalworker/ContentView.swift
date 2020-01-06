//
//  ContentView.swift
//  metalworker
//
//  Created by Felix on 06.01.20.
//  Copyright © 2020 scale. All rights reserved.
//

import SwiftUI

private func formatAsCurrency(_ currency: Float) -> String? {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    currencyFormatter.currencyCode = "EUR"
    currencyFormatter.maximumFractionDigits = 0
    return currencyFormatter.string(from: NSNumber(value: currency))
}

struct ContentView: View {
    @ObservedObject var resource = WebResource()

    var body: some View {
        VStack {
            if resource.data != nil {
                Text(formatAsCurrency(resource.data!) ?? "")
                    .font(.system(size: 60))
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(
            Color("primary")
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
