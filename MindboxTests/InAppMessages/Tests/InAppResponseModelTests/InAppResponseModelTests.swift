//
//  InAppResponseModelTests.swift
//  MindboxTests
//
//  Created by Akylbek Utekeshev on 19.01.2023.
//  Copyright © 2023 Mikhail Barilov. All rights reserved.
//

import XCTest
@testable import Mindbox

final class InAppResponseModelTests: XCTestCase {
    
    func test_TrueTargeting_valid() {
        let config: TrueTargeting? = getConfig(resourceName: "TrueTargetingModelValid")
        XCTAssertNotNil(config)
    }
    
    func test_AndTargeting_invalid() {
        let config: AndTargeting? = getConfig(resourceName: "TrueTargetingModelValid")
        XCTAssertNil(config)
    }
    
    func test_AndTargeting_valid() {
        guard let config: AndTargeting = getConfig(resourceName: "AndTargetingModelValid") else {
            assertionFailure("config is Nil")
            return
        }
        
        XCTAssertNotNil(config)
        XCTAssertFalse(config.nodes.isEmpty)
        XCTAssertEqual(config.nodes.count, 1)
    }
    
    func test_OrTargeting_invalid() {
        let config: OrTargeting? = getConfig(resourceName: "TrueTargetingModelValid")
        XCTAssertNil(config)
    }
    
    func test_OrTargeting_valid() {
        guard let config: OrTargeting = getConfig(resourceName: "AndTargetingModelValid") else {
            assertionFailure("config is Nil")
            return
        }
        
        XCTAssertNotNil(config)
        XCTAssertFalse(config.nodes.isEmpty)
        XCTAssertEqual(config.nodes.count, 1)
    }
    
    func test_SegmentTargeting_invalid() {
        let config: SegmentTargeting? = getConfig(resourceName: "OrTargetingModelValid")
        XCTAssertNil(config)
    }
    
    func test_SegmentTargeting_valid() {
        guard let config: SegmentTargeting = getConfig(resourceName: "SegmentTargetingModelValid") else {
            assertionFailure("config is Nil")
            return
        }
        
        XCTAssertNotNil(config)
        XCTAssertEqual(config.kind, .positive)
        XCTAssertEqual(config.segmentationExternalId, "00000000-0000-0000-0000-000000000001")
        XCTAssertEqual(config.segmentationInternalId, "00000000-0000-0000-0000-000000000002")
        XCTAssertEqual(config.segmentExternalId, "00000000-0000-0000-0000-000000000003")
    }
    
    func test_GeoTargeting_invalid() {
        let config: GeoTargeting? = getConfig(resourceName: "SegmentTargetingModelValid")
        XCTAssertNil(config)
    }
    
    func test_GeoTargeting_valid() {
        guard let config: GeoTargeting = getConfig(resourceName: "GeoTargetingModelValid") else {
            assertionFailure("config is Nil")
            return
        }
        
        XCTAssertNotNil(config)
        XCTAssertEqual(config.kind, .negative)
        XCTAssertFalse(config.ids.isEmpty)
        XCTAssertEqual(config.ids.count, 3)
        XCTAssertEqual(config.ids[0], 1)
    }
    
    func test_CommonTargeting_valid() {
        guard let andJSON: Targeting = getConfig(resourceName: "AllTargetingsModelValid") else {
            assertionFailure("config is Nil")
            return
        }
        
        XCTAssertNotNil(andJSON)
        
        switch andJSON {
        case .and(let andTargeting):
            XCTAssertEqual(andTargeting.nodes.count, 1)
            let orJSON = andTargeting.nodes[0]
            switch orJSON {
            case .or(let orTargeting):
                XCTAssertEqual(orTargeting.nodes.count, 3)
                let geoJSON = orTargeting.nodes[2]
                switch geoJSON {
                case .geo(let geoTargeting):
                    XCTAssertEqual(geoTargeting.kind, .negative)
                    XCTAssertEqual(geoTargeting.ids, [1, 2, 3])
                default:
                    assertionFailure("Wrong type")
                }
            default:
                assertionFailure("Wrong type")
            }
        default:
            assertionFailure("Wrong type")
        }
    }
    
    private func getConfig<T: Decodable>(resourceName: String) -> T? {
        do {
            let bundle = Bundle(for: InAppResponseModelTests.self)
            let fileURL = bundle.url(forResource: resourceName, withExtension: "json")!
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}
