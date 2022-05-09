//
//  EPHSApp.swift
//  EPHS
//
//  Created by 90310148 on 2/10/22.
//Commit

import SwiftUI

//https://stackoverflow.com/questions/32335942/check-if-user-is-logged-into-icloud-swift-ios


@main
struct EPHSApp: App {

    @StateObject var dict = dictionary()
    var body: some Scene {
        WindowGroup {
          
            
//
            if !dict.shouldSwitch{
                anotherAnimationTest().environmentObject(dict)
            }else{
                TestNewMethod().environmentObject(dict)
            }
                //deleteLater()
           
        }
    }
}
