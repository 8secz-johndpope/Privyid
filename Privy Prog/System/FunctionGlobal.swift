import UIKit

var loading = PUGIFLoading()
var titleLoading = ""
var nameGif = "loading"

func showLoding(){
    loading.show("Pleas Wait", gifimagename: nameGif, bg: false)
}

func hide(){
    loading.hide()
}

func AlertMessage(title: String, message: String, targetVC: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    alert.view.tintColor = .black
    targetVC.present(alert, animated: true, completion: nil)
}

func convStringtoDatePickerFilter(value: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .iso8601)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "en_GB")
    let dateNew = dateFormatter.date(from: value)! // yg serring error
    return dateNew
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

