//
//  RegistCheckSubViewController.swift
//  TravelDiary
//
//  Created by 정채운 on 2020/07/10.
//  Copyright © 2020 정채운. All rights reserved.
//

import UIKit
import WebKit

class RegistCheckSubViewController: UIViewController {

    @IBOutlet weak var subWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let localFilePath = Bundle.main.path(forResource: "Travel+Diary", ofType: "html")
                    else {
                          print("path is nil")
                          return
                          }
        let url = URL(fileURLWithPath: localFilePath)
        let request = URLRequest(url: url)
        subWebView?.load(request)
        
        // Do any additional setup after loading the view.
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
