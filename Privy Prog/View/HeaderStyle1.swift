import UIKit

protocol HeaderStyle1Delegate{
    func back()
}

class HeaderStyle1: UIView {

    var delegate: HeaderStyle1Delegate?
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func action(_ sender: Any) {
        delegate?.back()
    }
    
}
