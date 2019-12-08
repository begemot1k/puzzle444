//
//  MPCHandler.swift
//  
//
//  Created by 01587913 on 01.12.2019.
//

import UIKit
import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate {
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    var delegate: MoveProtocol!
    
    func setupPeer(displayName: String){
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: "vkh-puzzle444", session: session)
    }
    
    func advertiseSelf(advertise: Bool){
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "vkh-puzzle444", discoveryInfo: nil, session: session)
            advertiser?.start()
        } else {
            advertiser?.stop()
            advertiser = nil
        }
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID": peerID, "state": state.rawValue] as [String : Any]
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "MPC_DidChangeStateNotification"),
                object: nil,
                userInfo: userInfo
            )
        }
        if state == .connected {
            let displayName = peerID.displayName
            delegate.opponentFound(name: displayName , peerID: peerID)
            return
        }
        if state == .notConnected {
            delegate.connectionReset()
            return
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["peerID": peerID, "data": data] as [String : Any]
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "MPC_DidReceiveDataNotification"),
                object: nil,
                userInfo: userInfo
            )
        }
        print("от \(peerID) пришло сообщение \(data)")
        
        if String.init(data: data, encoding: .utf8 ) == "draw" {
            delegate.receiveDrawRequest()
            return
        }
        
        if String.init(data: data, encoding: .utf8 ) == "drawConfirmed" {
            delegate.drawConfirmed()
            return
        }
        
        if String.init(data: data, encoding: .utf8 ) == "newGame" {
            delegate.newGame()
            return
        }
        
        delegate.receiveMove(coord: String.init(data: data, encoding: .utf8)! )
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
