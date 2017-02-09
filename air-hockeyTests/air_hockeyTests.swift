//
//  air_hockeyTests.swift
//  air-hockeyTests
//
//  Created by Marek Newton on 2/5/17.
//  Copyright © 2017 Marek Newton. All rights reserved.
//

import XCTest
@testable import air_hockey
import UIKit
import SpriteKit

class air_hockeyTests: XCTestCase {
    var gameScene: GameScene?
    var controller: GameViewController?
    
    override func setUp() {
        gameScene = GameScene()
        controller = GameViewController()
        
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDidMoveToView() {
        controller?.viewDidLoad()
        XCTAssert(gameScene?.puckSpeed == 0.1)
    }
}
