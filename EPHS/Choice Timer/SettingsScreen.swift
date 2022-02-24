//
//  SettingsScreen.swift
//  EPHS
//
//  Created by 90310148 on 2/24/22.
//

import SwiftUI

struct SettingsScreen: View {
    
    @State var hasPopUpBeenShown = false
    
    
    //Add Appstorage when everything works.
    var body: some View {
        VStack{
            Text("Hello World")
        }
        .onAppear{
            hasPopUpBeenShown = true
        }
        .popover(isPresented: $hasPopUpBeenShown) {
                    Text("Popover is Presented")
                        .font(.largeTitle)
                        .frame(width: 500, height: 500)
        }
        
        
    }
    
   
    
    
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
