//
//  SambagMonthYearPickerResult.swift
//  Sambag
//
//  Created by Mounir Ybanez on 03/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

public struct SambagMonthYearPickerResult {

    public var month: SambagMonth
    public var year: Int
    
    public init() {
        self.month = .january
        self.year = 0
    }
}

extension SambagMonthYearPickerResult: CustomStringConvertible {
    
    public var description: String {
        return "\(month) \(year)"
    }
}

public enum SambagMonth: Int {
    
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}

extension SambagMonth: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .january: return "Jan"
        case .february: return "Feb"
        case .march: return "Mar"
        case .april: return "Apr"
        case .may: return "May"
        case .june: return "Jun"
        case .july: return "Jul"
        case .august: return "Aug"
        case .september: return "Sep"
        case .october: return "Oct"
        case .november: return "Nov"
        case .december: return "Dec"
        }
    }
}
