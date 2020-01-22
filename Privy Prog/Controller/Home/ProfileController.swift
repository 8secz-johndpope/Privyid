import UIKit
import Alamofire
import SwiftyJSON

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource, HeaderStyle1Delegate, FooterStyle1Delegate,  FieldStyle1ProfileCellDelegate, FieldStyle2ProfileCellDelegate, CZPickerViewDelegate, CZPickerViewDataSource, SambagDatePickerViewControllerDelegate  {
    
    var header = HeaderStyle1()
    var footer = FooterStyle1()
    var tableList = UITableView()
    var data = JSON()
    
    var param = [String:String]()

    var pickerWithGender: CZPickerView?
    var gender = [String]()
    
    var pickerDate = SambagDatePickerViewController()
    var DateBefore = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gender = ["Male", "Female"]
        conf()
        createview()
    }
    
    func conf(){
        self.param["name"] = data["name"].stringValue
        self.param["gender"] = data["gender"].stringValue
        
        let tmp = data["gender"].stringValue
        if tmp == "male"{
             self.param["genderid"] = "0"
        }else{
             self.param["genderid"] = "1"
        }
        
        self.param["birthday"] = data["birthday"].stringValue
        self.param["hometown"] = data["hometown"].stringValue
        self.param["bio"] = data["bio"].stringValue
    }
    
    func createview(){
        
        //MARK: create header
        header = Bundle.main.loadNibNamed("HeaderStyle1", owner: nil, options: nil)?.first as! HeaderStyle1
        header.titleHeader.text = "Edit Profile"
        header.delegate = self
        self.view .addSubview(header)
        
        //MARK: creat table
        tableList.delegate = self;
        tableList.dataSource = self;
        tableList.backgroundColor = .white
        tableList.allowsSelection = false
        tableList.separatorStyle = .none
        tableList.rowHeight = UITableView.automaticDimension
        tableList.estimatedRowHeight = 100
        tableList.bounces = true

        tableList.register(UINib(nibName: "FieldStyle1ProfileCell", bundle: nil), forCellReuseIdentifier: "FieldStyle1ProfileCell")
        tableList.register(UINib(nibName: "FieldStyle2ProfileCell", bundle: nil), forCellReuseIdentifier: "FieldStyle2ProfileCell")
        
        self.view.addSubview(tableList)
        
        //MARK: create footer
        footer = Bundle.main.loadNibNamed("FooterStyle1", owner: nil, options: nil)?.first as! FooterStyle1
        footer.btnFooter.setTitle("Save", for: .normal)
        footer.delegate = self
        self.view .addSubview(footer)
        
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

        tableList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableList.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0),
            tableList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
       
        footer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle1ProfileCell", for: indexPath) as! FieldStyle1ProfileCell
            
            cell.fieldInput.text = self.param["name"] ?? ""
            
            cell.fieldInput.placeholder = "Insert Name"
            cell.actionField.isHidden = true
            cell.fieldInput.isUserInteractionEnabled = true
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle1ProfileCell", for: indexPath) as! FieldStyle1ProfileCell
            
            cell.fieldInput.text = self.param["gender"] ?? ""
            cell.fieldInput.placeholder = "Insert Gender"
            cell.fieldInput.isUserInteractionEnabled = false
            cell.actionField.isHidden = false
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle1ProfileCell", for: indexPath) as! FieldStyle1ProfileCell
            
            cell.fieldInput.text = self.param["birthday"] ?? ""
            
            cell.fieldInput.placeholder = "Insert Birthday"
            cell.fieldInput.isUserInteractionEnabled = false
            cell.actionField.isHidden = false
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle1ProfileCell", for: indexPath) as! FieldStyle1ProfileCell
            
            cell.fieldInput.text = self.param["hometown"] ?? ""
            
            cell.fieldInput.placeholder = "Insert Hometown"
            cell.actionField.isHidden = true
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle2ProfileCell", for: indexPath) as! FieldStyle2ProfileCell
            
            cell.textViewValue.text = self.param["bio"] ?? ""
            
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
        
    //MARK:- HeaderStyle1Delegate
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- FieldStyle1ProfileCellDelegate
    func textDidChange(index: Int, text: String) {
        switch index {
        case 0:
            self.param["name"] = text
        case 3:
            self.param["hometown"] = text
        default:
            break
        }
    }
    
    func actionField(index: Int) {
        switch index {
        case 1:
            //Gender
            pickerWithGender = CZPickerView(headerTitle: "Choose Gender", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
            pickerWithGender?.delegate = self
            pickerWithGender?.dataSource = self
            pickerWithGender?.needFooterView = false
            pickerWithGender?.show()
        case 2:
            //Birthday
            DateBefore = convStringtoDatePickerFilter(value: self.param["birthday"] ?? "")
            self.pickerDate.timeNow = DateBefore
            self.pickerDate.theme = .light
            self.pickerDate.textTitle = "Birthday"
            self.pickerDate.delegate = self
            self.present(self.pickerDate, animated: true, completion: nil)
        default:
            break
        }
    }
    
    //MARK:- FieldStyle2ProfileCellDelegate
    func textviewChange(value: String) {
        self.param["bio"] = value
    }
    
    //MAR:- FooterStyle1Delegate
    func actionFooter() {
        showLoding()
        let param:[String:String] = [
            "name" : self.param["name"] ?? "",
            "gender" : self.param["genderid"] ?? "",
            "birthday" : self.param["birthday"] ?? "",
            "hometown" : self.param["hometown"] ?? "",
            "bio" : self.param["bio"] ?? ""
        ]

        Alamofire.request(POST_ChangeProfile(), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerBarear())
            .responseJSON { response in
                switch response.result{
                case .success(_):
                    switch response.response?.statusCode{
                    case 201?:
                        hide()
                        let jsonResult = JSON(response.result.value!)
                        self.data = jsonResult["data"]["user"]
                        
                        self.param["name"] = self.data["name"].stringValue
                        self.param["gender"] = self.data["gender"].stringValue
                        self.param["birthday"] = self.data["birthday"].stringValue
                        self.param["hometown"] = self.data["hometown"].stringValue
                        self.param["bio"] = self.data["bio"].stringValue
                        
                        self.tableList.reloadData()
                        
                    case 401:
                        hide()
                        UserDefaults.standard.set("", forKey: "token")
                        UserDefaults.standard.set("", forKey: "AuthorizationUser")
                        UserDefaults.standard.synchronize()
                        
                        let story = UIStoryboard(name: "Login", bundle: nil)
                        let controll = story.instantiateViewController(withIdentifier: "LoginController") as! LoginController
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
    
    //MARK:- CZPickerViewDelegate
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return gender[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        pickerWithGender?.setSelectedRows([row])
        switch gender[row] {
        case "Male":
            self.param["genderid"] = "0"
            self.param["gender"] = "Male"
        case "Female":
            self.param["genderid"] = "1"
            self.param["gender"] = "Female"
        default:
            break
        }
        self.tableList.reloadData()
    }
    
    //MARK:- CZPickerViewDataSource
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return gender.count
    }
    
    //MARK:- SambagDatePickerViewControllerDelegate
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        
        var month = String()
        var day = String()

        if result.month.rawValue > 9{
            month = "\(result.month.rawValue)"
        }else{
            month = "0\(result.month.rawValue)"
        }

        if result.day > 9{
            day = "\(result.day)"
        }else{
            day = "0\(result.day)"
        }
        
        param["birthday"] = "\(day)-\(month)-\(result.year)"
        self.tableList.reloadData()
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
