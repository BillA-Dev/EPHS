//
//  TestNewMethod.swift
//  EPHS
//
//  Created by 90310148 on 4/22/22.
//

import SwiftUI
import WidgetKit



struct TestNewMethod: View {
    @EnvironmentObject var dict: dictionary
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("final_tutorial") var isTutorialPresented: Bool = true
    @State var isTutorialPresentedState: Bool = false
    
    var dates = [1:"Sunday", 2: "Monday", 3: "Tuesday", 4:"Wednesday", 5:"Thursday", 6:"Friday", 7:"Saturday"]
    
    
    @State var timeRemainingText: String = "LOADING..."
    
    @State var timeInTheHour: Float = 0
    
    @State var progressValue: Float = 0
    
    @State var getCurrentHour: String = "LOADING..."
    
    @State var isToDoListShowing = false
    @State var showingSettings = false
    @State var opac = 0.0
    
    
    
    //Testing purposes
    @State var test = ""
    @State var x = 0
    //
    
    
    
    @State var currentDay: String = ""
    
    var body: some View {
        
        //Time in the hour isnt used
        
        ZStack{
            VStack{
                HStack{
                    
                    
                    Spacer()
                    
                    
                    Button(action:{
                        isToDoListShowing = true
                    }){
                        Image(systemName: "square.and.pencil").resizable().frame(width: 25.0, height: 25.0)
                    }.padding()
                    
                    
                    Spacer()
                    Text("\(currentDay)")
                        .font(.headline)
                        .fontWeight(.semibold).padding()
                    Spacer()
                    Button(action:{
                        showingSettings.toggle()
                        
                        if showingSettings == false{
                            
                            opac = 0.5
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            if showingSettings == true{
                                opac = 1
                            }
                        }
                        opac = 0.5
                        
                        
                        
                    }){
                        Image(systemName: "gearshape.fill").resizable().frame(width: 25.0, height: 25.0)
                    }.padding()
                    Spacer()
                    
                    
                }.popover(isPresented: $isToDoListShowing) {
                    ToDoList(currentHour: $getCurrentHour)
                }
                Spacer()
                
                ProgressBar(progress: $progressValue, timeInTheClass: $timeInTheHour).overlay{
                    
                    VStack {
                        Text("Time Remaining")
                            .font(.title)
                            .fontWeight(.bold)
                        VStack{
                            Text(getCurrentHour).font(.caption).fontWeight(.light).padding()
                            Text(timeRemainingText).font(.caption).fontWeight(.light).padding().onAppear{
                                
                                WidgetCenter.shared.reloadAllTimelines()
                                
                                dict.savedDict = dict.timeDict
                                
                                //IF LUNCH Chosen
                                for (index, value) in dict.timeDict{
                                    dict.timeDict[index] = value.map{$0.timeToMinutes()
                                    }
                                }
                                
                                addSchoolStart()
                                
                                ///Check if it works or not
                                //                                    let x = UserDefaults.standard.bool(forKey: "isLunchToggleOn")
                                //                                    print(x)
                                //                                        if x == true{
                                //                                            if let val = UserDefaults.standard.string(forKey: "whatLunchSelected"){
                                //                                                if !val.isEmpty{
                                //                                                dict.addLunchToDict(userSelectedLunch: val)
                                //                                                }
                                //                                            }
                                //                                        }
                                
                                
                                
                                
                                //print(dict.timeDict)
                                
                                getCurrentHour = getHourCurrently().0
                                timeRemaining(currentHourIn: getCurrentHour)
                                
                                DispatchQueue.main.async {
                                    
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true){timer in
                                        
                                       
                                        getCurrentHour = getHourCurrently().0
                                        timeRemaining(currentHourIn: getCurrentHour)
                                        
                                        
                                    }
                                }
                                
                                
                                
                                
                            }
                            
                            
                            
                        }
                    }.padding()
                        .onChange(of: getCurrentHour) { V in
                            //Time line is werid, IDK/
                            WidgetCenter.shared.reloadAllTimelines()
                            print("refreshing widget")
                        }
                    
                }
                
                
            }.onAppear{
                let today = Date()
                let day = Int(Calendar.current.component(.weekday, from: today))
                
                currentDay = dates[day]!
                
                if isTutorialPresented{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    isTutorialPresentedState = isTutorialPresented
                }
                }
                
            }
            //Have to make this dynamic as wel
            
