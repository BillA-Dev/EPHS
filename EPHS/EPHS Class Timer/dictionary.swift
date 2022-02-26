//
//  dictionary.swift
//  EPHS
//
//  Created by 90310148 on 2/23/22.
//

import Foundation
import SwiftUI


class dictionary: ObservableObject{
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
