//
//  ContentView.swift
//  TimeRemaining
//
//  Created by 90310148 on 2/6/22.
//
import SwiftUI
import Foundation


//Live updating swiftUI time done

struct ContentView: View {
    
    //This might work IDEK
    //ADD A LUNCH FUNCTION
    
    @State var progressValue: Float = 0.0
    @State var currentTime: String = "Time:"
    var timeDict = ["1st hour": ["8:35", "10:03"],
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
                if currentDay != "Tuesday"{
                    Text("\(currentDay) - regular day")
                        .font(.headline)
                        .fontWeight(.semibold).padding(.leading, 60.0)
                }else{
                    Text("\(currentDay) - Flex")
                }
                    Spacer()
                    Button(action:{
                        
                    }){
                        Image(systemName: "gearshape.fill").resizable().frame(width: 25.0, height: 25.0)
                    }.padding()
                    
                    
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
                        Text("\(timeLeft) left").fontWeight(.light).padding()
                    }
                    
                }
                
                Spacer()
                
            }
            
            
        }.onAppear{functionThatEncapsulatesALL(); print("ran code")}
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
           
            if progressValue/timeInTheHour >= 1{
    
//                functionThatEncapsulatesALL()
//                Timer.invalidate()
                //Those 2 lines OR these 2 lines
                progressValue = 0
                whatHourCurrently()
                timeTheClassLastFor()
            }
            
            
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
    
    func formatTime(minutes mn: Int){
        let minutes = mn%60
        let hours = Int(floor(Double(mn/60)))
        timeLeft="\(String(hours)) hour and \(minutes) minutes"
        //        if String(minutes).count == 1{
        //            timeLeft="\(String(hours)) hour and 0\(minutes) minutes"
        //        }else{
        //            timeLeft="\(String(hours)) hour and \(minutes) minutes"
        //        }
        
        
        
        
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
            
            formatTime(minutes: Int(abs(secondTime-currentTime)))
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
                formatTime(minutes: Int(time))
                progressValue = Float(abs(timeInTheHour-Float(time)))
                
                
            }else{
                //This seems to work
                let currentTime = (hours*60) + minutes + (seconds/60)
                
                let arr: [String] = timeDict[whatHour] ?? [""]
                let timeTwo = arr[1]
                
                let secondTime = Float(String(timeTwo[..<timeTwo.firstIndex(of: ":")!]))!*60 + Float(String(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...]))!
                
                
                progressValue = Float(abs(timeInTheHour - Float(abs(secondTime-currentTime))))
                
                formatTime(minutes: Int(abs(secondTime-currentTime)))
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
