//
//  MPCHandler.swift
//  
//
//  Created by 01587913 on 01.12.2019.
//

import UIKit
import MultipeerConnectivity

protocol MPCHandlerDelegate {
    func receive(message: String)
    func connected(name: String , peerID: MCPeerID)
    func connectionReset()
}

class MPCHandler: NSObject, MCSessionDelegate, MCBrowserViewControllerDelegate {
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    var delegate: MPCHandlerDelegate!
    
    func setupPeer(displayName: String){
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        session = MCSession(peer: peerID)
        
        session.delegate = self
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: "vkh-puzzle444", session: session)
        
        browser.delegate = self
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
    
// MARK: MCSessionDelegate methods
    
    /// Изменение статуса соединения
    /// - Parameters:
    ///   - session: сессия в рамках которой произошло изменение
    ///   - peerID: peerID для которого произошло изменение
    ///   - state: новое значение состояния
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            let displayName = peerID.displayName
            delegate.connected(name: displayName , peerID: peerID)
            return
        case .notConnected:
            delegate.connectionReset()
            return
        default: break
        }
    }
    
    /// Приняты данные
    /// - Parameters:
    ///   - session: сессия в рамках которой произошло изменение
    ///   - data: полученные данные
    ///   - peerID: peerID для которого произошло изменение
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate.receive(message: String.init(data: data, encoding: .utf8)! )
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    // MARK: MCBrowserViewControllerDelegate methods
    
    /// в обозревателе для сетевой игры нажали кнопку Done
    /// - Parameter browserViewController: контроллер представления обозревателя
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browser.dismiss(animated: true, completion: nil)
    }
    
    /// в обозревателе для сетевой игры нажали кнопку Cancel
    /// - Parameter browserViewController: контроллер представления обозревателя
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browser.dismiss(animated: true, completion: nil)
    }
    
    
}
