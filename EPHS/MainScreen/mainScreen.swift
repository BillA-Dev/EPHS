//
//  mainScreen.swift
//  EPHS
//
//  Created by 90310148 on 2/24/22.
//

import SwiftUI


class getBinding: ObservableObject{
    @Published var isTimerShowing = false
    
}


struct mainScreen: View {
    
    @Binding var isShowing: Bool
    
    @State var clickedTimer = false
    
   
    
    var body: some View {
        
        
        
        
        
        if isShowing {
        
        VStack{

            if clickedTimer == false{
            Text("EPHS APP")


            Spacer()

            Button(action:{
                clickedTimer = true
               
                
            }){
                Text("EPHS Timer")
            }
          
            Spacer()
            }


        }
        


    
        }
        
        
    
}
    
}


struct mainScreen_Previews: PreviewProvider {
    static var previews: some View {
        mainScreen(isShowing: Binding.constant(true))
    }
}
