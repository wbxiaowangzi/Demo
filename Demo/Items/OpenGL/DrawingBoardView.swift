////
////  DrawingBoardView.swift
////  Demo
////
////  Created by YingZi on 2018/11/2.
////  Copyright © 2018 wangbo. All rights reserved.
////
//
//import UIKit
//import GLKit
//import OpenGLES.ES2.glext
//
//let STROKE_WIDTH_MIN = 0.004
//
//let STROKE_WIDTH_MAX = 0.030
//
//let STROKE_WIDTH_SMOOTHING = 0.5
//
//let VELOCITY_CLAMP_MIN = 20
//
//let VELOCITY_CLAMP_MAC = 5000
//
//let QUADRATIC_DISTANCE_TOLERANCE = 3.0
//
//let MAXMUM_VERTECES = 1000000
//
//let StrokeColor = GLKVector3.init(v: (0, 0, 0))
//
//var clearColor = [1.0, 1.0, 1.0,0.0]
//
//public struct _WFSignaturePoint {
//    public var vertex: GLKVector3
//
//    public var color: GLKVector3
//}
//
//public typealias WFSignaturePoint = _WFSignaturePoint
//
//let maxLength = MAXMUM_VERTECES
////以下几个方法调用OpenGL函数实现一些数据处理
//
////通过点数组添加矢量
//func addVertex( length : inout uint, pointsArray : Array<NSNumber>, v : UnsafeRawPointer) {
//    var sum = 0
//    for num : NSNumber in pointsArray {
//        sum += num.intValue
//    }
//    let len = Int(length) + sum
//    if len >= maxLength {
//        return
//    }
//    var data : UnsafeMutableRawPointer
//    data = glMapBufferOES(UInt32(GL_ARRAY_BUFFER), UInt32(GL_WRITE_ONLY_OES))
//    data = data + MemoryLayout<WFSignaturePoint>.size * len
//    memcpy(data, v, MemoryLayout<WFSignaturePoint>.size)
//    glUnmapBufferOES(GLenum(GL_ARRAY_BUFFER))
//    length += 1
//}
//
////获取曲线二次点
//func QuadraticPointInCurve( start : CGPoint, end : CGPoint, controlPoint : CGPoint, percent : Float) -> CGPoint {
//    var a, b, c : Float
//    a = pow((1.0-percent), 2.0)
//    b = 2.0 * percent * (1.0 - percent)
//    c = pow(percent, 2.0)
//    
//    return CGPoint.init(x: Double(a) * Double(start.x) + Double(b) * Double(controlPoint.x) + Double(c) * Double(end.x), y: Double(a) * Double(start.y) + Double(b) * Double(controlPoint.y) + Double(c) * Double(end.y))
//}
//
////获取范围内随机数
//func generateRandom(from : Float, to : Float) -> Float {
//    return Float(arc4random() % 10000) / 10000.0 * (to - from) + from
//}
////夹紧
//func clamp(min : Float, max : Float, value : Float) -> Float {
//    return fmaxf(min, fminf(max, value))
//}
//
////获取两点所在直线的垂线
//func perpendicular(p1 : WFSignaturePoint, p2 : WFSignaturePoint) -> GLKVector3 {
//    let ret = GLKVector3.init(v: (p2.vertex.y - p1.vertex.y, -1 * (p2.vertex.x - p1.vertex.x), 0))
//    return ret
//}
//
////视图点转换成GL点
//func viewPointToGL(viewPoint : CGPoint, bounds : CGRect, color : GLKVector3) -> WFSignaturePoint {
//    return WFSignaturePoint.init(vertex: GLKVector3.init(v: (Float(viewPoint.x / bounds.size.width * 2.0) - 1, (Float((viewPoint.y / bounds.size.height) * 2.0) - 1) * -1, 0)), color: color)
//}
//
//class DrawingBoardView: GLKView {
//    /*
//     画笔颜色
//     */
//    var strokeColor : UIColor?
//    /*
//     是否有签名
//     */
//    var hasSignature : Bool
//    /*
//     签名图片
//     */
//    var signatureImage : UIImage? {
//        get {
//            return self.snapshot
//        }
//    }
//    
//    /**
//     上下文
//     **/
//    var glContext : EAGLContext?
//    /**
//     GLK base effect
//     **/
//    var effect : GLKBaseEffect?
//    /**
//     顶点数组
//     **/
//    var vertexArray : GLuint = 0
//    /**
//     顶点缓冲区
//     **/
//    var vertexBuffer : GLuint = 0
//    /**
//     圆点数组
//     **/
//    var dotsArray : GLuint = 0
//    /**
//     圆点缓冲区
//     **/
//    var dotsBuffer : GLuint = 0
//    /**
//     笔画顶点数组
//     **/
//    var signatureVertexData : Array<WFSignaturePoint?> = Array.init(repeating: nil, count: maxLength)
//
//    var length : uint = 0
//    /**
//     笔画圆点数组
//     **/
//    var signatureDotsData : Array<WFSignaturePoint?> = Array.init(repeating: nil, count: maxLength)
//
//    var dotsLength : uint = 0
//    /**
//     笔画厚度
//     **/
//    var penThickness : Float = 0.0
//    /**
//     之前的厚度
//     **/
//    var previousThickness : Float = 0.0
//    /**
//     之前的点
//     **/
//    var previousPoint : CGPoint?
//    /**
//     之前的中点
//     **/
//    var previousMidPoint : CGPoint?
//    /**
//     之前的顶点
//     **/
//    var previousVertex : WFSignaturePoint?
//    /**
//     当前的速度
//     **/
//    var currentVelocity : WFSignaturePoint?
//    /**
//     点数组
//     **/
//    private var pointsArray : Array<NSNumber> = Array.init()
//    /**
//     笔颜色
//     **/
//    private var penColor : GLKVector3 = GLKVector3.init(v: (0, 0, 0))
//    /**
//     当前路径
//     **/
//    private var currentPath : Int = 0
//    
//    required init?(coder aDecoder: NSCoder) {
//        self.hasSignature = true
//        super.init(coder: aDecoder)
//        self.commonInit()
//    }
//    
//    override init(frame: CGRect, context: EAGLContext) {
//        self.hasSignature = true
//        super.init(frame: frame, context: context)
//        self.commonInit()
//    }
//    
//    func commonInit() {
//        glContext = EAGLContext.init(api: EAGLRenderingAPI(rawValue: 2)!)
//        if glContext != nil {
//            time(UnsafeMutablePointer.init(bitPattern: 0))
//            
//            self.setBackgroundColor(backgroundColor: .white)
//            self.isOpaque = false
//            
//            self.context = glContext!
//            self.drawableDepthFormat = GLKViewDrawableDepthFormat.init(rawValue: 2)!
//            self.enableSetNeedsDisplay = true
//            
//            self.drawableMultisample = GLKViewDrawableMultisample.init(rawValue: 1)!
//            
//            self.setupGL()
//            
//            let pan = UIPanGestureRecognizer.init(target: self, action: #selector(self.pan(p: )))
//            pan.maximumNumberOfTouches = 1
//            pan.minimumNumberOfTouches = 1
//            pan.cancelsTouchesInView = true
//            self.addGestureRecognizer(pan)
//            
//            let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tap(t: )))
//            tap.cancelsTouchesInView = true
//            self.addGestureRecognizer(tap)
//            
//            let longer = UILongPressGestureRecognizer.init(target: self, action: #selector(self.longPress(p: )))
//            longer.cancelsTouchesInView = true
//            self.addGestureRecognizer(longer)
//        } else {
//            print("NSOpenGLES2ContextException")
//        }
//    }
//    
//    deinit {
//        self.tearDownGL()
//        
//        if EAGLContext.current() == glContext {
//            EAGLContext.setCurrent(nil)
//        }
//        glContext = nil
//    }
//    
//    override func draw(_ rect: CGRect) {
//        glClearColor(GLfloat(clearColor[0]), GLfloat(clearColor[1]), GLfloat(clearColor[2]), GLfloat(clearColor[3]))
//        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
//        
//        effect?.prepareToDraw()
//        
//        var len = 0
//        for num in pointsArray {
//            len += num.intValue
//        }
//        len += Int(length)
//        
//        if len > 2 {
//            glBindVertexArrayOES(vertexArray)
//            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, GLsizei(len))
//        }
//        
//        if dotsLength > 0 {
//            glBindVertexArrayOES(dotsArray)
//            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, GLsizei(dotsLength))
//        }
//    }
//    
//    func erase() {
//        length = 0
//        dotsLength = 0
//        pointsArray.removeAll()
//        self.hasSignature = false
//        
//        self.setNeedsDisplay()
//    }
//    
//    static var segments : Int = 20
//
//    @objc func tap(t : UITapGestureRecognizer) {
//        let l = t.location(in: self)
//        
//        if t.state == UIGestureRecognizer.State.recognized {
//            glBindBuffer(GLenum(GL_ARRAY_BUFFER), dotsBuffer)
//            
//            var touchPoint : WFSignaturePoint = viewPointToGL(viewPoint: l, bounds: self.bounds, color: self.penColor)
//            addVertex(length: &dotsLength, pointsArray: pointsArray, v: &touchPoint)
//            
//            var centerPoint = touchPoint
//            centerPoint.color = StrokeColor
//            addVertex(length: &dotsLength, pointsArray: pointsArray, v: &centerPoint)
//            
//            let radius = GLKVector2.init(v: (clamp(min: 0.00001, max: 0.02, value: penThickness * generateRandom(from: 0.5, to: 1.5)), clamp(min: 0.00001, max: 0.02, value: penThickness * generateRandom(from: 0.5, to: 1.5))))
//
//            let velocityRadius = radius
//
//            var angle : Float = 0.0
//            
//            for _ in 0 ... DrawingBoardView.segments {
//                let p = centerPoint
//
//                let x = p.vertex.x + velocityRadius.x * cosf(angle)
//
//                let y = p.vertex.y + velocityRadius.y * sinf(angle)
//
//                var point : WFSignaturePoint = WFSignaturePoint.init(vertex: GLKVector3.init(v: (x, y, p.vertex.z)), color: p.color)
//                addVertex(length: &dotsLength, pointsArray: pointsArray, v: &point)
//                addVertex(length: &dotsLength, pointsArray: pointsArray, v: &centerPoint)
//                
//                angle += Float(Double.pi * 2.0 / Double(DrawingBoardView.segments))
//            }
//            
//            addVertex(length: &dotsLength, pointsArray: pointsArray, v: &touchPoint)
//            glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
//        }
//        self.setNeedsDisplay()
//    }
//    
//    @objc func longPress(p : UILongPressGestureRecognizer) {
//        self.erase()
//    }
//    
//    @objc func pan(p : UIPanGestureRecognizer) {
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
//        
//        let v : CGPoint = p.velocity(in: self)
//
//        let l : CGPoint = p.location(in: self)
//        
//        currentVelocity = viewPointToGL(viewPoint: v, bounds: self.bounds, color: GLKVector3.init(v: (0, 0, 0)))
//        
//        var distance : Float = 0.0
//        if previousPoint!.x > 0 {
//            let a1 = (l.x - previousPoint!.x) * (l.x - previousPoint!.x)
//
//            let a = a1 + (l.y - previousPoint!.y) * (l.y - previousPoint!.y)
//            distance = sqrtf(Float(a))
//        }
//        
//        let velocityMagnitude = sqrtf(Float(v.x * v.x + v.y * v.y))
//
//        let clampedVelocityMagnitude = clamp(min: Float(VELOCITY_CLAMP_MIN), max: Float(VELOCITY_CLAMP_MAC), value: velocityMagnitude)
//
//        let normalizedVelocity = (clampedVelocityMagnitude - Float(VELOCITY_CLAMP_MIN)) / Float(VELOCITY_CLAMP_MAC - VELOCITY_CLAMP_MIN)
//        
//        let lowPassFilterAlpha = STROKE_WIDTH_SMOOTHING
//
//        let newThickness = Float(STROKE_WIDTH_MAX - STROKE_WIDTH_MIN) * Float(1 - normalizedVelocity) + Float(STROKE_WIDTH_MIN)
//        penThickness = penThickness * Float(lowPassFilterAlpha) + newThickness * Float(1 - lowPassFilterAlpha)
//        if p.state == UIGestureRecognizer.State.began {
//            previousPoint = l
//            previousMidPoint = l
//            
//            var startPoint = viewPointToGL(viewPoint: l, bounds: self.bounds, color: self.penColor)
//            previousVertex = startPoint
//            previousThickness = penThickness
//            
//            addVertex(length: &length, pointsArray: pointsArray, v: &startPoint)
//            addVertex(length: &length, pointsArray: pointsArray, v: &previousVertex!)
//            
//            self.hasSignature = true
//            self.currentPath = pointsArray.count
//        } else if p.state == UIGestureRecognizer.State.changed {
//            let mid = CGPoint.init(x: (l.x + (previousPoint?.x)!) / 2.0, y: (l.y + (previousPoint?.y)!) / 2.0)
//            if distance > Float(QUADRATIC_DISTANCE_TOLERANCE) {
//                let segmts : Int = Int(distance/1.5)
//
//                let startPenThickness = previousThickness
//
//                let endPenThickness = penThickness
//                previousThickness = penThickness
//                
//                for index in 0 ... (segmts-1) {
//                    penThickness = startPenThickness + ((endPenThickness - startPenThickness) / Float(segmts)) * Float(index)
//                    let quadPoint = QuadraticPointInCurve(start: previousMidPoint!, end: mid, controlPoint: previousPoint!, percent: Float(index)/Float(segmts))
//
//                    let wfv = viewPointToGL(viewPoint: quadPoint, bounds: self.bounds, color: self.penColor)
//                    self.addTriangleStripPointsForPrevious(previous: previousVertex!, next: wfv)
//                    previousVertex = wfv
//                }
//            } else if distance > 1.0 {
//                let wfv = viewPointToGL(viewPoint: l, bounds: self.bounds, color: self.penColor)
//                self.addTriangleStripPointsForPrevious(previous: previousVertex!, next: wfv)
//                previousVertex = wfv
//                previousThickness = penThickness
//            }
//            previousPoint = l
//            previousMidPoint = mid
//        } else if p.state == UIGestureRecognizer.State.ended || p.state == UIGestureRecognizer.State.cancelled {
//            var wfv = viewPointToGL(viewPoint: l, bounds: self.bounds, color: self.penColor)
//            addVertex(length: &length, pointsArray: pointsArray, v: &wfv)
//            previousVertex = wfv
//            addVertex(length: &length, pointsArray: pointsArray, v: &previousVertex!)
//            pointsArray.append(NSNumber.init(value: Int(length)))
//            length = 0
//        }
//        self.setNeedsDisplay()
//    }
//    
//    func updateStrokeColor() {
//        var red : CGFloat = 0, green : CGFloat = 0, blue : CGFloat = 0, alpha : CGFloat = 0, white : CGFloat = 1
//        if (effect != nil) && (self.strokeColor != nil) && self.strokeColor!.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
//            effect?.constantColor = GLKVector4.init(v: (Float(red), Float(green), Float(blue), Float(alpha)))
//        } else if effect != nil && self.strokeColor != nil && self.strokeColor!.getWhite(&white, alpha: &alpha) {
//            effect?.constantColor = GLKVector4.init(v: (Float(white), Float(white), Float(white), Float(alpha)))
//        } else {
//            effect?.constantColor = GLKVector4.init(v: (0, 0, 0, 1))
//        }
//    }
//    
//    func setBackgroundColor(backgroundColor : UIColor) {
//        self.backgroundColor = backgroundColor
//        
//        var red : CGFloat = 0, green : CGFloat = 0, blue : CGFloat = 0, alpha : CGFloat = 0, white : CGFloat = 1
//        if backgroundColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
//            clearColor[0] = Double(red)
//            clearColor[1] = Double(green)
//            clearColor[2] = Double(blue)
//        } else if backgroundColor.getWhite(&white, alpha: &alpha) {
//            clearColor[0] = Double(white)
//            clearColor[1] = Double(white)
//            clearColor[2] = Double(white)
//        }
//    }
//    
//    func bindShaderAttributes() {
//        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
//        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<WFSignaturePoint>.size), UnsafeRawPointer.init(bitPattern: 0))
//        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
//        glVertexAttribPointer(GLuint(GLKVertexAttrib.color.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(6*MemoryLayout<GLfloat>.size), UnsafeRawPointer.init(bitPattern: 12))
//    }
//    
//    func setupGL() {
//        EAGLContext.setCurrent(glContext)
//        effect = GLKBaseEffect.init()
//        self.updateStrokeColor()
//        
//        glDisable(GLenum(GL_DEPTH_TEST))
//        
//        glGenVertexArraysOES(1, &vertexArray)
//        glBindVertexArrayOES(vertexArray)
//        glGenBuffers(1, &vertexBuffer)
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
//        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<WFSignaturePoint>.size * maxLength, signatureVertexData, GLenum(GL_DYNAMIC_DRAW))
//        self.bindShaderAttributes()
//        
//        glGenVertexArraysOES(1, &dotsArray)
//        glBindVertexArrayOES(dotsArray)
//        glGenBuffers(1, &dotsBuffer)
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), dotsBuffer)
//        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<WFSignaturePoint>.size * maxLength, signatureDotsData, GLenum(GL_DYNAMIC_DRAW))
//        self.bindShaderAttributes()
//        
//        glBindVertexArrayOES(0)
//        
//        let ortho : GLKMatrix4 = GLKMatrix4MakeOrtho(-1, 1, -1, 1, 0.1, 2.0)
//        effect?.transform.projectionMatrix = ortho
//        
//        let modelViewMatrix : GLKMatrix4 = GLKMatrix4MakeTranslation(0.0, 0.0, -1.0)
//        effect?.transform.modelviewMatrix = modelViewMatrix
//        
//        length = 0
//        penThickness = 0.003
//        previousPoint = CGPoint.init(x: -100, y: -100)
//    }
//    
//    func addTriangleStripPointsForPrevious(previous : WFSignaturePoint, next : WFSignaturePoint) {
//        var toTravel = penThickness / 2.0
//        for _ in 0 ... 1 {
//            let p = perpendicular(p1: previous, p2: next)
//
//            let p1 = next.vertex
//
//            let ref = GLKVector3Add(p1, p)
//            
//            let distance = GLKVector3Distance(p1, ref)
//
//            var difX = p1.x - ref.x
//
//            var difY = p1.y - ref.y
//
//            let ratio = -1.0 * (toTravel / distance)
//            
//            difX = difX * ratio
//            difY = difY * ratio
//            
//            var stripPoint = WFSignaturePoint.init(vertex: GLKVector3.init(v: (p1.x + difX, p1.y + difY, 0.0)), color: self.penColor)
//            addVertex(length: &length, pointsArray: pointsArray, v: &stripPoint)
//            toTravel *= -1
//        }
//    }
//    
//    func tearDownGL() {
//        EAGLContext.setCurrent(glContext)
//        glDeleteVertexArraysOES(1, &vertexArray)
//        glDeleteBuffers(1, &vertexBuffer)
//        
//        glDeleteVertexArraysOES(1, &dotsArray)
//        glDeleteBuffers(1, &dotsBuffer)
//        
//        effect = nil
//    }
//    
//    /**
//     *设置笔触颜色
//     */
//    public func setPenColor(color : UIColor) {
//        var red : CGFloat = 0, green : CGFloat = 0, blue : CGFloat = 0, alpha : CGFloat = 0
//        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        self.penColor = GLKVector3.init(v: (Float(red), Float(green), Float(blue)))
//    }
//    
//    /**
//     *撤回最后一划
//     */
//    public func remove() {
//        if pointsArray.count<=0 {
//            return
//        }
//        pointsArray.removeLast()
//        self .setNeedsDisplay()
//    }
//}
