//
//  DateExtension.swift
//  weply
//
//  Created by Den Jo on 02/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

// MARK: - Enum
enum DateFormat: String {
    case format1 = "yyyyMMddHHmm"
    case format2 = "yyyy.MM.dd"
    case format3 = "yyyy년 MM월 dd일 HH시 mm분"
    case format4 = "yyyy/MM/dd HH:mm:ss"
    case format5 = "yyyy. MM. dd"
    case format6 = "yyyy년 MM월 dd일"
    case format7 = "yyyyMMdd HH:mm"
    case format8 = "MM.dd"
    case format9 = "yyyyMMdd"
    case format10 = "yyyy/MM/dd"
    case format11 = "yyyyMMdd'T'HHmm"
    case format12 = "yyyy.MM"
    case format13 = "yyyyMMMM"
    case time     = "HH:mm"
    case time2    = "HH:mm:ss"
    case weekDay  = "e"
    case hour     = "HH시"
    case hour2    = "H"
}

extension Date {
    
    var year: UInt {
        return UInt(Calendar.current.component(.year, from: self))
    }
    
    var month: UInt {
        return UInt(Calendar.current.component(.month, from: self))
    }
    
    var day: UInt {
        return UInt(Calendar.current.component(.day, from: self))
    }
    
    var hour: UInt {
        return UInt(Calendar.current.component(.hour, from: self))
    }
    
    var minute: UInt {
        return UInt(Calendar.current.component(.minute, from: self))
    }
    
    var weekDay: UInt {
        return UInt(Calendar.current.component(.weekday, from: self))
    }
    
    var firstDate: Date? {
        return self.date(from: [.year, .month])
    }
    
    var lastDate: Date? {
        guard let firstDate = self.firstDate else { return nil }
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: firstDate)
    }
    
    
    init(millisecondsIntervalSince1970  milliseconds: Double) {
        self.init(timeIntervalSince1970: milliseconds / 1000.0)
    }
    
    
    /// Return truncated date
    func date(from components: Set<Calendar.Component>, timeZone: TimeZone? = Calendar.current.timeZone) -> Date? {
        var dateComponents = Calendar.current.dateComponents(components, from: self)
        dateComponents.timeZone = timeZone
        
        return Calendar.current.date(from: dateComponents)
    }
    
    func date(minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(minute: minutes), to: self)
    }
    
    func date(hours: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(hour: hours), to: self)
    }
    
    func date(days: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: days), to: self)
    }
    
    func date(months: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(month: months), to: self)
    }
    
    func seconds(from: Date?) -> Int? {
        guard let from = from else { return nil }
        return Calendar.current.dateComponents([.minute], from: from, to: self).second
    }
    
    func minutes(from: Date?) -> Int? {
        guard let from = from else { return nil }
        return Calendar.current.dateComponents([.minute], from: from, to: self).minute
    }
    
    func days(from: Date?) -> Int? {
        guard let from = from else { return nil }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.locale   = Locale.current
        
        // Replace the hour (time) of both dates with 00:00
        let toDay   = calendar.startOfDay(for: self)
        let fromDay = calendar.startOfDay(for: from)
        
        return calendar.dateComponents([.day], from: fromDay, to: toDay).day
    }
    
    func months(from: Date?) -> Int? {
        guard let from = from else { return nil }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.locale   = Locale.current
        
        // Replace the hour (time) of both dates with 00:00
        guard let toDay = calendar.startOfDay(for: self).lastDate, let fromDay = calendar.startOfDay(for: from).firstDate else { return nil }
        return calendar.dateComponents([.month], from: fromDay, to: toDay).month
    }
    
    func years(from: Date?) -> Int? {
        guard let from = from else { return nil }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.locale   = Locale.current
        
        // Replace the hour (time) of both dates with 00:00
        let toDay   = calendar.startOfDay(for: self)
        let fromDay = calendar.startOfDay(for: from)
        
        return calendar.dateComponents([.year], from: fromDay, to: toDay).day
    }
    
    /// Default (locale : "currrent", timeZone : "current")
    func string(dateFormat: DateFormat, locale: Locale? = Locale.current, timeZone: TimeZone? = TimeZone.current) -> String? {
        return string(dateFormat: dateFormat.rawValue, locale: locale, timeZone: timeZone)
    }
    
    /// Default (locale : "currrent", timeZone : "current")
    func string(dateFormat: String, locale: Locale? = Locale.current, timeZone: TimeZone? = TimeZone.current) -> String? {
        guard let locale = locale, let timeZone = timeZone else {
            log(.error, "Failed to convert date to string.")
            return nil
        }
        
        // Set formatter
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale     = locale
        dateFormatter.timeZone   = timeZone
        
        let dateString = dateFormatter.string(from: self)
        return (dateString == "") ? nil : dateString
    }
}
