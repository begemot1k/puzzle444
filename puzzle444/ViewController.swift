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
    

    var buttonGC = UIButton()
    var buttonInfo = UIButton()
    var monoGameButton = UIButton()
    var wifiGameButton = UIButton()
    var inetGameButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        buttonGC.setTitle("Войти в GameCenter", for: .normal)
        buttonGC.setTitleColor(.green, for: .normal)
        buttonGC.addTarget(self, action: #selector(gamecenter), for: .touchUpInside)
        view.addSubview(buttonGC)
        
        monoGameButton.setTitle("Игра на устройстве", for: .normal)
        monoGameButton.setTitleColor(.green, for: .normal)
        monoGameButton.addTarget(self, action: #selector(monoGamePressed), for: .touchUpInside)
        view.addSubview(monoGameButton)
        
        wifiGameButton.setTitle("Игра по Wi-Fi", for: .normal)
        wifiGameButton.setTitleColor(.green, for: .normal)
        wifiGameButton.addTarget(self, action: #selector(wifiGamePressed), for: .touchUpInside)
        view.addSubview(wifiGameButton)
        
        inetGameButton.setTitle("Игра в Интернете", for: .normal)
        inetGameButton.setTitleColor(.green, for: .normal)
        inetGameButton.addTarget(self, action: #selector(inetGamePressed), for: .touchUpInside)
        view.addSubview(inetGameButton)

        placeButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        placeButtons()
    }
    
    func placeButtons(){
        let buttonsWidth = 200
        let buttonsX = (Int(view.frame.width) - buttonsWidth)/2
        buttonGC.frame = CGRect(x: buttonsX, y: 120, width: buttonsWidth, height: 30)
        monoGameButton.frame = CGRect(x: buttonsX, y: 170, width: buttonsWidth, height: 30)
        wifiGameButton.frame = CGRect(x: buttonsX, y: 220, width: buttonsWidth, height: 30)
        inetGameButton.frame = CGRect(x: buttonsX, y: 270, width: buttonsWidth, height: 30)
    }
    
    @objc func monoGamePressed(){
        self.navigationController?.pushViewController(MonoGameViewController(), animated: true)

    }

    @objc func wifiGamePressed(){
        self.navigationController?.pushViewController(MonoGameViewController(), animated: true)

    }
    
    @objc func inetGamePressed(){
        
    }

    @objc func playerInfo(){
        print("displayName is \(ViewController.localPlayer.isAuthenticated)")
        print("displayName is "+ViewController.localPlayer.alias)
        print("gameCenterEnabled is \(ViewController.gameCenterEnabled)" )

    }
    
    
    @objc func gamecenter(){
        if !ViewController.gameCenterEnabled {
            ViewController.authenticateLocalPlayer()
        }
    }
    
    static var localPlayer = GKLocalPlayer()
    static var gameCenterEnabled = false
    static func authenticateLocalPlayer() {
        print("lets auth")
        print("isAuthenticated is \(localPlayer.isAuthenticated) Alias is \(localPlayer.alias)")
        
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            print("its handler")
            if let viewController = viewController {
                print("viewController exists")
                if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                    print("lets view")
                    rootViewController.present(viewController, animated: true, completion: nil)
                }
            } else if localPlayer.isAuthenticated {
                print("authenticated!!!")
                gameCenterEnabled = true
                let defaultCenter = NotificationCenter.default
                defaultCenter.post(name: NSNotification.Name(rawValue: "local_player_authenticated"), object: nil)
            } else {
                print("no viewcontroller & not authenticated")
                gameCenterEnabled = false
            }

            if let error = error {
                print("error \(error)")
            }
        }
    }

  
}
