//
//  MoveProtocol.swift
//  puzzle444
//
//  Created by 01587913 on 08.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MoveProtocol {

    func receiveMove(coord: String)
    
    func opponentFound(name: String, peer: MCPeerID)
    
    func receiveDrawRequest()
    
    func connectionReset()
    
}
