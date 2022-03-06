//
//  ShapeView.swift
//  AwardsCollectionApp
//
//  Created by Arslan Abdullaev on 06.03.2022.
//

import SwiftUI

struct ShapeView: View {
    @State var colors: [AdditionalColors] =
    [
        AdditionalColors(hexValue: "#15654B", color: Color("Green")),
        AdditionalColors(hexValue: "#DAA4FF", color: Color("Violet")),
        AdditionalColors(hexValue: "#FFD90A", color: Color("Yellow")),
        AdditionalColors(hexValue: "#FE9EC4", color: Color("Pink")),
        AdditionalColors(hexValue: "#FB3272", color: Color("Orange")),
        AdditionalColors(hexValue: "#4460EE", color: Color("Blue"))
    ]
    @State var selectedColor: Color = Color("Blue")
    @State var animations: [Bool] = Array(repeating: false, count: 10)
    
    var body: some View {
        VStack{
        
        GeometryReader{ geometry in
            
            let maxY = geometry.frame(in: .global).maxY
            
            ShowShape()
                .rotation3DEffect(.init(degrees: animations[0] ? 0 : -270), axis: (x: 1, y: 0, z: 0), anchor: .center)
                .offset(y: animations[0] ? 0 : -maxY)
        }
        .frame(height: 270)
            HStack{
            Text("Created by: Arslan")
                .font(.title3)
                .fontWeight(.light)
                .toTheLeft()
                .offset(x: animations[1] ? 0 : -200)
                
            Text("Color Picker")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .offset(x: animations[1] ? 0 : 200)
            }.padding()
            
            GeometryReader{proxy in
                ZStack{
                    Color.gray
                        .clipShape(CustomCorner(corners: [.topLeft,.topRight], radius: 40))
                        .frame(height: animations[2] ? nil : 0)
                    ZStack{
                        ForEach(colors){colorGrid in
                            if !colorGrid.removeFromView{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorGrid.color)
                                    .frame(width: 150, height: animations[3] ? 60 : 150)
                                    .rotationEffect(.init(degrees: colorGrid.rotateCards ? 180 : 0))
                            }
                        }
                    }
                    .overlay(
                    
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 150, height: animations[3] ? 60 : 150)
                            .opacity(animations[3] ? 0 : 1)
                    )
                    .scaleEffect(animations[3] ? 1 : 2.3)
                }
                .clipped()
                ScrollView(.vertical, showsIndicators: false) {
                    
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        
                        ForEach(colors){colorGrid in
                            
                            getPicker(colorBox: colorGrid)
                        }
                    }
                    .padding(.top,40)
                }
                .cornerRadius(40)
            }
            .padding(.top)
        } .toTheTop()
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: animateScreen)
            
        }
    }


struct ShapeView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeView()
    }
}

extension ShapeView{
    
    @ViewBuilder
    private func ShowShape() -> some View {
    ZStack{
        RoundedRectangle(cornerRadius: 25)
            .fill(selectedColor)
        Circle()
            .stroke(Color.white.opacity(0.5),lineWidth: 18)
            .offset(x: 130, y: -120)
        Circle()
            .stroke(Color.white.opacity(0.2),lineWidth: 15)
            .offset(x: -130, y: 120)
        Circle()
            .stroke(Color.white.opacity(0.5),lineWidth: 17)
            .offset(x: 160, y: 70)
        Circle()
            .stroke(Color.white.opacity(0.7),lineWidth: 18)
            .offset(x: 10, y: 100)
        Circle()
            .stroke(Color.white.opacity(0.5),lineWidth: 20)
            .offset(x: -60, y: -60)
        }
    
    .clipped()
    .padding()
    }
    
    @ViewBuilder
    private func getPicker(colorBox: AdditionalColors)->some View{
        VStack{
        if colorBox.addToGrid{
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorBox.color)
                    .frame(width: 150, height: 60)
                    .onAppear {
                        if let index = colors.firstIndex(where: { color in
                            return color.id == colorBox.id
                        }){
                            withAnimation{
                                colors[index].showText = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                withAnimation{
                                    colors[index].removeFromView = true
                                }
                            }
                        }
                    }.onTapGesture {
                        withAnimation{
                            selectedColor = colorBox.color
                        }
                    }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .frame(width: 150, height: 60)
            }
            Text(colorBox.hexValue)
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.white)
                .padding([.horizontal,.top])
                .opacity(colorBox.showText ? 1 : 0)
        }
        
    }

    private func animateScreen(){
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction: 0.7, blendDuration: 0.7).delay(0.2)){
            animations[0] = true
        }
        
        withAnimation(.easeInOut(duration: 0.7)){
            animations[1] = true
        }
        
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction: 0.7, blendDuration: 0.7).delay(0.2)){
            animations[2] = true
        }
        
        withAnimation(.easeInOut(duration: 0.8)){
            animations[3] = true
        }
        
        for index in colors.indices{
            
            let delay: Double = (0.9 + (Double(index) * 0.1))
            
            let backIndex = ((colors.count - 1) - index)
            
            withAnimation(.easeInOut.delay(delay)){
                colors[backIndex].rotateCards = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation{
                    colors[backIndex].addToGrid = true
                }
            }
        }
    }
}

extension View {
    func toTheTop()->some View{
        self
            .frame(maxHeight: .infinity,alignment: .top)
    }
    func toTheLeft() -> some View{
        self
            .frame(maxWidth: .infinity,alignment: .leading)
    }
}
    
