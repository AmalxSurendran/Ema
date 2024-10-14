//
//  VisionImageUtils.h
//  Runner
//
//  Created by Athresh Kiran PR on 19/10/22.
//
#import <MLKitVision/MLKitVision.h>
#import "pigeon.h"
#ifndef MLKVisionImage_FlutterPlugin_h
#define MLKVisionImage_FlutterPlugin_h
@interface VisionImageUtils : NSObject

+ (MLKVisionImage *)visionImageFrom:(NSArray<FlutterStandardTypedData *>*)imageBytes withImageData:(InputImageData *)inputImageData;

@end

#endif /* VisionImageUtils_h */
