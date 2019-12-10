//
//  Protocols.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit


protocol ViewProtocol: class {
    func setGameStatusText(status: String)
    func setNetworkStatusText(status: String)
    func setNetworkStatusColor(color: UIColor)
    func updateDots(dots: Array<Player>)
}

protocol PresenterProtocol: class {
    var router: RouterProtocol! { set get }
    func configureView()

    func dotClicked(dotName: String)
    func disconnect()
    func exitToMenu()
    func networkMenuClicked()
    func updateDots(dots: Array<Player>)
    func setGameStatusText(status: String)
    func setNetworkStatusText(status: String)
    func setNetworkStatusColor(color: UIColor)
}

protocol InteractorProtocol: class {
    var opponentsValue: Double { set get }
    var myFigure: Player { set get }
    var myValue: Double {set get}
    
    func dotClicked(dotName: String)
    func networkMenu()
    func resetGame()
    func closeGame()
    func disconnect()
    func performMove(coord: String)
}

protocol ConfiguratorProtocol: class {
    func configure(with viewController: WiFiGameViewController)
}

protocol RouterProtocol: class {
    func exitToMenu()
    
}

