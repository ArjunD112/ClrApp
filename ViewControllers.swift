//
//  ViewController.swift
//  clr.
//
//  Created by Arjun Dalwadi on 10/10/22.
//

import UIKit

let calendar = Calendar.current

var user: User = User()
let userData = UserDefaults.standard
var pin = userData.string(forKey: "Pin")
var dailyPuffs: [Int] = userData.object(forKey: "DailyPuffsArray") as! [Int]
var dailyPuffsEdit = userData.object(forKey: "EditableDPArray") as! [Int]
var day: Int { calendar.dateComponents([.day], from: (userData.object(forKey: "StartDate") as! Date), to: Date()).day! }


class LogInVC: UIViewController {
    
    
    @IBOutlet weak var enterPin: UITextField!
    @IBOutlet weak var incorrectPin: UILabel!
    
    @IBAction func enterButton_Tapped(_ sender: UIButton) {
        
        incorrectPin.isHidden = true
        
        if enterPin.text! == pin {
            
            if day >= dailyPuffs.count {
                performSegue(withIdentifier: "S_LogIn_EndScreen", sender: self)
            }
            else {
                performSegue(withIdentifier: "S_LogIn_MainScreen", sender: self)
            }
            
        }

        else if !(enterPin.text! == pin) { incorrectPin.isHidden = false }
        else {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectPin.isHidden = true
        self.hideKeyboard()
    }
}

class CreatePinVC: UIViewController {

    
    @IBOutlet weak var newPin: UITextField!
    @IBOutlet weak var confirmPin: UITextField!
    @IBOutlet weak var pinsNotMatch: UILabel!
    
    @IBAction func nextButton_Tapped(_ sender: Any) {
        
        pinsNotMatch.isHidden = true
        
        if newPin.text! == "" { }
        else if newPin.text! == confirmPin.text! {
            
            user.setPin(newPin.text!)
            performSegue(withIdentifier: "S_CreatePin_UserDataInput", sender: self)
        }
        else if !(newPin.text! == confirmPin.text!) {
            pinsNotMatch.isHidden = false;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinsNotMatch.isHidden = true
        self.hideKeyboard()
    }
}

class UserDataInputVC: UIViewController {
    
    
    @IBOutlet weak var goalConsRate: UITextField!
    @IBOutlet weak var goalNumDays: UITextField!
    @IBOutlet weak var numPodsPerDay: UITextField!
    
    
    @IBOutlet weak var invalidNPD: UILabel!
    @IBOutlet weak var invalidGCR: UILabel!
    @IBOutlet weak var invalidGND: UILabel!

