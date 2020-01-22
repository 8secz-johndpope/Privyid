import UIKit

protocol FieldStyle2ProfileCellDelegate {
    func textviewChange(value: String)
}

class FieldStyle2ProfileCell: UITableViewCell, UITextViewDelegate {

    var delegate: FieldStyle2ProfileCellDelegate?
    @IBOutlet weak var textViewValue: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textViewValue.delegate = self
        textViewValue.layer.cornerRadius = 10
        textViewValue.layer.borderColor = UIColor.init(white: 230/255, alpha: 1).cgColor
        textViewValue.layer.borderWidth = 2
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textviewChange(value: textView.text)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        delegate?.textviewChange(value: textView.text)
        return true
    }
}
