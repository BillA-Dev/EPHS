//
//  ToDoList.swift
//  EPHS
//
//  Created by 90310148 on 2/25/22.
//

import SwiftUI


struct listsss: Codable, Identifiable{
    
    var item: String
    var isStriked: Bool
    var id = UUID()
}

struct ToDoList: View {
    
    @State var textFieldText = ""
    //Probably App Storage
    @State var listOfItems: [String] = []
    
    @Binding var currentHour: String
    
    @State var pickedHour = 0
    
    
    @State var toDoDict: [String: [listsss]] = ["First Hour":[], "Second Hour": [], "Third Hour": [], "Fourth Hour": []]//The arr string is ListOfitems
    
    
    @State var originalPickedLunch: Int = 0
    
    
    //Create a dictionary per hour with the listOfItems
    
    
    //The code gets the hour in dictionary and then gets the array.
    //IF there is no hour; it creates a new one.
    //OR CREATE A PRESET DICT, and remove this pop up from running when lunch starts ORRR 3rd lunch only shows when this runs. AIGHT thats the thing I might do.
    
    //L
    
    //@State var savedDictionary: [String: [Items]] = [:]
    //First lets try saving the list of items.
    
    //Userdefualts.standard.date()
    
    var body: some View {
        
        VStack{
            
            
            
            Image(systemName: "poweron").resizable().aspectRatio(contentMode: .fit).frame(width: 5).rotationEffect(Angle(degrees: 90)).foregroundColor(Color.gray).padding(.init(top: 2, leading: 0, bottom: 0, trailing: 0))
            HStack{
                
                
                //Text("To Do list: \(currentHour)").padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
//                Picker("", selection: $pickedHour){
//                    ForEach(Array(toDoDict.keys), id:\.self){ hours in
//                        Text(hours)
//                    }
                

//                }.labelsHidden().padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                  Picker(selection: $pickedHour, label: Text("Choose Lunch")) {
                                    Text("First Hour")
                                        .tag(0)
                                    Text("Second Hour")
                                        .tag(1)
                                    Text("Third Hour")
                                        .tag(2)
                                    Text("Fourth Hour")
                                        .tag(3)
                  }.background(Color.white).padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                Spacer()
                Button(action:{
                    //Remove all elements
                    toDoDict[pickedHour == 0 ? "First Hour" : pickedHour == 1 ? "Second Hour" : pickedHour == 2 ? "Third Hour" : "Fourth Hour"]!.removeAll()
                    
                    
                }){
                    Text("Clear")
                }.padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                
                
                
            }
            //UNDERSTAND HOW THE ID: \.self work
            List(){
                ForEach(toDoDict[pickedHour == 0 ? "First Hour" : pickedHour == 1 ? "Second Hour" : pickedHour == 2 ? "Third Hour" : "Fourth Hour"]!){dictText in
                    
                    Text(dictText.item)
                }
                
                //On Tap Gesture here. Have an image; correct and wrong
                
            }.onTapGesture(count: 2){
                
            }
            
            HStack{
                TextField("Enter item to do", text: $textFieldText).padding()
                Button(action:{
                    print(pickedHour)
                    if textFieldText != "" && textFieldText.count > 1 && textFieldText[textFieldText.index(textFieldText.startIndex, offsetBy: 1)] != " "{
                        
                        toDoDict[pickedHour == 0 ? "First Hour" : pickedHour == 1 ? "Second Hour" : pickedHour == 2 ? "Third Hour" : "Fourth Hour"]!.append(listsss(item: textFieldText, isStriked: false))
                        print(toDoDict[pickedHour == 0 ? "First Hour" : pickedHour == 1 ? "Second Hour" : pickedHour == 2 ? "Third Hour" : "Fourth Hour"]!)
                    }
                    textFieldText = ""
                }){
                    Text("ENTER")
                }.padding()
            }
        }.onDisappear{
            //IF already set dont set again maybe?\
            
            //Turn dict to JSON then save to userDefualts
            //https://stackoverflow.com/questions/61435230/store-dictionary-in-userdefaults'
            
            
//            toDoDict[pickedHour == 0 ? "First Hour" : pickedHour == 1 ? "Second Hour" : pickedHour == 2 ? "Third Hour" : "Fourth Hour"] = listOfItems
//            print(toDoDict)
//
            var data: Data?
            do{
                data = try JSONEncoder().encode(toDoDict)
            }catch{
                print("could not save data")
            }
            UserDefaults.standard.set(data, forKey: "dict")
            
        }.onAppear{
            //listOfItems = UserDefaults.standard.stringArray(forKey: "listOfItems") ?? []
//            if pickedHour == 0 || pickedHour == 1{
//                listOfItems = toDoDict[pickedHour == 0 ? "First Hour" : "Second Hour"]!
//            }else{
//                listOfItems = toDoDict[pickedHour == 2 ? "Third Hour" : "Fourth Hour"]!
//            }
            
            //This is not getting first hour
            
            
            if let data = UserDefaults.standard.data(forKey: "dict") {
            do{

                toDoDict = try JSONDecoder().decode([String: [listsss]].self, from: data)
               //It gets the twoDODict; I just cant make it update AFJASKLJDKLASJDKLAS print(toDoDict)
            }catch{
                print("Cannot get value")
            }

            }else{
                print("No value saved")
            }
            print(toDoDict)


            //originalPickedLunch = pickedHour

//
//
            
        }
            
//        }.onChange(of: pickedHour){ x in
//
//            //Save current list.
//
//
////            toDoDict[originalPickedLunch == 0 ? "First Hour" : originalPickedLunch == 1 ? "Second Hour" : originalPickedLunch == 2 ? "Third Hour" : "Fourth Hour"] = listOfItems
////
////            //This is working.
////
////
////            if pickedHour == 0 || pickedHour == 1{
////                listOfItems = toDoDict[pickedHour == 0 ? "First Hour" : "Second Hour"]!
////            }else{
////                listOfItems = toDoDict[pickedHour == 2 ? "Third Hour" : "Fourth Hour"]!
////            }
////            originalPickedLunch = pickedHour
////
//
//        }
        
        
        
    }
    
    
    
    
    
}



//String, CaseIterable, Identifiable, Codable {

//struct Items: Identifiable, Codable{
//    let toDoItem: String
//    let id = UUID()
//}

struct Items: Identifiable{
    let id = UUID()
    let toDoItem: String
    //let id = UUID()
}

struct ToDoList_Previews: PreviewProvider {
    static var previews: some View {
        ToDoList(currentHour: Binding.constant("1st hour test"))
    }
}
