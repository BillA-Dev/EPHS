


import SwiftUI

struct LunchSelectionView: View {
    
    
    // Do not change these variables.
    //This gets the dictionaryType enviorment object
    @EnvironmentObject var timeDict: dictionary
    
    
    @Binding var isShowing: Bool
    
    
    @AppStorage("isToggleOn") var isToggleOn = false
    @AppStorage("areNotificationsOn") var areNotificationOn = false
    @AppStorage("pickedLunch") private var pickedLunch = 0
    
    
    
    var body: some View {
        ZStack{
            
            if isShowing{
                RoundedRectangle(cornerRadius: 30)
                    //IF YOU CHANGE THE FRAME OR OBJECT, make sure the frame is within the center, the animation is based off that.
                    .frame(width: UIScreen.main.bounds.width/1.02, height: UIScreen.main.bounds.height/2, alignment: .center)
                    //.foregroundColor(Color(red: 250/255, green: 249/255, blue: 246/255))
                    //background to white
                     .foregroundColor(Color.white)
                    //changed the gradient colors to match timer
                    .border(LinearGradient(gradient: Gradient(colors: [Color.black, Color.red]), startPoint: .leading, endPoint: .trailing), width: 8)
                    
                    .cornerRadius(8)
                    //KEEP THIS TRANSITION.
                    .transition(.slide)
                    .ignoresSafeArea()
                    .overlay{
                        //OVERLAY, overlays stuff on top of it
                        VStack{
                            
                            VStack {
                                HStack{
                                    
                                    Text("Settings")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .padding()
                                    Spacer()
                                    //Keep The button action the way it is
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
                                //Keep to toggle binded variable
                                Toggle(isOn: $isToggleOn) {
                                    Text("Enable Lunch").padding()
                                }.padding()
                                Spacer()
                                
                            }
                            
                            
                            //Keep the picker text, and tags
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
                                //Keep toggle bindinded variable.
                                Toggle(isOn: $areNotificationOn) {
                                    Text("Enable Vibrations").padding()
                                }.padding()
                                Spacer()
                                
                            }
                            
                            
                            Spacer()
                            
                            //IMPORTANT: KEEP THIS BUTTON THE EXACT SAME
                            Button(action:{
                                
                                if isToggleOn{
                                    
                                    
                                    timeDict.resetLunch()
                                    
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                        timeDict.addLunch(enterLunch: pickedLunch)
                                    }
                                    
                                    
                                    
                                    print(timeDict.timeDict)
                                    
                                }else{
                                    
                                    timeDict.resetLunch()
                                }
                                
                               
                                isShowing = false
                            }){
                                Text("Save Selections").padding()
                            }.border(Color.teal, width: 1)//Add Background here
                            Spacer()
                            
                        }
                        
                        
                    }
                
            }
            
            //Keep this animation
        }.animation(.easeInOut(duration: 0.8), value: isShowing)
        
    }
    
    
}

struct LunchSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LunchSelectionView(isShowing: Binding.constant(true))
    }
}


