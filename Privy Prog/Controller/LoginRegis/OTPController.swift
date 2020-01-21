import UIKit
import Alamofire
import SwiftyJSON

class OTPController: UIViewController, HeaderStyle1Delegate, fieldOTPViewDelegate {
    
    var header = HeaderStyle1()
    var field = fieldOTPView()
    var id_User = String()
    var phone = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createView()
        print("cek phone = \(phone)")
        print("cek id = \(id_User)")
    }
    
    func createView(){
        self.view.backgroundColor = .init(white: 230/255, alpha: 1)
            
        header = Bundle.main.loadNibNamed("HeaderStyle1", owner: nil, options: nil)?.first as! HeaderStyle1
        header.titleHeader.text = ""
        header.delegate = self
        self.view .addSubview(header)
        
        field = Bundle.main.loadNibNamed("fieldOTPView", owner: nil, options: nil)?.first as! fieldOTPView
        field.label1.text = "Enter your OTP"
        field.label2.text = "We've sent PIN to this number\n\(phone)"
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
    
    //MARK:- fieldOTPViewDelegate
    func getPin(pin: String) {
        if pin.count > 3{
            let param = [
                "user_id"   : id_User,
                "otp_code"  : pin,
            ]

            print(param)
            Alamofire.request(POST_OTPMatch(), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headersAuth)
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
    }
    
    func actionForogotPass() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