            LunchSelectionView(isShowing: $showingSettings, opacity: $opac)
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                WidgetCenter.shared.reloadAllTimelines()
            } else if newPhase == .inactive {
                WidgetCenter.shared.reloadAllTimelines()
            } else if newPhase == .background {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .sheet(isPresented: $isTutorialPresentedState, onDismiss: {
            isTutorialPresented = isTutorialPresentedState
        }) {
            MainTutorialScreen(tutorialStarted: $isTutorialPresentedState)
                .interactiveDismissDisabled(true)
        }
        
       
       
        
    }
    
    
    
    func addLunchToDict(hourThatWillBeAffected h: String, userSelectedLunch selectedLunch: String){
        //Get this arr from my dict.
        var lunch = ["First Lunch": ["11:45", "12:15"], "Second Lunch": ["12:15", "12:45"], "Third Lunch": ["12:45", "13:15"], "Fourth Lunch": ["13:15", "13:45"]]
        for (index, value) in lunch{
            lunch[index] = value.map{$0.timeToMinutes()
            }
        }
        
        //print(lunch)
        let arr = dict.timeDict[h]!
        
        //Start of third hour to start of lunch
        //add Lunch Timings
        //End of lunch to end of third hour.
        if arr[0] == lunch[selectedLunch]![0]{
            //we know that this is "First Lunch"
            //Save timeDict beforeHand or just fetch from database again
            dict.timeDict[selectedLunch] = lunch[selectedLunch]
            dict.timeDict[h] = [lunch[selectedLunch]![1], dict.timeDict[h]![1]]
            
            // print("firstLunch")
        }else if arr[1] == lunch[selectedLunch]![1]{
            //We know this is "Fourth lunch"
            //print("fourthLunch")
            
            dict.timeDict[selectedLunch] = lunch[selectedLunch]
            dict.timeDict[h] = [dict.timeDict[h]![0], lunch[selectedLunch]![0]]
            
        }else{
            //The hardest one on this.
            let arrSaved = arr
            dict.timeDict[h] = [dict.timeDict[h]![0], lunch[selectedLunch]![0]]
            dict.timeDict[selectedLunch] = lunch[selectedLunch]
            dict.timeDict["\(h)2"] = [lunch[selectedLunch]![1], arrSaved[1]]
        }
        
        //Have to split the array into 2
        
        
        
    }
    
    
    
    
    func timeRemaining(currentHourIn whatHour: String){
        
        func formatTime(enterTime t: Double){
            //This prints the formatedTime
            
            let mn = round(t*100)/100
            let hour = floor(mn/60)
            let minute = floor(mn-(hour*60))
            let seconds = round((round(mn.truncatingRemainder(dividingBy: 1)*100)/100)*60)
            
            timeRemainingText = "Hour: \(hour) Minute: \(minute) Second: \(seconds)"
            
        }
        //Gets date
        let today = Date()
        var hours = Double((Calendar.current.component(.hour, from: today)))
        let minutes = Double((Calendar.current.component(.minute, from: today)))
        let seconds = Double((Calendar.current.component(.second, from: today)))
        //Testing purposes
        ///print("Hour: \(hours) Minute: \(minutes) Second: \(seconds)")
        
        
        hours = hours*60
        hours = hours + minutes + (seconds/60)
        
        guard let lastTime = Double(dict.timeDict[whatHour]![1]) else { return }
        
        ///print(abs(hours - lastTime))
        
        //This formats the time
        if whatHour != "School Starts"{
            formatTime(enterTime: abs(hours - lastTime))
            progressValue = Float(abs((abs(hours - lastTime) - Double(getHourCurrently().1))) / Double(getHourCurrently().1))
        }else{
            //Have to find the time remaining
            //....
            // print(hours)
            if hours > 12*60{
                //Figure this out
                
                formatTime(enterTime: abs(24*60 - hours + lastTime))
                progressValue = Float(abs((abs(24*60 - hours + lastTime) - Double(getHourCurrently().1))) / Double(getHourCurrently().1))
            }else{
                
                // print(hours)
                formatTime(enterTime: abs(hours - lastTime))
                progressValue = Float(abs((abs(hours - lastTime) - Double(getHourCurrently().1))) / Double(getHourCurrently().1))
            }
        }
        
        
        //Change progress value
        
        
    }
    
    
    func addSchoolStart(){
        var min = Int.max
        var max = Int.min
        
        for (_, value) in dict.timeDict{
            if Int(value[1])! > max{
                max = Int(value[1])!
            }
            if Int(value[0])! < min{
                min = Int(value[0])!
            }
        }
        
        dict.timeDict["School Starts"] = [String(max), String(min)]
    }
    
    
    func getHourCurrently() -> (String, Int){
        func timeInHour(enterNameOfClass clas: String, hourName: String) -> Int{
            if hourName != "School Starts"{
                return abs(Int(dict.timeDict[clas]![0])! - Int(dict.timeDict[clas]![1])!)
                
            }else{
                
                //24 - 3:20 + 8:35
                return (24*60 - Int(dict.timeDict[hourName]![0])! + Int(dict.timeDict[hourName]![1])!)
                
            }
        }
        
        //print(dict.timeDict)
        let today = Date()
        var hours = Double((Calendar.current.component(.hour, from: today)))
        let minutes = Double((Calendar.current.component(.minute, from: today)))
        let seconds = Double((Calendar.current.component(.second, from: today)))
        hours = hours*60
        hours = hours + minutes + (seconds/60)
        
        var hourName: String = ""
        
        var currentlyInSchool = false
        
        
        for (index, value) in dict.timeDict{
            
            if hours >= Double(value[0])! && hours <= Double(value[1])!{
                if index != "School Starts"{
                    hourName = index
                    currentlyInSchool = true
                }
                
                
            }
            
            
        }
        
        if !currentlyInSchool{
            hourName = "School Starts"
        }
        
        
        return (hourName, timeInHour(enterNameOfClass: hourName, hourName: hourName))
        //This should return how much time in the hour!
        //Nest a function inside of this.
    }
    
    
    
}

struct TestNewMethod_Previews: PreviewProvider {
    static var previews: some View {
        TestNewMethod()
    }
}
