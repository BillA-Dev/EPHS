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
