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
    var mpcHandler: MPCHandler { set get }
    var opponentPeerID: MCPeerID! {set get}
    var delegate: MoveProtocol! { set get }
    func disconnect()
    func sendDrawRequest()
    func confirmDraw()
    func findOpponent()
    func sendMove(coord: String)
    func newGame()
}

class MPCService: MPCServiceProtocol {
    var mpcHandler = MPCHandler()
    var opponentPeerID: MCPeerID!
    var delegate: MoveProtocol!
    
    func sendMove(coord: String) {
        do {
            try mpcHandler.session.send(coord.data(using: .utf8, allowLossyConversion: false)!, toPeers: [opponentPeerID], with: .reliable)
        } catch {
            print("ошибка отправки хода оппоненту")
        }
    }
    
    func newGame() {
        do {
            if self.opponentPeerID != nil {
                try self.mpcHandler.session.send("newGame".data(using: .utf8, allowLossyConversion: false )!, toPeers: [self.opponentPeerID], with: .reliable)
            } else {
                print("а откуда у нас оппонент???")
            }
        } catch {
            print("error")
        }
        
    }
    func disconnect(){
        mpcHandler.advertiseSelf(advertise: false)
        mpcHandler.session.disconnect()
    }
    
    func findOpponent() {
        mpcHandler.setupPeer(displayName: UIDevice.current.name)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
        UIApplication.shared.delegate?.window?!.rootViewController!.present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    
    func sendDrawRequest() {
        do {
            try mpcHandler.session.send("draw".data(using: .utf8, allowLossyConversion: false)!, toPeers: [opponentPeerID], with: .reliable)
        } catch {
            print("ошибка отправки предложения о ничьей")
        }
        
    }
    
    func confirmDraw() {
        do {
            try mpcHandler.session.send("drawConfirmed".data(using: .utf8, allowLossyConversion: false)!, toPeers: [self.opponentPeerID], with: .reliable)
        }catch {
            print("ошибка отправки подтверждения ничьей")
        }
        
    }
}
