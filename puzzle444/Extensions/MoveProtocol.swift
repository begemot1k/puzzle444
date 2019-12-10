//
//  MoveProtocol.swift
//  puzzle444
//
//  Created by 01587913 on 08.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit

protocol MoveProtocol {
    
    func receiveMove(coord: String)

    func foundOpponent(name: String)
    
    func receiveDrawRequest()
    
    func newGame()
    
    func drawConfirmed()
    
    func connectionReset()
    
}


