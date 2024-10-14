//
//  VisionImageUtils.h
//  Runner
//
//  Created by Athresh Kiran PR on 19/10/22.
//

#import <Flutter/Flutter.h>
#import <MLKitVision/MLKitVision.h>
#import "VisionImageUtils.h"
#import "pigeon.h"
NS_ASSUME_NONNULL_BEGIN

@implementation VisionImageUtils

+ (MLKVisionImage *)visionImageFrom:(NSArray<FlutterStandardTypedData *> *)planes withImageData:(InputImageData *) inputImageData{
    
    size_t planeCount = inputImageData.planeData.count;
    
    FourCharCode format = FOUR_CHAR_CODE(inputImageData.inputImageFormat.unsignedIntValue);
    
    CVPixelBufferRef pxBuffer = NULL;
    if (planeCount == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Can't create image buffer with 0 planes."
                                     userInfo:nil];
    } else if (planeCount == 1) {
        InputImagePlaneMetadata *plane = inputImageData.planeData[0];
        NSNumber *bytesPerRow = plane.bytesPerRow;
        pxBuffer = [self bytesToPixelBuffer:inputImageData.width.unsignedLongValue
                                     height:inputImageData.height.unsignedLongValue
                                     format:format
                                baseAddress:(void *)planes[0].data.bytes
                                bytesPerRow:bytesPerRow.unsignedLongValue];
    } else {
        NSMutableData *imageData = [planes.firstObject.data mutableCopy];
        for (int i=1; i<planes.count; i++) {
            [imageData appendData:planes[i].data];
        }
        pxBuffer = [self planarBytesToPixelBuffer:inputImageData.width.unsignedLongValue
                                           height:inputImageData.height.unsignedLongValue
                                           format:format
                                      baseAddress:(void *)imageData.bytes
                                         dataSize:imageData.length
                                       planeCount:planeCount
                                        planeData:inputImageData.planeData];
    }
    
    return [self pixelBufferToVisionImage:pxBuffer];
}

+ (CVPixelBufferRef)bytesToPixelBuffer:(size_t)width
                                height:(size_t)height
                                format:(FourCharCode)format
                           baseAddress:(void *)baseAddress
                           bytesPerRow:(size_t)bytesPerRow {
    CVPixelBufferRef pxBuffer = NULL;
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault, width, height, format, baseAddress, bytesPerRow,
                                 NULL, NULL, NULL, &pxBuffer);
    return pxBuffer;
}

+ (CVPixelBufferRef)planarBytesToPixelBuffer:(size_t)width
                                      height:(size_t)height
                                      format:(FourCharCode)format
                                 baseAddress:(void *)baseAddress
                                    dataSize:(size_t)dataSize
                                  planeCount:(size_t)planeCount
                                   planeData:(NSArray<InputImagePlaneMetadata *> *)planeData {
    size_t widths[planeCount];
    size_t heights[planeCount];
    size_t bytesPerRows[planeCount];
    
    void *baseAddresses[planeCount];
    baseAddresses[0] = baseAddress;
    
    size_t lastAddressIndex = 0;  // Used to get base address for each plane
    for (int i = 0; i < planeCount; i++) {
        InputImagePlaneMetadata *plane = planeData[i];
        
        NSNumber *width = plane.width;
        NSNumber *height = plane.height;
        NSNumber *bytesPerRow = plane.bytesPerRow;
        
        widths[i] = width.unsignedLongValue;
        heights[i] = height.unsignedLongValue;
        bytesPerRows[i] = bytesPerRow.unsignedLongValue;
        
        if (i > 0) {
            size_t addressIndex = lastAddressIndex + heights[i - 1] * bytesPerRows[i - 1];
            baseAddresses[i] = baseAddress + addressIndex;
            lastAddressIndex = addressIndex;
        }
    }
    
    CVPixelBufferRef pxBuffer = NULL;
    CVPixelBufferCreateWithPlanarBytes(kCFAllocatorDefault, width, height, format, NULL, dataSize,
                                       planeCount, baseAddresses, widths, heights, bytesPerRows, NULL,
                                       NULL, NULL, &pxBuffer);
    
    return pxBuffer;
}

+ (MLKVisionImage *)pixelBufferToVisionImage:(CVPixelBufferRef)pixelBufferRef {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage =
    [temporaryContext createCGImage:ciImage
                           fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBufferRef),
                                               CVPixelBufferGetHeight(pixelBufferRef))];
    
    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CVPixelBufferRelease(pixelBufferRef);
    CGImageRelease(videoImage);
    return [[MLKVisionImage alloc] initWithImage:uiImage];
}

@end


NS_ASSUME_NONNULL_END
