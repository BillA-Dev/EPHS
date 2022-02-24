//
//  mainScreen.swift
//  EPHS
//
//  Created by 90310148 on 2/24/22.
//

import SwiftUI
class Screens: ObservableObject{
    @Published var EPHS_Timer = ContentView()
    @Published var homeScreen = mainScreen()
    //Add choice timer here
}
struct mainScreen: View {
    @State var clicked = false
    var body: some View {
        
        NavigationView {
       
        VStack{
            
            Text("EPHS APP")
            Spacer()
//            Button(action:{
//                clicked = true
//            }){
//                Text("EPHS Timer")
//            }
            NavigationLink(destination: ContentView()) {
                                Text("EPHS Timer")
            }
            
            
         
        }
            
            
        
        }
    }
}

//extension View {
//    /// Navigate to a new view.
//    /// - Parameters:
//    ///   - view: View to navigate to.
//    ///   - binding: Only navigates when this condition is `true`.
//    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
//        NavigationView {
//            ZStack {
//                self
//                    .navigationBarTitle("")
//                    .navigationBarHidden(true)
//
//                NavigationLink(
//                    destination: view
//                        .navigationBarTitle("")
//                        .navigationBarHidden(true),
//                    isActive: binding
//                ) {
//                    EmptyView()
//                }
//            }
//        }
//        .navigationViewStyle(.stack)
//    }
//}


struct mainScreen_Previews: PreviewProvider {
    static var previews: some View {
        mainScreen()
    }
}
