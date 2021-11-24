//
//  ViewController.swift
//  Homework20Scoreboard
//
//  Created by 黃柏嘉 on 2021/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    //timeLabel
    @IBOutlet weak var buzzerLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    //teamTitle
    @IBOutlet weak var team1TitleTextView: UITextView!
    @IBOutlet weak var team2TitleTextView: UITextView!
    //winImage
    @IBOutlet weak var team1WinImage: UIImageView!
    @IBOutlet weak var team2WinImage: UIImageView!
    //Score
    @IBOutlet weak var team1ScoreLabel: UILabel!
    @IBOutlet weak var team2ScoreLabel: UILabel!
    //Fouls
    @IBOutlet weak var team1FoulsLabel: UILabel!
    @IBOutlet weak var team2FoulsLabel: UILabel!
    
    //timeButton
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    
    //variable
    var team1Score = 0
    var team2Score = 0
    var gameMinute = 10
    var gameSecond = 0
    var team1Fouls = 0
    var team2Fouls = 0
    var buzzerTimer:Timer?
    var shotClockSecond = 12
    var shotClockTimer:Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //進攻時間重新計時
    //每次按下進攻時間重新進攻時間
    
    @IBAction func restartShotClock(_ sender: UITapGestureRecognizer) {
        shotClockSecond = 12
        shotClockLabel.text = "\(shotClockSecond)"
    }
    
    
    //大錶開始
    //按下後大錶開始且進攻時間也開始，開始鍵失效以免誤觸，字體變白
    
    @IBAction func buzzerStart(_ sender: UIButton) {
        buzzerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        shotClockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(shotClockCountDown), userInfo: nil, repeats: true)
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        buzzerLabel.textColor = .white
    }
    
    //大錶暫停
    //按下後大錶和進攻時間暫停，開始鍵開啟，字體變紅色
    
    @IBAction func buzzerPause(_ sender: UIButton) {
        buzzerTimer?.invalidate()
        shotClockTimer?.invalidate()
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        buzzerLabel.textColor = .red
    }
    
    //比賽重新開始
    //按下後重新開始，使用下方function，將所有參數歸零
    
    @IBAction func restarGame(_ sender: UIButton) {
        endOfGame(winner: nil)
    }

    //兩隊分數增減
    //先判斷往左或往右滑動來決定增減，接下來使用寫好的function判定目前是哪支球隊得分以及滑動方向還有是否率先獲得21分
    
    @IBAction func team1Scoring(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left{
            team1Score += 1
            scoring(team: team1ScoreLabel, score: team1Score, direction: .left, winner:team1TitleTextView.text)
        }else if sender.direction == .right{
            team1Score -= 1
            if team1Score < 0{
                team1Score = 0
                scoring(team: team1ScoreLabel, score: team1Score, direction: .right, winner: team1TitleTextView.text)
            }else{
                scoring(team: team1ScoreLabel, score: team1Score, direction: .right, winner: team1TitleTextView.text)
            }
            
        }
    }
    @IBAction func team2Scoring(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left{
            team2Score += 1
            scoring(team: team2ScoreLabel, score: team2Score, direction: .left, winner:team2TitleTextView.text)
        }else if sender.direction == .right{
            team2Score -= 1
            if team2Score < 0{
                team2Score = 0
                scoring(team: team2ScoreLabel, score: team2Score, direction: .right, winner: team2TitleTextView.text)
            }else{
                scoring(team: team2ScoreLabel, score: team2Score, direction: .right, winner: team2TitleTextView.text)
            }
        }
    }
    
    
    //兩隊犯規次數
    //先判定左右滑動，然後判定犯規次數是否需要提醒使用者
    
    @IBAction func team1Fouls(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left{
            team1Fouls += 1
            team1FoulsLabel.text = "\(team1Fouls)"
            if team1Fouls >= 7{
                team1FoulsLabel.textColor = .red
            }else{
                team1FoulsLabel.textColor = .white
            }
        }else if sender.direction == .right{
            if team1Fouls == 0{
                return
            }else{
                team1Fouls -= 1
                team1FoulsLabel.text = "\(team1Fouls)"
                if team1Fouls >= 7{
                    team1FoulsLabel.textColor = .red
                }else{
                    team1FoulsLabel.textColor = .white
                }
            }
        }
    }
    @IBAction func team2Fouls(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left{
            team2Fouls += 1
            team2FoulsLabel.text = "\(team2Fouls)"
            if team2Fouls >= 7{
                team2FoulsLabel.textColor = .red
            }else{
                team2FoulsLabel.textColor = .white
            }
        }else if sender.direction == .right{
            if team2Fouls == 0{
               return
            }else{
                team2Fouls -= 1
                team2FoulsLabel.text = "\(team2Fouls)"
                if team2Fouls >= 7{
                    team2FoulsLabel.textColor = .red
                }else{
                    team2FoulsLabel.textColor = .white
                }
            }
        }
    }
    
    
    //判斷得分結果
    //輸入參數，得分隊伍，目前分數，方向，如果獲勝是誰獲勝，然後判斷比賽結束了嗎
    
    func scoring(team:UILabel,score:Int,direction:UISwipeGestureRecognizer.Direction,winner:String?){
        if direction == .left{
            if score == 21{
                endOfGame(winner: winner)
                team.text = "\(score)"
            }else{
                if score < 10{
                    team.text = "0\(score)"
                }else{
                    team.text = "\(score)"
                }
                shotClockSecond = 12
                shotClockLabel.text = "\(shotClockSecond)"
            }
        }else{
            if score == 0{
                team.text = "00"
            }else{
                if score < 10{
                    team.text = "0\(score)"
                }else{
                    team.text = "\(score)"
                }
            }
        }
    }
    //重設比賽或比賽結束
    //先將所有歸零後，再來判斷勝者是誰或是無勝者純粹重新開始
    
    func endOfGame(winner:String?){
        team1Score = 0
        team2Score = 0
        team1Fouls = 0
        team2Fouls = 0
        team1FoulsLabel.text = "\(team1Fouls)"
        team1FoulsLabel.textColor = .white
        team2FoulsLabel.text = "\(team2Fouls)"
        team2FoulsLabel.textColor = .white
        buzzerTimer?.invalidate()
        buzzerLabel.text = "10:00"
        buzzerLabel.textColor = .red
        shotClockTimer?.invalidate()
        shotClockSecond = 12
        shotClockLabel.text = "12"
        gameMinute = 10
        gameSecond = 0
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        if winner == team1TitleTextView.text{
            team1WinImage.isHidden = false
            team1TitleTextView.text = "Winner"
            team2TitleTextView.text = ""
        }else if winner == team2TitleTextView.text{
            team2WinImage.isHidden = false
            team1TitleTextView.text = ""
            team2TitleTextView.text = "Winner"
        }else{
            team1WinImage.isHidden = true
            team2WinImage.isHidden = true
            team1TitleTextView.text = "Team1"
            team2TitleTextView.text = "Team2"
            team1ScoreLabel.text = "00"
            team2ScoreLabel.text = "00"
        }
    }
    
    //大錶倒數計時
    
    @objc func countDown(){
        if gameSecond == 0{
            if gameMinute == 0{
                buzzerTimer?.invalidate()
                if team1Score > team2Score{
                    endOfGame(winner: team1TitleTextView.text)
                }else if team1Score < team2Score{
                    endOfGame(winner: team2TitleTextView.text)
                }else{
                    endOfGame(winner: nil)
                }
            }else{
                gameMinute -= 1
                gameSecond = 59
                if gameSecond < 10{
                    buzzerLabel.text = "0\(gameMinute):0\(gameSecond)"
                }else{
                    buzzerLabel.text = "0\(gameMinute):\(gameSecond)"
                }
            }
        }else{
            gameSecond -= 1
            if gameSecond < 10{
                buzzerLabel.text = "0\(gameMinute):0\(gameSecond)"
            }else{
                buzzerLabel.text = "0\(gameMinute):\(gameSecond)"
            }
        }
    }
    
    //進攻計時器
   
    @objc func shotClockCountDown(){
        shotClockSecond -= 1
        shotClockLabel.text = "\(shotClockSecond)"
        if shotClockSecond == 0 {
            shotClockTimer?.invalidate()
            buzzerTimer?.invalidate()
            startButton.isEnabled = true
            pauseButton.isEnabled = false
            shotClockSecond = 12
        }
    }

}

