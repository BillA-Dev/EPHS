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
    
    
   
    var body: some View {
        
        VStack{
            
            
            
            Image(systemName: "poweron").resizable().aspectRatio(contentMode: .fit).frame(width: 5).rotationEffect(Angle(degrees: 90)).foregroundColor(Color.gray).padding(.init(top: 2, leading: 0, bottom: 0, trailing: 0))
            HStack{
                
                
            
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
            
            
            //Maybe make a better save system: Maybe in documents folder?
            //https://developer.apple.com/tutorials/app-dev-training/persisting-data

            var data: Data?
            do{
                data = try JSONEncoder().encode(toDoDict)
            }catch{
                print("could not save data")
            }
            UserDefaults.standard.set(data, forKey: "dict")
            
        }.onAppear{

            
            
            if let data = UserDefaults.standard.data(forKey: "dict") {
            do{

                toDoDict = try JSONDecoder().decode([String: [listsss]].self, from: data)
              
            }catch{
                print("Cannot get value")
            }

            }else{
                print("No value saved")
            }
            print(toDoDict)


   
            
        }
            



        
        
        
    }
    
    
    
    
    
}





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
