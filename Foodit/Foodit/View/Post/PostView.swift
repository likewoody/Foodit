//
//  ContentView.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

import SwiftUI

struct PostView: View {
    @State var postList: [Post] = []
    
    // For Modal popup
    @State var isModal: Bool = false
    @State var isRefresh: Bool = false
    
    var body: some View {
        NavigationStack{
            GeometryReader(content: { geometry in
                VStack {
                    // MARK: Body
                    if postList.isEmpty{
                        ProgressView()
                            .offset(x: geometry.size.width / 2 , y: geometry.size.height / 2)
                    } // if
                    else{
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(postList, id: \.id) { data in
                                    NavigationLink(destination: Detail(post: data)) {
                                        VStack(alignment: .leading) {
                                            Image(uiImage: data.image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: .infinity, maxHeight: 300)
                                            Text(data.name)
                                                .font(.system(size: 20))
                                                .padding()
                                            Text(data.date)
                                                .font(.system(size: 20))
                                                .padding([.leading, .bottom], 15)
                                                
                                        } // VStack
                                        .foregroundStyle(.black)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                    } // NavigationLink
                                    
                                    
                                } // ForEach
                                
                            } // LazyVStack
                            .padding()
                        } // ScrollView
                        
                    } // else
                    
                } // VStack
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        HStack(content: {
                            Text("    ")
                            
                            Spacer()
                            
                            Text("푸딧")
                                .bold()
                            
                            Spacer()
                            Button(action: {
                                isModal = true
                            }, label: {
                                Image(systemName: "plus")
                            }) // Button
                            
                        }) // HStack
                        .font(.system(size: 18))
                        .foregroundStyle(.orange)
                    } // ToolbarItem
                }) // toolbar

            }) // GeometryReader
            .onAppear(perform: {
                loadData()
            
            }) // onAppear
            .onChange(of: isModal, {
                loadData()
            })
            .sheet(isPresented: $isModal, content: {
                ModalPopup(isModal: $isModal)
            }) // sheet
            .preferredColorScheme(.light)
        } // NavigationStack
    } // body
    func loadData(){
        postList.removeAll()
        let query = PostQuery()
        postList = query.searchDB()
    }
    
    func delete(at offsets: IndexSet){
        postList.remove(atOffsets: offsets)
    }
} // PostView

#Preview {
    PostView()
}
