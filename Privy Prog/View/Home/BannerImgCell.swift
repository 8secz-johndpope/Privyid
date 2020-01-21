import UIKit
import SwiftyJSON
import SDWebImage
import FSPagerView

protocol BannerImgCellDelegate {
    
}

class BannerImgCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {
    
    var delegate: BannerImgCellDelegate?
    var data = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        pagerView.delegate = self
//        pagerView.dataSource = self
        self.pageControl.currentPage = 0
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.isInfinite = false
            self.pagerView.automaticSlidingInterval = 5.0
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .left
            self.pageControl.setFillColor(.white, for: .normal)
            self.pageControl.setFillColor(UIColor.init(red: 162/255, green: 32/255, blue: 21/255, alpha: 1), for: .selected)
        }
    }
    
    // MARK:- FSPagerView DataSource
    open func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.data.count
    }
    
    open func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        cell.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imageView?.sd_setImage(with: URL(string: "\(data[index])"), placeholderImage: UIImage(named: "ImgEmpty2"), options: SDWebImageOptions.refreshCached)

        cell.imageView?.contentMode = .redraw
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pageControl.currentPage = index
//        delegate?.pushImg(indexImg: index)
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    
}
