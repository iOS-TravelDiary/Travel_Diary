//
//  SecondViewController.swift
//  TravelDiary
//
//  Created by 정채운 on 2020/07/09.
//  Copyright © 2020 정채운. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var idDataLabel: UITextField!
    @IBOutlet weak var pwDataLabel: UITextField!
    @IBOutlet weak var loginWarningLabel: UILabel!
    @IBOutlet weak var btn_box_Button: UIButton!
    
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    var screenType:String?
    
    var defaultViewHeight: CGFloat!
    var yOfTextField: CGFloat!
    
    var http : HttpToServer?
    var httpResult : String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWarningLabel.isHidden = true
        loginIndicator.stopAnimating()
        
        idDataLabel.placeholder = "Insert your ID"
        pwDataLabel.placeholder = "Insert your PW"
        
        idDataLabel.delegate = self
        pwDataLabel.delegate = self
        
        addKeyboardNotification()
        
        defaultViewHeight = self.view.frame.origin.y
        
        http = HttpToServer(viewType : "SecondView", SecondView: self)
    }
    
    @IBAction func swipeBack(_ sender: Any) {
        if(screenType! == "Available"){
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    @IBAction func btn_box(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print("\(sender.isSelected)")
    }
    
    @IBAction func signinButton(_ sender: UIButton) {
        loginWarningLabel.isHidden = false;
        
        if(idDataLabel.text == ""){
            loginWarningLabel.text = "Write your ID"
            return
        }else if(pwDataLabel.text == ""){
            loginWarningLabel.text = "Write your PW"
            return
        }
        print("1")
        
        loginWarningLabel.isHidden = true
        
        loginIndicator.startAnimating()
        
        http!.httpJson("POST", "/user/signin", userId : idDataLabel.text, userPw : pwDataLabel.text)
    }
    
    func endHttpJson(){
        DispatchQueue.main.async{
            if(self.httpResult == "200 OK"){
                if(self.btn_box_Button.isSelected){
                    UserDefaults.standard.set(self.idDataLabel.text!, forKey: "userId")
                    UserDefaults.standard.set(self.pwDataLabel.text!, forKey: "userPw")
                }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeScreenView")
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else{
                self.loginWarningLabel.text = "Wrong ID/PW"
                self.loginWarningLabel.isHidden = false;
            }
            self.httpResult = "1"
            self.loginIndicator.stopAnimating()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        yOfTextField = textField.frame.origin.y
    }
    
    private func addKeyboardNotification() {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
      )
      
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification,
        object: nil
      )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
        
        let min = self.view.frame.size.height - (keyboardHeight + 100)
        
        if(yOfTextField > min){
            self.view.frame.origin.y = defaultViewHeight - (yOfTextField - min)
        }
      }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = defaultViewHeight
    }
    
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
