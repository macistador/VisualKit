//
//  AnimatedShapeView.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 06/10/2024.
//

import SwiftUI
import VisualKit

struct AnimatedShapeViewDemo: View {

    @State private var shapeIndex = 0
    @State private var isMask = false
    let durations = [0, 0.2, 0.3, 0.3]
    let colors: [Color] = [.yellow.opacity(0.25), .yellow.opacity(0.25), .yellow.opacity(0.25), .yellow.opacity(0.25)]

    let shapes = [
        CreateShapeA(),
        CreateShapeB(),
        CreateShapeC(),
        CreateShapeD()
    ]
    
    var body: some View {
        ZStack {
            if isMask {
                Image(.sample)
                    .resizable()
                    .mask {
                        effectView
                            .scaleEffect(x: 1.2, anchor: .center)
                    }
            } else {
                effectView
                    .scaleEffect(x: 1.2, anchor: .center)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Text("Mask")
                        .bold()
                    Toggle("", isOn: $isMask)
                    Spacer()
                }
                .padding(.horizontal, 80)

                GenericButton("Boom", colors: .init(primaryButton: .yellow)) {
                    shapeIndex = 0
                    shapeIndex = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        shapeIndex = 2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + 0.2) {
                        shapeIndex = 3
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
            .padding()
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var effectView: some View {
        ZStack {
            animatedView(delay: 0, opacityIndex: 0)
            animatedView(delay: 0, opacityIndex: 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            
            animatedView(delay: 0.2, opacityIndex: 1)
            animatedView(delay: 0.2, opacityIndex: 1)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            
            animatedView(delay: 0.4, opacityIndex: 2)
            animatedView(delay: 0.4, opacityIndex: 2)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            
            animatedView(delay: 0.6, opacityIndex: 3)
            animatedView(delay: 0.6, opacityIndex: 3)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
    }
    
    @ViewBuilder
    private func animatedView(delay: Double, opacityIndex: Int) -> some View {
        AnimatableShape(curves: shapes[shapeIndex])
            .fill(colors[opacityIndex])
            .animation(.linear(duration: durations[shapeIndex]).delay(delay), value: shapeIndex)
    }
}

#Preview {
    AnimatedShapeViewDemo()
}


func CreateShapeA() -> [CubicCurve] {
    var curves:[CubicCurve] = []
    
    let curve = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.4, y: 0.8),
        control2: CGPoint(x: 0.4, y: 0.8))
    curves.append(curve)
    
    let curve2 = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.4, y: 0.8),
        control2: CGPoint(x: 0.4, y: 0.8))
    curves.append(curve2)
    
    let curve3 = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.4, y: 0.8),
        control2: CGPoint(x: 0.4, y: 0.8))
    curves.append(curve3)
    
    let curve4 = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.4, y: 0.8),
        control2: CGPoint(x: 0.4, y: 0.8))
    curves.append(curve4)

    
    let curve5 = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.4, y: 0.8),
        control2: CGPoint(x: 0.4, y: 0.8))
    curves.append(curve5)

    return curves
}


func CreateShapeB() -> [CubicCurve] {
    var curves:[CubicCurve] = []
    
    let curve = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.4, y: 0.8),
        control2: CGPoint(x: 0.41, y: 0.81))
    curves.append(curve)
    
    let curve2 = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.9),
        control1: CGPoint(x: 0.41, y: 0.81),
        control2: CGPoint(x: 0.4, y: 0.89))
    curves.append(curve2)
    
    let curve3 = CubicCurve (
        point: CGPoint(x: 0.3, y: 0.9),
        control1: CGPoint(x: 0.38, y: 0.93),
        control2: CGPoint(x: 0.32, y: 0.93))
    curves.append(curve3)
    
    let curve4 = CubicCurve (
        point: CGPoint(x: 0.3, y: 0.75),
        control1: CGPoint(x: 0.25, y: 0.85),
        control2: CGPoint(x: 0.22, y: 0.77))
    curves.append(curve4)

    
    let curve5 = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.35, y: 0.74),
        control2: CGPoint(x: 0.4, y: 0.75))
    curves.append(curve5)

    return curves
}

func CreateShapeC() -> [CubicCurve] {
    var curves:[CubicCurve] = []
    
    let curve = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.4, y: 0.8),
        control2: CGPoint(x: 0.41, y: 0.81))
    curves.append(curve)
    
    let curve2 = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.9),
        control1: CGPoint(x: 0.41, y: 0.81),
        control2: CGPoint(x: 0.4, y: 0.89))
    curves.append(curve2)
    
    let curve3 = CubicCurve (
        point: CGPoint(x: 0.1, y: 0.9),
        control1: CGPoint(x: 0.4, y: 1.0),
        control2: CGPoint(x: 0.1, y: 1.0))
    curves.append(curve3)

    let curve4 = CubicCurve (
        point: CGPoint(x: 0.7, y: 0.6),
        control1: CGPoint(x: 0.0, y: 0.1),
        control2: CGPoint(x: 0.8, y: 0.2))
    curves.append(curve4)

    
    let curve5 = CubicCurve (
        point: CGPoint(x: 0.4, y: 0.8),
        control1: CGPoint(x: 0.6, y: 0.8),
        control2: CGPoint(x: 0.4, y: 0.8))
    curves.append(curve5)

    return curves
}

