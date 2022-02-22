
//Animation new deprecated
//https://stackoverflow.com/questions/69443588/how-to-replace-deprecated-animation-in-swiftui
//https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwin5c2Bnof2AhWSjokEHYGeDZMQwqsBegQIAhAB&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DK00oSg1gm_0&usg=AOvVaw0rvWgvu33jngulkRzqc15L
//Transition

//Toggle
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-toggle-switch

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-render-a-gradient

//Change TimeDict


//Fix this


import SwiftUI

struct LunchSelectionView: View {
    
    @EnvironmentObject var timeDict: dictionary
    //wtf is this
    
    @Binding var isShowing: Bool
    @State var isToggleOn = false
    @State var areNotificationOn = false
    @State private var pickedLunch = 0
    
    //Color: []
    
    var body: some View {
        ZStack{
            
            if isShowing{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: UIScreen.main.bounds.width/1.02, height: UIScreen.main.bounds.height/2, alignment: .center).foregroundColor(Color(red: 250/255, green: 249/255, blue: 246/255)).border(LinearGradient(gradient: Gradient(colors: [Color.teal, Color.purple]), startPoint: .leading, endPoint: .trailing), width: 8).cornerRadius(8).transition(.slide).ignoresSafeArea().overlay{
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
                            Toggle(isOn: $isToggleOn) {
                                Text("Enable Lunch").padding()
                            }.padding()
                            
                            
                            Picker(selection: $pickedLunch, label: Text("Choose Lunch")) {
                                Text("First Lunch").tag(0)
                                Text("Second Lunch").tag(1)
                                Text("Third Lunch").tag(2)
                                Text("Fourth Lunch").tag(3)
                            }.background(Color.black.opacity(0.4)).disabled(!isToggleOn)
                            Spacer()
                            Toggle(isOn: $areNotificationOn) {
                                Text("Enable Vibrations").padding()
                            }.padding()
                            Spacer()
                            Button(action:{
                                //Save selections here
                                //let saver = UserDefaults.standard
                                if isToggleOn{
                                    //user enabled lunch
                                    //lunch.timeDict
                                    resetLunch()
                                    addLunch(enterLunch: pickedLunch)
                                    
                                    print(timeDict.timeDict)
                                    
                                }else{
                                    //Reset time dict
                                    resetLunch()
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
    
    //Can move this all to the observedobject class
    func resetLunch(){
        if Int(Calendar.current.component(.weekday, from: Date())) == 3{
            timeDict.timeDict = ["1st hour": ["8:35", "9:38"],
                            "Passing Time to connections": ["9:38", "9:45"],
                            "Connections": ["9:45","10:05"],
                            "Passing Time to 2nd Hour": ["10:05","10:12"],
                            "2nd hour": ["10:12", "11:15"],
                            "Passing Time to 3rd hour": ["11:15", "11:22"],
                            "3rd hour": ["11:22", "13:22"],
                            "Passing Time to 4th hour": ["13:22", "13:29"],
                            "4th hour": ["13:29", "14:33"],
                        "Passing time to flex": ["14:33", "14:40"],
                        "Flex": ["14:40","15:20"],
                        "Busses Leave" : ["15:20", "15:27"],
                            "School Starts" : ["15:20", "8:35"]]
            print(timeDict.timeDict)
        }else if Int(Calendar.current.component(.weekday, from: Date())) == 5{
            timeDict.timeDict = ["1st hour": ["8:35", "9:33"],
                        "Core 1st hour": ["9:33", "10:03"],
                            "Passing Time to 2nd hour": ["10:03", "10:10"],
                            "2nd hour": ["10:10", "11:08"],
                        "Core 2nd hour": ["11:08", "11:38"],
                            "Passing Time to 3rd hour": ["11:38", "11:45"],
                            "3rd hour": ["11:45", "13:15"],
                        "Core 3rd hour": ["13:15", "13:45"],
                            "Passing Time to 4th hour": ["13:45", "13:53"],
                            "4th hour": ["13:53", "14:50"],
                        "Core 4th hour": ["14:50", "15:20"],
                        "Busses Leave" : ["15:20", "15:27"],
                            "School Starts" : ["15:20", "8:35"]]
        }else{
        timeDict.timeDict = ["1st hour": ["8:35", "10:03"],
                             "Passing Time 1st hour": ["10:03", "10:10"],
                             "2nd hour": ["10:10", "11:38"],
                             "Passing Time 2nd hour": ["11:38", "11:45"],
                             "3rd hour": ["11:45", "13:45"],
                             "Passing Time 3rd hour": ["13:45", "13:53"],
                             "4th hour": ["13:53", "15:20"],
                                    "Busses Leave" : ["15:20", "15:27"],
                             "School Starts" : ["15:20", "8:35"]]
        }
    }
    
    func addLunch(enterLunch usersLunch: Int){
   
        if Int(Calendar.current.component(.weekday, from: Date())) == 3{
            let lunchTimings: [[String]] = [["11:22", "11:52"],["11:52", "12:22"], ["12:22", "12:52"], ["12:52", "13:22"]]
            var getArr =  timeDict.timeDict["3rd hour"]!
    
            
            if usersLunch == 0{
    
                getArr[0] = lunchTimings[0][1]
                timeDict.timeDict["3rd hour"] = getArr
                timeDict.timeDict["First Lunch"] = lunchTimings[0]
       
            } else if usersLunch == 1{
                
                //Add thirdLunch
                //Replace ending of third hour with the start of lunch
                getArr[1] = lunchTimings[1][0]
                //Replace thirdHour in Dicionary
                timeDict.timeDict["3rd hour"] = getArr
                //Add thirdLunch to dictionary
                timeDict.timeDict["Third Lunch"] = lunchTimings[1]
                //Add another Third hour, starting from the end of lunch to end of third normally
                timeDict.timeDict["3rd hour (2)"] = [lunchTimings[1][1], getArr[1]]

            }else if usersLunch == 2{
                print("ran this")
                getArr[1] = lunchTimings[2][0]
                //Replace thirdHour in Dicionary
                timeDict.timeDict["3rd hour"] = getArr
                //Add thirdLunch to dictionary
                timeDict.timeDict["Third Lunch"] = lunchTimings[2]
                //Add another Third hour, starting from the end of lunch to end of third normally
                timeDict.timeDict["3rd hour (2)"] = [lunchTimings[2][1], getArr[1]]

                
            }else if usersLunch == 3{
    
                // 4th lunch
                //["11:45", "13:45"]
    
                getArr[1] = lunchTimings[3][0]
                timeDict.timeDict["3rd hour"] = getArr
                timeDict.timeDict["4th Lunch"] = lunchTimings[3]
        //        print(timeDict["3rd hour"] ?? "Didnt Work")
            }
            
        }else{
            //Get there lunch. \
        //    let usersLunch = 0 //They will have a dropdown that the user can choose from
            let lunchTimings: [[String]] = [["11:45", "12:15"],["12:15", "12:45"], ["12:45", "13:15"], ["13:15", "13:45"]]
            var getArr =  timeDict.timeDict["3rd hour"]!
    
            //If they have firstLunch do that first
            if usersLunch == 0{
    
                getArr[0] = lunchTimings[0][1]
                timeDict.timeDict["3rd hour"] = getArr
                timeDict.timeDict["First Lunch"] = lunchTimings[0]
        //        print(timeDict["3rd hour"] ?? "Didnt Work")
            } else if usersLunch == 1{
                //["11:45", "13:45"]
                let thirdHourEnding = getArr[1]
                getArr[1] = lunchTimings[1][0]
                var secondArr = ["",""]
                secondArr[0] = lunchTimings[1][1]
                secondArr[1] = thirdHourEnding
                timeDict.timeDict["3rd hour"] = getArr
                timeDict.timeDict["Second Lunch"] = lunchTimings[1]
                timeDict.timeDict["3rd hour (2)"] = secondArr
            }else if usersLunch == 2{
               
                let thirdHourEnding = getArr[1]
                getArr[1] = lunchTimings[2][0]
                var secondArr = ["",""]
                secondArr[0] = lunchTimings[2][1]
                secondArr[1] = thirdHourEnding
                timeDict.timeDict["3rd hour"] = getArr
                timeDict.timeDict["Third Lunch"] = lunchTimings[1]
                timeDict.timeDict["3rd hour (2)"] = secondArr
                
                
            }else if usersLunch == 3{
    
                // 4th lunch
                //["11:45", "13:45"]
    
                getArr[1] = lunchTimings[3][0]
                timeDict.timeDict["3rd hour"] = getArr
                timeDict.timeDict["4th Lunch"] = lunchTimings[3]
      
            }
        }
    
        }
}

struct LunchSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LunchSelectionView(isShowing: Binding.constant(true))
    }
}


