////
////  LunchSelectionView.swift
////  EPHS
////
////  Created by 90310148 on 2/14/22.
////Commit
//
//import SwiftUI
//
//struct LunchSelectionView: View {
//    @Binding var isShowing: Bool
//    var body: some View {
//        ZStack{
//
//            RoundedRectangle(cornerRadius: 20).frame(width: UIScreen.main.bounds.width/1.02, height: UIScreen.main.bounds.height/2, alignment: .center).padding(.horizontal, 50.0)
//
//
//
//        }
//
//    }
//}
//
//struct LunchSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        LunchSelectionView(isShowing: Binding.constant(true))
//    }
//}
//
//  LunchSelectionView.swift
//  EPHS
//
//  Created by 90310148 on 2/14/22.
//Commit

import SwiftUI

struct LunchSelectionView: View {
    @Binding var isOn: Bool
    var body: some View {
        VStack{
            
            HStack {
                
                Toggle("Enable Lunch", isOn: $isOn).padding()
            }
        
        }
        
    }
}

struct LunchSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LunchSelectionView(isOn: Binding.constant(false))
    }
}
