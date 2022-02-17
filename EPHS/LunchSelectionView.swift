//
//  LunchSelectionView.swift
//  EPHS
//
//  Created by 90310148 on 2/14/22.
//Commit

//Animation new deprecated
//https://stackoverflow.com/questions/69443588/how-to-replace-deprecated-animation-in-swiftui
//https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwin5c2Bnof2AhWSjokEHYGeDZMQwqsBegQIAhAB&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DK00oSg1gm_0&usg=AOvVaw0rvWgvu33jngulkRzqc15L
//Transition

//Toggle
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-toggle-switch

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-render-a-gradient


import SwiftUI

struct LunchSelectionView: View {
    @Binding var isShowing: Bool
    @State var isToggleOn = false
    @State var areNotificationOn = false
    
    var body: some View {
        ZStack{
            
            if isShowing{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: UIScreen.main.bounds.width/1.02, height: UIScreen.main.bounds.height/2, alignment: .center).foregroundColor(Color.red).transition(.slide).ignoresSafeArea().overlay{
                        VStack{
                            Toggle(isOn: $isToggleOn) {
                            Text("Enable Lunch")
                            }.padding()
                            
                            Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Choose Lunch")) {
                                Text("First Lunch").tag(1)
                                Text("Second Lunch").tag(2)
                                Text("Third Lunch").tag(3)
                                Text("Fourth Lunch").tag(4)
                            }.background(Color.black.opacity(0.4)).disabled(!isToggleOn)
                            
                            Toggle(isOn: $areNotificationOn) {
                            Text("Enable Vibrations")
                            }.padding()

                        }
                        
                        
                    }
                
            }
            
        }.animation(.linear(duration: 1), value: isShowing)
        
    }
}

struct LunchSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LunchSelectionView(isShowing: Binding.constant(true))
    }
}

//  LunchSelectionView.swift
//  EPHS
//
//  Created by 90310148 on 2/14/22.
//Commit
//
