//
//  ViewController.swift
//  TravelDiary
//
//  Created by 정채운 on 2020/07/09.
//  Copyright © 2020 정채운. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var userId : String?
    var userPw : String?
    var httpResult : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var http = HttpToServer(viewType : "View", View : self)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if let userId = UserDefaults.standard.string(forKey: "userId"){
            self.userId = userId
            self.userPw = UserDefaults.standard.string(forKey: "userPw")!
            print("Auto Login")
            
            http.httpJson("POST", "/user/signin", userId : self.userId, userPw : self.userPw)
        }
        // Do any additional setup after loading the view.
    }
    
    func endHttpJson(){
        DispatchQueue.main.async{
            if(self.httpResult == "200 OK"){
                print("Hello")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeScreenView")
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as? SecondViewController
        vc!.screenType = "Available"
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

