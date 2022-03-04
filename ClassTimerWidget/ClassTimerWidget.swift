//
//  ClassTimerWidget.swift
//  ClassTimerWidget
//
//  Created by 90310148 on 3/3/22.
//https://stackoverflow.com/questions/65670736/how-to-refresh-multiple-timers-in-widget-ios14


import WidgetKit
import SwiftUI
import Intents
//import EPHS
//Import to access other functions.


struct Provider: IntentTimelineProvider {
    
    
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
            
        //Find timeLeft
            let entryDate = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

//This structs runs everysecond
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    //let totalTime: Date //88mins
    let timeDict =  ["1st hour": ["8:35", "10:03"],
                     "Passing Time 1st hour": ["10:03", "10:10"],
                     "2nd hour": ["10:10", "11:38"],
                     "Passing Time 2nd hour": ["11:38", "11:45"],
                     "3rd hour": ["11:45", "13:45"],
                     "Passing Time 3rd hour": ["13:45", "13:53"],
                     "4th hour": ["13:53", "15:20"],
                     "Busses Leave" : ["15:20", "15:27"],
                     "School Starts" : ["15:20", "8:35"]]
    let currentlyInSchool = false
    
    
    
    func whatHourCurrently() -> String{
        
        var whatHour: String = ""
        
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
                    currentlyInSchool = true
                    whatHour = hour
                    
                }
                
                
                
            }
            
            
        }
        if currentlyInSchool == false{
            
            
            whatHour = "School Starts"
            
            
            
            
            
        }
            return whatHour
    }
    
    func timeTheClassLastFor() -> Float{
        //THIS IS FOR PROGRESS BAR DENOMINATOR
        //THIS WILL BE A BINDING AND STATE
        
        let whatHour: String = whatHourCurrently()
        var timeInTheHour: Float = 0.0
        let arr: [String] = timeDict[whatHour] ?? [""]
        
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
        return timeInTheHour
        
    }
    
    func formatTime(minutes ms: Float) -> Date{
        
        
        var mn = ms
        mn = round(mn*100)/100
        //        print(mn)
        let hour = floor(mn/60)
        let minute = floor(mn-(hour*60))
        let seconds = round((round(mn.truncatingRemainder(dividingBy: 1)*100)/100)*60)
        
        let components = DateComponents(hour: Int(hour), minute: Int(minute), second: Int(seconds))
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        return futureDate
//        var timeLeft: String = ""
//
//        if hour == 0.0{
//            if minute == 1{
//                timeLeft="\(minute) minute and \(seconds) seconds"
//            }else{
//                timeLeft="\(minute) minutes and \(seconds) seconds"
//            }
//        }else if minute == 0.0{
//            if hour == 0.0{
//                timeLeft="\(seconds) seconds"
//            }else{
//                if hour == 1.0{
//                    timeLeft="\(hour) hour and \(seconds) seconds"
//                }else{
//                    timeLeft="\(hour) hours and \(seconds) seconds"
//                }
//            }
//
//        }else{
//            if hour == 1.0{
//                if minute == 1{
//                    timeLeft="\(hour) hour \(minute) minute and \(seconds) seconds"
//                }else{
//                    timeLeft="\(hour) hour \(minute) minutes and \(seconds) seconds"
//                }
//
//            }else{
//                if minute == 1{
//                    timeLeft="\(hour) hours \(minute) minute and \(seconds) seconds"
//                }else{
//                    timeLeft="\(hour) hours \(minute) minutes and \(seconds) seconds"
//                }
//
//            }
//
//
//        }
//
//
//        return timeLeft
    }
    
    
    func timeRemaing() -> (Date, Float){
        
        //THIS IS FOR THE NUMERATOR
        
        let today = Date()
        
        let hours   = Float((Calendar.current.component(.hour, from: today)))
        let minutes = Float((Calendar.current.component(.minute, from: today)))
        let seconds = Float(Calendar.current.component(.second, from: today))
        
        var whatHour = whatHourCurrently()
        
        
        var progress: Float = 0.0
        
        
        let timeInTheHour = timeTheClassLastFor()
        
        var valueRecieved: Date
        
        if whatHour != "School Starts"{
            
            let currentTime = (hours*60) + minutes + (seconds/60)
            
            
            
            var arr: [String] = timeDict[whatHour] ?? [""]
            //            if arr == [""]{
            //                timeDict.checkSave()
            //            }
            
            
            var timeTwo = ""
            
            //print(arr)
            
            
            //FIXED APP CRASHING
            if arr[0] == ""{
                whatHour = whatHourCurrently()
                arr = timeDict[whatHour] ?? [""]
                timeTwo = arr[1]
            
                
            }else{
                timeTwo = arr[1]
            }
            
            
            let secondTime = Float(String(timeTwo[..<timeTwo.firstIndex(of: ":")!]))!*60 + Float(String(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...]))!
            

            
            progress = Float(abs(timeInTheHour - Float(abs(secondTime-currentTime))))/timeInTheHour
           
            valueRecieved = formatTime(minutes: abs(secondTime-currentTime))
            
        }else{
            
            let arr: [String] = timeDict[whatHour] ?? [""]
            
            if hours > 12{
                
                
                var time = abs((hours*60)+minutes+(seconds/60)-(24*60))
                let endTime = arr[1]
                
                let hour = Float(endTime[..<endTime.firstIndex(of: ":")!])!*60
                let minutes = Float(endTime[endTime.index(after: endTime.firstIndex(of: ":")!)...])!
                time+=hour+minutes
                valueRecieved = formatTime(minutes: time)
                progress = Float(abs(timeInTheHour-Float(time)))/timeInTheHour
                
                
            }else{
                //This seems to work
                let currentTime = (hours*60) + minutes + (seconds/60)
                
                let arr: [String] = timeDict[whatHour] ?? [""]
                let timeTwo = arr[1]
                
                let secondTime = Float(String(timeTwo[..<timeTwo.firstIndex(of: ":")!]))!*60 + Float(String(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...]))!
                
                
                //progressValue = Float(abs(timeInTheHour - Float(abs(secondTime-currentTime))))/timeInTheHour
                
                valueRecieved = formatTime(minutes: abs(secondTime-currentTime))
            }
            
            
            
        }
        
        
        //Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        
        return (valueRecieved, progress)
    }
    
    
    
    
    
}


