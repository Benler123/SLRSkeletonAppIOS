//
//  Camera.swift
//  SKRSkeletonAppIOS
//
//  Created by Tyler Kwok on 5/6/24.
//

import Foundation
import SwiftUI

class CameraDataObject {
    var signDataList: [RawSignData]
    var frameNumber: Int
    
    init(frameNumber: Int) {
        self.signDataList = []
        self.frameNumber = frameNumber
    }
    
    func AddToList(signData: RawSignData) {
        let dataWithCorrectFrames = signData.data.count > 60 ? extractFramesByEnd(signData: signData):interpolateDataWithMiddleFrame(signData: signData)
        
        self.signDataList.append(dataWithCorrectFrames)
    }
    
    func extractFramesByEnd(signData: RawSignData) -> RawSignData{
        return RawSignData(data: Array(signData.data.suffix(60)))
    }
    
    func interpolateDataWithMiddleFrame(signData: RawSignData) -> RawSignData {
        let dataLength = signData.data.count
        let midpointFrame = signData.data[dataLength / 2]
        
        let interpolatedData = signData.data + Array(repeating: midpointFrame, count: dataLength - self.frameNumber)
        
        return RawSignData(data: interpolatedData)
    }
}
