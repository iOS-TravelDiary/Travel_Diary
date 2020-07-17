//
//  ThirdViewController.swift
//  TravelDiary
//
//  Created by 정채운 on 2020/07/10.
//  Copyright © 2020 정채운. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var idCheckLabel: UILabel!
    @IBOutlet weak var pwCheckLabel: UILabel!
    @IBOutlet weak var pwWrongLabel: UILabel!
    
    @IBOutlet weak var idDataLabel: UITextField!
    @IBOutlet weak var pwDataLabel: UITextField!
    @IBOutlet weak var pwConfirmDataLabel: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var nameDataLabel: UITextField!
    @IBOutlet weak var birthDataLabel: UITextField!
    @IBOutlet weak var phoneDataLabel: UITextField!
    
    var checkTextField: [Int] = [0, 0, 0]
    
    var defaultViewHeight: CGFloat!
    var yOfTextField: CGFloat!
    
    //var http : HttpToServer = HttpToServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idCheckLabel.isHidden = true
        pwCheckLabel.isHidden = true
        pwWrongLabel.isHidden = true
        
        nameDataLabel.placeholder = "Insert your Name"
        birthDataLabel.placeholder = "Insert your birth"
        idDataLabel.placeholder = "Insert your E-mail"
        phoneDataLabel.placeholder = "Insert your phone"
        pwDataLabel.placeholder = "Insert your PW"
        pwConfirmDataLabel.placeholder = "Check you PW"
        
        signUpButton.isEnabled = false
        
        idDataLabel.delegate = self
        pwDataLabel.delegate = self
        pwConfirmDataLabel.delegate = self
        
        nameDataLabel.delegate = self
        birthDataLabel.delegate = self
        phoneDataLabel.delegate = self
        
        addKeyboardNotification()
        
        defaultViewHeight = self.view.frame.origin.y
        
        // Do any additional setup after loading the view.
        
    }
    @IBAction func swipeBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    

    @IBAction func signUpButton(_ sender: Any) {
        //http.httpJson("POST", "/user/signup", userName : nameDataLabel.text, userId: idDataLabel.text, userPw: pwDataLabel.text,userPhoneNum: phoneDataLabel.text, userBirth: birthDataLabel.text)
        
        //if(http.httpJson("POST", "/user/signup/certi", userPhoneNum: phoneDataLabel.text) == "Success"){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "registerCheckView")
            self.navigationController?.pushViewController(vc!, animated: true)
        //}
        
//        let vc = SMSCertiViewController()
//        self.navigationController?.present(vc, animated: true, completion: nil)
        

    }
    
    @IBAction func idTextChanged(_ sender: Any) {
        if(!isValidID()){
            idCheckLabel.isHidden = false
            idCheckLabel.text = "ID again"
            signUpButton.isEnabled = false
            checkTextField[0] = 0
            return
        }
        checkTextField[0] = 1;
        idCheckLabel.isHidden = true
    
        if(checkTextField[0] == 1 && checkTextField[1] == 1 && checkTextField[2] == 1 && nameDataLabel.text != "" && phoneDataLabel.text != ""){
            signUpButton.isEnabled = true
        }
    }
    
    @IBAction func pwTextChanged(_ sender: Any) {
        if(pwDataLabel.text != pwConfirmDataLabel.text){
            pwWrongLabel.isHidden = false
            pwWrongLabel.text = "PW Confirm again"
        }
        if(!isValidPassword()){
            pwCheckLabel.isHidden = false
            pwCheckLabel.text = "PW again"
            signUpButton.isEnabled = false
            checkTextField[1] = 0
            return
        }
        checkTextField[1] = 1
        pwCheckLabel.isHidden = true
        
        if(pwDataLabel.text == pwConfirmDataLabel.text){
            checkTextField[2] = 1
            pwWrongLabel.isHidden = true
        }
        if(checkTextField[0] == 1 && checkTextField[1] == 1 && checkTextField[2] == 1 && nameDataLabel.text != "" && phoneDataLabel.text != ""){
            signUpButton.isEnabled = true
        }
    }
    
    @IBAction func pwConfirmTextChanged(_ sender: Any) {
        if(pwDataLabel.text != pwConfirmDataLabel.text){
            pwWrongLabel.isHidden = false
            pwWrongLabel.text = "PW Confirm again"
            signUpButton.isEnabled = false;
            checkTextField[2] = 0
            return
        }
        checkTextField[2] = 1
        pwWrongLabel.isHidden = true
        
        if(checkTextField[0] == 1 && checkTextField[1] == 1 && checkTextField[2] == 1 && nameDataLabel.text != "" && phoneDataLabel.text != ""){
            signUpButton.isEnabled = true
        }
    }
    
    public func isValidPassword() -> Bool {
        let pwReg = "^.*(?=^.{8,15}$)(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$"
        let pwMatch = NSPredicate(format:"SELF MATCHES %@", pwReg)

        return pwMatch.evaluate(with: pwDataLabel.text)
    }
    
    public func isValidID() -> Bool {
        let idReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let idMatch = NSPredicate(format:"SELF MATCHES %@", idReg)
        
        return idMatch.evaluate(with: idDataLabel.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        yOfTextField = textField.frame.origin.y
        
        print("\(textField.frame.origin.y)")
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
        print("min is \(min)")
        
        if(yOfTextField > min){
            print("Hello")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
