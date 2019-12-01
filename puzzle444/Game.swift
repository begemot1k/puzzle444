//
//  Game.swift
//  puzzle444
//
//  Created by 01587913 on 01.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit

class Game: NSObject {
    var activePlayer: String!
    var isGameOver: Bool!
    var dots: Array<String>!
    
    override init(){
        super.init()
        self.reset()
    }
    
    func reset(){
        activePlayer = "x"
        isGameOver = false
        dots = Array(repeating: " ", count: 64)
    }
    
    func isValidMove(dotName: String)->Bool{
        print("проверяем валидность \(dotName)")
        if dotName.count != 3 {
            return false
        }
        let array = dotName.map { $0 }
        guard let x = array[0].wholeNumberValue else { return false }
        guard let y = array[1].wholeNumberValue else { return false }
        guard let z = array[2].wholeNumberValue else { return false }
        if x >= 0 && x <= 3 && y >= 0 && y <= 3 && z >= 0 && z <= 3 {
            return dots[ x + y * 4 + z * 16] == " "
        }
        return false
    }
    
    func pressed(dotName: String)->Bool{
        if isGameOver {
            print("game over")
            return false
        }
        
        if isValidMove(dotName: dotName) {
            let array = dotName.map { $0 }
            guard let x = array[0].wholeNumberValue else { return false }
            guard let y = array[1].wholeNumberValue else { return false }
            guard let z = array[2].wholeNumberValue else { return false }
            print("метим точку \(x) \(y) \(z) за игроком \(activePlayer ?? "")")
            dots[ x + y * 4 + z * 16] = activePlayer
            activePlayer = activePlayer == "x" ? "o" : "x"
            checkGameOver()
            return true
        } else {
            return false
        }
        
    }
    
    func checkGameOver(){
        print("проверяем выигрыш")
        checkGameOver(player: "x")
        checkGameOver(player: "o")
    }
    
    func checkGameOver(player: String){
        var winx="", winy="", winz=""
        let winPositions = [
            "!!!!                                                            ",
            "    !!!!                                                        ",
            "        !!!!                                                    ",
            "            !!!!                                                ",
            "                !!!!                                            ",
            "                    !!!!                                        ",
            "                        !!!!                                    ",
            "                            !!!!                                ",
            "                                !!!!                            ",
            "                                    !!!!                        ",
            "                                        !!!!                    ",
            "                                            !!!!                ",
            "                                                !!!!            ",
            "                                                    !!!!        ",
            "                                                        !!!!    ",
            "                                                            !!!!",
            "!   !   !   !                                                   ",
            " !   !   !   !                                                  ",
            "  !   !   !   !                                                 ",
            "   !   !   !   !                                                ",
            "                !   !   !   !                                   ",
            "                 !   !   !   !                                  ",
            "                  !   !   !   !                                 ",
            "                   !   !   !   !                                ",
            "                                !   !   !   !                   ",
            "                                 !   !   !   !                  ",
            "                                  !   !   !   !                 ",
            "                                   !   !   !   !                ",
            "                                                !   !   !   !   ",
            "                                                 !   !   !   !  ",
            "                                                  !   !   !   ! ",
            "                                                   !   !   !   !",
            "!               !               !               !               ",
            " !               !               !               !              ",
            "  !               !               !               !             ",
            "   !               !               !               !            ",
            "    !               !               !               !           ",
            "     !               !               !               !          ",
            "      !               !               !               !         ",
            "       !               !               !               !        ",
            "        !               !               !               !       ",
            "         !               !               !               !      ",
            "          !               !               !               !     ",
            "           !               !               !               !    ",
            "            !               !               !               !   ",
            "             !               !               !               !  ",
            "              !               !               !               ! ",
            "               !               !               !               !",
            "!    !    !    !                                                ",
            "                !    !    !    !                                ",
            "                                !    !    !    !                ",
            "                                                !    !    !    !",
            "   !  !  !  !                                                   ",
            "                   !  !  !  !                                   ",
            "                                   !  !  !  !                   ",
            "                                                   !  !  !  !   ",
            "!                   !                   !                   !   ",
            " !                   !                   !                   !  ",
            "  !                   !                   !                   ! ",
            "   !                   !                   !                   !",
            "            !           !           !           !               ",
            "             !           !           !           !              ",
            "              !           !           !           !             ",
            "               !           !           !           !            ",
            "!                !                !                !            ",
            "    !                !                !                !        ",
            "        !                !                !                !    ",
            "            !                !                !                !",
            "   !              !              !              !               ",
            "       !              !              !              !           ",
            "           !              !              !              !       ",
            "               !              !              !              !   ",
            "!                    !                    !                    !",
            "   !                  !                  !                  !   ",
            "            !            !            !            !            ",
            "               !          !          !          !               "
        ]
        for mask in winPositions {
            if checkDotsByMask(mask: mask, player: player){
                isGameOver = true
                return
            }
        }
        
    }
    
    func coordinatesToIndex(x: Int, y: Int, z: Int)->Int{
        return x+y*4+z*16;
    }
    
    func checkDotsByMask(mask: String, player: String)->Bool{
        let array = mask.map{$0}
        var result = true
        for index in 0...array.count-1 {
            if array[index]=="!" {
                result = result  && dots[index]==player
            }
        }
        return result
    }
}
