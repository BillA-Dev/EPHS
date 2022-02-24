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
            HStack{
                
            }
            Text("Hello World")
        }
        .onAppear{
            hasPopUpBeenShown = true
        }
        .popover(isPresented: $hasPopUpBeenShown) {
                
            //Add info here
        }
        
        
    }
    
   
    
    
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
