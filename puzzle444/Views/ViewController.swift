//
//  ViewController.swift
//  puzzle444
//
//  Created by 01587913 on 20.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var monoGameButton = UIButton()
    var wifiGameButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .darkGray
        placeButtons()
    }
    
    func placeButtons(){
        monoGameButton.setTitle("Игра на устройстве", for: .normal)
        monoGameButton.setTitleColor(.green, for: .normal)
        monoGameButton.addTarget(self, action: #selector(monoGamePressed), for: .touchUpInside)
        view.addSubview(monoGameButton)
        
        wifiGameButton.setTitle("Игра по Wi-Fi", for: .normal)
        wifiGameButton.setTitleColor(.green, for: .normal)
        wifiGameButton.addTarget(self, action: #selector(wifiGamePressed), for: .touchUpInside)
        view.addSubview(wifiGameButton)

        
        let buttonsWidth = CGFloat(200)
        let buttonsHeight = CGFloat(50)
        monoGameButton.frame = CGRect(x: 0, y: CGFloat(view.center.y - 50), width: buttonsWidth, height: buttonsHeight)
        monoGameButton.center.x = view.center.x
        
        wifiGameButton.frame = CGRect(x: 0, y: CGFloat(view.center.y + 50), width: buttonsWidth, height: buttonsHeight)
        wifiGameButton.center.x = view.center.x
    }
    
    @objc func monoGamePressed(){
        self.navigationController?.pushViewController(MonoGameViewController(), animated: true)
    }

    @objc func wifiGamePressed(){
        self.navigationController?.pushViewController(WiFiGameViewController(), animated: true)
    }
}
