import UIKit
import Alamofire
import SwiftyJSON

class CareerController: UIViewController, UITableViewDelegate, UITableViewDataSource, HeaderStyle1Delegate, FooterStyle1Delegate,  FieldStyle1ProfileCellDelegate, SambagDatePickerViewControllerDelegate {
    
    var header = HeaderStyle1()
    var footer = FooterStyle1()
    var tableList = UITableView()
    var data = JSON()
    
    var param = [String:String]()
    
    var pickerDatein = SambagDatePickerViewController()
    var pickerDateout = SambagDatePickerViewController()
    var DateBefore = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conf()
        createview()
    }
    
    func conf(){
        self.param["position"] = data["career"]["position"].stringValue
        self.param["company_name"] = data["career"]["company_name"].stringValue
        self.param["starting_from"] = data["career"]["starting_from"].stringValue
        self.param["ending_in"] = data["career"]["ending_in"].stringValue
    }
    
    func createview(){
        
        //MARK: create header
        header = Bundle.main.loadNibNamed("HeaderStyle1", owner: nil, options: nil)?.first as! HeaderStyle1
        header.titleHeader.text = "Career"
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle1ProfileCell", for: indexPath) as! FieldStyle1ProfileCell
            
            cell.fieldInput.text = self.param["position"] ?? ""
            
            cell.fieldInput.placeholder = "Insert position"
            cell.actionField.isHidden = true
            cell.fieldInput.isUserInteractionEnabled = true
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle1ProfileCell", for: indexPath) as! FieldStyle1ProfileCell
            
            cell.fieldInput.text = self.param["company_name"] ?? ""
            cell.fieldInput.placeholder = "Insert Company Name"
            cell.fieldInput.isUserInteractionEnabled = true
            cell.actionField.isHidden = true
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle1ProfileCell", for: indexPath) as! FieldStyle1ProfileCell
            
            cell.fieldInput.text = self.param["starting_from"] ?? ""
            
            cell.fieldInput.placeholder = "Insert Sart Time"
            cell.fieldInput.isUserInteractionEnabled = false
            cell.actionField.isHidden = false
            
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldStyle1ProfileCell", for: indexPath) as! FieldStyle1ProfileCell
            
            cell.fieldInput.text = self.param["ending_in"] ?? ""
            
            cell.fieldInput.placeholder = "Insert End Time"
            cell.fieldInput.isUserInteractionEnabled = false
            cell.actionField.isHidden = false
            
            cell.index = indexPath.row
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
            self.param["position"] = text
        case 1:
            self.param["company_name"] = text
        default:
            break
        }
    }
    
    func actionField(index: Int) {
        switch index {
        case 2:
            let tmp = self.param["starting_from"] ?? ""
            if tmp.isEmpty{
                let calendar = Calendar.current
                DateBefore = calendar.date(byAdding: .year, value: -10, to: Date())!
            }else{
                DateBefore = convStringtoDatePickerFilter(value: self.param["starting_from"] ?? "")
            }
            
            self.pickerDatein.timeNow = DateBefore
            self.pickerDatein.theme = .light
            self.pickerDatein.textTitle = "Start Time"
            self.pickerDatein.delegate = self
            self.present(self.pickerDatein, animated: true, completion: nil)
        case 3:
            let tmp = self.param["ending_in"] ?? ""
            if tmp.isEmpty{
                let calendar = Calendar.current
                DateBefore = calendar.date(byAdding: .year, value: 0, to: Date())!
            }else{
                DateBefore = convStringtoDatePickerFilter(value: self.param["ending_in"] ?? "")
            }
            
            self.pickerDateout.timeNow = DateBefore
            self.pickerDateout.theme = .light
            self.pickerDateout.textTitle = "End Time"
            self.pickerDateout.delegate = self
            self.present(self.pickerDateout, animated: true, completion: nil)
        default:
            break
        }
    }
        
    //MAR:- FooterStyle1Delegate
    func actionFooter() {
        showLoding()
        let param:[String:String] = [
            "position" : self.param["position"] ?? "",
            "company_name" : self.param["company_name"] ?? "",
            "starting_from" : self.param["starting_from"] ?? "",
            "ending_in" : self.param["ending_in"] ?? "",
        ]

        Alamofire.request(POST_Career(), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerBarear())
            .responseJSON { response in
                switch response.result{
                case .success(_):
                    switch response.response?.statusCode{
                    case 201?:
                        hide()
                        let jsonResult = JSON(response.result.value!)
                        self.data = jsonResult["data"]["user"]
                        
                        self.param["position"] = self.data["career"]["position"].stringValue
                        self.param["company_name"] = self.data["career"]["company_name"].stringValue
                        self.param["starting_from"] = self.data["career"]["starting_from"].stringValue
                        self.param["ending_in"] = self.data["career"]["ending_in"].stringValue
                        
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
        
        if viewController == pickerDatein {
            param["starting_from"] = "\(day)-\(month)-\(result.year)"
        }else{
            param["ending_in"] = "\(day)-\(month)-\(result.year)"
        }
        
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
