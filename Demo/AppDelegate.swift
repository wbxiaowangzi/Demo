//
//  AppDelegate.swift
//  Demo
//
//  Created by 王波 on 2018/6/10.
//  Copyright © 2018年 wangbo. All rights reserved.
//

import UIKit
//import NVMAspects
import SDWebImage

let umkey = "5fcdcefabed37e4506c428c7"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var enableRotation: Bool = false
    
    var supportedInterfaceOrientationMask: UIInterfaceOrientationMask?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle")?.load()
        #endif
        UMConfigure.initWithAppkey(umkey, channel: "adhoc")
        hookSDWebImage()
        CatonMonitoring()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground: .
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if enableRotation {
            if let so = supportedInterfaceOrientationMask {
                return so
            }
            return UIInterfaceOrientationMask.all
        } else {
            return .portrait
        }
    }

}

extension AppDelegate {
    
    fileprivate func hookSDWebImage() {
        let block: @convention(block) (AspectInfo?) -> () = { info in
            guard let imageView = info?.instance() as? UIImageView else { return }
            let arguments = info?.arguments()
            guard arguments?.count ?? 0 > 0 else { return }
            var placeholderImage: UIImage?
            var options: SDWebImageOptions = []
            var completed: SDExternalCompletionBlock?
            if arguments!.count == 2 {
                completed = arguments![1] as? SDExternalCompletionBlock
            } else if arguments!.count == 4 {
                placeholderImage = arguments![1] as? UIImage
                options = arguments![2] as? SDWebImageOptions ?? []
                completed = arguments![3] as? SDExternalCompletionBlock
            } else {
                return
            }
            guard let url = arguments![0] as? URL else {
                imageView.sd_setImage(with: nil,
                                      placeholderImage: placeholderImage,
                                      options: options,
                                      progress: nil,
                                      completed: completed)
                return
            }
            let width = imageView.frame.size.width * UIScreen.main.scale
            let height = imageView.frame.size.height * UIScreen.main.scale
            guard width != 0, height != 0 else {
                DispatchQueue.main.async {
                    imageView.sd_setImage(with: url,
                                          placeholderImage: placeholderImage,
                                          options: options,
                                          completed: completed)
                }
                return
            }
            let parsedURL = parse(for: url, imageSize: CGSize(width: width, height: height), scale: nil)
            imageView.sd_setImage(with: parsedURL,
                                  placeholderImage: placeholderImage,
                                  options: options,
                                  progress: nil,
                                  completed: completed)
        }
        _ = try? UIImageView.aspect_hook(#selector(UIImageView.sd_setImage(with:placeholderImage:options:completed:)), with: .positionInstead, usingBlock: block)
    }
    
    func CatonMonitoring() {
        SDCatonMonitor.shareInstance().beginMonitoring()
    }
}

