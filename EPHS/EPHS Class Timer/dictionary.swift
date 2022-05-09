//
//  dictionary.swift
//  EPHS
//
//  Created by 90310148 on 2/23/22.
//NEED TO ADD POPOVER WHEN SCHOOL STARTS, Lunch Timing; and for what hour they are in

import Foundation
import SwiftUI
import CloudKit

extension String{
    func timeToMinutes() -> String{
        let s = self
        guard let hour = Int(s[..<firstIndex(of: ":")!]) else { return "Failed" }
        guard let minute = Int(s[s.index(after: s.firstIndex(of: ":")!)...]) else { return "Failed" }
        return String((hour * 60)+minute)
    }
}


class dictionary: ObservableObject{
    
    
    @Published var shouldSwitch: Bool = false
    
    
    @Published var dataBase = CKContainer.init(identifier: "iCloud.ephs2022.AdminApp")
    
    @Published var dates = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @Published var arrRecieved: [[String]] = []
    
    
    @Published var lunchArr: [[String]] = []
    //FULLY RESET THIS.
    
    
    
   
    @Published var whichLunch: String = ""
    
    @Published var doneLoading: Bool = false
    
    @Published var lunch: [String:[String]] = [:]
    
    //This is when the user turns of lunch
    @Published var savedDict: [String:[String]] = [:]
    
    
    public func getInfo(){
        
        //Testing purposes
        //let q = CKQuery(recordType: "Thursday", predicate: NSPredicate(value: true))
        //print(dates[Calendar.current.component(.weekday, from: Date())])
        
        
       let q = CKQuery(recordType: dates[Calendar.current.component(.weekday, from: Date())], predicate: NSPredicate(value: true))
        print(q)
        let op = CKQueryOperation(query: q)
        var a: [[String]] = []
        
        op.recordMatchedBlock = {recordID, recordItem in
            switch recordItem{
            case .success(let record):
                guard let ar = record["HOURS"] as? [String] else {return}
                a.append(ar)
            case .failure(let error):
                print(error)
            }
        }
        op.queryResultBlock = {result in
            switch result{
            case .success(_):
                
                DispatchQueue.main.async {
                    self.arrRecieved = a
                    //print(self.arrRecieved)
                    self.turninto24hour()
                    self.turnArrIntoDict()
                    
                    
                    
                    
                }
                
                
                
            case .failure(let err):
                print(err)
                
            }
        }
        self.dataBase.publicCloudDatabase.add(op)
        
        
        
    }
    
   
    
    private func turnArrIntoDict(){
        var di: [String: [String]] = [:]
        for x in self.arrRecieved{
            di[x[0]] = [x[1], x[2]]
        }
        self.timeDict = di
    }
    
    
    private func schoolStarts(){
        //ASK IN MY DATABASE APP FOR WHEN SCHOOL STARTS
        //Use this information to add!!
    }
    private func addBussesLeaving(){
        let x = DateFormatter()
        x.dateFormat = "HH:mm"
        let da = x.date(from: self.arrRecieved[self.arrRecieved.count-1][2])!
        
        let newD = Calendar.current.date(byAdding: .minute, value: 7, to: da)
        
        self.arrRecieved.append(["Busses Leave", "\(self.arrRecieved[self.arrRecieved.count-1][2])", "\(x.string(from: newD!))"])
        
        
    }
    //ADD SCHOOL STARTS
    
    
    private func turninto24hour(){
       
        var arr: [[String]] = []
        for x in self.arrRecieved{
            var a: [String] = []
            a.append(x[0])
            a.append(formatNumbers(date: returnDate(string: x[1])))
            a.append(formatNumbers(date: returnDate(string: x[2])))
            arr.append(a)
        }
        self.arrRecieved = arr
    }
    private func formatNumbers(date: Date) -> String{
        let x = DateFormatter()
        x.dateFormat = "HH:mm"
        return x.string(from: date)
    }
    
    private func returnDate(string: String) -> Date{
        let x = DateFormatter()
        x.dateFormat = "h:mm a"
        return x.date(from: string)!
    }
    
