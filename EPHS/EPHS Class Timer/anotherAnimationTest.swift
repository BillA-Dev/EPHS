//
//  anotherAnimationTest.swift
//  EPHS
//
//  Created by 90310148 on 5/9/22.
//

import SwiftUI

struct anotherAnimationTest: View {
    
    @State var rotationEffect: Double = 0.0
    @State var opacity: Double = 0.0
    
    @State var textOpacity: Double = 0.0
    
    @EnvironmentObject var dict: dictionary
    
    var body: some View {
        VStack{
        Circle()
            .stroke(lineWidth: 10)
            .frame(width: 150, height: 150)
            .overlay{
                RoundedRectangle(cornerRadius: 12).frame(width: 10, height: 0.4*150, alignment: .center).offset(y: -20).rotationEffect(Angle(degrees: rotationEffect), anchor: .center)
                
            }
            .opacity(opacity)
            .animation(.easeInOut(duration: 1), value: opacity)
            .animation(.easeOut(duration: 3), value: rotationEffect)
            .onAppear {
                
                dict.getInfo()
                dict.getLunch()
                
                opacity = 1
                
            }
            .onChange(of: opacity) { newValue in
                if opacity == 1{
                    rotationEffect += 360*3
                }
            }
            .onChange(of: rotationEffect) { v in
                if rotationEffect == 360*3{
                    textOpacity = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now()+3){
                        dict.shouldSwitch = true
                    }
                }
            }
            
            HStack{
                Spacer()
                Text("EPHS").font(.largeTitle)
                Text("Timer").padding(-8).foregroundColor(Color.red).font(.largeTitle)
                Spacer()
            }.opacity(textOpacity)
                .animation(.easeInOut(duration: 2), value: textOpacity)
                
            
        }
            
            
    }
}

struct anotherAnimationTest_Previews: PreviewProvider {
    static var previews: some View {
        anotherAnimationTest()
    }
}
