//
//  ContentView.swift
//  Foodit
//
//  Created by Woody on 6/21/24.
//

import SwiftUI

struct MainMapView: View {
//    @StateObject var firestoreManager = FireStoreManager()
    @StateObject var coordinator: Coordinator = Coordinator.shared
    @State var search: String = ""
    @FocusState var isTextFieldFocused: Bool
    



    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                VStack {
                    NaverMap()
                        .ignoresSafeArea(.all, edges: .top)
                        .overlay {
                            TextField("검색어를 입력하세요", text: $search)
                                .padding()
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.leading)
                                .focused($isTextFieldFocused)
                                .offset(x:geometry.size.width / geometry.size.width, y: geometry.size.height * (-0.6))
                                .onSubmit {
                                    // submit 하면 실행할 action
                                    let searchUserInput = SearchPlace()
                                    Task{
                                        let result = try await searchUserInput.loadData(url: URL(string: "http://127.0.0.1:8000/place?userInput=\(search)")!)
                                            
                                        print("result :  \(result)")
                                        
                                        // result 값 return
                                        coordinator.userLocation = (result.lat, result.lng)
                                        
                                        
                                        print("userLocation check : \(coordinator.coord)")
                                        coordinator.userSearchInputOnSubmitted()
                                        // 그러고 map reload
//                                        coordinator.checkIfLocationServiceIsEnabled()
                                        
                                    }
                                } // Textfield
                                                        
                        } // NaverMap
                } // VStack
                Spacer()

            } // ZStack
            .onAppear {
                Coordinator.shared.checkIfLocationServiceIsEnabled()
    //                    Task {
    //                        await firestoreManager.fetchData()
                // fetchData는 Firebase에 올라간 데이터에 접근해서 lat, leg를 불러오는 함수 입니다.
    //                        Coordinator.shared.setMarker(lat: firestoreManager.mylat, lng: firestoreManager.mylng)
    //                    }
            } // onAppear
        }) // GeometryReader
        
    } // body
} // MainView

#Preview {
    MainMapView()
}
