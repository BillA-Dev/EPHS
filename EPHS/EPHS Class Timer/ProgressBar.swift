//
//  ProgressBar.swift
//  TimeRemaining
//
//  Created by 90310148 on 2/6/22.
//Commit
import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    @Binding var timeInTheClass: Float
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        
        ZStack {
            
            Circle()
                .stroke(lineWidth: 30)
                .opacity(0.3)
                .padding()
                .foregroundColor(Color.red.opacity(0.5))
            
            LinearGradient(gradient: Gradient(colors: colorScheme == .dark ? [Color(red: 173/255, green: 14/255, blue: 14/255), colorScheme == .dark ? Color(red: 205/255, green: 149/255, blue: 149/255): Color.black] : [Color.red, Color.black]), startPoint: .top, endPoint: .bottom)
            .mask(
                //MASK ADD COLOR TO FORGROUND OFF ALL OBJECTS IN HERE
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1)))
                    .stroke(style: StrokeStyle(lineWidth: 30, lineCap: (progress >= 0.9 ? .square: .round), lineJoin: .round))
                    .padding()
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.linear, value: progress)
            
            
            )
            
            
        }.padding()
        
        
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: Binding.constant(50), timeInTheClass: Binding.constant(88))
    }
}
