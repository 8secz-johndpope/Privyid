import UIKit

protocol fieldLoginRegisDelegate{
    func textChange(textfield: UITextField)
    func actionLogin()
    func actionRegis()
}

class fieldLoginRegis: UIView, UITextFieldDelegate {

    var delegate: fieldLoginRegisDelegate?
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var bgField: UIView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegis: UIButton!
    
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottonConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        phone.layer.borderColor = UIColor.init(white: 240/255, alpha: 1).cgColor
        phone.layer.borderWidth = 2
        phone.setLeftPaddingPoints(15)
        phone.delegate = self
        phone.tag = 100
        
        pass.layer.borderColor = UIColor.init(white: 240/255, alpha: 1).cgColor
        pass.layer.borderWidth = 2
        pass.setLeftPaddingPoints(15)
        pass.delegate = self
        pass.tag = 200
        
        country.layer.borderColor = UIColor.init(white: 240/255, alpha: 1).cgColor
        country.layer.borderWidth = 2
        country.setLeftPaddingPoints(15)
        country.delegate = self
        country.tag = 300
        
        bgField.layer.cornerRadius = 10
        bgField.layer.shadowColor = UIColor.white.cgColor
        bgField.layer.shadowRadius = 5.6
        bgField.layer.shadowOpacity = 0.15
        bgField.layer.shadowOffset = .init(width: 0, height: 0)
        
        btnLogin.layer.cornerRadius = 10
        btnLogin.layer.shadowColor = UIColor.white.cgColor
        btnLogin.layer.shadowRadius = 5.6
        btnLogin.layer.shadowOpacity = 0.15
        btnLogin.layer.shadowOffset = .init(width: 0, height: 0)
        
        phone.addTarget(self, action: #selector(textfieldDidChange(textField:)), for: .editingChanged)
        pass.addTarget(self, action: #selector(textfieldDidChange(textField:)), for: .editingChanged)
        country.addTarget(self, action: #selector(textfieldDidChange(textField:)), for: .editingChanged)
        
    }
    
    @objc func textfieldDidChange(textField: UITextField){
        delegate?.textChange(textfield: textField)
    }

    @IBAction func login(_ sender: Any) {
        delegate?.actionLogin()
    }
    
    @IBAction func regis(_ sender: Any) {
        delegate?.actionRegis()
    }
}
