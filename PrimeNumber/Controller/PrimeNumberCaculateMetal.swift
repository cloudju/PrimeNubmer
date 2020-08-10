//
//  PrimeNumberCaculateMetal.swift
//  PrimeNumber
//
//  Created by 居朝強 on 2020/08/10.
//  Copyright © 2020 Cloud.Ju. All rights reserved.
//

import Metal

class PrimeNumberCaculateMetal {
    // metalの仕様に従って、Pipelineを一回のみ生成する旨で、クラスをシングルトンにする。
    static let def = PrimeNumberCaculateMetal()
    
    private var device: MTLDevice!
    private var defaultLibrary: MTLLibrary!
    private var commandQueue: MTLCommandQueue!
    private var computePipelineState: MTLComputePipelineState!
    
    // metal用pipleline作成
    private init() {
        device = MTLCreateSystemDefaultDevice()
        defaultLibrary = device.makeDefaultLibrary()
        commandQueue = device.makeCommandQueue()
        let ml2Func = defaultLibrary.makeFunction(name: "addOne")!
        computePipelineState = try! device.makeComputePipelineState(function: ml2Func)
    }
    
    // 計算用関数
    func calculate()
    {
        let inputDataCount = 100
        //入力データ
        var inputData:[Float] = []
        for _ in 0...inputDataCount-1 {
            inputData.append(Float(arc4random_uniform(UInt32(inputDataCount))))
        }

        //コマンドバッファとエンコーダの作成と設定
        guard
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let computeCommandEncoder = commandBuffer.makeComputeCommandEncoder()
            else {
                return
        }
        
        computeCommandEncoder.setComputePipelineState(computePipelineState)

        //入力バッファの作成と設定
        let inputDataBuffer = device.makeBuffer(bytes: inputData, length: inputData.byteLength, options: [])
        computeCommandEncoder.setBuffer(inputDataBuffer, offset: 0, index: 0)

        //出力バッファの作成と設定
        let outputData = [Float](repeating: 0, count: inputData.count)
        let outputDataBuffer = device.makeBuffer(bytes: outputData, length: outputData.byteLength, options: [])
        computeCommandEncoder.setBuffer(outputDataBuffer, offset: 0, index: 1)

        //スレッドグループの数、スレッドグループ内のスレッドの数を設定。これにより並列で実行される演算数が決定される
        let width = 64
        let threadsPerGroup = MTLSize(width: width, height: 1, depth: 1)
        let numThreadgroups = MTLSize(width: (inputData.count + width - 1) / width, height: 1, depth: 1)
        computeCommandEncoder.dispatchThreadgroups(numThreadgroups, threadsPerThreadgroup: threadsPerGroup)

        //エンコーダーからのコマンドは終了
        computeCommandEncoder.endEncoding()

        //コマンドバッファを実行し、完了するまで待機
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        //結果をresultDataに格納
        let data = Data(bytesNoCopy: (outputDataBuffer?.contents())!, count: outputData.byteLength, deallocator: .none)
        var resultData = [Float](repeating: 1, count: outputData.count)
        resultData = data.withUnsafeBytes { dataBytes in
            let startAddress = dataBytes.bindMemory(to: Float.self).baseAddress
            return Array(UnsafeBufferPointer<Float>(
                start: startAddress ,
                count: data.count/MemoryLayout<Float>.size))
        }

        //結果の表示
        print("[Input data]: \(inputData)")
        print("[Result data]: \(resultData)")
    }
    
    
}

//配列要素のバイト数を取得
private extension Array {
    var byteLength: Int {
        return self.count * MemoryLayout.size(ofValue: self[0])
    }
}
