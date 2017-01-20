//
//  ViewController.swift
//  SirHaxALot
//
//  Created by James Bruno on 1/12/17.
//  Copyright © 2017 James Bruno. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation


class HackthonViewController: UIViewController {
    
    @IBOutlet weak var womboProgress: UIProgressView!
    @IBOutlet weak var gameMessage: UILabel!
    @IBOutlet weak var hpProgressView: UIProgressView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var white: UIImageView!
    
    var delegate: UIViewController?
    
    var motionManager: CMMotionManager?
    var opQ = OperationQueue()
    var faceUp:Bool = false
    var acceleration = 0.0
    var yacceleration = 0.0
    var zacceleration = 0.0
    var chopping = false
    var zGrav = 0
    var wombo = 0
    var drag = 200.0
    var totHP:Float = 200.0
    var dmg = 5.0
    var bonus = 0
    var fulfilled = false
    var randSlash = 0
    var curAccel = 0.0
    var totDmg = 0.0
    var message = ""
    var time = 0
    var startTime = 20
    var gameOver = false
    func animateWhite(){
        self.white.alpha = 0.0
        print("FLASH FLASH FLASH")
    }
    var curCommand:Int = 0
    var curFunction = ""
    var swingSpeed = 0.0
    
    
    ////////////////////////////////////////////////////////////////////////
    //                                                                    //
    // MARK:     AUDIO SETUP                                              //
    //                                                                    //
    ////////////////////////////////////////////////////////////////////////
    
    var dragonTellLeft: AVAudioPlayer?
    
