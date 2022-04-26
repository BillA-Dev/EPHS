//
//  EPHSApp.swift
//  EPHS
//
//  Created by 90310148 on 2/10/22.
//Commit

import SwiftUI

@main
struct EPHSApp: App {

    @StateObject var dict = dictionary()
    var body: some Scene {
        WindowGroup {
          
        
            VStack{
           TestNewMethod().environmentObject(dict)
            }.onAppear {
                dict.getInfo()
                dict.getLunch()
            }
            //SettingsScreen()
            //mainScreen(isShowing: Binding.constant(true))
            //ToDoList()
           
        }
    }
}
