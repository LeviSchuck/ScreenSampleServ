//
//  main.cpp
//  ScreenSampleServ
//
//  Created by Levi Schuck on 8/23/15.
//  Copyright (c) 2015 Levi Schuck. All rights reserved.
//

#include <stdio.h>
#include <cstdint>
#include <vector>

#include "ScreenSample.h"
#include "opc_client.h"

std::vector<uint8_t> frameBuffer;
OPCClient opc;

int main(int argc, const char * argv[]) {
    const int width = 25;
    const int height = 15;
    const int pixels = width + height*2;
    const int bytes = pixels*3;
    uint8_t vals[bytes];
    
    /*for(int blah = 0; blah < 10; blah++){
            takeSample(vals, width, height, 0.8f);
            dumpPixels(vals, pixels);
    }*/
    
    frameBuffer.resize(sizeof(OPCClient::Header) + bytes);
    OPCClient::Header::view(frameBuffer).init(0, opc.SET_PIXEL_COLORS, bytes);
    opc.resolve("localhost");
    while(true){
        if (!opc.tryConnect()) {
            sleep(10);
            continue;
        }
        takeSample(vals,width,height,0.8f);
        uint8_t * dest = OPCClient::Header::view(frameBuffer).data();
        memcpy(dest,vals,bytes);
        opc.write(frameBuffer);
        usleep(100000);
    }
    
    return 0;
}