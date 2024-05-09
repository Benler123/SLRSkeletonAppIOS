//
//  SLRView.swift
//  SKRSkeletonAppIOS
//
//  Created by Tyler Kwok on 5/6/24.
//

import SwiftUI

class SLRViewModel: ObservableObject {
    @Published var isCameraShowing = true
    
    func toggleCamera(){
        isCameraShowing = !isCameraShowing
    }
    
}

