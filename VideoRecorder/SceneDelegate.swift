//
//  SceneDelegate.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // MARK: - !!!TEST!!!
        /* Test DATA 생성
        이후에 repository 와 연결해서 데이터 끌어와서 사용
        */
        
//        let videoData1 = VideoListItemViewModel(video: Video(id: "AA7DE9BB-A894-4BB4-BFD9-45609180A898", title: "project", releaseDate: Date(), duration: 27, thumbnailPath: "/var/mobile/Containers/Data/Application/3A9AD567-451B-4DA3-B288-55C4345D2D0C/Documents/VideoRecorder/AA7DE9BB-A894-4BB4-BFD9-45609180A898.mp4"))
//        let videoData2 = VideoListItemViewModel(video: Video(id: "aa", title: "Food", releaseDate: Date(), duration: 60, thumbnailPath: ""))
//        let videoData3 = VideoListItemViewModel(video: Video(id: "bb", title: "Building", releaseDate: Date(), duration: 120, thumbnailPath: ""))
//        let videoData4 = VideoListItemViewModel(video: Video(id: "cc", title: "Concert", releaseDate: Date(), duration: 132, thumbnailPath: ""))
//        let videoData5 = VideoListItemViewModel(video: Video(id: "dd",title: "Bridge", releaseDate: Date(), duration: 3600, thumbnailPath: ""))
//
//        let testViewModel = VideoListViewModel(videoItems: [videoData1, videoData2, videoData3, videoData4, videoData5, videoData1, videoData2, videoData3, videoData4, videoData5, videoData1, videoData2, videoData3, videoData4, videoData5, videoData1, videoData2, videoData3, videoData4, videoData5, videoData1, videoData2, videoData3, videoData4, videoData5, videoData1, videoData2, videoData3, videoData4, videoData5, videoData1, videoData2, videoData3, videoData4, videoData5, videoData1, videoData2, videoData3, videoData4, videoData5, videoData1, videoData2, videoData3, videoData4, videoData5,])
        
        var videos = [VideoListItemViewModel]()
        for video in MediaFileManager.shared.fetchJson() {
            videos.append(VideoListItemViewModel(video: video))
        }
        let testViewModel = VideoListViewModel(videoItems: videos)
        
        let mainViewController = VideoListViewController(viewModel: testViewModel)
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

