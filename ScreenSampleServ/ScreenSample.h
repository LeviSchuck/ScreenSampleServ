//
//  ScreenSample.h
//  ScreenSampleServ
//
//  Created by Levi Schuck on 8/22/15.
//  Copyright (c) 2015 Levi Schuck. All rights reserved.
//

#ifndef ScreenSampleServ_ScreenSample_h
#define ScreenSampleServ_ScreenSample_h


#ifdef __cplusplus
extern "C" {
#endif


void takeSample(uint8_t * dest, const int width, const int height, const float gausBy);
void dumpPixels(uint8_t * vals, const int pixels);

#ifdef __cplusplus
}
#endif

#endif
