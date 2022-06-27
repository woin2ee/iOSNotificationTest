//
//  ViewController.swift
//  NotificationTest
//
//  Created by Jaewon on 2022/04/09.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    // NotificationCenter 객체 (싱글톤으로 사용)
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        requestNotificationAuthorization() // 권한 요청 함수 호출
    }
    
    @IBAction func AddNotification(_ sender: UIButton) {
        // UNMutableNotificationContent 객체로 content 정의
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "subtitle"
        content.body = "body"
        content.sound = .default
        content.badge = 5
        
        // trigger 정의 (여러 트리거 지원)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // request 객체 생성
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // NotificationCenter에 request 객체 등록
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("error: \(error)")
            }
        }
    }
    
    // 권한 요청 함수
    func requestNotificationAuthorization() {
        // 요청할 권한 옵션
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        // 권한 요청
        notificationCenter.requestAuthorization(options: authOptions) { isAllowed, error in
            
            self.showAlert(message: isAllowed.description)
            
            self.notificationCenter.getNotificationSettings { settings in
                print(settings.soundSetting.rawValue)
            }
            
            // 요청 성공 시 error에 nil 반환
            if let error = error {
                print(error)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림 허용 여부", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: false)
        }
    }
}

