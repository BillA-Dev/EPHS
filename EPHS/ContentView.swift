//
//  ContentView.swift
//  TimeRemaining
//
//  Created by 90310148 on 2/6/22.
//Commit Comment



import SwiftUI
import Foundation
import AudioToolbox


//Live updating swiftUI time done

struct ContentView: View {
    
    //This might work IDEK
    //ADD A LUNCH FUNCTION
    
    @State var progressValue: Float = 0.0
    @State var currentTime: String = "Time:"
    @State var timeDict = ["1st hour": ["8:35", "10:03"],
                    "Passing Time 1st hour": ["10:03", "10:10"],
                    "2nd hour": ["10:10", "11:38"],
                    "Passing Time 2nd hour": ["11:38", "11:45"],
                    "3rd hour": ["11:45", "13:45"],
                    "Passing Time 3rd hour": ["13:45", "13:53"],
                    "4th hour": ["13:53", "15:20"],
                    "School Starts" : ["15:20", "8:35"]]
    
    
    
    @State var timeInTheHour: Float = 0.0
    @State var timeLeft: String = ""
    
    @State var whatHour: String = "1st hour"
    
    var dates = [1:"Sunday", 2: "Monday", 3: "Tuesday", 4:"Wednesday", 5:"Thursday", 6:"Friday", 7:"Saturday"]
    
    
    //Vars here
    
    @State var currentDay: String = "Monday-RegularDay"
    
    
    
    var body: some View {
        
        //Test this later
        
        
        ZStack{
            
            
            
            
            VStack{
                
                HStack{
                    Spacer()
                    Button(action:{
                        
                    }){
                        Image(systemName: "arrowshape.turn.up.backward.fill").resizable().frame(width: 25.0, height: 25.0)
                    }.padding()
                    Spacer()
                    if currentDay == "Tuesday"{
                        Text("\(currentDay) - Flex")
                            .font(.headline)
                            .fontWeight(.semibold).padding()
                    }else if currentDay == "Thursday" {
                        Text("\(currentDay) - Core")
                            .font(.headline)
                            .fontWeight(.semibold).padding(.leading, 60.0)
                    }else{
                        Text("\(currentDay) - Regular Day")
                            .font(.headline)
                            .fontWeight(.semibold).padding()
                    }
                    Spacer()
                    Button(action:{
                        
                    }){
                        Image(systemName: "gearshape.fill").resizable().frame(width: 25.0, height: 25.0)
                    }.padding()
                    Spacer()
                    
                    
                }
                Spacer()
                
                
                ProgressBar(progress: $progressValue, timeInTheClass: $timeInTheHour).overlay{
                    
                    VStack {
                        Text("Time Remaining")
                            .font(.title)
                            .fontWeight(.bold)
                        if whatHour != "School Starts"{
                            Text("until \(whatHour) ends")
                        }else if whatHour.contains("Passing Time"){
                            Text("until passing time ends")
                        }else{
                            Text("until \(whatHour)")
                        }
                        Text("\(timeLeft) left").font(.caption).fontWeight(.light).padding()
                    }.padding()
                    
                }
                
                Spacer()
                
            }
            
            
        }.onAppear{functionThatEncapsulatesALL(); print("ran code")}
    }
    
    func changeTimeDict(){
        if currentDay == "Tuesday"{
            timeDict = ["1st hour": ["8:35", "9:38"],
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
                            "School Starts" : ["15:20", "8:35"]]
        }else if currentDay == "Thursday"{
            timeDict = ["1st hour": ["8:35", "9:33"],
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
                            "School Starts" : ["15:20", "8:35"]]
        }
    }
    
    func getDayOfTheWeek(){
        let today = Date()
        let day = Int(Calendar.current.component(.weekday, from: today))
        print(day)
        currentDay = dates[day]!
    }
    
    
    //Functions Here
    
    private func functionThatEncapsulatesALL(){
        //Get  date here
        getDayOfTheWeek()
        whatHourCurrently()
        timeTheClassLastFor()
        runTimer()
    }
    
    func runTimer(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
            
            timeRemaing()
            getDayOfTheWeek()
            changeTimeDict()
            whatHourCurrently()
            timeTheClassLastFor()
            
            if progressValue/timeInTheHour >= 1{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
//            if progressValue/timeInTheHour >= 1{
//
//                //                functionThatEncapsulatesALL()
//                //                Timer.invalidate()
//                //Those 2 lines OR these 2 lines
//                //Wait function - about a seconds before executing
//                sleep(1)
//                progressValue = 0
//                whatHourCurrently()
//                timeTheClassLastFor()
//            }
            
            
        }
    }
    
