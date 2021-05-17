//
//  CreateOrder.swift
//  Mindbox
//
//  Created by Mikhail Plotnikov on 05.05.2021.
//  Copyright © 2021 Mikhail Barilov. All rights reserved.
//

import Foundation

public class CreateOrder: Codable {
    public let order: Order

    public init(order: Order) {
        self.order = order
    }
}
