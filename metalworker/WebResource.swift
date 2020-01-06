//
//  WebResource.swift
//  metalworker
//
//  Created by Felix on 06.01.20.
//  Copyright © 2020 scale. All rights reserved.
//

import SwiftUI
import UIKit

final class WebResource: ObservableObject {
    @Published var data: Float? = nil

    init() {
        WebService().getCurrentAmount { data in
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}
