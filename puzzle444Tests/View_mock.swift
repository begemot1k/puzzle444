//
//  View_mock.swift
//  puzzle444Tests
//
//  Created by 01587913 on 11.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
@testable import puzzle444

class View_mock: ViewProtocol {
    var presenter: PresenterProtocol!
    
    var gameStatusCount = 0
    var networkStatusCount = 0
    var networkColorCount = 0
    var updateDotsCount = 0
    var exitToMenuCount = 0
    
    func setGameStatusText(status: String){
        gameStatusCount += 1
    }
    func setNetworkStatusText(status: String){
        networkStatusCount += 1
    }
    func setNetworkStatusColor(color: UIColor){
        networkColorCount += 1
    }
    func updateDots(dots: Array<Player>){
        updateDotsCount += 1
    }
    func exitToMenu() {
        exitToMenuCount += 1
    }
}
