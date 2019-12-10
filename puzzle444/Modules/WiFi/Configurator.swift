//
//  Configurator.swift
//  puzzle444
//
//  Created by 01587913 on 09.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit


class Configurator: ConfiguratorProtocol {
    func configure(with viewController: WiFiGameViewController) {
        let presenter = Presenter(view: viewController)
        let interactor = Interactor(presenter: presenter)
        let router = Router(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }

}
