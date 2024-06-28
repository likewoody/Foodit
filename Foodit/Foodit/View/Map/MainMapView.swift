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
                        .ignoresSafeArea(edges: .top)
                        .overlay {
                            TextField("검색어를 입력하세요", text: $search)
                                .padding()
                                .padding(.leading, 50)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.leading)
                                .focused($isTextFieldFocused)
                                .position(x:geometry.size.width / 2, y: geometry.size.height / geometry.size.height + 30)
//                            * (-0.45)
                                .onSubmit {
                                    // submit 하면 실행할 action
                                    let searchUserInput = ConnectWithPython()
                                    Task{
                                        let result = try await searchUserInput.userAddPlace(url: URL(string: "http://localhost:8000/place?userInputPlace=\(search)")!)
//                                        localhost
                                            
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
                search = ""
                let query = PostQuery()
                postList = query.searchDB()
                
                for i in postList{
                    print(i.name)
                    print(i.id)
                }
                coordinator.checkIfLocationServiceIsEnabled()
                coordinator.setMarker(postList: postList)
                
            } // onAppear
            .sheet(isPresented: $coordinator.isMapDetail, content: {
                MapDetail(id: $coordinator.id)
            })
//            .onChange(of: coordinator.coord.0) {
//                print("changed coordinator.coord.0 : \(coordinator.coord)")
//                coordinator.checkIfLocationServiceIsEnabled()
//            }
        }) // GeometryReader
        
    } // body
} // MainView

#Preview {
    MainMapView()
}
