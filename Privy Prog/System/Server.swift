import UIKit

let Base = "http://pretest-qa.privydev.id/"

let headersAuth = [
    "Accept": "application/json"
]

func headerBarear() -> [String:String]{
    var headerCustomer = [String:String]()
    // Barear User
    headerCustomer = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization" : UserDefaults.standard.value(forKey: "AuthorizationUser") as? String ?? ""
    ]
    print(headerCustomer)
    return headerCustomer
}


//MARK:- Message
public enum message: String {
    case messageList    = "api/v1/message/"
    case messageSend    = "api/v1/message/send"
}
func GET_MessageList() -> String{
    return "\(Base)\(message.messageList.rawValue)"
}
func POST_MessageSend() -> String{
    return "\(Base)\(message.messageSend.rawValue)"
}

//MARK:- Oauth
public enum oauth: String {
    case credentials    = "api/v1/oauth/credentials"
    case sign           = "api/v1/oauth/sign_in"
    case revoke         = "api/v1/oauth/revoke"
}
func GET_Credentials() -> String{
    return "\(Base)\(oauth.credentials.rawValue)?access_token=\(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
}
func POST_Sign() -> String{
    return "\(Base)\(oauth.sign.rawValue)"
}
func POST_Revoke() -> String{
    return "\(Base)\(oauth.revoke.rawValue)"
}

//MARK:- Profile
public enum profile: String {
    case career         = "api/v1/profile/career"
    case education      = "api/v1/profile/education"
    case changeProfile  = "api/v1/profile"
    case showProfile    = "api/v1/profile/me"
}
func POST_Career() -> String{
    return "\(Base)\(profile.career.rawValue)"
}
func POST_Education() -> String{
    return "\(Base)\(profile.education.rawValue)"
}
func POST_ChangeProfile() -> String{
    return "\(Base)\(profile.changeProfile.rawValue)"
}
func GET_ShowProfile() -> String{
    return "\(Base)\(profile.showProfile.rawValue)"
}

//MARK:- Register
public enum register: String {
    case otp        = "api/v1/register/otp/request"
    case otpMatch   = "api/v1/register/otp/match"
    case register   = "api/v1/register"
}
func POST_OTP() -> String{
    return "\(Base)\(register.otp.rawValue)"
}
func POST_OTPMatch() -> String{
    return "\(Base)\(register.otpMatch.rawValue)"
}
func POST_Register() -> String{
    return "\(Base)\(register.register.rawValue)"
}

//MARK:- Upload
public enum upload: String {
    case cover      = "api/v1/uploads/cover"
    case defaultPic = "api/v1/uploads/profile/default"
    case uploadPic  = "api/v1/uploads/profile"
}
func POST_Cover() -> String{
    return "\(Base)\(upload.cover.rawValue)"
}
func POST_DefaultPic() -> String{
    return "\(Base)\(upload.defaultPic.rawValue)"
}
func POST_UploadPic() -> String{
    return "\(Base)\(upload.uploadPic.rawValue)"
}
func DELETE_PriflePic() -> String{
    return "\(Base)\(upload.uploadPic.rawValue)"
}