    @Published var timeDict =  ["1st hour": ["8:35", "10:03"],
                                "Passing Time 1st hour": ["10:03", "10:10"],
                                "2nd hour": ["10:10", "11:38"],
                                "Passing Time 2nd hour": ["11:38", "11:45"],
                                "3rd hour": ["11:45", "13:45"],
                                "Passing Time 3rd hour": ["13:45", "13:53"],
                                "4th hour": ["13:53", "15:20"],
                                "Busses Leave" : ["15:20", "15:27"],
                                "School Starts" : ["15:20", "8:35"]]
    
    
    func checkSave(){
        //https://developer.apple.com/documentation/foundation/userdefaults
        //Apple Documentation
        
        if UserDefaults.standard.bool(forKey: "isToggleOn"){
            addLunch(enterLunch: UserDefaults.standard.integer(forKey: "pickedLunch"))
        }
        
        
    }
    
    func resetLunch(){
        if Int(Calendar.current.component(.weekday, from: Date())) == 3{
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
                        "Busses Leave" : ["15:20", "15:27"],
                        "School Starts" : ["15:20", "8:35"]]
            
        }else if Int(Calendar.current.component(.weekday, from: Date())) == 5{
            timeDict = ["1st hour": ["8:35", "9:33"],
                        "Core 1st hour": ["9:33", "10:03"],
                        "Passing Time to 2nd hour": ["10:03", "10:10"],
                        "2nd hour": ["10:10", "11:08"],
                        "Core 2nd hour": ["11:08", "11:38"],
                        "Passing Time to 3rd hour": ["11:38", "11:45"],
                        "3rd hour": ["11:45", "13:45"],
                        "Passing Time to 4th hour": ["13:45", "13:53"],
                        "4th hour": ["13:53", "14:50"],
                        "Core 4th hour": ["14:50", "15:20"],
                        "Busses Leave" : ["15:20", "15:27"],
                        "School Starts" : ["15:20", "8:35"]]
        }else{
            timeDict = ["1st hour": ["8:35", "10:03"],
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
    
    func getLunch(){
        
        //Testing
       // let recordName: String = "LunchMonday"
        
      let recordName: String = "Lunch\(dates[Calendar.current.component(.weekday, from: Date())])"
        let q = CKQuery(recordType: recordName, predicate: NSPredicate(value: true))
        let op = CKQueryOperation(query: q)
        var a: [[String]] = []
        
        op.recordMatchedBlock = {recordID, recordItem in
            switch recordItem{
            case .success(let record):
                guard let ar = record["HOURS"] as? [String] else {return}
                a.append(ar)
            case .failure(let error):
                print(error)
            }
        }
        op.queryResultBlock = {result in
            switch result{
            case .success(_):
                
                DispatchQueue.main.async {
                    self.lunchArr = a
                    self.formatLunch()
                    //self.printArr()
                    print("CALLED")
                    
                    
                }
                
                
                
                
            case .failure(let err):
                print(err)
                
            }
        }
        self.dataBase.publicCloudDatabase.add(op)
    }
    
   
    func formatLunch(){
        //Create a dict of lunch here.
        
        for x in self.lunchArr{
            lunch[x[0]] = [x[1], x[2]]
        }
        
      //  print(lunch)
        
        whichLunch = self.lunchArr[0][3]
        
        for (index, value) in lunch{
            
        
            lunch[index] = [formatNumbers(date: returnDate(string: value[0])), formatNumbers(date: returnDate(string: value[1]))]
        }
        
        
        //Turns it into mintues
        for (index, value) in lunch{
            lunch[index] = value.map{$0.timeToMinutes()
            }
        }
        
        //This might work now? The app should be functional!
        
        
       // print(lunch)

    }
    
   
    
    func addLunchToDict(userSelectedLunch selectedLunch: String){
        //Get this arr from my dict.
      // print(selectedLunch)
        
        let h = whichLunch
        
        print(lunch)
        print(selectedLunch)
        
        //print(lunch)
        //print(lunch)
        
        //WORK ON LUNCH
        let arr = timeDict[h]!
        
        //Start of third hour to start of lunch
        //add Lunch Timings
        //End of lunch to end of third hour.
        
        
        if arr[0] == lunch[selectedLunch]![0]{
            //we know that this is "First Lunch"
            //Save timeDict beforeHand or just fetch from database again
            timeDict[selectedLunch] = lunch[selectedLunch]
            timeDict[h] = [lunch[selectedLunch]![1], timeDict[h]![1]]
            
            // print("firstLunch")
        }else if arr[1] == lunch[selectedLunch]![1]{
            //We know this is "Fourth lunch"
            //print("fourthLunch")
            
            timeDict[selectedLunch] = lunch[selectedLunch]
            timeDict[h] = [timeDict[h]![0], lunch[selectedLunch]![0]]
            
        }else{
            //The hardest one on this.
            let arrSaved = arr
            timeDict[h] = [timeDict[h]![0], lunch[selectedLunch]![0]]
            timeDict[selectedLunch] = lunch[selectedLunch]
            timeDict["\(h) - 2"] = [lunch[selectedLunch]![1], arrSaved[1]]
        }
        
        print(timeDict)
        
        //Have to split the array into 2
        
        
        
    }
    
    
    
    
    
    func addLunch(enterLunch usersLunch: Int){
        do{
            if Int(Calendar.current.component(.weekday, from: Date())) == 3{
                let lunchTimings: [[String]] = [["11:22", "11:52"],["11:52", "12:22"], ["12:22", "12:52"], ["12:52", "13:22"]]
                var getArr =  timeDict["3rd hour"]!
                
                
                if usersLunch == 0{
                    
                    getArr[0] = lunchTimings[0][1]
                    timeDict["3rd hour"] = getArr
                    timeDict["First Lunch"] = lunchTimings[0]
                    
                } else if usersLunch == 1{
                    
                    //Add thirdLunch
                    //Replace ending of third hour with the start of lunch
                    
                    //Replace thirdHour in Dicionary
                    timeDict["3rd hour"] = [getArr[0], lunchTimings[1][0]]
                    //Add thirdLunch to dictionary
                    timeDict["Second Lunch"] = lunchTimings[1]
                    //Add another Third hour, starting from the end of lunch to end of third normally
                    timeDict["3rd hour (2)"] = [lunchTimings[1][1], getArr[1]]
                    
                }else if usersLunch == 2{
                    print("ran this")
                    
                    //Replace thirdHour in Dicionary
                    timeDict["3rd hour"] = [getArr[0], lunchTimings[2][0]]
                    //Add thirdLunch to dictionary
                    timeDict["Third Lunch"] = lunchTimings[2]
                    //Add another Third hour, starting from the end of lunch to end of third normally
                    timeDict["3rd hour (2)"] = [lunchTimings[2][1], getArr[1]]
                    
                    
                }else if usersLunch == 3{
                    
                    // 4th lunch
                    //["11:45", "13:45"]
                    
                    getArr[1] = lunchTimings[3][0]
                    timeDict["3rd hour"] = getArr
                    timeDict["4th Lunch"] = lunchTimings[3]
                    //        print(timeDict["3rd hour"] ?? "Didnt Work")
                }
                
            }else{
                //Get there lunch. \
                //    let usersLunch = 0 //They will have a dropdown that the user can choose from
                let lunchTimings: [[String]] = [["11:45", "12:15"],["12:15", "12:45"], ["12:45", "13:15"], ["13:15", "13:45"]]
                var getArr =  timeDict["3rd hour"]!
                
                
                if usersLunch == 0{
                    
                    getArr[0] = lunchTimings[0][1]
                    timeDict["3rd hour"] = getArr
                    timeDict["First Lunch"] = lunchTimings[0]
                    
                } else if usersLunch == 1{
                    
                    //Add thirdLunch
                    //Replace ending of third hour with the start of lunch
                    
                    //Replace thirdHour in Dicionary
                    timeDict["3rd hour"] = [getArr[0], lunchTimings[1][0]]
                    //Add thirdLunch to dictionary
                    timeDict["Second Lunch"] = lunchTimings[1]
                    //Add another Third hour, starting from the end of lunch to end of third normally
                    timeDict["3rd hour (2)"] = [lunchTimings[1][1], getArr[1]]
                    
                }else if usersLunch == 2{
                    print("ran this")
                    
                    //Replace thirdHour in Dicionary
                    timeDict["3rd hour"] = [getArr[0], lunchTimings[2][0]]
                    //Add thirdLunch to dictionary
                    timeDict["Third Lunch"] = lunchTimings[2]
                    //Add another Third hour, starting from the end of lunch to end of third normally
                    timeDict["3rd hour (2)"] = [lunchTimings[2][1], getArr[1]]
                    
                    
                }else if usersLunch == 3{
                    
                    // 4th lunch
                    //["11:45", "13:45"]
                    
                    getArr[1] = lunchTimings[3][0]
                    timeDict["3rd hour"] = getArr
                    timeDict["4th Lunch"] = lunchTimings[3]
                    //        print(timeDict["3rd hour"] ?? "Didnt Work")
                }
            }
            
        }catch{
            print("thisFunctionWentWrong")
        }
    }
    
}
