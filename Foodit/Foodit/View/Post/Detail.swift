//
//  Detail.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

/*
 Author : Woody
 Date : 2024.06.23 Sunday
 Description : 1차 UI frame 작업 & 저장하기 Button 클릭 시 DB 저장 완료
*/


import SwiftUI
import PhotosUI

struct Detail: View {
    
    // MARK: Property
    @State var post: Post
    @State var name: String = ""
    @State var review: String = ""
    @State var image: UIImage?
    @State var isUpdate: Bool = false
    @State var isDelete: Bool = false
    @State var isDeleteDone: Bool = false
    @State var selectedCategory: String = "음식"
    @State var categoryList = ["음식", "커피", "베이커리"]
    @FocusState var isTextfieldFocused: Bool
    @State var selectedImg: PhotosPickerItem?
    var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        // HH -> 24, hh -> 12
        formatter.dateFormat = "yyyy-MM-dd EEE HH:mm:ss"
        
        return formatter
    }
    var currentDate = Date()
    @Environment(\.dismiss) var dismiss
    
    // MARK: View
    var body: some View {
        NavigationStack{
            GeometryReader(content: { geometry in
                ScrollView {
                    VStack(content: {
                        // MARK: 사진 선택
                        PhotosPicker("사진 선택", selection: $selectedImg, matching: .images)
                            .foregroundStyle(.accent)
                            .padding()
                            .onChange(of: selectedImg, {
                                Task{
                                    if let data = try? await selectedImg?.loadTransferable(type: Data.self){
                                        image = UIImage(data: data)
                                    }
                                } // Task
                            }) // onChange
                            
                        
                        Spacer()
                        // image
                        if let image{
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: geometry.size.width, height: geometry.size.height / 3)
                                .scaledToFit()
                        } // if let
                        
                        Spacer()
                        
                        HStack(content: {
                            Spacer()
                            Text("가게 상호명 (수정 불가)")
                                .padding(.leading, 18)

                            
                            Spacer()
                            
                            Picker("", selection: $selectedCategory, content: {
                                ForEach(categoryList, id: \.self) { category in
                                    Text(category)
                                }
                            })
                            .padding()
                            .pickerStyle(.menu)
                            .foregroundStyle(.blue)
                        }) // HStack
                            .padding(.trailing, geometry.size.width / 4)
                        
                        // name Text Editor
                        TextEditor(text: $name)
                            .border(.gray.opacity(0.2))
                            .foregroundStyle(.gray.opacity(0.8))
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.leading)
                            .frame(width: geometry.size.width / 1.3, height: geometry.size.height / 20)
                            .focused($isTextfieldFocused)
                            .padding(.bottom, 15)
                            .disabled(true)
                        
                        Text("후기 남기기")
                            .padding(.trailing, geometry.size.width / 2)
                        // review Text Editor
                        TextEditor(text: $review)
                            .border(.gray.opacity(0.2))
                            .multilineTextAlignment(.leading)
                            .focused($isTextfieldFocused)
                            .frame(width: geometry.size.width / 1.3, height: geometry.size.height / 2.7)
                            .lineLimit(0)
                            .padding(.bottom, 15)
                        
                        Button(action: {
                            
                            let insertDate = dateFormatter.string(from: currentDate)
                            
                            let query = PostQuery()
                            isUpdate = query.updateDB(date: insertDate, review: review, category: selectedCategory, image: image!, id: post.id)
                            if isUpdate {
                                print("inserted sucessfully !!")
                            }else{
                                print("failed...")
                            }
                        }, label: {
                            Text("수정하기")
                                .bold()
                                .frame(width: 100, height: 30)
                                .padding()
                                .background(.accent)
                                .foregroundStyle(.white)
                                .clipShape(.rect(cornerRadius: 20))
                        }) // Button
                    }) // VStack
                    .alert("수정이 완료 되었습니다.", isPresented: $isUpdate) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("확인")
                        })
                    } // alert
                    
                } // ScrollView
                

            }) // GeometryRedaer
            .preferredColorScheme(.light)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isDelete = true
                    }, label: {
                        Image(systemName: "trash")
                    }) // Button
                } // ToolbarItem
                
            }) // toolbar
            .fullScreenCover(isPresented: $isDelete) {
                BottomSheet(isDelete: $isDelete, post: $post, isDeleteDone: $isDeleteDone)
                    .background(BackgroundClearView())
            }
            .onChange(of: isDeleteDone) {
                dismiss()
            }
        } // NavigationStack
        .onAppear(perform: {
            loadData()
        })
        .accentColor(.accent)
    }
    // ---- Function ---
    func loadData(){
        name = post.name
        review = post.review
        image = post.image
        selectedCategory = post.category
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


#Preview {
    Detail(post: Post(id: 0, name: "", address: "", date: "", review: "", category: "", lat: 0, lng: 0, image: UIImage()))
}
