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
            //widgetTutorial()
          // Text("Second View")
            ZStack {
                widgetTutorial()
                VStack {
                    Spacer(minLength: 700)
                    
                    Button(action:{
                        tutorialStarted = false
                    }){
                        Text("End")
                            .font(.title)

                    }
                    Spacer()
                }
            }
            /*
            Button(action:{
                tutorialStarted = false
            }){
                Text("End")
            }
*/
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        
    }
}

struct widgetTutorial: View {
 
    var body: some View {
 
        Image("tutorial")
            .resizable()
        
    }
}


struct MainTutorialScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainTutorialScreen(tutorialStarted: Binding.constant(true))
    }
}
