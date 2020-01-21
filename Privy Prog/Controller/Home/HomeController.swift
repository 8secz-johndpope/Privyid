import UIKit
import Alamofire
import SwiftyJSON

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuHomeCellDelegate {
    
    var tableList = UITableView()
    var listMenu = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listMenu = ["Upload Cover", "Upload Profile", "Update Profile", "Message", "Logout"]
        createview()
    }
    
    func createview(){
        
        tableList.delegate = self;
        tableList.dataSource = self;
        tableList.backgroundColor = .white
        tableList.allowsSelection = false
        tableList.separatorStyle = .none
        tableList.rowHeight = UITableView.automaticDimension
        tableList.estimatedRowHeight = 100
        tableList.bounces = true

        tableList.register(UINib(nibName: "BannerImgCell", bundle: nil), forCellReuseIdentifier: "BannerImgCell")
        tableList.register(UINib(nibName: "MenuHomeCell", bundle: nil), forCellReuseIdentifier: "MenuHomeCell")
        
        self.view.addSubview(tableList)
        constrain()
    }
    
    func constrain(){
       tableList.translatesAutoresizingMaskIntoConstraints = false
       if #available(iOS 11.0, *) {
           NSLayoutConstraint.activate([
            tableList.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
           ])
       } else {
           NSLayoutConstraint.activate([
            tableList.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0),
            tableList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
           ])
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMenu.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerImgCell", for: indexPath) as! BannerImgCell

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHomeCell", for: indexPath) as! MenuHomeCell

            cell.btnMenu.setTitle(listMenu[indexPath.row-1], for: .normal)
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
    }
        
    //MARK:- MenuHomeCellDelegate
    func actionMenu(index: Int) {
        switch index {
        case 1:
            //Upload Cover
            print("Upload Cover")
        case 2:
            //Upload Profile
            print("Upload Profile")
        case 3:
            //Update Profile
            print("Update Profile")
        case 4:
            //Message
            print("Message")
        case 5:
            //Logout
            print("Logout")
            proesLogout()
        default:
            break
        }
    }
    
    func proesLogout(){
        let param = [
            "access_token" : UserDefaults.standard.value(forKey: "token") as? String ?? "",
            "confirm" : 1,
            ] as [String : Any]

        print(param)
        Alamofire.request(POST_Revoke(), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headersAuth)
            .responseJSON { response in
                switch response.result{
                case .success(let a):
                    print(a)
                    switch response.response?.statusCode{
                    case 201?:

                        self.gotoLogin()
                        
                    case 401:
                        self.gotoLogin()
                        
                    case 500?:
//                        AlertMessage(title: "Error", message: "Something Wrong Server", targetVC: self)
                        self.gotoLogin()
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
    
    func gotoLogin(){
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.set("", forKey: "AuthorizationUser")
        UserDefaults.standard.synchronize()
        
        let story = UIStoryboard(name: "Login", bundle: nil)
        let controll = story.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