func CreateShapeD() -> [CubicCurve] {
    var curves:[CubicCurve] = []
    
    let curve = CubicCurve (
        point: CGPoint(x: 0.55, y: 1.0),
        control1: CGPoint(x: 1.0, y: 1.0),
        control2: CGPoint(x: 0.5, y: 1.0))
    curves.append(curve)
    
    let curve2 = CubicCurve (
        point: CGPoint(x: 0.0, y: 1.0),
        control1: CGPoint(x: 0.55, y: 1.0),
        control2: CGPoint(x: 0.0, y: 1.0))
    curves.append(curve2)
    
    let curve3 = CubicCurve (
        point: CGPoint(x: 0.0, y: 0.0),
        control1: CGPoint(x: 0.0, y: 1.0),
        control2: CGPoint(x: 0.0, y: 0.0))
    curves.append(curve3)
    
    let curve4 = CubicCurve (
        point: CGPoint(x: 1.0, y: 0.0),
        control1: CGPoint(x: 1.0, y: 0.0),
        control2: CGPoint(x: 1.0, y: 0.0))
    curves.append(curve4)

    
    let curve5 = CubicCurve (
        point: CGPoint(x: 1.0, y: 1.0),
        control1: CGPoint(x: 1.0, y: 0.0),
        control2: CGPoint(x: 1.0, y: 1.0))
    curves.append(curve5)

    return curves
}

struct AnimatableShape: Shape {
    var curves:[CubicCurve]

    var animatableData: AnimatableCubicCurveList {
        get { AnimatableCubicCurveList(values: curves) }
        set { curves = newValue.values }
    }

    func path(in rect: CGRect) -> Path {
        func adjustPoint(p: CGPoint) -> CGPoint {
            return CGPoint(x: p.x * rect.width, y: p.y * rect.height)
        }

        var path = Path()
        path.move(to: adjustPoint(p: curves[0].point))
        for i in 1..<curves.count {
            path.addCurve(to: adjustPoint(p: curves[i].point),
                          control1: adjustPoint(p: curves[i].control1),
                          control2: adjustPoint(p: curves[i].control2))
        }
        path.closeSubpath()
        return path
    }
}

struct AnimatableCubicCurveList : VectorArithmetic {
    var values:[CubicCurve]

    var magnitudeSquared: Double {
        // dotProduct has no meaning on a list of cubic curves
        return 0.0
    }

    mutating func scale(by rhs: Double) {
        values = values.map { $0 * rhs }
    }

    static var zero: AnimatableCubicCurveList {
        return AnimatableCubicCurveList(values: [CubicCurve.zero])
    }

    static func - (lhs: AnimatableCubicCurveList, rhs: AnimatableCubicCurveList) ->
    AnimatableCubicCurveList {
        let result = zip(lhs.values, rhs.values).map(-)
        return AnimatableCubicCurveList(values: result)
    }

    static func -= (lhs: inout AnimatableCubicCurveList, rhs: AnimatableCubicCurveList) {
        lhs = lhs - rhs
    }

    static func + (lhs: AnimatableCubicCurveList, rhs: AnimatableCubicCurveList) ->
    AnimatableCubicCurveList {
        let result = zip(lhs.values, rhs.values).map(+)
        return AnimatableCubicCurveList(values: result)
    }

    static func += (lhs: inout AnimatableCubicCurveList, rhs: AnimatableCubicCurveList) {
        lhs = lhs + rhs
    }
}

struct CubicCurve : VectorArithmetic {
    var point: CGPoint
    var control1: CGPoint
    var control2: CGPoint

    var magnitudeSquared: Double {
        return 0.0
    }

    mutating func scale(by rhs: Double) {
        self.point.x.scale(by: rhs)
        self.point.y.scale(by: rhs)
        self.control1.x.scale(by: rhs)
        self.control1.y.scale(by: rhs)
        self.control2.x.scale(by: rhs)
        self.control2.y.scale(by: rhs)
    }

    static var zero: CubicCurve {
        return CubicCurve(point: CGPoint(x: 0.0, y: 0.0),
                          control1: CGPoint(x: 0.0, y: 0.0),
                          control2: CGPoint(x: 0.0, y: 0.0))
    }

    static func - (lhs: CubicCurve, rhs: CubicCurve) -> CubicCurve {
        return CubicCurve(
            point: CGPoint(
                x: lhs.point.x - rhs.point.x,
                y: lhs.point.y - rhs.point.y),
            control1: CGPoint(
                x: lhs.control1.x - rhs.control1.x,
                y: lhs.control1.y - rhs.control1.y),
            control2: CGPoint(
                x: lhs.control2.x - rhs.control2.x,
                y: lhs.control2.y - rhs.control2.y))
    }

    static func -= (lhs: inout CubicCurve, rhs: CubicCurve) {
        lhs = lhs - rhs
    }

    static func + (lhs: CubicCurve, rhs: CubicCurve) -> CubicCurve {
        return CubicCurve(
            point: CGPoint(
                x: lhs.point.x + rhs.point.x,
                y: lhs.point.y + rhs.point.y),
            control1: CGPoint(
                x: lhs.control1.x + rhs.control1.x,
                y: lhs.control1.y + rhs.control1.y),
            control2: CGPoint(
                x: lhs.control2.x + rhs.control2.x,
                y: lhs.control2.y + rhs.control2.y))
    }

    static func += (lhs: inout CubicCurve, rhs: CubicCurve) {
        lhs = lhs + rhs
    }

    static func * (lhs: CubicCurve, rhs: Double) -> CubicCurve {
        return CubicCurve(
            point: CGPoint(
                x: lhs.point.x * CGFloat(rhs),
                y: lhs.point.y * CGFloat(rhs)),
            control1: CGPoint(
                x: lhs.control1.x * CGFloat(rhs),
                y: lhs.control1.y * CGFloat(rhs)),
            control2: CGPoint(
                x: lhs.control2.x * CGFloat(rhs),
                y: lhs.control2.y * CGFloat(rhs)))
    }
}
