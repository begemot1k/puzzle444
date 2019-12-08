//
//  ViewController.swift
//  puzzle444
//
//  Created by 01587913 on 20.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import MultipeerConnectivity    

class ViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    var monoGameButton = UIButton()
    var wifiGameButton = UIButton()
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.mpcHandler.setupPeer(displayName: UIDevice.current.name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.setupBrowser()
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
        placeButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        monoGameButton.translatesAutoresizingMaskIntoConstraints = false
        monoGameButton.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
        monoGameButton.widthAnchor.constraint(equalToConstant: buttonsWidth).isActive = true
        monoGameButton.center.x = view.center.x
        
        wifiGameButton.frame = CGRect(x: 0, y: CGFloat(view.center.y + 50), width: buttonsWidth, height: buttonsHeight)
        wifiGameButton.translatesAutoresizingMaskIntoConstraints = false
        wifiGameButton.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
        wifiGameButton.widthAnchor.constraint(equalToConstant: buttonsWidth).isActive = true
        wifiGameButton.center.x = view.center.x

    
    }
    
    @objc func monoGamePressed(){
        self.navigationController?.pushViewController(MonoGameViewController(), animated: true)
    }

    @objc func wifiGamePressed(){
        self.navigationController?.pushViewController(WiFiGameViewController(), animated: true)
    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
}
