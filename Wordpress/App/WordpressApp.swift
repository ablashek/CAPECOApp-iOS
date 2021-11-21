//
//  NewsApp.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import Firebase
import CoreData
import Firebase
import FirebaseInstanceID
import Alamofire
import SwiftyJSON
import UserNotifications

@main
struct WordpressApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @ObservedObject var mainViewModel = MainViewModel()
    
    @State var showMenu = false
    @State var showPage = false
    @State var page : Page?
    
    init() {
        FirebaseApp.configure()
      }
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            }else{
                ZStack{
                    
                    // Menu...
                    
                    NavigationMenuView(show: $showMenu, showPage: $showPage, page: $page)
                    
                    MainView(showMenu: $showMenu)
                        .cornerRadius(self.showMenu ? 30 : 0)
                        // Shrinking And Moving View Right Side When Menu Button Is Clicked...
                        .scaleEffect(self.showMenu ? 0.9 : 1)
                        .offset(x: self.showMenu ? UIScreen.main.bounds.width / 2 : 0, y: self.showMenu ? 15 : 0)
                        // Rotating Slighlty...
                        .rotationEffect(.init(degrees: self.showMenu ? -5 : 0))
                        .environmentObject(mainViewModel)
                    
                    if showPage {
                        PageView(showPage: $showPage, page: page!)
                    }
                    
                }
                .background(Color.accentColor)
                .edgesIgnoringSafeArea(.all)
                .onAppear(){
                    mainViewModel.fetchHeadlineData()
                    mainViewModel.fetchLastData()
                    mainViewModel.fetchCategoryData()
                }
            }
            
        }
    }
}

//*** Implement App delegate ***//
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
     return true
    }
//No callback in simulator
//-- must use device to get valid push token
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)          {
      print(deviceToken)
        Messaging.messaging().apnsToken = deviceToken
        updateFCMToken()
    }
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print(error.localizedDescription)
        
    }
    
    
    fileprivate func updateFCMToken() {
        Messaging.messaging().token { token, error in
            if let refreshedToken = token {
                let systemVersion = UIDevice.current.systemVersion
                print("iOS\(systemVersion)")
                
                //iPhone or iPad
                let model = UIDevice.current.model
                
                print("device type=\(model)")
                let deviceID = UIDevice.current.identifierForVendor!.uuidString
                print(deviceID)
                print("InstanceID token: \(refreshedToken)")
                
                
                let parameters: [String: String] = [
                    "regid" : refreshedToken,
                    "device_name" : model,
                    "serial" : deviceID,
                    "os_version" : systemVersion
                ]
                
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json"
                ]
                
                AF.request("\(WORDPRESS_URL)/?api-fcm=register", method: .post,parameters:parameters, encoding: JSONEncoding.default, headers: headers).validate()
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            
                            let json = JSON(value)
                            print("Firebase noti")
                            print(json)
                            
                        case .failure(let error):
                            print(error)
                        }
                }
            }
        }
    }
}


extension AppDelegate: MessagingDelegate {
    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Refresh Token")
        updateFCMToken()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        
    
      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        updateFCMToken()
    }
}