    func whatHourCurrently(){
        
        let today = Date()
        
        var hours   = Double((Calendar.current.component(.hour, from: today)))
        let minutes = Double((Calendar.current.component(.minute, from: today)))
        let seconds = Double((Calendar.current.component(.second, from: today)))
        
        
        
        hours = hours*60
        hours = hours + minutes + (seconds/60)
        
        
        
        var currentlyInSchool = false
        
        
        timeDict.forEach{hour, time in
            let beginningTime = time[0]
            let endingTime = time[1]
            
            let beginningTimeHour = Double(beginningTime[..<beginningTime.firstIndex(of: ":")!]) ?? 0
            
            
            let beginningTimeMinute = Double(beginningTime[beginningTime.index(after: beginningTime.firstIndex(of: ":")!)..<beginningTime.endIndex]) ?? 0
            
            
            let endingTimeHour = Double(endingTime[..<endingTime.firstIndex(of: ":")!]) ?? 0
            
            
            let endingTimeMinute = Double(endingTime[beginningTime.index(after: endingTime.firstIndex(of: ":")!)..<endingTime.endIndex]) ?? 0
            
            
            if hours>=beginningTimeHour*60 + beginningTimeMinute && hours<=endingTimeHour * 60 + endingTimeMinute{
                
                if hour != "School Starts"{
                    whatHour = hour
                    currentlyInSchool = true
                }
                
                
                
            }
            
            
        }
        if currentlyInSchool == false{
            
            
            whatHour = "School Starts"
            
            
            
            
            
        }
    }
    
    func timeTheClassLastFor(){
        //THIS IS FOR PROGRESS BAR DENOMINATOR
        //THIS WILL BE A BINDING AND STATE
        
        let arr: [String] = timeDict[whatHour] ?? [""] //OR !
        
        let timeOne = arr[0]
        let timeTwo = arr[1]
        if whatHour != "School Starts"{
            let firstTime = Int(String(timeOne[..<timeOne.firstIndex(of: ":")!]))!*60 + Int(String(timeOne[timeOne.index(after: timeOne.firstIndex(of: ":")!)...]))!
            let secondTime = Int(String(timeTwo[..<timeTwo.firstIndex(of: ":")!]))!*60 + Int(String(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...]))!
            timeInTheHour = Float(abs(secondTime-firstTime))
        }else{
            
            
            
            let startHour = Int(timeOne[..<timeOne.firstIndex(of: ":")!])!
            let StartMinutes = Int(timeOne[timeOne.index(after: timeOne.firstIndex(of: ":")!)...])!
            
            let endHour = Int(timeTwo[..<timeTwo.firstIndex(of: ":")!])!*60
            let endMinutes = Int(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...])!
            
