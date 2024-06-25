//
//  BottomSheet.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

/*
 Author : Woody
 Description : Bottom Sheet Frame과 Bottom Sheet View 만들기
 Date : 2024.06.23 Sunday 21:14
 */

import SwiftUI

struct BottomSheet: View {
    
    @Binding var isDelete: Bool
    @Binding var post: Post
    // Delete Query가 실행되었을 때 상태 변경을 알려줌으로써 Detail 화면 또한 dismiss 하여 PostView로 돌아간다.
    @Binding var isDeleteDone: Bool
    
    var body: some View {
        ZStack(content: {
            if isDelete {
                Color.black
                    .opacity(0.3)
                    .onTapGesture {
                        isDelete.toggle()
                    }
                BottomSheetView(post: $post, isDeleteDone: $isDeleteDone)
                    .transition(.move(edge: .bottom))
            }
        }) // ZStack
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .animation(.easeInOut, value: isDelete)
        
    }// body
} // BottomSheet

struct BottomSheetView: View{
    
    @Environment(\.dismiss) var dismiss
    @Binding var post: Post
    @Binding var isDeleteDone: Bool
    
    var body: some View{
        GeometryReader(content: { geometry in
            VStack(content: {
                Text("글을 삭제 하시겠습니까?")
                    .padding(10)
                    .foregroundStyle(.gray)
                Divider()
                    .background(Color.white)
                
                Button(action: {
                    let query = PostQuery()
                    let result = query.deleteDB(id: post.id)
                    if result{
                        print("sccuessfully deleted !")
                        dismiss()
                        isDeleteDone = true
                    }else{
                        print("failed delete...")
                    }
                    
                }, label: {
                    Text("삭제")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.red)
                        .padding(10)
                })
                    
            }) // VStack
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(
                Color.black.opacity(0.7)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
            .padding()
            .offset(x: geometry.size.width / geometry.size.width, y: geometry.size.height / 1.35)
            
            VStack(content: {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("취소")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blue)
                        .padding(10)
                }) // Button
            }) // VStack
            .frame(maxWidth: .infinity, minHeight: 58)
            .background(
                Color.black.opacity(0.7)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
            .padding()
            
            .offset(x: geometry.size.width / geometry.size.width, y: geometry.size.height / 1.14)

        }) // GeometryReader
                
    } // body
} // BottomSheetView
