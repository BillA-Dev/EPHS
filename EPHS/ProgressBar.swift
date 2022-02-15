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
    
    var body: some View {
        ZStack {
            Circle().stroke(lineWidth: 30).opacity(0.3).padding().foregroundColor(Color.red.opacity(0.5))
            
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.black]), startPoint: .top, endPoint: .bottom).mask(
                
                
                Circle().trim(from: 0.0, to: CGFloat(min(progress/timeInTheClass, 1))).stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round)).padding().rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress))
            
            
        }.padding()
        
        
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: Binding.constant(50), timeInTheClass: Binding.constant(88))
    }
}
