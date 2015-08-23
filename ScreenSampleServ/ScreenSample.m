//
//  ScreenSample.m
//  ScreenSampleServ
//
//  Created by Levi Schuck on 8/22/15.
//  Copyright (c) 2015 Levi Schuck. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "ScreenSample.h"

@import CoreGraphics;
@import QuartzCore;
@import AppKit;

CIImage * scaleBlur(CGImageRef img, const float gausBy) {
    NSInteger width = CGImageGetWidth(img) >> 3;
    NSInteger height = CGImageGetHeight(img) >> 3;
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CIImage * cimg = [CIImage imageWithCGImage:img];
    
    CIFilter * resize = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [resize setValue:cimg forKey:kCIInputImageKey];
    [resize setValue:[NSNumber numberWithFloat:1.0f] forKey:kCIInputAspectRatioKey];
    [resize setValue:[NSNumber numberWithFloat:0.125] forKey:kCIInputScaleKey];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter * clamp = [CIFilter filterWithName:@"CIAffineClamp"];
    [clamp setValue:resize.outputImage forKey:kCIInputImageKey];
    [clamp setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:kCIInputTransformKey];
    
    CIFilter * gaus = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaus setValue:clamp.outputImage forKey:kCIInputImageKey];
    [gaus setValue:[NSNumber numberWithFloat:gausBy] forKey:kCIInputRadiusKey];
    
    CIImage * gausCropped = [[gaus valueForKey:kCIOutputImageKey] imageByCroppingToRect:rect];
    
    CIFilter * resize2 = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [resize2 setValue:gausCropped forKey:kCIInputImageKey];
    [resize2 setValue:[NSNumber numberWithFloat:1.0f] forKey:kCIInputAspectRatioKey];
    [resize2 setValue:[NSNumber numberWithFloat:0.125] forKey:kCIInputScaleKey];
    
    CIImage * result = [resize2 valueForKey:kCIOutputImageKey];
    return result;
}

void logColor(NSColor * color){
    NSLog(@"0x%02x%02x%02x\n",
          [[NSNumber numberWithFloat: [color redComponent]*255] intValue],
          [[NSNumber numberWithFloat: [color greenComponent]*255] intValue],
          [[NSNumber numberWithFloat: [color blueComponent]*255] intValue]
          );
}
void putColor(NSColor * color, uint8_t * dest,int * index) {
    dest[(*index)++] = [[NSNumber numberWithFloat: [color redComponent]*255] intValue];
    dest[(*index)++] = [[NSNumber numberWithFloat: [color greenComponent]*255] intValue];
    dest[(*index)++] = [[NSNumber numberWithFloat: [color blueComponent]*255] intValue];
}

void takeSample(uint8_t * dest, const int width, const int height, const float gausBy) {
    @autoreleasepool {
        CGImageRef screenshot = CGDisplayCreateImage(CGMainDisplayID());
        
        CIImage * result = scaleBlur(screenshot, gausBy);
        
        // NSString * filePath = [@"~/Desktop/test.png" stringByExpandingTildeInPath];
        NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithCIImage: result];
        // NSData *pngData = [rep representationUsingType: NSPNGFileType properties: nil];
        // [pngData writeToFile: filePath atomically: YES];
        
        NSInteger stepX = [rep pixelsWide] / width;
        NSInteger stepY = [rep pixelsHigh] / height;
        NSInteger midY = stepY * (0.45 * height);
        NSColor * color;
        int index = 0;
        
        // right, upwards
        for(int i = height-1; i >= 0; i--){
            color = [rep colorAtX:([rep pixelsWide] - stepX) y:(i * stepY)];
            putColor(color, dest, &index);
            //dest[index++] = i % 3 != 0 ? 255 : 0;
            //dest[index++] = i % 3 != 1 ? 255 : 0;
            //dest[index++] = i % 3 != 2 ? 255 : 0;
        }
        
        // middle, towards left
        for(int i = width-1; i >= 0; i--){
            color = [rep colorAtX:(stepX * i) y:midY];
            putColor(color, dest, &index);
            //dest[index++] = i % 3 == 0 ? 255 : 0;
            //dest[index++] = i % 3 == 1 ? 255 : 0;
            //dest[index++] = i % 3 == 2 ? 255 : 0;
        }
        //NSLog(@"\n");
        
        //NSLog(@"\n");
        // left, downwards
        for(int i = 0; i < height; i++){
            color = [rep colorAtX:stepX y:(i * stepY)];
            putColor(color, dest, &index);
            //dest[index++] = 255;
            //dest[index++] = 255;
            //dest[index++] = 255;
        }
        
        //NSLog(@"Wrote %d pixels\n",index/3);
        
        CGImageRelease(screenshot);
    }
}

void dumpPixels(uint8_t * vals, const int pixels) {
    for(int i = 0; i < pixels; i++){
        int index = i*3;
        int color
        = (vals[index + 0] << (8 * 2))
        + (vals[index + 1] << (8 * 1))
        + (vals[index + 2] << (8 * 0))
        ;
        
        NSLog(@"0x%06x", color);
    }
}