    @IBAction func nextButton_Tapped(_ sender: UIButton) {
        
        invalidNPD.isHidden = true
        invalidGCR.isHidden = true
        invalidGND.isHidden = true
        
        if Double(numPodsPerDay.text!)! == 0.0 {
            invalidNPD.isHidden = false
        }
        else if Double(goalConsRate.text!)! >= Double(numPodsPerDay.text!)! {
            invalidGCR.isHidden = false
        }
        else if Double(goalNumDays.text!)! == 0.0 {
            invalidGND.isHidden = false
        }
        else {
            user.setData(ir: Double(numPodsPerDay.text!)!, er: Double(goalConsRate.text!)!, nd: Double(goalNumDays.text!)!)
            userData.set(user.dailyPuffs, forKey: "DailyPuffsArray")
            performSegue(withIdentifier: "S_UserDataInput_MainScreen", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidNPD.isHidden = true
        invalidGCR.isHidden = true
        invalidGND.isHidden = true
        self.hideKeyboard()
    }
}

class MainScreenVC: UIViewController {
    
    @IBOutlet weak var progressBar: CircularProgressView!
    @IBOutlet weak var puffButton: UIButton!
    @IBOutlet weak var numDay: UILabel!
    @IBOutlet weak var numPuffs: UILabel!
    @IBOutlet weak var statusMessage: UILabel!
    
    @IBAction func puffButton_Tapped(_ sender: UIButton) {
        
        let p = dailyPuffsEdit[day]
        
        switch p {
            
        case _ where p > 1:
            
            dailyPuffsEdit[day] = dailyPuffsEdit[day] - 1
            userData.set(dailyPuffsEdit, forKey: "EditableDPArray")
            progressBar.setProgressWithAnimation(duration: 0.5, value: Float(dailyPuffsEdit[day])/Float(dailyPuffs[day]))
            numPuffs.text = String(dailyPuffsEdit[day])
            
        case _ where p == 1:
            
            dailyPuffsEdit[day] = dailyPuffsEdit[day] - 1
            userData.set(dailyPuffsEdit, forKey: "EditableDPArray")
            progressBar.setProgressWithAnimation(duration: 0.5, value: Float(dailyPuffsEdit[day])/Float(dailyPuffs[day]))
            numPuffs.text = String(dailyPuffsEdit[day])
            statusMessage.text = "no puffs remaining"
            
        case _ where p < 1:
            
            progressBar.setProgressWithAnimation(duration: 0.5, value: Float(dailyPuffsEdit[day])/Float(dailyPuffs[day]))
            numPuffs.text = String(dailyPuffsEdit[day])
            statusMessage.text = "no puffs remaining"
            
        default:
            fatalError("how bruh")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dailyPuffsEdit[day] <= 0 {
            statusMessage.text = "no puffs remaining"
        }
        else {
            statusMessage.text = "tap the circle to log a puff"
        }
        
        numPuffs.text = String(dailyPuffsEdit[day])
        numDay.text = String(day + 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        progressBar.trackClr = UIColor.clear
        progressBar.progressClr = UIColor(hex: 0xA1CBF2)
        progressBar.setProgressWithAnimation(duration: 1.0, value: Float(dailyPuffsEdit[day])/Float(dailyPuffs[day]))
    }
        
}

class VerifyPinVC: UIViewController {
    
    @IBOutlet weak var verifyPin: UITextField!
    @IBOutlet weak var wrongPin: UILabel!
    
    
    @IBAction func enterButton_Tapped(_ sender: UIButton) {
        
        wrongPin.isHidden = true
        
        if verifyPin.text! == pin {
            performSegue(withIdentifier: "S_VerifyPin_ChangePin", sender: self)
        }
        else if !(verifyPin.text! == pin) {
            wrongPin.isHidden = false
        }
        else {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wrongPin.isHidden = true
        self.hideKeyboard()
    }
}

class ChangePinVC: UIViewController {
    
    
    @IBOutlet weak var newPin: UITextField!
    @IBOutlet weak var confirmPin: UITextField!
    @IBOutlet weak var pinsMustMatch: UILabel!
    
    @IBAction func changePinButton_Tapped(_ sender: UIButton) {
        
        pinsMustMatch.isHidden = true
        
        if newPin.text! == "" { }
        else if newPin.text! == pin {
            pinsMustMatch.text = "new pin can't equal old pin"
            pinsMustMatch.isHidden = false
        }
        else if !(newPin.text! == confirmPin.text!) {
            pinsMustMatch.text = "pins must match"
            pinsMustMatch.isHidden = false
        }
        else if newPin.text! == confirmPin.text! {
            user.setPin(newPin.text!)
            pin = userData.string(forKey: "Pin")
            performSegue(withIdentifier: "S_changePin_MainScreen", sender: self)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinsMustMatch.isHidden = true
        self.hideKeyboard()
    }
}

// CircularProgressView class written by Smita Kapse at
// https://www.tutorialspoint.com/create-circular-progress-bar-in-ios
class CircularProgressView: UIView {
   var progressLyr = CAShapeLayer()
   var trackLyr = CAShapeLayer()
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      makeCircularPath()
   }
   var progressClr = UIColor.white {
      didSet {
         progressLyr.strokeColor = progressClr.cgColor
      }
   }
   var trackClr = UIColor.white {
      didSet {
         trackLyr.strokeColor = trackClr.cgColor
      }
   }
   func makeCircularPath() {
      self.backgroundColor = UIColor.clear
      self.layer.cornerRadius = self.frame.size.width/2
       let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(0.5 * Double.pi), endAngle: CGFloat(2.5 * Double.pi), clockwise: true)
      trackLyr.path = circlePath.cgPath
      trackLyr.fillColor = UIColor.clear.cgColor
      trackLyr.strokeColor = trackClr.cgColor
      trackLyr.lineWidth = 5.0
      trackLyr.strokeEnd = 1.0
      layer.addSublayer(trackLyr)
      progressLyr.path = circlePath.cgPath
      progressLyr.fillColor = UIColor.clear.cgColor
      progressLyr.strokeColor = progressClr.cgColor
      progressLyr.lineWidth = 10.0
      progressLyr.strokeEnd = 0.0
      layer.addSublayer(progressLyr)
   }
   func setProgressWithAnimation(duration: TimeInterval, value: Float) {
       
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.duration = duration
      animation.fromValue = 0
      animation.toValue = value
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
      progressLyr.strokeEnd = CGFloat(value)
      progressLyr.add(animation, forKey: "animateProgress")
   }
}

// UIViewController extension written by Esqarrouth at
// https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// UIColor extension written by Rudolf Adamkovič at
// https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values

extension UIColor {

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}



