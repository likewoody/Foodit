//
//  MainMapView.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

import SwiftUI

struct MainMapView: View {
//    @StateObject var firestoreManager = FireStoreManager()
    @StateObject var coordinator: Coordinator = Coordinator.shared
    @State var search: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    // for Map Detail
    @State var isMapDetail: Bool = false
    @State var id: Int = 0
    @State var postList: [Post] = []

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
                                .offset(x:geometry.size.width / geometry.size.width, y: geometry.size.width - geometry.size.height)
//                            * (-0.45)
                                .onSubmit {
                                    // submit 하면 실행할 action
                                    let searchUserInput = ConnectWithPython()
                                    Task{
                                        let result = try await searchUserInput.userAddPlace(url: URL(string: "http://127.0.0.1:8000/place?userInputPlace=\(search)")!)
                                            
                                        print("result :  \(result)")
                                        
                                        // result 값 return
                                        coordinator.userLocation = (result[0].lat, result[0].lng)
                                        
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
            .preferredColorScheme(.light)
            .onAppear {
                let query = PostQuery()
                postList = query.searchDB()
//                print("check")
//                print(postList)
                
                Coordinator.shared.checkIfLocationServiceIsEnabled()
    //                    Task {
    //                        await firestoreManager.fetchData()
                // fetchData는 Firebase에 올라간 데이터에 접근해서 lat, leg를 불러오는 함수 입니다.
    //                        Coordinator.shared.setMarker(lat: firestoreManager.mylat, lng: firestoreManager.mylng)
    //                    }
                Coordinator.shared.setMarker(postList: postList)
            } // onAppear
            .sheet(isPresented: $coordinator.isMapDetail, content: {
                MapDetail(id: $coordinator.id)
            })
        }) // GeometryReader
        
    } // body
} // MainView

#Preview {
    MainMapView()
}
