//
//  ClassTimerWidget.swift
//  ClassTimerWidget
//
//  Created by 90310148 on 3/3/22.
//https://stackoverflow.com/questions/65670736/how-to-refresh-multiple-timers-in-widget-ios14

//I can access userDefaults now.
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
       
            
            
        
            let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
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
    
    func formatTime(minutes ms: Float) -> (Date, Int){
        
        
        var mn = ms
        mn = round(mn*100)/100
        //        print(mn)
        let hour = floor(mn/60)
        let minute = floor(mn-(hour*60))
        let seconds = round((round(mn.truncatingRemainder(dividingBy: 1)*100)/100)*60)
        
        let components = DateComponents(hour: Int(hour), minute: Int(minute), second: Int(seconds))
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        
        //may
        
        
        return (futureDate, (Int(hour*3600) + Int(minute*60) + Int(seconds)))
        
    }
    
    
    func timeRemaing() -> (Date, Float, Int){
        
        //THIS IS FOR THE NUMERATOR
        
        let today = Date()
        
        let hours   = Float((Calendar.current.component(.hour, from: today)))
        let minutes = Float((Calendar.current.component(.minute, from: today)))
        let seconds = Float(Calendar.current.component(.second, from: today))
        
        var whatHour = whatHourCurrently()
        
        
        var progress: Float = 0.0
        
        
        let timeInTheHour = timeTheClassLastFor()
        
        var valueRecieved: Date
        var secondsRecievedFromformatTime: Int
        
        if whatHour != "School Starts"{
            
            let currentTime = (hours*60) + minutes + (seconds/60)
            
            
            
            var arr: [String] = timeDict[whatHour] ?? [""]
            
            
            
            var timeTwo = ""
            
            
            if arr[0] == ""{
                whatHour = whatHourCurrently()
                arr = timeDict[whatHour] ?? [""]
                timeTwo = arr[1]
                
                
            }else{
                timeTwo = arr[1]
            }
            
            
            let secondTime = Float(String(timeTwo[..<timeTwo.firstIndex(of: ":")!]))!*60 + Float(String(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...]))!
            
            
            
            progress = Float(abs(timeInTheHour - Float(abs(secondTime-currentTime))))/timeInTheHour
            
            let x = formatTime(minutes: abs(secondTime-currentTime))
            valueRecieved = x.0
            secondsRecievedFromformatTime = x.1
            
        }else{
            
            let arr: [String] = timeDict[whatHour] ?? [""]
            
            if hours > 12{
                
                
                var time = abs((hours*60)+minutes+(seconds/60)-(24*60))
                let endTime = arr[1]
                
                let hour = Float(endTime[..<endTime.firstIndex(of: ":")!])!*60
                let minutes = Float(endTime[endTime.index(after: endTime.firstIndex(of: ":")!)...])!
                time+=hour+minutes
                let x = formatTime(minutes: time)
                valueRecieved = x.0
                secondsRecievedFromformatTime = x.1
                
                progress = Float(abs(timeInTheHour-Float(time)))/timeInTheHour
                
                
            }else{
                //This seems to work
                let currentTime = (hours*60) + minutes + (seconds/60)
                
                let arr: [String] = timeDict[whatHour] ?? [""]
                let timeTwo = arr[1]
                
                let secondTime = Float(String(timeTwo[..<timeTwo.firstIndex(of: ":")!]))!*60 + Float(String(timeTwo[timeTwo.index(after: timeTwo.firstIndex(of: ":")!)...]))!
                
                
                progress = Float(abs(timeInTheHour - Float(abs(secondTime-currentTime))))/timeInTheHour
                
                let x = formatTime(minutes: abs(secondTime-currentTime))
                valueRecieved = x.0
                secondsRecievedFromformatTime = x.1
            }
            
            
            
        }
        
        
        
        
        return (valueRecieved, progress, secondsRecievedFromformatTime)
    }
    
    func getLunchSelectionThatWasPicked() -> Int{
        //First see if lunch was picked.
        //https://stackoverflow.com/questions/63922032/share-data-between-main-app-and-widget-in-swiftui-for-ios-14
        return (UserDefaults(suiteName: "group.edu.ephs2020.widgetTest")?.integer(forKey: "pickedLunch"))!
        
        
        //If let userDefaults
    }
    
    //So weird might have to run the widget everysecond.
    
    
    //ADD Function that encapsulates all here.
    
    
    
    
    
    
    
}


//ALL data fetching should be done in the timeLineProvider.
struct ClassTimerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var time: Date {
        return entry.timeRemaing().0
        
    }
    
    @State var prog: Float = 0.95
    
    
    var body: some View {
 
        VStack{
            
            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { Timer in
                let x = entry.timeRemaing().2
                print(x)
                if x == 0{
                    print("Called this")
                    //Calling this, but why is the view not updating.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    
                    //Timer.invalidate()
                }
            
               
            }
            
            
            ProgressBarForWidget(progress: Binding.constant(entry.timeRemaing().1), timeInTheClass: Binding.constant(88)).overlay{
                
                VStack{
                    
                    Text(entry.whatHourCurrently()).fontWeight(.light)
                    //maybe remove hStack here
                    
                    Text(time, style: .timer).fontWeight(.light).multilineTextAlignment(.center).padding(2)
                    //This aint working
                    //Text(String(entry.getLunchSelectionThatWasPicked()))
                    
                    
                }
            }
            
            
            
            
        }.onTapGesture(count: 1, perform: {
            print(time)
        })
            .onChange(of: time) { newValue in
            print(newValue)
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
                .description("This is an timer widget.")
        }
    }
    
    struct ClassTimerWidget_Previews: PreviewProvider {
        static var previews: some View {
            ClassTimerWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
