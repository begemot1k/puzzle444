//
//  Interactor.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol InteractorProtocol: class {
    var inputValue: Double { set get }
    var myFigure: Player { set get }
    var myValue: Double {set get}
    
    func dotClicked(dotName: String)
    func networkMenu()
    func resetGame()
    func closeGame()
    func disconnect()
    func performMove(coord: String)
    func opponentFound(name: String, peerID: MCPeerID)
}


class Interactor: InteractorProtocol, MoveProtocol {
    
    weak var presenter: PresenterProtocol!
    
    let mpcHandler: MPCServiceProtocol = MPCService()
    let game: GameProtocol = Game()
    
    var myFigure: Player = .free
    var inputValue: Double = 0.0
    var myValue: Double = 0.0
    var opponentName: String = ""
    var statusText: String = ""
    var drawSent = false
    
    
    required init(presenter: PresenterProtocol) {
        self.presenter = presenter
        mpcHandler.delegate = self
    }
    
    func dotClicked(dotName: String){
        guard !game.isGameOver else { return }
        performMove(coord: dotName)
        mpcHandler.sendMove(coord: dotName)
    }
    
    func opponentFound(name: String, peerID: MCPeerID) {
        opponentName = name
        mpcHandler.opponentPeerID = peerID
        presenter.setGameStatusText(status: "Начните новую игру или ждите приглашения")
        presenter.setNetworkStatusText(status: "Присоединился \(name)")
    }
    
    func disconnect(){
        opponentName = ""
        mpcHandler.disconnect()
    }
    
    func resetGame() {
        
    }
    
    func sendDrawRequest(){
        drawSent = true
        mpcHandler.sendDrawRequest()
    }
    
    func performMove(coord: String){
        print("обработка хода в \(coord)")
        if game.isValidMove(dotName: coord ){
            print("move is valid")
            game.move(dotName: coord)
            presenter.updateDots(dots: game.dots)
            presenter.setGameStatusText(status: game.status)
        }
    }
    
    func closeGame(){
        if game.isGameOver {
            print("Игра окончена, покидаем эран спокойно")
            presenter.exitToMenu()
        } else {
            let alert = UIAlertController(title: "Подтверждение", message: "Выйти из сетевой игры?", preferredStyle: .alert)
            let actionExit = UIAlertAction(title: "Выйти", style: .destructive, handler: { (UIAlertAction) -> Void in
                print("покидаем эран")
                self.presenter.exitToMenu()
            })
            let actionCancel = UIAlertAction(title: "Раздумал", style: .cancel, handler: {(UIAleerAction)->Void in
                print("передумали. остаёмся в игре")
            })
            
            alert.addAction(actionExit)
            alert.addAction(actionCancel)
            print("Хотим покинуть игру?")
            UIApplication.shared.delegate?.window?!.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    func startNewGame(){
        guard game.isGameOver else { return }
        game.reset()
        myFigure = .free
        myValue = Double.random(in: 0 ..< 1)
        mpcHandler.newGame()
        newGame()
    }
    
    func connectionReset() {
        print("Оппонент покинул игру")
        opponentName = ""
        myFigure = .free
        myValue = 0.0
        stopGame()
        
        presenter.setGameStatusText(status: "Найдите оппонента или ожидайте приглашения")
        presenter.setNetworkStatusText(status: "Соединение разорвано")
    }
    
    func stopGame(){
        game.isGameOver = true
        myFigure = .free
    }
    
    func receiveDrawRequest() {
        DispatchQueue.main.async {
            print("видимо соперник уже проигрывает")
            let alert = UIAlertController.init(title: "Ничья", message: "Оппонент предлагает ничью, согласны?", preferredStyle: .alert)
            let actionDraw = UIAlertAction(title: "Согласен", style: .default) { (UIAlertAction) in
                print("принимаем ничью")
                self.mpcHandler.confirmDraw()
                self.game.isGameOver = true
                self.presenter.setGameStatusText(status: "Ничья. Начните новую игру")
                self.presenter.setNetworkStatusText(status: "Соединено.")
            }
            let actionDeny = UIAlertAction(title: "Отвергнуть", style: .destructive) { (UIAlertAction) in
                print("со злорадством отвергаем ничью. враг слаб. добьём его!")
                
            }
            alert.addAction(actionDraw)
            alert.addAction(actionDeny)
            UIApplication.shared.delegate?.window?!.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    func drawConfirmed() {
        print("ничья подтверждена")
        if drawSent {
            game.isGameOver = true
            myFigure = .free
            presenter.setGameStatusText(status: "Ничья. Начните новую игру")
            presenter.setNetworkStatusText(status: "Соединено.")
        }
    }
    
    
    func newGame(){
        myFigure = .free
        myValue = Double.random(in: 0 ..< 1)
        print("поступило интересное предложение начать новую игру")
        print("загадали наше значение, немного подождем, чтобы оппонент тоже его загадал")
        mpcHandler.sendMove(coord: "\(myValue)")
        
    }
    
    func receiveMove(coord: String) {
        print("пришли данные \(coord)")
        if myFigure == .free {
            print("я вне игры, необходимо определиться кто за кого")
            guard let opponentValue = Double(coord) else {return}
            if self.myValue > opponentValue {
                self.myFigure = .blue
                statusText = "Соединено, мой цвет СИНИЙ"
            }
            else {
                self.myFigure = .red
                statusText = "Соединено, мой цвет КРАСНЫЙ"
            }
            print("всё очень просто. моё значение \(myValue), у соперника \(opponentValue), значит у меня \(myFigure)")
            game.isGameOver = false
            presenter.setNetworkStatusText(status: statusText)
            print("завершение обработки")
            return
        }
        print("делаем ход")
        performMove(coord: coord)
    }
    
    func findOpponent(){
        mpcHandler.findOpponent()
    }
    
    @objc func networkMenu(){
        let menu = UIAlertController(title: "Вы желаете", message: "выберите действие", preferredStyle: .actionSheet)
        if opponentName == "" {
            let actionConnect = UIAlertAction(title: "Найти оппонента", style: .default, handler: { (UIAlertAction)->Void in
                self.myFigure = .free
                self.myValue = Double.random(in: 0 ..< 1)
                self.findOpponent()
            } )
            menu.addAction(actionConnect)
        } else {
            let actionConnect = UIAlertAction(title: "Найти другого игрока", style: .destructive, handler: { (UIAlertAction)->Void in
                self.mpcHandler.disconnect()
                self.opponentName = ""
                self.myFigure = .free
                self.myValue = Double.random(in: 0 ..< 1)
                self.findOpponent()
            } )
            menu.addAction(actionConnect)
        }
        if game.isGameOver && opponentName != "" {
            let actionNew = UIAlertAction(title: "Новая игра", style: .default, handler: { (UIAlertAction)->Void in
                self.startNewGame()
            } )
            menu.addAction(actionNew)
        }
        if !game.isGameOver {
            let actionReset = UIAlertAction(title: "Предложить ничью", style: .default, handler: { (UIAlertAction)->Void in
                self.sendDrawRequest()
            } )
            menu.addAction(actionReset)
        }
        let actionContinue = UIAlertAction(title: "Подолжить игру", style: .cancel, handler: { (UIAlertAction)->Void in
            
        } )
        menu.addAction(actionContinue)
        let actionExit = UIAlertAction(title: "Выход в меню", style: .destructive, handler: { (UIAlertAction)->Void in
            self.closeGame()
        } )
        menu.addAction(actionExit)
        UIApplication.shared.delegate?.window?!.rootViewController!.present( menu, animated: true, completion: nil)
    }

}
