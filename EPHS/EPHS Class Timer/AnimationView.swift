//
//  AnimationView.swift
//  EPHS
//
//  Created by 90310148 on 5/5/22.
//

import SwiftUI
import Foundation
import Network



class Network: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    var connected: Bool = false
    
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connected = true
                print(self.connected)
            } else {
                self.connected = false
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopConnection(){
        monitor.cancel()
    }
    
}




struct AnimationView: View {
    
    
    @EnvironmentObject var dict: dictionary
    
    @State var circleAmmount: String = "4"
    @State var frameWidth: String = "20"; @State var frameHeight: String = "20"
    
    @StateObject var network = Network()
    
    
    @State var isInternetConnected = false
    
    @State var bothDone = false
    @State var settingUpApp = false
    @State var startingApp = false
    
    
    var body: some View{
        
        VStack{
            HStack{
                Spacer()
                Text("EPHS").font(.largeTitle)
                Text("Timer").padding(-8).foregroundColor(Color.red).font(.largeTitle)
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12).padding().foregroundColor(Color.red).opacity(0.2).shadow(radius: 10)
                VStack {
                    HStack {
                        Text("Checking Network").padding()
                        passOrFail(color: isInternetConnected ? Color.green : Color.red, image: isInternetConnected ? "checkmark" : "x")
                    }
                    
                    HStack{
                        Text("Checking ICloud").padding()
                        if FileManager.default.ubiquityIdentityToken != nil {
                            passOrFail(color: Color.green, image: "checkmark")
                        } else {
                            passOrFail(color: Color.red, image: "x")
                        }
                    }
                    HStack{
                    Text("Initiazlizing Database").padding()
                        if bothDone{
                            passOrFail(color: Color.green, image: "checkmark")
                        }
                    }
                    HStack{
                    Text("Calling Database").padding()
                        if bothDone{
                            passOrFail(color: Color.green, image: "checkmark")
                        }
                    }
                    HStack{
                    Text("Setting up App").padding()
                        if settingUpApp{
                            passOrFail(color: Color.green, image: "checkmark")
                        }
                    }
                    HStack{
                        Text("Starting App").padding()
                        if startingApp{
                            
                            passOrFail(color: Color.green, image: "checkmark")
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
            Text("Movitavional Quaotes:")
                .font(.headline)
            Text("I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration. I will face my fear. I will permit it to pass over me and through me. And when it has gone past I will turn the inner eye to see its path. Where the fear has gone there will be nothing. Only I will remain")
                .multilineTextAlignment(.center).padding([.horizontal, .top])
            progressCircle(countOfCricles: Int(circleAmmount)!, speed: 3, gradient: Gradient(colors: [Color(hex: "fafa6e"), Color(hex: "64c987"), Color(hex: "#00898a"), Color(hex: "2a4858")])).frame(height: 100)
        }.onAppear {
            network.checkConnection()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                isInternetConnected = network.connected
                print(network.connected)
                if FileManager.default.ubiquityIdentityToken != nil && isInternetConnected{
                    bothDone.toggle()
                    dict.getInfo()
                    dict.getLunch()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        //Setting up app, maybe lunch functoins in here
                        settingUpApp = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                            //Starting App
                            startingApp = true
                        }
                    }
                    //Check if there are errors;
                }
                
            }
            network.stopConnection()
        }
        .onChange(of: startingApp, perform: { newValue in
            dict.shouldSwitch = true
        })
        
        .environmentObject(dict)
    }
}


struct passOrFail: View{
    var color: Color
    var image: String
    
    @State var animateCircle: Double = 0.0
    
