import UIKit

protocol FieldStyle1ProfileCellDelegate{
    func textDidChange(index: Int, text: String)
    func actionField(index: Int)
}

class FieldStyle1ProfileCell: UITableViewCell, UITextFieldDelegate {

    var delegate: FieldStyle1ProfileCellDelegate?
    @IBOutlet weak var fieldInput: UITextField!
    @IBOutlet weak var actionField: UIButton!
    var index = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fieldInput.layer.borderColor = UIColor.init(white: 240/255, alpha: 1).cgColor
        fieldInput.layer.borderWidth = 2
        fieldInput.setLeftPaddingPoints(15)
        
        fieldInput.delegate = self
        fieldInput.addTarget(self, action: #selector(textfieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(textField: UITextField){
        delegate?.textDidChange(index: index, text: textField.text ?? "")
    }

    @IBAction func action(_ sender: Any) {
        delegate?.actionField(index: index)
    }
    
}
