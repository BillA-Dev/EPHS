//
//  MainTutorialScreen.swift
//  EPHS
//
//  Created by 90310148 on 5/9/22.
//

import SwiftUI

struct MainTutorialScreen: View {
    
    @Binding var tutorialStarted: Bool
    var body: some View {
        TabView(){
            widgetTutorial()
           Text("Second View")
            Button(action:{
                tutorialStarted = false
            }){
                Text("End")
            }

        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        
    }
}

struct widgetTutorial: View {
    var body: some View {
        //need to remove watermark once design is finalized
        Image("tempWidget")
            .resizable()
        
    }
}


struct MainTutorialScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainTutorialScreen(tutorialStarted: Binding.constant(true))
    }
}
