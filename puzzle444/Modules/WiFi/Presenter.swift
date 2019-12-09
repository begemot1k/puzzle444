//
//  Presenter.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit

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
}

class Presenter: PresenterProtocol {

    weak var view: ViewProtocol!
    var interactor: InteractorProtocol!
    var router: RouterProtocol!
    
    
    required init(view: ViewProtocol) {
        self.view = view
    }

    func setGameStatusText(status: String) {
        view.setGameStatusText(status: status)
    }

    func setNetworkStatusText(status: String) {
        view.setNetworkStatusText(status: status)
    }
    
    func configureView() {
        view?.setGameStatusText(status: "Начните игру или ждите приглашения")
        view?.setNetworkStatusText(status: "Нет соединения")
        interactor.resetGame()
    }

    func dotClicked(dotName: String){
        interactor.dotClicked(dotName: dotName)
    }
    
    func networkMenuClicked() {
        interactor.networkMenu()
    }
    
    func updateDots(dots: Array<Player>) {
        view.updateDots(dots: dots)
    }
    
    func disconnect(){
        interactor.disconnect()
    }
    
    func exitToMenu(){
        view?.exitToMenu()
    }
}
