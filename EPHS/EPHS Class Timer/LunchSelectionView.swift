
//Animation new deprecated
//https://stackoverflow.com/questions/69443588/how-to-replace-deprecated-animation-in-swiftui
//https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwin5c2Bnof2AhWSjokEHYGeDZMQwqsBegQIAhAB&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DK00oSg1gm_0&usg=AOvVaw0rvWgvu33jngulkRzqc15L
//Transition

//Toggle
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-toggle-switch

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-render-a-gradient



import SwiftUI

struct LunchSelectionView: View {
    
    //This gets the dictionaryType enviorment object
    @EnvironmentObject var timeDict: dictionary
    
    
    @Binding var isShowing: Bool
    
    
    @AppStorage("isToggleOn") var isToggleOn = false
    @AppStorage("areNotificationsOn") var areNotificationOn = false
    @AppStorage("pickedLunch") private var pickedLunch = 0
    
    //Color: []
    
    var body: some View {
        ZStack{
            
            if isShowing{
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: UIScreen.main.bounds.width/1.02, height: UIScreen.main.bounds.height/2, alignment: .center)
                    .foregroundColor(Color(red: 250/255, green: 249/255, blue: 246/255))
                    .border(LinearGradient(gradient: Gradient(colors: [Color.teal, Color.purple]), startPoint: .leading, endPoint: .trailing), width: 8)
                    .cornerRadius(8)
                    .transition(.slide)
                    .ignoresSafeArea()
                    .overlay{
                        //OVERLAY, overlays stuff on top of it
                        VStack{
                            
                            VStack {
                                HStack{
                                    
                                    Text("Settings")
                                        .font(.largeTitle)
                                        .fontWeight(.bold).padding()
                                    Spacer()
                                    Button(action:{isShowing = false}){
                                        Image(systemName: "xmark").padding()
                                    }
                                    
                                    
                                }
                            }.padding()
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .padding()
                                Toggle(isOn: $isToggleOn) {
                                    Text("Enable Lunch").padding()
                                }.padding()
                                Spacer()
                                
                            }
                            
                            
                            Picker(selection: $pickedLunch, label: Text("Choose Lunch")) {
                                Text("First Lunch")
                                    .tag(0)
                                Text("Second Lunch")
                                    .tag(1)
                                Text("Third Lunch")
                                    .tag(2)
                                Text("Fourth Lunch")
                                    .tag(3)
                            }.background(Color.white)
                                .disabled(!isToggleOn)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .padding()
                                Toggle(isOn: $areNotificationOn) {
                                    Text("Enable Vibrations").padding()
                                }.padding()
                                Spacer()
                                
                            }
                            
                            
                            Spacer()
                            Button(action:{
                                //Save selections here
                                //let saver = UserDefaults.standard
                                if isToggleOn{
                                    //user enabled lunch
                                    //lunch.timeDict
                                    
                                    timeDict.resetLunch()
                                    
                                    //Mayeb this work, will have to test tomorrow.
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                        timeDict.addLunch(enterLunch: pickedLunch)
                                    }
                                    
                                    
                                    
                                    print(timeDict.timeDict)
                                    
                                }else{
                                    //Reset time dict
                                    timeDict.resetLunch()
                                }
                                
                                //Run function here
                                
                                isShowing = false
                            }){
                                Text("Save Selections").padding()
                            }.border(Color.teal, width: 1)//Add Background here
                            Spacer()
                            
                        }
                        
                        
                    }
                
            }
            
        }.animation(.easeInOut(duration: 0.8), value: isShowing)
        
    }
    
    
}

struct LunchSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LunchSelectionView(isShowing: Binding.constant(true))
    }
}


