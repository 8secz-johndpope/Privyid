import UIKit
import Alamofire
import SwiftyJSON

class RegisterController: UIViewController, HeaderStyle1Delegate, fieldLoginRegisDelegate {
    
    var header = HeaderStyle1()
    var field = fieldLoginRegis()
    
    var phone = String()
    var pass = String()
    var country = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createView()
    }
    
    func createView(){
        self.view.backgroundColor = .init(white: 230/255, alpha: 1)
            
        //MARK: create header
        header = Bundle.main.loadNibNamed("HeaderStyle1", owner: nil, options: nil)?.first as! HeaderStyle1
        header.titleHeader.text = "Register"
        header.delegate = self
        self.view .addSubview(header)
        
        //MARK: create field regis
        field = Bundle.main.loadNibNamed("fieldLoginRegis", owner: nil, options: nil)?.first as! fieldLoginRegis
        field.topConstrain.constant = 80
        field.btnLogin.setTitle("REGISTER", for: .normal)
        field.btnRegis.isHidden = true
        field.bottonConstrain.constant = -40
        field.delegate = self
        self.view .addSubview(field)

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
        swipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipe)
        
        constrain()
    }
    
    func constrain(){
        header.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
                ])
        } else {
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0),
                header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        }
        
        field.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])

        let xConstraint = NSLayoutConstraint(item: field, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: field, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConstraint, yConstraint])

    }
    
    //MARK:- HeaderStyle1Delegate
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- fieldLoginRegisDelegate
    func textChange(textfield: UITextField) {
        switch textfield.tag {
        case 100:
            phone = textfield.text ?? ""
        case 200:
            pass = textfield.text ?? ""
        case 300:
            country = textfield.text ?? ""
        default:
            break
        }
    }
    
    func actionLogin() {
        showLoding()
        let param = [
            "phone" : phone,
            "password" : pass,
            "country" : country,
            "latlong" : "-",
            "device_token" : "-",
            "device_type" : "0"
        ]

        print(param)
        Alamofire.request(POST_Register(), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headersAuth)
            .responseJSON { response in
                switch response.result{
                case .success(let a):
                    print(a)
                    switch response.response?.statusCode{
                    case 201?:
                        self.requestOTP()
                        
                    case 500?:
                        hide()
                        AlertMessage(title: "Error", message: "Something Wrong Server", targetVC: self)
                    default:
                        hide()
                        let jsonResult = JSON(response.result.value!)
                        var message = ""
                        for i in 0..<jsonResult["error"]["errors"].count{
                            message.append("\(jsonResult["error"]["errors"][i].stringValue)\n")
                        }
                        AlertMessage(title: "Error", message: message, targetVC: self)
                    }

                case .failure(let error) :
                    hide()
                    AlertMessage(title: "Error", message: error.localizedDescription, targetVC: self)
                }
        }
    }
    
    func actionRegis() {
        //not use
    }
    
    func requestOTP(){
        let param = [
            "phone" : phone,
        ]

        Alamofire.request(POST_OTP(), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headersAuth)
            .responseJSON { response in
                switch response.result{
                case .success(_):
                    switch response.response?.statusCode{
                    case 201?:
                        hide()
                        let jsonResult = JSON(response.result.value!)
                        
                        let story = UIStoryboard(name: "Login", bundle: nil)
                        let controll = story.instantiateViewController(withIdentifier: "OTPController") as! OTPController
                        controll.id_User = jsonResult["data"]["user"]["id"].stringValue
                        controll.phone = jsonResult["data"]["user"]["phone"].stringValue
                        self.navigationController?.pushViewController(controll, animated: true)
                        
                    case 500?:
                        hide()
                        AlertMessage(title: "Error", message: "Something Wrong Server", targetVC: self)
                    default:
                        hide()
                        let jsonResult = JSON(response.result.value!)
                        var message = ""
                        for i in 0..<jsonResult["error"]["errors"].count{
                            message.append("\(jsonResult["error"]["errors"][i].stringValue)\n")
                        }
                        AlertMessage(title: "Error", message: message, targetVC: self)
                    }

                case .failure(let error) :
                    hide()
                    AlertMessage(title: "Error", message: error.localizedDescription, targetVC: self)
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
