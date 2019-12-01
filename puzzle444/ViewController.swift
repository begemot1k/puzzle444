//
//  ViewController.swift
//  puzzle444
//
//  Created by 01587913 on 20.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import GameKit
import MultipeerConnectivity    

class ViewController: UIViewController {
    var monoGameButton = UIButton()
    var wifiGameButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        monoGameButton.setTitle("Игра на устройстве", for: .normal)
        monoGameButton.setTitleColor(.green, for: .normal)
        monoGameButton.addTarget(self, action: #selector(monoGamePressed), for: .touchUpInside)
        view.addSubview(monoGameButton)
        
        wifiGameButton.setTitle("Игра по Wi-Fi", for: .normal)
        wifiGameButton.setTitleColor(.green, for: .normal)
        wifiGameButton.addTarget(self, action: #selector(wifiGamePressed), for: .touchUpInside)
        view.addSubview(wifiGameButton)

        placeButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        placeButtons()
    }
    
    func placeButtons(){
        let buttonsWidth = 200
        let buttonsX = (Int(view.frame.width) - buttonsWidth)/2
        monoGameButton.frame = CGRect(x: buttonsX, y: 170, width: buttonsWidth, height: 30)
        wifiGameButton.frame = CGRect(x: buttonsX, y: 220, width: buttonsWidth, height: 30)
    }
    
    @objc func monoGamePressed(){
        self.navigationController?.pushViewController(MonoGameViewController(), animated: true)
    }

    @objc func wifiGamePressed(){
        self.navigationController?.pushViewController(WiFiGameViewController(), animated: true)
    }
}
