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
    
    func connected(name: String, peerID: MCPeerID) {
        opponentName = name
        opponentPeerID = peerID
        delegate.foundOpponent(name: name)
    }
    
    func connectionReset() {
        delegate.connectionReset()
    }
    
    func sendMove(coord: String) {
        sendToOpponent(coord)
    }
    
    func newGame() {
        sendToOpponent("newGame")
    }
    
    func disconnect(){
        mpcHandler.advertiseSelf(advertise: false)
        mpcHandler.session.disconnect()
    }
    
    func findOpponent() {
        mpcHandler.setupBrowser()
        UIApplication.shared.delegate?.window?!.rootViewController!.present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    
    func sendDrawRequest() {
        sendToOpponent("draw")
    }
    
    func confirmDraw() {
        sendToOpponent("drawConfirmed")
    }
    
    private func sendToOpponent(_ message: String){
        guard self.opponentPeerID != nil else { return }
        do {
            try mpcHandler.session.send(message.data(using: .utf8, allowLossyConversion: false)!, toPeers: [opponentPeerID], with: .reliable)
        } catch {
            print("ошибка отправки сообщения")
        }
    }
    
    func receive(message: String){
        if message == "draw" {
            delegate.receiveDrawRequest()
            return
        }
        
        if message == "drawConfirmed" {
            delegate.drawConfirmed()
            return
        }
        
        if message == "newGame" {
            delegate.newGame()
            return
        }
        delegate.receiveMove(coord: message)
    }
    
}