//ALL data fetching should be done in the timeLineProvider.
struct ClassTimerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.widgetFamily) var family
    
   
    
//    @State var whatHour: String = "1st hour"
//    @StateObject var timeDict = dictionary()
//
//    @State var timeInTheHour: Float = 0.0
//    @State var timeLeft: String = ""
    
    //@State var progressValue: Float = 0.0
    
    var body: some View {
        
        VStack{
        switch family{
        case .systemSmall:
            
            
            ProgressBarForWidget(progress: Binding.constant(entry.timeRemaing().1), timeInTheClass: Binding.constant(88)).overlay{
                VStack{
                    
                    Text(entry.whatHourCurrently()).fontWeight(.light)
                    HStack{ //maybe remove hStack here
                
                        Text(entry.timeRemaing().0, style: .timer).fontWeight(.light).multilineTextAlignment(.center).padding(2)
                    }
                    
                }
            }
//            Text("1:02:03").multilineTextAlignment(.center).padding(.bottom).padding(.trailing).padding(.leading)
//        case .systemMedium:
//            ProgressBarForWidget(progress: Binding.constant(0.4), timeInTheClass: Binding.constant(88)).overlay{
//                Text("1st Hour")
//            }
//            HStack{
//                Spacer()
//                //Text(entry.date, style: .timer)
//                //Apparently needs String
//                Text(entry.timeRemaing(), style: .timer)
//                Spacer()
//            }
//            Text("1 hour : 2 minutes : 3 seconds left").multilineTextAlignment(.center).padding(.bottom).padding(.trailing).padding(.leading)
        default:
            Text("NA")
        }
        
        
        }
        
    }
    
    
    

    
    
    
    //    Add Lunch Functino here
    
    


struct ProgressBarForWidget: View {
    @Binding var progress: Float
    @Binding var timeInTheClass: Float
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .padding()
                .foregroundColor(Color.red.opacity(0.5))
            
            LinearGradient(gradient: Gradient(colors: colorScheme == .dark ? [Color(red: 173/255, green: 14/255, blue: 14/255), colorScheme == .dark ? Color(red: 205/255, green: 149/255, blue: 149/255): Color.black] : [Color.red, Color.black]), startPoint: .top, endPoint: .bottom)
            .mask(
                //MASK ADD COLOR TO FORGROUND OFF ALL OBJECTS IN HERE
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: (progress >= 0.9 ? .square: .round), lineJoin: .round))
                    .padding()
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.linear, value: progress)
            
            
            )
            
            
        }
        
        
    }
}






@main
struct ClassTimerWidget: Widget {
    let kind: String = "ClassTimerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ClassTimerWidgetEntryView(entry: entry)
        }.supportedFamilies([.systemSmall])//Add .systemMedium in array here
        .configurationDisplayName("EPHS Class Timer Widget")
        .description("This is an example widget.")
    }
}

struct ClassTimerWidget_Previews: PreviewProvider {
    static var previews: some View {
        ClassTimerWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
}
