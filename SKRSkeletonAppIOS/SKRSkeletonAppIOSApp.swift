//
//  SKRSkeletonAppIOSApp.swift
//  SKRSkeletonAppIOS
//
//  Created by Tyler Kwok on 5/6/24.
//

import SwiftUI

@main
struct SKRSkeletonAppIOSApp: App {
    var body: some Scene {
        WindowGroup {
            CameraButtonView(cameraEnabled: false, useBackCamera: false)
        }
    }
}
 
