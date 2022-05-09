//
//  EPHS_Timer_Widget.swift
//  EPHS Timer Widget
//
//  Created by 90310148 on 4/29/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    //Timer.publish(every: 1, on: .current, in: .defualt).autoConnect()
    var d = dictionary()
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), progress: Binding.constant(12.0), timeInClass: Binding.constant(88.0), classTimeRemaining: (0.0, 0.0, 0.0), currentHour: "1st Hour", p: "test")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), progress: Binding.constant(12.0), timeInClass: Binding.constant(88.0), classTimeRemaining: (0.0, 0.0, 0.0), currentHour: "1st Hour", p: "test")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
       
        
        let entries = [SimpleEntry(date: Date(), progress: Binding.constant(timeRemaining().0), timeInClass: Binding.constant(88.0), classTimeRemaining: timeRemaining().1, currentHour: timeRemaining().2, p: String(timeRemaining().0))]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    
    func getInformation() -> [String: [String]]{
        d.getInfo()
        for (index, value) in d.timeDict{
            if d.timeDict[index]![0].contains(":"){
            d.timeDict[index] = value.map{$0.timeToMinutes()
            }
            }
        }
        return d.timeDict
    }
    
    
    
    func timeRemaining() -> (Float, (hour: Double, minute: Double, seconds: Double), String){
        let timeDict: [String: [String]] = getInformation()
        print(timeDict)
        
        var progressValue: Float = 0.0
        var remTime: (hour: Double, minute: Double, seconds: Double) = (0.0, 0.0, 0.0)
        var getHour: String = getHourCurrently(timeDict: timeDict).0
        
        
        //Function
        func getHourCurrently(timeDict: [String: [String]]) -> (String, Int){
            func timeInHour(enterNameOfClass clas: String, hourName: String) -> Int{
                if hourName != "School Starts"{
                    return abs(Int(timeDict[clas]![0])! - Int(timeDict[clas]![1])!)
                    
                }else{
                    
                    //24 - 3:20 + 8:35
                    return (24*60 - Int(timeDict[hourName]![0])! + Int(timeDict[hourName]![1])!)
                    
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
            
            
            for (index, value) in timeDict{
                
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
        
        
        
       
        func formatTime(enterTime t: Double) -> (hour: Double, minute: Double, seconds: Double){
            //This prints the formatedTime
         
            
            let mn = round(t*100)/100
            let hour = floor(mn/60)
            let minute = floor(mn-(hour*60))
            let seconds = round((round(mn.truncatingRemainder(dividingBy: 1)*100)/100)*60)
            return (hour, minute, seconds)
//           // timeRemainingText = "Hour: \(hour) Minute: \(minute) Second: \(seconds)"
            
        }
        //Gets date
        let today = Date()
        var hours = Double((Calendar.current.component(.hour, from: today)))
        let minutes = Double((Calendar.current.component(.minute, from: today)))
        let seconds = Double((Calendar.current.component(.second, from: today)))
        //Testing purposes
        ///print("Hour: \(hours) Minute: \(minutes) Second: \(seconds)")
        
        
        var whatHour = getHourCurrently(timeDict: timeDict).0
        
        hours = hours*60
        hours = hours + minutes + (seconds/60)
        
        guard let lastTime = Double(timeDict[whatHour]![1]) else { return (0.0, (0.0,0.0,0.0), "") }
        
        ///print(abs(hours - lastTime))
        
        //This formats the time
        if whatHour != "School Starts"{
            remTime = formatTime(enterTime: abs(hours - lastTime))
            progressValue = Float(abs((abs(hours - lastTime) - Double(getHourCurrently(timeDict: timeDict).1))) / Double(getHourCurrently(timeDict: timeDict).1))
        }else{
            //Have to find the time remaining
                //....
           // print(hours)
            if hours > 12*60{
                //Figure this out
                
                remTime = formatTime(enterTime: abs(24*60 - hours + lastTime))
                progressValue = Float(abs((abs(24*60 - hours + lastTime) - Double(getHourCurrently(timeDict: timeDict).1))) / Double(getHourCurrently(timeDict: timeDict).1))
            }else{
                
               // print(hours)
                remTime = formatTime(enterTime: abs(hours - lastTime))
                progressValue = Float(abs((abs(hours - lastTime) - Double(getHourCurrently(timeDict: timeDict).1))) / Double(getHourCurrently(timeDict: timeDict).1))
            }
        }
        
        
        //Change progress value
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            WidgetCenter.shared.reloadAllTimelines()
//        }
        return (progressValue, remTime, getHour)
    }
    
    
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let progress: Binding<Float>
    let timeInClass: Binding<Float>
    let reciever = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    let classTimeRemaining: (hour: Double, minute: Double, seconds: Double)
    
    
    let currentHour: String
    
    let p: String
    
   
}

struct EPHS_Timer_WidgetEntryView : View {
    var entry: Provider.Entry
    
  
    @State var S: String = ""
    
    var component: DateComponents
    var futureDate: Date
    
    init(entry: Provider.Entry){
        self.entry = entry
        component = DateComponents(hour: Int(entry.classTimeRemaining.hour), minute: Int(entry.classTimeRemaining.minute), second: Int(entry.classTimeRemaining.seconds))
        futureDate = Calendar.current.date(byAdding: component, to: Date())!
    }
    //var text = entry.progress
    
    var body: some View {
        
        ProgressBar(progress: entry.progress, timeInTheClass: entry.timeInClass, lineWidth: 10)
           .overlay{
               VStack{
                   Text(entry.currentHour)
                   Text(futureDate, style: .timer).multilineTextAlignment(.center)
               
               }
            }
           
    }
}

@main
struct EPHS_Timer_Widget: Widget {
    let kind: String = "EPHS_Timer_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EPHS_Timer_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct EPHS_Timer_Widget_Previews: PreviewProvider {
    static var previews: some View {
        EPHS_Timer_WidgetEntryView(entry: SimpleEntry(date: Date(), progress: Binding.constant(0.5), timeInClass: Binding.constant(88), classTimeRemaining: (0.0, 0.0, 0.0), currentHour: "Test", p: "test"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
