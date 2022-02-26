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
    @State var listOfItems: [Items] = []
    
    @Binding var currentHour: String
    
    
    //@State var savedDictionary: [String: [Items]] = [:]
    //First lets try saving the list of items.
    
    //Userdefualts.standard.date()
    
    var body: some View {
        
        VStack{
            Text("\(currentHour) To Do list").padding()
            List(listOfItems){x in
                Text(x.toDoItem)
                   
                //On Tap Gesture here. Have an image; correct and wrong
                
            }
            
            HStack{
                TextField("Enter item to do", text: $textFieldText).padding()
                Button(action:{
                    
                    if textFieldText != "" || textFieldText[textFieldText.index(textFieldText.startIndex, offsetBy: 1)] == " "{
                    listOfItems.append(Items(toDoItem: textFieldText))
                    }
                    textFieldText = ""
                }){
                    Text("ENTER")
                }.padding()
            }
        }.onDisappear{
            UserDefaults.standard.set(listOfItems, forKey: "listOfItems")
        }.onAppear{
            //JSONEncoder.encode(UserDefaults.standard.data(forKey: "listOfItems")!)
           //JSONDecoder().decode(Items, from: UserDefaults.standard.data(forKey: "listOfItems")!)
            
//            if let data = UserDefaults.standard.data(forKey: "listOfItems") {
//                        let arr = try! PropertyListDecoder().decode([Items].self, from: data)
//                print(arr)
//            }
        }
    }
}



//String, CaseIterable, Identifiable, Codable {

//struct Items: Identifiable, Codable{
//    let toDoItem: String
//    let id = UUID()
//}

struct Items: Identifiable{
    let toDoItem: String
    let id = UUID()
}

struct ToDoList_Previews: PreviewProvider {
    static var previews: some View {
        ToDoList(currentHour: Binding.constant("1st hour test"))
    }
}
