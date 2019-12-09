//
//  Router.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit

class Router: RouterProtocol {
    weak var viewController: WiFiGameViewController!
    
    init(viewController: WiFiGameViewController) {
        self.viewController = viewController
    }

    func exitToMenu(){
        
    }
}
