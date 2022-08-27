//
//  NotificationManager.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 27.08.22.
//

import UIKit
import UserNotifications

enum NotificationError: Error {
    case authFailed
}

enum DateStamp {
    case year
    case month
    case day
    case hour
    case minute
    case second
}

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func checkUserPermission(completionHandler: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let _ = error {
                print(NotificationError.authFailed)
            }
            completionHandler(granted)
        }
    }
    
    func createNotification(withName name: String, duration: Date) {
        let center = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Reminder"
        notificationContent.body = name
        notificationContent.sound = .default
        notificationContent.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let dateStamps = dateHelper(current: duration, previous: Date())
        let timeInterval = Date().addingTimeInterval(TimeInterval(dateStamps[.second]!))
        let id = UUID().uuidString
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: timeInterval)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)
        
        center.add(notificationRequest) { error in
            guard error == nil else { return }
        }
    }
    
    private func dateHelper(current: Date, previous: Date) -> [DateStamp: Int] {
        var dateStampDict = [DateStamp: Int]()
        dateStampDict[.year] = Calendar.current.dateComponents([.year], from: previous, to: current).day
        dateStampDict[.month] = Calendar.current.dateComponents([.month], from: previous, to: current).month
        dateStampDict[.day] = Calendar.current.dateComponents([.day], from: previous, to: current).day
        dateStampDict[.hour] = Calendar.current.dateComponents([.hour], from: previous, to: current).hour
        dateStampDict[.minute] = Calendar.current.dateComponents([.minute], from: previous, to: current).minute
        dateStampDict[.second] = Calendar.current.dateComponents([.second], from: previous, to: current).second
        
        return dateStampDict
    }
    
}
