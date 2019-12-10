//
//  Interactor.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit


class Interactor: InteractorProtocol, MoveProtocol {
    
    weak var presenter: PresenterProtocol!
    
    let mpcService: MPCServiceProtocol = MPCService()
    let game: GameProtocol = Game()
    
    var myFigure: Player = .free
    var opponentsValue: Double = 0.0
    var myValue: Double = 0.0
    var opponentsName: String = ""
    var drawSent = false
    
    required init(presenter: PresenterProtocol) {
        self.presenter = presenter
        mpcService.delegate = self
        game.isGameOver = true
    }
        
    func foundOpponent(name: String) {
        opponentsName = name
        presenter?.setGameStatusText(status: "Начните новую игру или ждите приглашения")
        presenter?.setNetworkStatusText(status: "Присоединился \(name)")
        game.isGameOver = true
}
        
    func disconnect(){
        opponentsName = ""
        mpcService.disconnect()
    }
    
    func resetGame() {
        
    }
    
    func sendDrawRequest(){
        drawSent = true
        mpcService.sendDrawRequest()
    }
    
    /// обработка нажатия точки игроком
    /// - Parameter dotName: координаты точки
    func dotClicked(dotName: String){
        guard !game.isGameOver else { return }
        guard myFigure == game.activePlayer else { return }
        performMove(coord: dotName)
        mpcService.sendMove(coord: dotName)
    }

    /// Обработка пришедшего хода соперника
    /// - Parameter coord: координаты точки
    func receiveMove(coord: String) {
        print("пришли данные \(coord)")
        if myFigure == .free {
            print("я вне игры, необходимо определиться кто за кого")
            guard let opponentValue = Double(coord) else {return}
            var statusText: String = ""
            var statusColor: UIColor = .white
            if myValue > opponentValue {
                myFigure = .blue
                statusText = "Соединено, мой цвет СИНИЙ"
                statusColor = .blue
            }
            else {
                myFigure = .red
                statusText = "Соединено, мой цвет КРАСНЫЙ"
                statusColor = .red
            }
            print("всё очень просто. моё значение \(myValue), у соперника \(opponentValue), значит у меня \(myFigure)")
            game.reset()
            game.isGameOver = false
            presenter?.setGameStatusText(status: game.status)
            presenter?.setNetworkStatusText(status: statusText)
            presenter?.setNetworkStatusColor(color: statusColor)
            presenter?.updateDots(dots: game.dots)
            print("завершение обработки")
            return
        }
        print("делаем ход")
        performMove(coord: coord)
    }
    
    func performMove(coord: String){
        print("обработка хода в \(coord)")
        if game.isValidMove(dotName: coord ){
            print("move is valid")
            game.move(dotName: coord)
            presenter?.updateDots(dots: game.dots)
            presenter?.setGameStatusText(status: game.status)
            if game.isGameOver {
                presenter?.setNetworkStatusColor(color: .green)
                presenter?.setNetworkStatusText(status: "Соединено")
            }
        }
    }
    
    func closeGame(){
        if game.isGameOver {
            print("Игра окончена, покидаем экран спокойно")
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
        mpcService.newGame()
        newGame()
    }
    
    func connectionReset() {
        print("Оппонент покинул игру")
        opponentsName = ""
        myFigure = .free
        myValue = 0.0
        stopGame()
        
        presenter?.setGameStatusText(status: "Найдите оппонента или ожидайте приглашения")
        presenter?.setNetworkStatusText(status: "Соединение разорвано")
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
                self.mpcService.confirmDraw()
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
            presenter?.setNetworkStatusColor(color: .green)
            presenter.setNetworkStatusText(status: "Соединено.")
        }
    }
    
    
    func newGame(){
        print("поступило интересное предложение начать новую игру")
        print("загадали наше значение, немного подождем, чтобы оппонент тоже его загадал")
        myFigure = .free
        myValue = Double.random(in: 0 ..< 1)
        mpcService.sendMove(coord: "\(myValue)")
        presenter?.updateDots(dots: game.dots)
        
    }
    
    func findOpponent(){
        mpcService.findOpponent()
    }
    
    @objc func networkMenu(){
        let menu = UIAlertController(title: "Вы желаете", message: "выберите действие", preferredStyle: .actionSheet)
        if opponentsName == "" {
            let actionConnect = UIAlertAction(title: "Найти оппонента", style: .default, handler: { (UIAlertAction)->Void in
                self.myFigure = .free
                self.myValue = Double.random(in: 0 ..< 1)
                self.findOpponent()
            } )
            menu.addAction(actionConnect)
        } else {
            let actionConnect = UIAlertAction(title: "Найти другого игрока", style: .destructive, handler: { (UIAlertAction)->Void in
                self.mpcService.disconnect()
                self.opponentsName = ""
                self.myFigure = .free
                self.myValue = Double.random(in: 0 ..< 1)
                self.findOpponent()
            } )
            menu.addAction(actionConnect)
        }
        if game.isGameOver && opponentsName != "" {
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