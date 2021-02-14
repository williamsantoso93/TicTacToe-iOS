//
//  ViewModel.swift
//  TicTacToe
//
//  Created by William Santoso on 12/02/21.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var inputs = [[Int]]()
    @Published var turn: Turn = .x
    @Published var status: Status = .playing
    @Published var turnLeft = 9
    @Published var isShowAlert = false
    
    init() {
        reset()
    }
    
    //MARK: - update view and input
    
    func reset() {
        inputs = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
//            [1, -1, 1],
//            [0, 1, -1],
//            [1, -1, -1]
        ]
        turnLeft = 9
        status = .playing
        turn = .x
        isShowAlert = false
    }
    
    func updateTurn(_ turn: Turn) -> Turn {
        turnLeft -= 1
        return turn == .x ? .o : .x
    }
    
    func updateInput(_ i: Int,_ j: Int) {
        if status == .playing {
            let input = inputs[i][j]
            
            if input == 0 {
                if turn == .x {
                    inputs[i][j] = 1
                } else {
                    inputs[i][j] = -1
                }
                
                turn = updateTurn(turn)
                
            }
            getWinner()
            
            if (status != .playing) && (status != .tie) {
                isShowAlert = true
            }
        }
    }
    
    func getWinner() {
        if inputs.count == 3 {
            status = checkAnswer(inputs)
        } else {
            print("input count error")
        }
    }
    
    
    //MARK: - check status
    func checkAnswer(_ rows: [[Int]]) -> Status {
        var cols = [[Int]]()
        var diags = [[Int]]()
        
        var diag = [Int]()
        for i in 0...2 {
            var col = [Int]()
            
            for j in 0...2 {
                col.append(rows[j][i])
                
                if i == j {
                    diag.append(rows[j][i])
                }
            }
            
            cols.append(col)
        }
        diags.append(diag)
        diag = [rows[0][2], rows[1][1], rows[2][0]]
        diags.append(diag)
        
        let rowValues = countValue(rows)
        let colValues = countValue(cols)
        let diagValues = countValue(diags)
        
        var statuses: [Status] = [Status]()
        
        statuses.append(checkStatus(rowValues))
        statuses.append(checkStatus(colValues))
        statuses.append(checkStatus(diagValues))
        
        var tempStatus: Status = .playing
        
        print(statuses)
        
        if turnLeft > 0 {
            for tempStatuses in statuses {
                if (tempStatuses != .playing) || (tempStatus != .tie) {
                    tempStatus = tempStatuses
                    break
                }
            }
        } else {
            for tempStatuses in statuses {
                if (tempStatuses != .playing) || (tempStatus != .tie) {
                    tempStatus = tempStatuses
                } else {
                    tempStatus = .tie
                    break
                }
            }
        }
        
        return tempStatus
    }

    func checkStatus(_ values: [Int]) -> Status {
        var tempStatus: Status = .playing
        
        for i in values {
            if i == 3 {
                tempStatus = .xWin
                break
            } else if i == -3 {
                tempStatus = .oWin
                break
            }
        }
        
        return tempStatus
    }

    func countValue(_ inputs: [[Int]]) -> [Int] {
        var values = [Int]()
        for input in inputs {
            var value = 0
            
            for i in input {
                value += i
            }
            
            values.append(value)
        }
        
        return values
    }
}
