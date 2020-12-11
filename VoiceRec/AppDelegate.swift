//
//  AppDelegate.swift
//  VoiceRec
//
//  Created by Ivan Dolgushin on 04.06.20.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		FileUtils.PrepareDefaultData()
		DB.settings.register(defaults: [
			"music.volume":0.5,
			"voice.volume":1.0,
			"phrase.delay.inner":1.0,
			"phrase.delay.outer":3.0,
			"phrase.random":true,
			])
		if DB.options.getValue(forKey: "language.base") == "" {
			DB.options.setValue(forKey: "language.base", value: "English")
			DB.options.setValue(forKey: "language.target", value: "Chinese")
			DB.options.flush()
		}

		ViewModelRegistry.register(AudioRecorder())

//		let appearance = UINavigationBarAppearance()
//		appearance.configureWithOpaqueBackground()
//		appearance.backgroundColor = .red
//
//		let attrs: [NSAttributedString.Key: Any] = [
//			.foregroundColor: UIColor.white,
//			.font: UIFont.monospacedSystemFont(ofSize: 36, weight: .black)
//		]
//
//		appearance.largeTitleTextAttributes = attrs
//
//		UINavigationBar.appearance().scrollEdgeAppearance = appearance

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
		NotificationCenter.default.post(name: .appGoesBackground, object: self)
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

		#if ENABLE_SHARE
		let sharedUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.diplomat.VoiceRec.inbox")!

		let files = try! FileManager.default.contentsOfDirectory(at: sharedUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

		var didImport = false
		for url in files {

			if (!url.hasDirectoryPath) {
//				OpusTranscoder.convert(opusFile: url, toM4A: FileUtils.get(file: url.lastPathComponent, withExtension: "m4a", inDirectory:"INBOX"), completionHandler: { () in
//					try! FileManager.default.removeItem(at: url)
//					NotificationCenter.default.post(name: .refreshMusic, object: self)
//				})
				didImport = true
			}
		}
		if didImport {
			NotificationCenter.default.post(name: .refreshMusic, object: self)
		}
		#endif
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

		if url.scheme == "voicerec" && url.host == "onetap" {
			let rvc = UIApplication.shared.windows.first?.rootViewController as! UITabBarController
			rvc.selectedIndex = 0
			DispatchQueue.main.async {
				NSLog("TODO: Start audio recording")
				//let ivc = rvc.selectedViewController as! InboxViewController
				//ivc.startRecording()
			}
			return true
		}
		return false
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

