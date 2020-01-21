import UIKit

protocol MenuHomeCellDelegate{
    func actionMenu(index: Int)
}

class MenuHomeCell: UITableViewCell {

    var delegate: MenuHomeCellDelegate?
    @IBOutlet weak var btnMenu: UIButton!
    var index = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        btnMenu.layer.cornerRadius = 10
        btnMenu.layer.shadowColor = UIColor.white.cgColor
        btnMenu.layer.shadowRadius = 5.6
        btnMenu.layer.shadowOpacity = 0.15
        btnMenu.layer.shadowOffset = .init(width: 0, height: 0)
        
    }
    
    @IBAction func action(_ sender: Any) {
        delegate?.actionMenu(index: index)
    }
    
}
