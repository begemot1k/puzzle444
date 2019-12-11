//
//  Router.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit

class Router: RouterProtocol {
    weak var viewController: ViewProtocol!
    
    init(viewController: ViewProtocol) {
        self.viewController = viewController
    }
    
    // MARK: RouterProtocol methods
    
    /// Выход в меню
    func exitToMenu(){
        viewController.exitToMenu()
    }
}
