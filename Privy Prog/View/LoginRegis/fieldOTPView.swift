import UIKit

protocol fieldOTPViewDelegate{
    func getPin(pin : String)
    func actionForogotPass()
}

class fieldOTPView: UIView, UITextFieldDelegate {

    var delegate : fieldOTPViewDelegate!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var pinField: UITextField!
    
    @IBOutlet weak var pin1: UIView!
    @IBOutlet weak var pin2: UIView!
    @IBOutlet weak var pin3: UIView!
    @IBOutlet weak var pin4: UIView!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        btn.layer.cornerRadius = 6.7
        btn.isEnabled = false

        pinField.delegate = self
        pinField.addTarget(self, action: #selector(textfieldDidCHange(textField:)), for: .editingChanged)
        pinField.tintColor = .clear
        pinField.becomeFirstResponder()
        clearAll()
    }
    
    func clearAll() {
        pinField.text = ""
        pin1.isHidden = true
        pin2.isHidden = true
        pin3.isHidden = true
        pin4.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let stringArray = Array(textField.text ?? "")
        if stringArray.count > 0{
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 4
        }
        return true
    }
    
    @objc func textfieldDidCHange(textField: UITextField){
        if textField.text!.count == 0 {
            pin1.isHidden = true
            pin2.isHidden = true
            pin3.isHidden = true
            pin4.isHidden = true
        }else if textField.text!.count == 1 {
            pin1.isHidden = false
            pin2.isHidden = true
            pin3.isHidden = true
            pin4.isHidden = true
        }else if textField.text!.count == 2 {
            pin1.isHidden = false
            pin2.isHidden = false
            pin3.isHidden = true
            pin4.isHidden = true
        }else if textField.text!.count == 3 {
            pin1.isHidden = false
            pin2.isHidden = false
            pin3.isHidden = false
            pin4.isHidden = true
        }else {
            pin1.isHidden = false
            pin2.isHidden = false
            pin3.isHidden = false
            pin4.isHidden = false
            delegate.getPin(pin: textField.text!)
        }
    }
    
    @IBAction func btnClick(_ sender: Any) {
        delegate.actionForogotPass()
    }
    
}
