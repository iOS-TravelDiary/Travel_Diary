//
//  RegisterCheckViewController.swift
//  TravelDiary
//
//  Created by 정채운 on 2020/07/10.
//  Copyright © 2020 정채운. All rights reserved.
//

import UIKit

class RegisterCheckViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func swipeBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sub1ButtonPressed(_ sender: Any) {
        count += 1
        if(count >= 2){
            nextButton.isEnabled = true
        }
    }
    
    @IBAction func sub2ButtonPressed(_ sender: Any) {
        count += 1
        if(count >= 2){
            nextButton.isEnabled = true
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as? SecondViewController
        vc!.screenType = "Unavailable"
        
        self.navigationController?.pushViewController(vc!, animated: true)
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
