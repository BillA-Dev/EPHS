//
//  ToDoList.swift
//  EPHS
//
//  Created by 90310148 on 2/25/22.
//

import SwiftUI

struct ToDoList: View {
    
    @State var textFieldText = ""
    //Probably App Storage
    @State var listOfItems: [String] = []
    
    @Binding var currentHour: String
    
    @State var pickedHour = 0
    
    
    @State var toDoDict: [String: [String]] = [:]//The arr string is ListOfitems
    
    
    
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
                    listOfItems.removeAll()
                }){
                    Text("Clear")
                }.padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                
                
                
            }
            //UNDERSTAND HOW THE ID: \.self work
            List(listOfItems, id: \.self){ list in
                    Text(list)
   
                //On Tap Gesture here. Have an image; correct and wrong
                
            }
            
            HStack{
                TextField("Enter item to do", text: $textFieldText).padding()
                Button(action:{
                    
                    if textFieldText != "" || textFieldText[textFieldText.index(textFieldText.startIndex, offsetBy: 1)] == " "{
                    listOfItems.append(textFieldText)
                    }
                    textFieldText = ""
                }){
                    Text("ENTER")
                }.padding()
            }
        }.onDisappear{
            //IF already set dont set again maybe?
            UserDefaults.standard.set(listOfItems, forKey: "listOfItems")
           
        }.onAppear{
            listOfItems = UserDefaults.standard.stringArray(forKey: "listOfItems") ?? []
        }
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
