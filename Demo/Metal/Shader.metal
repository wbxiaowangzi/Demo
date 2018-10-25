//
//  Shader.metal
//  Demo
//
//  Created by 王波 on 2018/10/4.
//  Copyright © 2018 wangbo. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertext ( constant packed_float3* vertex_array[[buffer(0)]], unsigned int vid[[vertex_id]]){
    return float4(vertex_array[vid], 1.0);
    
}

