//
//  Presenter.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit


class Presenter: PresenterProtocol {

    weak var view: ViewProtocol!
    var interactor: InteractorProtocol!
    var router: RouterProtocol!
    
    required init(view: ViewProtocol) {
        self.view = view
    }

    // MARK: PresenterProtocol methods
    
    /// Установка игрового статуса
    /// - Parameter status: статус игры
    func setGameStatusText(status: String) {
        view?.setGameStatusText(status: status)
    }
    
    /// Установка сетевого статуса
    /// - Parameter status: статус соединения
    func setNetworkStatusText(status: String) {
        view?.setNetworkStatusText(status: status)
    }
    
    /// Установка цвета для сетевого статуса
    /// - Parameter color: цвет статуса
    func setNetworkStatusColor(color: UIColor) {
        view?.setNetworkStatusColor(color: color)
    }
    
    /// Начальная установка представления
    func configureView() {
        view?.setGameStatusText(status: "Начните игру или ждите приглашения")
        view?.setNetworkStatusColor(color: .green)
        view?.setNetworkStatusText(status: "Нет соединения")
        if interactor != nil {
            interactor.resetGame()
        }
    }
    
    /// Обработка игрового события, которое произошло в представлении, в нашем случае событие передаётся в Interactor
    /// - Parameter dotName: имя нажатой точки (имя состоит из координат точки xyz)
    func dotClicked(dotName: String){
        interactor.dotClicked(dotName: dotName)
    }
    
    /// Обработка нажатия меню
    func networkMenuClicked() {
        interactor.networkMenu()
    }
    
    /// обновления представления в соответствии с моделью, переданной из Interactor`а`
    /// - Parameter dots: точки
    func updateDots(dots: Array<Player>) {
        view?.updateDots(dots: dots)
    }
    
    /// разъединение сети
    func disconnect(){
        interactor.disconnect()
    }
    
    /// выход в меню. так как действие происходит с переходом на другие экраны, задействуется роутер
    func exitToMenu(){
        router.exitToMenu()
    }
}
