//
//  SubViewProduct.swift
//  Mindbox
//
//  Created by Mikhail Plotnikov on 06.05.2021.
//  Copyright © 2021 Mikhail Barilov. All rights reserved.
//

import Foundation

public class SubViewProduct: Codable {
    public let productGroup, product: Product?
    public let customerAction: CustomerAction?

    public init(productGroup: Product?, product: Product?, customerAction: CustomerAction?) {
        self.productGroup = productGroup
        self.product = product
        self.customerAction = customerAction
    }
}
