//
//  MPCService.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MPCServiceProtocol: class {
    var opponentName: String { set get }
    var opponentPeerID: MCPeerID! {set get}
    var delegate: MoveProtocol! { set get }
    func disconnect()
    func sendDrawRequest()
    func confirmDraw()
    func findOpponent()
    func sendMove(coord: String)
    func newGame()
}

class MPCService: MPCServiceProtocol, MPCHandlerDelegate {
    
    var mpcHandler: MPCHandler!
    var opponentName: String = ""
    var opponentPeerID: MCPeerID!
    var delegate: MoveProtocol!
    
    init(){
        mpcHandler = MPCHandler()
        mpcHandler.delegate = self
        mpcHandler.setupPeer(displayName: UIDevice.current.name)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
    }
    
    // MARK: MPCHandlerDelegate methods
    
    /// Обработка события присоединения оппонента по сети
    /// - Parameters:
    ///   - name: имя устройства оппонента
    ///   - peerID: peerID соединения
    func connected(name: String, peerID: MCPeerID) {
        opponentName = name
        opponentPeerID = peerID
        delegate.foundOpponent(name: name)
    }
    
    /// Обработка события разрыва соединения.
    func connectionReset() {
        delegate.connectionReset()
    }
    
    /// Получение сообщения от оппонента
    /// - Parameter message: полученное сообщение
    func receive(message: String){
        switch message {
        case "draw":
            delegate.receiveDrawRequest()
            break
        case "drawConfirmed":
            delegate.drawConfirmed()
            break
        case "newGame":
            delegate.newGame()
            break
        default:
            delegate.receiveMove(coord: message)
        }
    }
    
    // MARK: MPCServiceProtocol methods
    
    /// Разъединяемся (перед выходом из игры)
    func disconnect(){
        mpcHandler.advertiseSelf(advertise: false)
        mpcHandler.session.disconnect()
    }
    
    /// Отправляем наш ход
    /// - Parameter coord: координата точки хода
    func sendMove(coord: String) {
        sendToOpponent(coord)
    }
    
    /// Отправляем запрос на новую игру
    func newGame() {
        sendToOpponent("newGame")
    }
    
    /// Ищем оппонента
    func findOpponent() {
        mpcHandler.setupBrowser()
        UIApplication.shared.delegate?.window?!.rootViewController!.present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    /// Отправляем предложение о ничьей
    func sendDrawRequest() {
        sendToOpponent("draw")
    }
    
    /// Отправляем подтверждение ничьей
    func confirmDraw() {
        sendToOpponent("drawConfirmed")
    }
    
    // MARK: приватные методы
    
    /// Внутренняя функция отправки сообщений оппоненту
    /// - Parameter message: сообщения для отправки
    private func sendToOpponent(_ message: String){
        guard self.opponentPeerID != nil else { return }
        do {
            try mpcHandler.session.send(message.data(using: .utf8, allowLossyConversion: false)!, toPeers: [opponentPeerID], with: .reliable)
        } catch {
            print("ошибка отправки сообщения")
        }
    }
    
}
