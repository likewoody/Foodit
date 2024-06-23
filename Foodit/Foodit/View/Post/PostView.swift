//
//  WishList.swift
//  Foodit
//
//  Created by Woody on 6/21/24.
//

/*
 Author : Woody
 Date : 2024.06.22 Friday
 Description : 1차 UI frame 작업 & DB 연결 완료 (6.22)
 1. 왜 그런지는 모르겠는데 Title 부분이 Padding이 많이 되어 있는 것처럼 밑으로 밀려있음.
 2. 그리고 Modal Popup을 이용하여 DB를 추가하면은 화면이 reload가 아니기 때문에 isModal을 Binding 하여
 ModalView에서 작업 완료시 isModal을 ture => false로 전환하여 reload 한다.
 
 */

import SwiftUI
//import SDWebImageSwiftUI

struct PostView: View {
    
    @State var testList: [Post] = [
//        ["google", "오태식 해바라기 치킨 신천점", "간장은 달고 맛있고 할라피뇨는 매콤해 맛있다."],
//        ["naver", "BBQ 시흥능곡점", "비비큐는 맛있는데 많이 먹으면 느끼하다."],
//        ["daum", "맘스터치 시흥능곡점", "맘스터치 짱!"]
    ]
    
    // For Modal popup
    @State var isModal: Bool = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.orange,
            .font: UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
    }
    
    var body: some View {
        NavigationStack{
            GeometryReader(content: { geometry in
                ZStack(content: {
                    // MARK: Body
                    if testList.isEmpty{
                        ProgressView()
                            .offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    } // if
                    else{
                        List{
                            ForEach(testList, id: \.id) { data in
                                
                                VStack(alignment: .leading, content: {
//                                    Image(uiImage: data.image)
//                                        .resizable()
//                                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3)
                                    
                                    Text(data.name)
                                        .font(.system(size: 20))
                                        .padding()
                                    
                                    Text(data.review)
                                        .font(.system(size: 20))
                                        .padding(.leading, 15)
                                }) // VStack

                            } // ForEach
                            .padding(.bottom, 20)
                            
                        } // List
                    } // else
                    
                }) // ZStack
                .navigationTitle("VINOBLE")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: {
                            isModal = true
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.orange)
                        })
                    })
                }) // toolbar

            }) // GeometryReader
            
                        
        } // Navigation Stack
        .sheet(isPresented: $isModal, content: {
            ModalPopup(isModal: $isModal)

        }) // sheet
        .onChange(of: isModal, {
            testList.removeAll()
            let query = PostQuery()
            
            testList = query.searchDB()

        })
        .onAppear(perform: {
            testList.removeAll()
            let query = PostQuery()
            
            testList = query.searchDB()
//            store.send(.searchOnlyWish)
        }) // onAppear
        
    } // body
} // WishListView

#Preview {
    PostView()
}
