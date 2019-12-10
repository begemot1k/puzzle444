//
//  ViewController.swift
//  puzzle444
//
//  Created by 01587913 on 20.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var monoGameButton = UIButton()
    var wifiGameButton = UIButton()
    var player: AVAudioPlayer!
    
    let soundTrackUrl = "http://157.245.165.84/Minecraft.mp3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        placeButtons()
        downloadSoundTrack(completion: { data, error in
            if let error = error {
                print("вернулась ошибка \(error)")
                return
            }
            DispatchQueue.main.async {
                self.playMusic(music: data!)
            }
        })
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
    
    func playMusic(music: Data){
        DispatchQueue.main.async {
            do {
                print("музыка \(music.count) bytes")
                self.player = try AVAudioPlayer(data: music)
                self.player.prepareToPlay()
                self.player.numberOfLoops = -1
                self.player.play()
                
                let audioSession = AVAudioSession.sharedInstance()
                do{
                    try audioSession.setCategory(.playback)
                }catch{
                    print("в фоне музыки, наверное, не будет")
                }
            }catch {
                print("музыки не будет")
            }
        }
    }
    
    func downloadSoundTrack(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: soundTrackUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let currentError = error {
                completion(nil, currentError)
                return
            }
            guard let soundTrack = data else { return }
            completion(soundTrack, nil)
        }
        task.resume()
    }
    
    @objc func monoGamePressed(){
        self.navigationController?.pushViewController(MonoGameViewController(), animated: true)
    }
    
    @objc func wifiGamePressed(){
        self.navigationController?.pushViewController(WiFiGameViewController(), animated: true)
    }
}
