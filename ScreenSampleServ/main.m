//
//  main.m
//  ScreenSampleServ
//
//  Created by Levi Schuck on 8/22/15.
//  Copyright (c) 2015 Levi Schuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "ScreenSample.h"


int main(int argc, const char * argv[]) {
    const int width = 26;
    const int height = 15;
    const int pixels = width + height*2;
    const int bytes = pixels*3;
    uint8_t vals[bytes];
    
    for(int blah = 0; blah < 1000; blah++){
        @autoreleasepool {
            takeSample(vals, width, height, 0.8f);
            dumpPixels(vals, pixels);
        }
    }
    return 0;
}


