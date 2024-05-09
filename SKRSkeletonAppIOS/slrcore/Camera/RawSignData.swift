//
//  RawSignData.swift
//  SKRSkeletonAppIOS
//
//  Created by Tyler Kwok on 5/9/24.
//

import Foundation
import SwiftUI

struct RawSignData {
    var data: [CIImage]
    
    init(data: [CIImage]) {
        self.data = data
    }
}
