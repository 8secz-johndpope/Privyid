import UIKit
import Alamofire
import SwiftyJSON

class LoginController: UIViewController, fieldLoginRegisDelegate {
    
    var field = fieldLoginRegis()
    var phone = String()
    var pass = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createView()
    }
    
    func createView(){
        self.view.backgroundColor = .init(white: 230/255, alpha: 1)
            
        field = Bundle.main.loadNibNamed("fieldLoginRegis", owner: nil, options: nil)?.first as! fieldLoginRegis
        field.country.isHidden = true
        field.topConstrain.constant = 40
        field.delegate = self
        self.view .addSubview(field)

        constrain()
    }
    
    func constrain(){
        field.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])

        let xConstraint = NSLayoutConstraint(item: field, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: field, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConstraint, yConstraint])

    }
    
    //MARK:- fieldLoginRegisDelegate
    func textChange(textfield: UITextField) {
        switch textfield.tag {
        case 100:
            phone = textfield.text ?? ""
        case 200:
            pass = textfield.text ?? ""
        default:
            break
        }
    }
    
    func actionLogin() {
        let param = [
            "phone" : phone,
            "password" : pass,
            "latlong" : "-",
            "device_token" : "-",
            "device_type" : "0"
        ]

        print(param)
        Alamofire.request(POST_Sign(), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headersAuth)
            .responseJSON { response in
                switch response.result{
                case .success(let a):
                    print(a)
                    switch response.response?.statusCode{
                    case 201?:
                        let jsonResult = JSON(response.result.value!)
                        let type = jsonResult["data"]["user"]["token_type"].stringValue
                        let token = jsonResult["data"]["user"]["access_token"].stringValue
                        UserDefaults.standard.set("\(type) \(token)", forKey: "AuthorizationUser")
                        UserDefaults.standard.set("\(token)", forKey: "token")
                        UserDefaults.standard.synchronize()
                        
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let controll = story.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                        self.navigationController?.pushViewController(controll, animated: true)
                        
                    case 401:
                        self.requestOTP()
                        
                    case 500?:
                        AlertMessage(title: "Error", message: "Something Wrong Server", targetVC: self)
                    default:
                        let jsonResult = JSON(response.result.value!)
                        var message = ""
                        for i in 0..<jsonResult["error"]["errors"].count{
                            message.append("\(jsonResult["error"]["errors"][i].stringValue)\n")
                        }
                        AlertMessage(title: "Error", message: message, targetVC: self)
                    }

                case .failure(let error) :
                    AlertMessage(title: "Error", message: error.localizedDescription, targetVC: self)
                }
        }
    }
    
    func requestOTP(){
        let param = [
            "phone" : phone,
        ]

        Alamofire.request(POST_OTP(), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headersAuth)
            .responseJSON { response in
                switch response.result{
                case .success(let a):
                    print(a)
                    switch response.response?.statusCode{
                    case 201?:
                        let jsonResult = JSON(response.result.value!)
                        
                        let story = UIStoryboard(name: "Login", bundle: nil)
                        let controll = story.instantiateViewController(withIdentifier: "OTPController") as! OTPController
                        controll.id_User = jsonResult["data"]["user"]["id"].stringValue
                        controll.phone = jsonResult["data"]["user"]["phone"].stringValue
                        self.navigationController?.pushViewController(controll, animated: true)
                        
                    case 500?:
                        AlertMessage(title: "Error", message: "Something Wrong Server", targetVC: self)
                    default:
                        let jsonResult = JSON(response.result.value!)
                        var message = ""
                        for i in 0..<jsonResult["error"]["errors"].count{
                            message.append("\(jsonResult["error"]["errors"][i].stringValue)\n")
                        }
                        AlertMessage(title: "Error", message: message, targetVC: self)
                    }

                case .failure(let error) :
                    AlertMessage(title: "Error", message: error.localizedDescription, targetVC: self)
                }
        }
    }
    
    func actionRegis() {
        let story = UIStoryboard(name: "Login", bundle: nil)
        let controll = story.instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    func ProsesLogin(){
        let param = [
            "phone" : phone,
            "password" : pass,
            "latlong" : "",
            "device_token" : "",
            "device_type" : "0"
        ]

        Alamofire.request(POST_Sign(), method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result{
                case .success(_):
                    switch response.response?.statusCode{
                    case 200?:
                        let jsonResult = JSON(response.result.value!)
                        if jsonResult["status"].stringValue == "success"{
                            
                        }else{
                            
                        }
                    case 500?:
                        print("500")
                    default:
                        print("default")
                    }

                case .failure(let error) :
                    print(error.localizedDescription)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
