import UIKit

protocol FooterStyle1Delegate{
    func actionFooter()
}

class FooterStyle1: UITableViewCell {

    var delegate: FooterStyle1Delegate?
    @IBOutlet weak var btnFooter: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnFooter.layer.cornerRadius = 10
        btnFooter.layer.shadowColor = UIColor.white.cgColor
        btnFooter.layer.shadowRadius = 5.6
        btnFooter.layer.shadowOpacity = 0.15
        btnFooter.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    @IBAction func action(_ sender: Any) {
        delegate?.actionFooter()
    }
        
}
