import UIKit

class HttpToServer {
    
    private var userName : String?
    private var userId : String?
    private var userPw : String?
    private var userPhoneNum : String?
    private var userBirth : String?
    
    private let serverUrl : String = "http://ec2-3-22-168-34.us-east-2.compute.amazonaws.com:8080"
    private var resourceUrl : URL?
    private var resultOfHttp : String?
    
    var vc : ViewController?
    var svc : SecondViewController?
    var viewType : String?
    
    init(viewType : String, View : ViewController = ViewController(),SecondView : SecondViewController = SecondViewController()){
        self.viewType = viewType
        
        if(viewType == "View"){
            self.vc = View
        }else if(viewType == "SecondView"){
            self.svc = SecondView
        }
    }
    
    func httpJson(_ method : String?, _ resource : String?, userName : String? = nil, userId : String? = nil, userPw : String? = nil, userPhoneNum : String? = nil, userBirth : String? = nil){        
        print("HTTP START")
        
        var request : URLRequest?
        var param : [String : String] = [:]
        
        if let resourceTmp = resource {
            resourceUrl = URL(string : serverUrl + resourceTmp)
            request = URLRequest(url: resourceUrl!)
        }else{
            print("Resource Empty")
            
            if(viewType == "SecondView"){
                self.svc!.httpResult = "Fail"
            }
            return
        }
        
        request!.httpMethod = method!
        request!.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch method! {
            case "POST" :
                if let userNameTmp = userName {
                    param.updateValue(userNameTmp, forKey: "userName")
                }
                if let userIdTmp = userId {
                    param.updateValue(userIdTmp, forKey: "userId")
                }
                if let userPwTmp = userPw {
                    param.updateValue(userPwTmp, forKey: "userPw")
                }
                if let userPhoneTmp = userPhoneNum {
                    param.updateValue(userPhoneTmp, forKey: "userPhone")
                }
                if let userBirthTmp = userBirth {
                    param.updateValue(userBirthTmp, forKey: "userBirth")
                }
                let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
                request!.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
                
                request!.httpBody = paramData
                
                print("\(request?.httpBody)")
                break
            case "PUT" : fallthrough
            case "DELETE" : fallthrough
            default : print("")
        }
        let task = URLSession.shared.dataTask(with: request!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                self.resultOfHttp = httpStatus.statusCode as! String
                
                print("response = \(response)")
            }
             
            let responseString = String(data: data, encoding: .utf8)
           
            if let data = responseString!.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                        self.resultOfHttp = json["statusCode"] as! String
                        print("\(self.resultOfHttp)")
                    }
                }catch {
                    print("JSON Error")
                }
            }
            if(self.viewType == "SecondView"){
                self.svc!.httpResult = self.resultOfHttp!
                self.svc!.endHttpJson()
            }else if(self.viewType == "View"){
                self.vc!.httpResult = self.resultOfHttp!
                self.vc!.endHttpJson()
            }
            
        })
        
        task.resume()
    }
}
