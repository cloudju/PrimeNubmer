//
//  primeNuberCaculate.metal
//  PrimeNumber
//
//  Created by 居朝強 on 2020/08/10.
//  Copyright © 2020 Cloud.Ju. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

using namespace metal;

kernel void addOne(const device float *inputData [[ buffer(0) ]],
                         device float *outputData [[ buffer(1) ]],
                         uint id [[ thread_position_in_grid ]])
{
    float result = inputData[id];
    result += 1.0f;
    outputData[id] = result;
}
