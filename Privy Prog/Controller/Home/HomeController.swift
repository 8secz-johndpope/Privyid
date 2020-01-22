import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SKPhotoBrowser

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, BannerImgCellDelegate, MenuHomeCellDelegate {
    
    var tableList = UITableView()
    
    var listMenu = [String]()
    var data = JSON()
    
    var coverLink = [String]()
    var coverImg = [SKPhotoProtocol]()
    
    var profileLink = [String]()
    var profleImg = [SKPhotoProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listMenu = ["Upload Cover", "Upload Profile", "Update Profile", "Message", "Education", "Career", "Logout"]
        createview()
    }
    
    func getData(){
        showLoding()
        Alamofire.request(GET_ShowProfile() , headers: headerBarear())
            .responseJSON { response in
                switch response.result{
                case .success(let a):
                    print(a)
                    switch response.response?.statusCode{
                    case 200?:
                        hide()
                        let jsonResult = JSON(response.result.value!)
                        self.data = jsonResult["data"]["user"]
                        
                        self.profileLink.removeAll()
                        self.coverLink.removeAll()
                        
                        self.profleImg.removeAll()
                        self.coverImg.removeAll()
                                                
                        for i in 0..<self.data["user_pictures"].count{
                            self.profileLink.append(self.data["user_pictures"][i]["picture"]["url"].stringValue)
                            
                            let photoProfile = SKPhoto.photoWithImageURL(self.data["user_pictures"][i]["picture"]["url"].stringValue)
                            photoProfile.shouldCachePhotoURLImage = false
                            self.profleImg.append(photoProfile)
                        }
                        
                        self.coverLink.append(self.data["cover_picture"]["url"].stringValue)
                        let photoCover = SKPhoto.photoWithImageURL(self.data["cover_picture"]["url"].stringValue)
                        photoCover.shouldCachePhotoURLImage = false
                        self.coverImg.append(photoCover)
                        
                        self.tableList.reloadData()
                        
                    case 401:
                        self.proesLogout()
                        
                    case 500:
                        hide()
                        AlertMessage(title: "Error", message: "Something Wrong Server", targetVC: self)
                        
                    default:
                        hide()
                        let jsonResult = JSON(response.result.value!)
                        var message = ""
                        for i in 0..<jsonResult["error"]["errors"].count{
                            message.append("\(jsonResult["error"]["errors"][i].stringValue)\n")
                        }
                        print(message)
                    }

                case .failure(let error) :
                    hide()
                    print(error.localizedDescription)
                }
        }
    }
    
    func createview(){
        
        //MARK: create table
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

            
            cell.data = self.coverLink
            cell.pageControl.numberOfPages = 1
            cell.pageControl.currentPage = 0
            cell.pagerView.reloadData()
            
            cell.img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.img.sd_setImage(with: URL(string: data["user_picture"]["picture"]["url"].stringValue), placeholderImage: UIImage(named: "defaultProfile"), options: SDWebImageOptions.highPriority)
            
            cell.name.text = data["name"].stringValue
            cell.carear.text = "Scholl : \(data["education"]["school_name"].stringValue) - \(data["education"]["graduation_time"].stringValue)\nCareer : \(data["career"]["company_name"].stringValue)"
            
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHomeCell", for: indexPath) as! MenuHomeCell

            cell.btnMenu.setTitle(listMenu[indexPath.row-1], for: .normal)
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
    }
        
    //MARK:- BannerImgCellDelegate
    func showBanner(indexImg: Int) {
        let browser = SKPhotoBrowser(photos: coverImg)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func showProfile() {
        let browser = SKPhotoBrowser(photos: profleImg)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    //MARK:- MenuHomeCellDelegate
    func actionMenu(index: Int) {
        switch index {
        case 1:
            //Upload Cover
            print("Upload Cover")
            AlertMessage(title: "Info", message: "Under Maintenance", targetVC: self)
        case 2:
            //Upload Profile
            print("Upload Profile")
            AlertMessage(title: "Info", message: "Under Maintenance", targetVC: self)
        case 3:
            //Update Profile
            print("Update Profile")
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controll = story.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
            controll.data = data
            self.navigationController?.pushViewController(controll, animated: true)

        case 4:
            //Message
            print("Message")
            AlertMessage(title: "Info", message: "Under Maintenance", targetVC: self)
        case 5:
            //Education
            print("Education")
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controll = story.instantiateViewController(withIdentifier: "EducationController") as! EducationController
            controll.data = data
            self.navigationController?.pushViewController(controll, animated: true)
            
        case 6:
            //Career
            print("Career")
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controll = story.instantiateViewController(withIdentifier: "CareerController") as! CareerController
            controll.data = data
            self.navigationController?.pushViewController(controll, animated: true)
            
        case 7:
            //Logout
            print("Logout")
            showLoding()
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

                        hide()
                        self.gotoLogin()
                        
                    case 401:
                        hide()
                        self.gotoLogin()
                        
                    case 500?:
                        hide()
//                        AlertMessage(title: "Error", message: "Something Wrong Server", targetVC: self)
                        self.gotoLogin()
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
        
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
