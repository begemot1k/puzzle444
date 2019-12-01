//
//  WiFiGameViewController.swift
//  puzzle444
//
//  Created by 01587913 on 24.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import GameKit

class WiFiGameViewController: UIViewController {
    
    let mainMenuButton = UIButton()
    let resetGameButton = UIButton()
    let scene = SCNView()
    
    let dots = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        mainMenuButton.setTitle("Меню", for: .normal)
        mainMenuButton.setTitleColor(.blue, for: .normal)
        mainMenuButton.addTarget(self, action: #selector(mainMenuPressed), for: .touchUpInside)
        view.addSubview(mainMenuButton)
        resetGameButton.setTitle("Сброс", for: .normal)
        resetGameButton.setTitleColor(.red, for: .normal)
        resetGameButton.addTarget(self, action: #selector(resetGamePressed), for: .touchUpInside)
        view.addSubview(resetGameButton)
        
        scene.backgroundColor = .black
        scene.scene = PrimitivesScene()
//        scene.scene.delegate = self
        scene.allowsCameraControl = true
        scene.autoenablesDefaultLighting = true
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(handleTap))
        scene.addGestureRecognizer(tapGesture)
        view.addSubview(scene)
        placeButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        placeButtons()
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer){
        
        // check what nodes are tapped
        let p = gestureRecognizer.location(in: scene)
        let hitResults = scene.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: SCNHitTestResult = hitResults[0]
            
            print(result.node.name ?? "")
            //   print(result.textureCoordinates(withMappingChannel: 0)) // This line is added here.
            print("x: \(p.x) y: \(p.y)") // <--- THIS IS WHERE I PRINT THE COORDINATES
            
            
        }
    }
    
    func placeButtons(){
        let buttonsWidth = 150
        let topMargin = UIScreen.main.bounds.width>UIScreen.main.bounds.height ? 10 : 50
        mainMenuButton.frame = CGRect(x: 10, y: topMargin, width: buttonsWidth, height: 30)
        resetGameButton.frame = CGRect(x: Int(view.frame.width) - buttonsWidth - 10, y: topMargin, width: buttonsWidth, height: 30)
        scene.frame = CGRect(x: 0, y: topMargin+30, width: Int(view.frame.width), height: Int(view.frame.height)-topMargin-30)
    }
    
    @objc func mainMenuPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func resetGamePressed(){
        print("reset fired. user Alias is \(GKLocalPlayer().alias)")
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
