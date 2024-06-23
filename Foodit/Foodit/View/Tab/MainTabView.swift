//
//  MainTab.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

import SwiftUI

/*
 Author : Woody
 Date : 2024.06.21 Friday
 Description : 1차 UI frame 작업 (완료)
 */

import SwiftUI

struct MainTabView: View {
    
    @State var selection: Int = 0
    
    var body: some View {
        
        NavigationView(content: {
            
            ZStack(content: {
                
                TabView(selection: $selection,
                        content:  {
                    Group{
                        MainMapView()
                            .tabItem {
                                Image(systemName: "mappin.circle")
                                Text("Food Map")
                            }
                            .tag(0)

                        PostView()
                            .tabItem {
                                Image(systemName: "square.and.pencil")
                                Text("Post")
                            }
                            .tag(1)

                    } // Group
                    .toolbarBackground(.orange, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    
                    
                }) // TabView


            }) // ZStack
            
        }) // NavigationView
        
    } // body
} // MainTabView

#Preview {
    MainTabView()
}
