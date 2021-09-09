//
//  MetalVC.swift
//  Demo
//
//  Created by 王波 on 2018/10/4.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class MetalVC: UIViewController {

    var device: MTLDevice! = nil//GPU

    var metalLayer: CAMetalLayer! = nil

    var pipelineState: MTLRenderPipelineState! = nil//渲染管道状态

    var commandQueue: MTLCommandQueue! = nil//命令队列

    var vertexBuffer: MTLBuffer! = nil//顶点缓存

    let vertexData: [Float] =
        [0.0,   1.0,  0.0,
        -1.0,  -1.0,  0.0,
         1.0,  -1.0,  0.0, ]
    
    var timer: CADisplayLink! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        creatMTLLayer()
        sizeData()
        CreatPipelineState()
        creatCommandQueue()
        creatTimer()
//        render()
    }
    
    func creatMTLLayer() {
        device = MTLCreateSystemDefaultDevice()
        //创建CAMetalLayer
        metalLayer = CAMetalLayer()
        //明确layer使用的MTLDevice
        metalLayer.device = device
        //把像素格式设置为BGRAUnorm
        metalLayer.pixelFormat = .bgra8Unorm
        //framebufferonly设置为true，来增强表现率，
        metalLayer.framebufferOnly = true
        var frame = view.layer.frame
        frame.size.height -= 120
        frame.origin.y += 84
        metalLayer.frame = frame
        
        var drawableSize = CGSize(width:  self.view.bounds.size.width, height:  self.view.bounds.size.height-64)
        drawableSize.width *= self.view.contentScaleFactor
        drawableSize.height *= self.view.contentScaleFactor
        metalLayer.drawableSize = drawableSize
        view.layer.addSublayer(metalLayer)
    }
    
    func sizeData() {
        let dataSize = vertexData.count * 4
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: MTLResourceOptions(rawValue: UInt(0)))
        
    }

    func CreatPipelineState() {
        
        let defaultLibrary = device.makeDefaultLibrary()

        let fragmentProgram = defaultLibrary?.makeFunction(name: "fragment_func")

        let vertextProgram = defaultLibrary?.makeFunction(name: "vertex_func")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertextProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
    }
    
    func creatCommandQueue() {
        commandQueue = device.makeCommandQueue()
    }
    
    func creatTimer() {
        timer = CADisplayLink(target: self, selector: #selector(self.drawloop))
        timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
    
    func render() {
        creatRenderPassDescriptor()
    }
    
    @objc func drawloop() {
        self.render()
    }
    
    func creatRenderPassDescriptor() {
        let drawable = metalLayer.nextDrawable()

        let renderpassDescriptor = MTLRenderPassDescriptor()
        renderpassDescriptor.colorAttachments[0].texture = drawable?.texture
        renderpassDescriptor.colorAttachments[0].loadAction = .clear
        renderpassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.8, 0.5, 1.0)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderpassDescriptor)
        renderEncoder?.setRenderPipelineState(pipelineState)
        
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable!)
        commandBuffer?.commit()
    }
}