            var time = abs((startHour*60)+StartMinutes-(24*60))
            time+=endHour+endMinutes
            timeInTheHour = Float(time)
            
            
        }
        
        
    }
    
    func formatTime(minutes mn: Float){
        let hour = floor(mn/60)
        let minute = floor(mn-(hour*60))
        let seconds = floor((mn-(hour*60)-minute)*60)
        if hour == 0.0{
            if minute == 1{
                timeLeft="\(minute) minute and \(seconds) seconds"
            }else{
                timeLeft="\(minute) minutes and \(seconds) seconds"
            }
        }else if minute == 0.0{
            if hour == 0.0{
                timeLeft="\(seconds) seconds"
            }else{
                if hour == 1.0{
                    timeLeft="\(hour) hour and \(seconds) seconds"
                }else{
                    timeLeft="\(hour) hours and \(seconds) seconds"
                }
            }
            
        }else{
            if hour == 1.0{
                if minute == 1{
                    timeLeft="\(hour) hour \(minute) minute and \(seconds) seconds"
                }else{
                    timeLeft="\(hour) hour \(minute) minutes and \(seconds) seconds"
                }

            }else{
                if minute == 1{
                    timeLeft="\(hour) hours \(minute) minute and \(seconds) seconds"
                }else{
                    timeLeft="\(hour) hours \(minute) minutes and \(seconds) seconds"
                }
                
            }
        
        
    }
    
    }
    func timeRemaing(){
        
        //THIS IS FOR THE NUMERATOR
        let today = Date()
        
        let hours   = Float((Calendar.current.component(.hour, from: today)))
        let minutes = Float((Calendar.current.component(.minute, from: today)))
        let seconds = Float(Calendar.current.component(.second, from: today))
        
        if whatHour != "School Starts"{
            
            let currentTime = (hours*60) + minutes + (seconds/60)
            
            let arr: [String] = timeDict[whatHour] ?? [""]
            let timeTwo = arr[1]
            
            let secondTime = Float(String(timeTwo[..<timeTwo.firstIndex(of: ":")!]))!*60 + Float(String(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...]))!
            
            
            progressValue = Float(abs(timeInTheHour - Float(abs(secondTime-currentTime))))
            
            formatTime(minutes: abs(secondTime-currentTime))
        }else{
            
            let arr: [String] = timeDict[whatHour] ?? [""]
            
            if hours > 12{
                
                //First subtract real time from 24 hours
                //Then add startTime*60 + m
                //Turn that into mins
                var time = abs((hours*60)+minutes+(seconds/60)-(24*60))
                let endTime = arr[1]
                
                let hour = Float(endTime[..<endTime.firstIndex(of: ":")!])!*60
                let minutes = Float(endTime[endTime.index(after: endTime.firstIndex(of: ":")!)...])!
                time+=hour+minutes
                formatTime(minutes: time)
                progressValue = Float(abs(timeInTheHour-Float(time)))
                
                
            }else{
                //This seems to work
                let currentTime = (hours*60) + minutes + (seconds/60)
                
                let arr: [String] = timeDict[whatHour] ?? [""]
                let timeTwo = arr[1]
                
                let secondTime = Float(String(timeTwo[..<timeTwo.firstIndex(of: ":")!]))!*60 + Float(String(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...]))!
                
                
                progressValue = Float(abs(timeInTheHour - Float(abs(secondTime-currentTime))))
                
                formatTime(minutes: abs(secondTime-currentTime))
            }
            
            
            
        }
        
        
        //Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        
        
    }
    
    
    
    //    Add Lunch Functino here
    //    func addLunch(enterLunch usersLunch: Int){
    //
    //
    //        //This will also be connected to a database, lunch timings
    //
    //        //Get there lunch. \
    //    //    let usersLunch = 0 //They will have a dropdown that the user can choose from
    //        let lunchTimings: [[String]] = [["11:45", "12:15"],["12:15", "12:45"], ["12:45", "13:15"], ["13:15", "13:45"]]
    //        var getArr = timeDict["3rd hour"]!
    //
    //        //If they have firstLunch do that first
    //        if usersLunch == 0{
    //
    //            getArr[0] = lunchTimings[0][1]
    //            timeDict["3rd hour"] = getArr
    //            timeDict["First Lunch"] = lunchTimings[0]
    //    //        print(timeDict["3rd hour"] ?? "Didnt Work")
    //        } else if usersLunch == 1{
    //            //["11:45", "13:45"]
    //            let thirdHourEnding = getArr[1]
    //            getArr[1] = lunchTimings[1][0]
    //            var secondArr = ["",""]
    //            secondArr[0] = lunchTimings[1][1]
    //            secondArr[1] = thirdHourEnding
    //            timeDict["3rd hour"] = getArr
    //            timeDict["Second Lunch"] = lunchTimings[1]
    //            timeDict["3rd hour (2)"] = secondArr
    //        }else if usersLunch == 2{
    //            let thirdHourEnding = getArr[1]
    //            getArr[1] = lunchTimings[2][0]
    //            var secondArr = ["",""]
    //            secondArr[0] = lunchTimings[2][1]
    //            secondArr[1] = thirdHourEnding
    //            timeDict["3rd hour"] = getArr
    //            timeDict["Third Lunch"] = lunchTimings[1]
    //            timeDict["3rd hour (2)"] = secondArr
    //        }else if usersLunch == 3{
    //
    //            // 4th lunch
    //            //["11:45", "13:45"]
    //
    //            getArr[1] = lunchTimings[3][0]
    //            timeDict["3rd hour"] = getArr
    //            timeDict["4th Lunch"] = lunchTimings[3]
    //    //        print(timeDict["3rd hour"] ?? "Didnt Work")
    //        }
    //
    //    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