    var body: some View{
        Circle()
            .trim(from: 0.0, to: animateCircle)
            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .rotationEffect(Angle(degrees: 270))
            .frame(width: 20, height: 20)
            .animation(.easeInOut(duration: 2), value: animateCircle)
            .foregroundColor(color)
            .overlay{
                Image(systemName: image)
            }
            .onAppear{
                animateCircle = 1
            }
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct progressCircle: View{
    
    
    @State var isAnimated = false
    @State var isCricleDone = false
    
    var countOfCricles: Int
    
    @State var isAnimatedArr: [Bool] = []
    
    
    @State var isCircleDone: [Bool] = []
    
    
    @State var animationIsDone: Bool = false
    
    var savedFalseArr: [Bool] = []
    
    
    var offsetValue: CGFloat = 0.0
    
    var speed: Int = 2
    var dSpeed: Double = 0.0
    
    var frameWidth: Int
    var frameHeight: Int
    
    
    
    var gradient: Gradient?
    
    
    
    
    ///Non Optional Paramters: Count of Cirlcles
    ///Optional Parametes:: Frame width and height -- defualt set at 20 --, speed -- 1 is the slowest, anyything greater gets faster, and gradient is optional. You can choose the gradient if you wish.
    ///
    ///
    ///
    init(countOfCricles: Int, frameWidth: Int = 20, frameHeight: Int = 20, speed: Int = 2, gradient: Gradient? = nil){
        if speed == 0{
            fatalError("Speed can not be zero")
        }
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        
        
        self.countOfCricles = countOfCricles
        
        
        self.gradient = gradient
        
        _isAnimatedArr = State(initialValue: Array(repeating: false, count: self.countOfCricles))
        _isCircleDone = State(initialValue: Array(repeating: false, count: self.countOfCricles))
        offsetValue = CGFloat(8*countOfCricles)
        
        self.speed = speed
        dSpeed = 1.0/Double(self.speed)
        
        
    }
    var body: some View{
        
        if gradient != nil{
            LinearGradient(gradient: self.gradient!, startPoint: .leading, endPoint: .trailing)
                .mask(
                    HStack{
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.red)
                            .offset(x:  animationIsDone && isAnimatedArr.last == false ? 0 : isAnimatedArr[0] ? CGFloat((frameWidth+8)*countOfCricles) : 0)
                            .animation(.linear(duration: Double(countOfCricles)/Double(speed)), value: isAnimatedArr[0])
                            .animation(.linear(duration: Double(countOfCricles)/Double(speed)), value: isAnimatedArr.last)
                        
                        
                        ForEach(0..<countOfCricles, id: \.self){ index in
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.black)
                                .rotationEffect(Angle(degrees: isAnimatedArr[index] ? (270) : 0), anchor: animationIsDone ? .bottomLeading : .bottomLeading)
                                .offset(x: self.isCircleDone[index] ? -8 : 0)
                                .animation(.linear(duration: dSpeed), value: isAnimatedArr[index])
                                .animation(.linear(duration: 0.2), value: self.isCircleDone[index])
                            
                        }
                        
                        
                    }
                    
                    
                        .onAppear{
                            
                            startTimer()
                            
                        }.onChange(of: animationIsDone) { V in
                            if animationIsDone == false{
                                DispatchQueue.main.asyncAfter(deadline: .now() + dSpeed){
                                    //Add stop funciton here
                                    isAnimatedArr = Array(repeating: false, count: self.countOfCricles)
                                    isCircleDone = Array(repeating: false, count: self.countOfCricles)
                                    startTimer()
                                    
                                }
                            }
                        }
                )
        }else{
            HStack{
                
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.red)
                    .offset(x:  animationIsDone && isAnimatedArr.last == false ? 0 : isAnimatedArr[0] ? CGFloat((frameWidth+8)*countOfCricles) : 0)
                    .animation(.linear(duration: Double(countOfCricles)/Double(speed)), value: isAnimatedArr[0])
                    .animation(.linear(duration: Double(countOfCricles)/Double(speed)), value: isAnimatedArr.last)
                
                
                ForEach(0..<countOfCricles, id: \.self){ index in
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.black)
                        .rotationEffect(Angle(degrees: isAnimatedArr[index] ? (270) : 0), anchor: animationIsDone ? .bottomLeading : .bottomLeading)
                        .offset(x: self.isCircleDone[index] ? -8 : 0)
                        .animation(.linear(duration: dSpeed), value: isAnimatedArr[index])
                        .animation(.linear(duration: 0.2), value: self.isCircleDone[index])
                    
                }
                
                
            }
            
            
            .onAppear{
                
                startTimer()
                
            }.onChange(of: animationIsDone) { V in
                if animationIsDone == false{
                    DispatchQueue.main.asyncAfter(deadline: .now() + dSpeed){
                        //Add stop funciton here
                        isAnimatedArr = Array(repeating: false, count: self.countOfCricles)
                        isCircleDone = Array(repeating: false, count: self.countOfCricles)
                        startTimer()
                        
                    }
                }
            }
        }
        
    }
    
    
    func startTimer(){
        var index = 0
        Timer.scheduledTimer(withTimeInterval: dSpeed, repeats: true) { t in
            
            t.tolerance = 0.001
            isAnimatedArr[index] = true
            
            //Somehow is CirlceDone is working
            isCircleDone[index] = true
            index+=1
            
            if index == self.isAnimatedArr.count{
                
                //This is reverse function
                DispatchQueue.main.asyncAfter(deadline: .now() + dSpeed){
                    animationIsDone = true
                    var index = isAnimatedArr.count-1
                    Timer.scheduledTimer(withTimeInterval: dSpeed, repeats: true) { timer in
                        isAnimatedArr[index] = false
                        isCircleDone[index] = false
                        index -= 1
                        if index < 0{
                            timer.invalidate()
                            animationIsDone = false
                        }
                    }
                    
                    
                }
                
                
                t.invalidate()
                
            }
        }
        
    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}