    func playDragonTellLeft() {
        print("Playing: dragonTellLeft")
        let sound = NSDataAsset(name: "dragonTellLeft")!
        
        do {
            dragonTellLeft = try AVAudioPlayer(data: sound.data)
            guard let player = dragonTellLeft else { return }
            
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    var dragonTellRight: AVAudioPlayer?
    
    func playDragonTellRight() {
        print("Playing: dragonTellRight")
        let sound = NSDataAsset(name: "dragonTellRight")!
        
        do {
            dragonTellRight = try AVAudioPlayer(data: sound.data)
            guard let player = dragonTellRight else { return }
            
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    var dragonTellCenter: AVAudioPlayer?
    
    func playDragonTellCenter() {
        print("Playing: dragonTellCenter")
        let sound = NSDataAsset(name: "dragonTellCenter")!
        
        do {
            dragonTellCenter = try AVAudioPlayer(data: sound.data)
            guard let player = dragonTellCenter else { return }
            
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    var playTell = [playDragonTellLeft, playDragonTellCenter, playDragonTellRight]
    
    var swordSlice: AVAudioPlayer?
    var slices = ["swordSlice1","swordSlice2","swordSlice3"]
    
    func playSlice() {
        print("Playing: Slice!")
        let sound = NSDataAsset(name: slices[randoNum()])!
        
        do {
            swordSlice = try AVAudioPlayer(data: sound.data)
            guard let player = swordSlice else { return }
            
            swordSlice!.volume = 0.6
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    var swordMiss: AVAudioPlayer?
    var misses = ["swordMiss1","swordMiss2","swordMiss3"]
    
    func playMiss() {
        print("Playing: Miss...")
        let sound = NSDataAsset(name: misses[randoNum()])!
        
        do {
            swordMiss = try AVAudioPlayer(data: sound.data)
            guard let player = swordMiss else { return }
            
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    var leftYelp: AVAudioPlayer?
    var leftYelps = ["dragonYelp1L","dragonYelp2L","dragonYelp3L"]
    
    func playLeftYelps() {
        print("Playing: LeftYelp")
        let sound = NSDataAsset(name: leftYelps[randoNum()])!
        
        do {
            leftYelp = try AVAudioPlayer(data: sound.data)
            guard let player = leftYelp else { return }
            
            leftYelp!.volume = 0.4
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    var rightYelp: AVAudioPlayer?
    var rightYelps = ["dragonYelp1R","dragonYelp2R","dragonYelp3R"]
    
    func playRightYelps() {
        print("Playing: RightYelp")
        let sound = NSDataAsset(name: rightYelps[randoNum()])!
        
        do {
            rightYelp = try AVAudioPlayer(data: sound.data)
            guard let player = rightYelp else { return }
            
            rightYelp!.volume = 0.4
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    var centerYelp: AVAudioPlayer?
    var centerYelps = ["dragonYelp1","dragonYelp2","dragonYelp3"]
    
    func playCenterYelps() {
        print("Playing: CenterYelp")
        let sound = NSDataAsset(name: centerYelps[randoNum()])!
        
        do {
            centerYelp = try AVAudioPlayer(data: sound.data)
            guard let player = centerYelp else { return }
            
            centerYelp!.volume = 0.4
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    var dragonFlap: AVAudioPlayer?
    
    func playDragonFlap() {
        if gameOver == false{
            print("Playing: dragonTellCenter")
            let sound = NSDataAsset(name: "dragonFlap")!
            
            do {
                dragonFlap = try AVAudioPlayer(data: sound.data)
                guard let player = dragonFlap else { return }
                
                dragonFlap!.volume = 1.0
                dragonFlap!.numberOfLoops = -1
                dragonFlap!.pan = ((Float(self.command)-1.0) * -1.0)
                print("Playing Dragon Flap!", dragonFlap!.pan)
                player.prepareToPlay()
                player.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
        
    }
    
    var dragonDeath: AVAudioPlayer?
    
    func playDragonDeath() {
        print("Playing: dragonTellCenter")
        let sound = NSDataAsset(name: "dragonDeath")!
        
        do {
            dragonDeath = try AVAudioPlayer(data: sound.data)
            guard let player = dragonDeath else { return }
            
            print("Playing Dragon Death!")
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////
    //                                                                    //
    //      REPLAY                                                        //
    //                                                                    //
    ////////////////////////////////////////////////////////////////////////
    @IBAction func replay(_ sender: Any) {
        self.drag = Double(totHP)
        self.wombo = 0
        self.womboProgress.setProgress(Float(self.wombo)/10, animated: true)
        self.message = ""
        self.gameMessage.text! = ""
        self.hpProgressView.setProgress(Float(self.drag)/totHP, animated: false)
        self.time = startTime
        self.command = self.randoNum()
        moveDierdre()
        gameOver = false
        clearLog()
    }
    
    func randoNum () -> Int {
        return Int(arc4random_uniform(3))
    }
    
    func randoSlashNum () -> Int {
        return Int(arc4random_uniform(5)+1)
    }
    
    var command = 0
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////
    //                                                                    //
    //      MODULARIZATION                                                //
    //                                                                    //
    ////////////////////////////////////////////////////////////////////////
    func clearLog(){
        for _ in 0...61{
            print("-_")
        }
    }
    func flashWhite(){
        OperationQueue.main.addOperation {
            self.white.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.animateWhite()
            }, completion: nil)
            self.white.isHidden = true
            self.white.alpha = 1.0
        }
    }
    
    func womboCombo(){
        drag -= 10.0
        wombo = 0
    }
    
    func womboCheck(){
        if wombo == 10 {
            womboCombo()
        }
    }
    
    
    func isDierdreDead(){
        if drag <= 0.0{
            print("u did it!")
            drag = 0.0
            message = "U did it"
            gameOver = true
            dragonFlap!.stop()
            playDragonDeath()
        }
    }
    
    func runDiagnostics( function:String ){
        print("Starting Diagnostics From..." , function )
        print("swingSpeed: ", swingSpeed)
        print("drag hp: ", drag)
        print("Total Damage: ", totDmg)
        print("wombo : ", wombo)
        print("Current Command",self.command)
        print("Finishing Diagnostics From..." , function )
    }
    
    func updateHUD(){
        OperationQueue.main.addOperation{
            self.womboProgress.setProgress(Float(self.wombo)/10, animated: true)
            self.gameMessage.text! = self.message
            self.hpProgressView.setProgress(Float(self.drag)/self.totHP, animated: true)
            print("hp",self.hpProgressView.progress)
        }
    }
    
    func successfulChop(){
        print("$$$$$$$$$$$$$$$$$$$$$$ Correct! $$$$$$$$$$$$$$$$$$$$$$")
        flashWhite()
        randSlash -= 1
        wombo += 1
        totDmg = dmg * Double(swingSpeed / -2.5)
        drag -= totDmg
        womboCheck()
        isDierdreDead()
        updateHUD()
        runDiagnostics(function: "SuccessfulChop")
        playSlice()
    }
    
    func unsuccessfulChop(){
        print("++++++++++++++++++++++ Wrong... ++++++++++++++++++++++")
        //        playMiss()
        wombo = 0
    }
    
    func moveDierdre(){
        if self.command == 0{
            playDragonTellRight()
        }else if self.command == 1{
            playDragonTellCenter()
        }else{
            playDragonTellLeft()
        }
        playDragonFlap()
    }
    
    func willDierdreMove(){
        if randSlash < 1{
            self.command = self.randoNum()
            self.randSlash = self.randoSlashNum()
            while self.command == curCommand{
                self.command = self.randoNum()
            }
            moveDierdre()
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    //                                                                    //
    //  MARK:    START CHOP                                               //
    //                                                                    //
    ////////////////////////////////////////////////////////////////////////
    
    func chopChop(){
        chopping = true
        if curAccel < -5.0 && self.yacceleration > 0{
            playMiss()
            print("Start Chop..........................................")
            swingSpeed = curAccel
            curAccel = 0
            runDiagnostics(function: "StartChop")
            stopChop()
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    //                                                                    //
    // MARK:     STOP CHOP                                                //
    //                                                                    //
    ////////////////////////////////////////////////////////////////////////
    
    func stopChop(){
        //        if self.acceleration > -5.0 && chopping == true {
        //        if chopping == true{
        chopping = false
        //Check for left chop
        if self.zGrav < -40 && self.zGrav > -57 {
            if command == 2{
                curCommand = 2
                successfulChop()
                playLeftYelps()
                runDiagnostics(function: "stopChop(left)")
                willDierdreMove()
            }else{
                unsuccessfulChop()
                runDiagnostics(function: "stopChop(unsuccessfull)")
            }
        }else if self.zGrav > 40 && self.zGrav < 57 {
            //Check for right chop
            if command == 0{
                curCommand = 0
                successfulChop()
                playRightYelps()
                runDiagnostics(function: "stopChop(right)")
                willDierdreMove()
                
            }else{
                unsuccessfulChop()
                runDiagnostics(function: "stopChop(unsuccessful)")
            }
        }else if self.zGrav > -39 && self.zGrav < 39 {
            //Check for center chop
            if command == 1{
                curCommand = 1
                successfulChop()
                playCenterYelps()
                runDiagnostics(function: "stopChop(center)")
                willDierdreMove()
            }else{
                unsuccessfulChop()
                runDiagnostics(function: "stopChop(unsuccessful)")
            }
        }
        //        }
    }
    
    
    
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            print("WE ARE IN ADD OPERATION")
            self.dragonFlap?.stop()
            self.dragonFlap?.stop()
            self.dragonFlap?.stop()
            self.dragonFlap?.numberOfLoops = 0
        }
        
        super.viewDidLoad()
        self.time = startTime
        white.isHidden = true
        self.command = randoNum()
        moveDierdre()
        runDiagnostics(function: "viewDidLoad")
        
        //SETTING UP HUD/UI VIEWS
        self.hpProgressView.progressTintColor = UIColor(red:0.44, green:0.63, blue:0.60, alpha:1.0)
        self.womboProgress.progressTintColor = UIColor(red:0.26, green:0.49, blue:0.56, alpha:1.0)
        self.randSlash = self.randoSlashNum()
        self.womboProgress.setProgress(Float(self.wombo)/10, animated: true)
        self.hpProgressView.setProgress(Float(self.drag)/totHP, animated: false)
        var _ = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        ////////////////////////////////////////////////////////////////////////
        //                                                                    //
        //      MOTION MANAGER                                                //
        //                                                                    //
        ////////////////////////////////////////////////////////////////////////
        motionManager = CMMotionManager()
        if let manager = motionManager{
            print("Yes CMMotion")
            let queue = OperationQueue()
            manager.startDeviceMotionUpdates(to: queue, withHandler: {
                (data, error)->Void in
                manager.deviceMotionUpdateInterval = 0.03;
                //                print("Grav Z:", (Int((180/Double.pi)*data!.gravity.z)) , "Grav X:", (Int((180/Double.pi)*data!.gravity.x)) , "Grav Y:", (Int((180/Double.pi)*data!.gravity.y)));
                //                print("x-Accell: ", data!.userAcceleration.x)
                self.zGrav = Int((180/Double.pi)*data!.gravity.z)
                self.acceleration = Double(data!.userAcceleration.x)
                self.yacceleration = Double(data!.userAcceleration.y)
                self.zacceleration = Double(data!.userAcceleration.z)
                
                
                
                //Start/stop chop
                
                if self.acceleration < -5.0 && self.chopping == false && self.drag > 0 && self.time > 0{
                    self.curAccel = self.acceleration
                    self.chopChop()
                }
                if self.chopping == true && self.drag > 0 && self.time > 0{
                    self.stopChop()
                }
                
                
                
                if self.drag <= 0.0 && self.gameOver == false{
                    print("u did it!")
                    self.drag = 0.0
                    self.message = "U did it"
                    self.gameOver = true
                    self.dragonFlap!.stop()
                    self.playDragonDeath()
                    DispatchQueue.main.async{
                        self.womboProgress.setProgress(Float(self.wombo)/10, animated: true)
                        self.gameMessage.text! = self.message
                        self.hpProgressView.setProgress(Float(self.drag)/self.totHP, animated: true)
                        print("hp",self.hpProgressView.progress)
                    }
                    
                }
                
            });
            
        }
        else{
            print("No motion")
        }
    }
    
    func update(){
        if self.time > 0 && self.drag > 0{
            self.time -= 1
            if(self.drag > 0 && self.time/60 == 0){
                if self.time >= 10{
                    self.timerLabel.text! = "00:"+String(self.time)
                }
                else{
                    self.timerLabel.text! = "00:"+"0"+String(self.time)
                }
            }
            else if (self.time/60 > 0){
                let min = self.time/60
                let sec = self.time-min*60
                if sec >= 10{
                    self.timerLabel.text! = String(Int(min))+":"+String(Int(sec))
                }
                else{
                    self.timerLabel.text! = String(Int(min))+":"+"0"+String(Int(sec))
                }
                if min < 10{
                    self.timerLabel.text! = "0"+self.timerLabel.text!
                }
            }
        }
        else if self.drag > 0{
            self.timerLabel.text! = "00:00"
            self.gameMessage.text! = "U lost"
            dragonFlap!.stop()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

