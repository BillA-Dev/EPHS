


import SwiftUI

struct LunchSelectionView: View {
    
    
    // Do not change these variables.
    //This gets the dictionaryType enviorment object
    @EnvironmentObject var timeDict: dictionary
    
    
    @Binding var isShowing: Bool
    
    
    @Binding var opacity: Double
    
    
    
    @AppStorage("isToggleOn") var isToggleOn = false
    @AppStorage("areNotificationsOn") var areNotificationOn = false
    @AppStorage("pickedLunch") private var pickedLunch = 0
    
    
    

    //gets var from the enviorment.
    
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var selectedText: String = ""
    
    var body: some View {
        ZStack{
            
            //Have to figure this out
            
            if isShowing{
                RoundedRectangle(cornerRadius: 30)
                //IF YOU CHANGE THE FRAME OR OBJECT, make sure the frame is within the center, the animation is based off that.
                    .frame(width: UIScreen.main.bounds.width/1.02, height: UIScreen.main.bounds.height/2, alignment: .center)
                //.foregroundColor(Color(red: 250/255, green: 249/255, blue: 246/255))
                //background to white
                    .foregroundColor(colorScheme == .dark ? Color.black.opacity(opacity) : Color.white.opacity(opacity))
                //changed the gradient colors to match timer
                
                //Turn this .bootom to .top
                //COlor.red
                    .border(LinearGradient(gradient: Gradient(colors: [colorScheme == .dark ? Color.white: Color.black, Color(red: 161/255, green: 32/255, blue: 22/255)]), startPoint: .bottom, endPoint: .top), width: 8)
                
                    .cornerRadius(8)
                //KEEP THIS TRANSITION.
                    .transition(.slide)
                    .animation(.easeInOut, value: opacity)
                   
                        
                        
                    
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
                                    .padding().overlay{
                                        Image(colorScheme == .light ? "lunch": "lunchb").resizable().frame(width: 50/1.5, height: 50/1.5).aspectRatio(contentMode: .fit)
                                    }
                                //Keep to toggle binded variable
                                Toggle(isOn: $isToggleOn) {
                                    Text("Enable Lunch").padding()
                                }.padding().tint(Color.red)
                                Spacer()
                                
                            }
                            
                            
                            HStack{
                            
                            //Keep the picker text, and tags
                            Picker("Choose Lunch", selection: $selectedText) {
                                ForEach(Array(timeDict.lunch.keys), id:\.self){x in
                                    Text(x)
                                }
                                
                            }.background(colorScheme == .light ? Color.white.opacity(0): Color.black.opacity(0))//This opactiy might be off
                                .disabled(!isToggleOn)
                                Image(systemName: "arrow.down")
                            }.padding().border(LinearGradient(gradient: Gradient(colors: [colorScheme == .dark ? Color.white : Color.black, Color.red]), startPoint: .bottom, endPoint: .top))
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .padding().overlay{
                                        Image(colorScheme == .light ? "vibration": "vibrationb").resizable().frame(width: 50/1.5, height: 50/1.5).aspectRatio(contentMode: .fit)
                                    }
                                //Keep toggle bindinded variable.
                                Toggle(isOn: $areNotificationOn) {
                                    Text("Enable Vibrations").padding()
                                }.padding().tint(Color.red)
                                Spacer()
                                
                            }
                            
                            
                            Spacer()
                            
                            //IMPORTANT: KEEP THIS BUTTON THE EXACT SAME
                            Button(action:{
                                
                                if isToggleOn{
                                    
                                   
                                    timeDict.timeDict = timeDict.savedDict
                                    
                                    updateTimeDict()
                                    
                                    print("BUTTONCLICKED")
                                    print(timeDict.timeDict)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                       timeDict.addLunchToDict(userSelectedLunch: selectedText)
      
                                    }
                                    
                                    
        
    
                                    
                                }else{
                                    
                                    timeDict.timeDict = timeDict.savedDict
                                    updateTimeDict()
                                    
                                   
                                    
                                }
                                
                                UserDefaults.standard.set(isToggleOn, forKey: "isLunchToggleOn")
                                UserDefaults.standard.set(selectedText, forKey: "whatLunchSelected")
                                
                                isShowing = false
                            }){
                                Text("Save Selections").padding()
                            }.border(LinearGradient(gradient: Gradient(colors: [colorScheme == .dark ? Color.white : Color.black, Color.red]), startPoint: .bottom, endPoint: .top)).padding()//Add Background here
                            Spacer()
                            
                        }
                        .onAppear{
                            isToggleOn = UserDefaults.standard.bool(forKey: "isLunchToggleOn")
                            if let v = UserDefaults.standard.string(forKey: "whatLunchSelected"){
                                if !v.isEmpty{
                                    selectedText = v
                                }else{
                                    isToggleOn = false
                                }
                            }
                        }
                        
                        
                    }
                
            }
            
            //Keep this animation
        }.animation(.easeInOut(duration: 0.8), value: isShowing)
           
        
    }
    
    func updateTimeDict(){
        for (index, value) in timeDict.timeDict{
            timeDict.timeDict[index] = value.map{$0.timeToMinutes()
            }
        }
        
        addSchoolStart()
        
    }
    func addSchoolStart(){
        var min = Int.max
        var max = Int.min
        
        for (_, value) in timeDict.timeDict{
            if Int(value[1])! > max{
                max = Int(value[1])!
            }
            if Int(value[0])! < min{
                min = Int(value[0])!
            }
        }
        
        timeDict.timeDict["School Starts"] = [String(max), String(min)]
    }
    
    
    
}

struct LunchSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LunchSelectionView(isShowing: Binding.constant(true), opacity: Binding.constant(1))
    }
}


