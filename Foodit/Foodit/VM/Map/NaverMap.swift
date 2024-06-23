//
//  NaverMap.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

import SwiftUI
import NMapsMap

struct NaverMap: UIViewRepresentable {
    
    // MARK: Cordinator => SwiftUI-UIKit간의 브릿지 역할을 하는 녀석
    func makeCoordinator() -> Coordinator {
        Coordinator.shared // SwiftUI로의 bridge delegate 역할
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
}

