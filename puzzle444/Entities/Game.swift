//
//  Game.swift
//  puzzle444
//
//  Created by 01587913 on 01.12.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit

protocol GameProtocol: class {
    var dots: Array<Player>! {set get}
    var isGameOver: Bool! { set get }
    var status: String! { set get }
    var moves: Array<String>! {set get}
    var activePlayer: Player! { set get }
    func reset()
    func isValidMove(dotName: String)->Bool
    func move(dotName: String)
}

class Game: GameProtocol {
    var activePlayer: Player!
    var isGameOver: Bool!
    var dots: Array<Player>!
    var status: String!
    var moves: Array<String>!
    
    init(){
        self.reset()
    }
    
    /// Сброс игры в начальное состояние
    func reset(){
        activePlayer = .blue
        isGameOver = false
        dots = Array(repeating: Player.free, count: 64)
        moves = Array()
        status = "Первый ход СИНИХ"
    }
    
    /// Проверка на допустимость хода, активна ли игра и не занята ли ячейка
    /// - Parameter dotName: координата ячейки в формате xyz
    func isValidMove(dotName: String)->Bool{
        guard !isGameOver else { return false }
        guard Game.coordToIndex(coord: dotName)>=0 else { return false }
        return dots[ Game.coordToIndex( coord: dotName ) ] == .free
    }
    
    /// Совершаем ход в ячейку
    /// - Parameter dotName: координата ячейки в которую совершается ход
    func move(dotName: String){
        guard isValidMove(dotName: dotName) else { return }
        dots[ Game.coordToIndex( coord: dotName ) ] = activePlayer
        moves.append(dotName)
        // меняем текущего игрока, обновляем статус, проверяем выигрыш
        if activePlayer == .blue {
            activePlayer = .red
            status = "Ход КРАСНЫХ"
        } else {
            activePlayer = .blue
            status = "Ход СИНИХ"
        }
        checkGameOver()
    }
    
    func undo(){
        guard !isGameOver else {return}
        guard moves.count>0 else {return}
        let lastMove = moves.removeLast()
        dots[ Game.coordToIndex(coord: lastMove) ] = .free
        // меняем текущего игрока, обновляем статус
        if activePlayer == .blue {
            activePlayer = .red
            status = "Ход КРАСНЫХ"
        } else {
            activePlayer = .blue
            status = "Ход СИНИХ"
        }
        isGameOver = false
    }
    
    /// Проверка на завершение игры по комбинациям и по заполнению всего игрового поля
    func checkGameOver(){
        // маски выигрышных позиций в массиве dots
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
            if checkDotsByMask(mask: mask, player: .blue){
                isGameOver = true
                status = "Игра окончена, победили СИНИЕ"
                return
            }
            if checkDotsByMask(mask: mask, player: .red){
                isGameOver = true
                status = "Игра окончена, победили КРАСНЫЕ"
                return
            }
        }
        if dots.firstIndex(of: .free) == nil  {
            isGameOver=true
            status = "Игра окончена, НИЧЬЯ"
        }
    }
    
    /// Возвращает индекс в массиве по координатам точки
    /// - Parameter coord: координаты ячейки в формате xyz
    static func coordToIndex(coord: String)->Int{
        if coord.count != 3 { return -1 }
        let array = coord.map { $0 }
        guard let x = array[0].wholeNumberValue else { return -1 }
        guard let y = array[1].wholeNumberValue else { return -1 }
        guard let z = array[2].wholeNumberValue else { return -1 }
        return x + y * 4 + z * 16
    }
    
    /// Проверка на соответствие ячеек в массиве заданной маске выигрышных позиций
    /// возвращает true если совпала хоть одна маска
    /// - Parameters:
    ///   - mask: маска выигрышных позиций
    ///   - player: игрок, чьи точки необходимо проверить
    func checkDotsByMask(mask: String, player: Player)->Bool{
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
