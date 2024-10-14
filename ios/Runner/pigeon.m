// Autogenerated from Pigeon (v4.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "pigeon.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ?: [NSNull null]),
        @"message": (error.message ?: [NSNull null]),
        @"details": (error.details ?: [NSNull null]),
        };
  }
  return @{
      @"result": (result ?: [NSNull null]),
      @"error": errorDict,
      };
}
static id GetNullableObject(NSDictionary* dict, id key) {
  id result = dict[key];
  return (result == [NSNull null]) ? nil : result;
}
static id GetNullableObjectAtIndex(NSArray* array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}


@interface PlatformPose ()
+ (PlatformPose *)fromMap:(NSDictionary *)dict;
+ (nullable PlatformPose *)nullableFromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end
@interface PlatformPoseLandmark ()
+ (PlatformPoseLandmark *)fromMap:(NSDictionary *)dict;
+ (nullable PlatformPoseLandmark *)nullableFromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end
@interface PlatformInputImage ()
+ (PlatformInputImage *)fromMap:(NSDictionary *)dict;
+ (nullable PlatformInputImage *)nullableFromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end
@interface InputImageData ()
+ (InputImageData *)fromMap:(NSDictionary *)dict;
+ (nullable InputImageData *)nullableFromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end
@interface InputImagePlaneMetadata ()
+ (InputImagePlaneMetadata *)fromMap:(NSDictionary *)dict;
+ (nullable InputImagePlaneMetadata *)nullableFromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end

@implementation PlatformPose
+ (instancetype)makeWithLandmarks:(NSDictionary<NSNumber *, PlatformPoseLandmark *> *)landmarks {
  PlatformPose* pigeonResult = [[PlatformPose alloc] init];
  pigeonResult.landmarks = landmarks;
  return pigeonResult;
}
+ (PlatformPose *)fromMap:(NSDictionary *)dict {
  PlatformPose *pigeonResult = [[PlatformPose alloc] init];
  pigeonResult.landmarks = GetNullableObject(dict, @"landmarks");
  NSAssert(pigeonResult.landmarks != nil, @"");
  return pigeonResult;
}
+ (nullable PlatformPose *)nullableFromMap:(NSDictionary *)dict { return (dict) ? [PlatformPose fromMap:dict] : nil; }
- (NSDictionary *)toMap {
  return @{
    @"landmarks" : (self.landmarks ?: [NSNull null]),
  };
}
@end

@implementation PlatformPoseLandmark
+ (instancetype)makeWithType:(NSNumber *)type
    x:(NSNumber *)x
    y:(NSNumber *)y
    z:(NSNumber *)z
    likelihood:(NSNumber *)likelihood {
  PlatformPoseLandmark* pigeonResult = [[PlatformPoseLandmark alloc] init];
  pigeonResult.type = type;
  pigeonResult.x = x;
  pigeonResult.y = y;
  pigeonResult.z = z;
  pigeonResult.likelihood = likelihood;
  return pigeonResult;
}
+ (PlatformPoseLandmark *)fromMap:(NSDictionary *)dict {
  PlatformPoseLandmark *pigeonResult = [[PlatformPoseLandmark alloc] init];
  pigeonResult.type = GetNullableObject(dict, @"type");
  NSAssert(pigeonResult.type != nil, @"");
  pigeonResult.x = GetNullableObject(dict, @"x");
  NSAssert(pigeonResult.x != nil, @"");
  pigeonResult.y = GetNullableObject(dict, @"y");
  NSAssert(pigeonResult.y != nil, @"");
  pigeonResult.z = GetNullableObject(dict, @"z");
  NSAssert(pigeonResult.z != nil, @"");
  pigeonResult.likelihood = GetNullableObject(dict, @"likelihood");
  NSAssert(pigeonResult.likelihood != nil, @"");
  return pigeonResult;
}
+ (nullable PlatformPoseLandmark *)nullableFromMap:(NSDictionary *)dict { return (dict) ? [PlatformPoseLandmark fromMap:dict] : nil; }
- (NSDictionary *)toMap {
  return @{
    @"type" : (self.type ?: [NSNull null]),
    @"x" : (self.x ?: [NSNull null]),
    @"y" : (self.y ?: [NSNull null]),
    @"z" : (self.z ?: [NSNull null]),
    @"likelihood" : (self.likelihood ?: [NSNull null]),
  };
}
@end

@implementation PlatformInputImage
+ (instancetype)makeWithPlanes:(NSArray<FlutterStandardTypedData *> *)planes
    inputImageData:(InputImageData *)inputImageData {
  PlatformInputImage* pigeonResult = [[PlatformInputImage alloc] init];
  pigeonResult.planes = planes;
  pigeonResult.inputImageData = inputImageData;
  return pigeonResult;
}
+ (PlatformInputImage *)fromMap:(NSDictionary *)dict {
  PlatformInputImage *pigeonResult = [[PlatformInputImage alloc] init];
  pigeonResult.planes = GetNullableObject(dict, @"planes");
  NSAssert(pigeonResult.planes != nil, @"");
  pigeonResult.inputImageData = [InputImageData nullableFromMap:GetNullableObject(dict, @"inputImageData")];
  NSAssert(pigeonResult.inputImageData != nil, @"");
  return pigeonResult;
}
+ (nullable PlatformInputImage *)nullableFromMap:(NSDictionary *)dict { return (dict) ? [PlatformInputImage fromMap:dict] : nil; }
- (NSDictionary *)toMap {
  return @{
    @"planes" : (self.planes ?: [NSNull null]),
    @"inputImageData" : (self.inputImageData ? [self.inputImageData toMap] : [NSNull null]),
  };
}
@end

@implementation InputImageData
+ (instancetype)makeWithHeight:(NSNumber *)height
    width:(NSNumber *)width
    imageRotation:(NSNumber *)imageRotation
    inputImageFormat:(NSNumber *)inputImageFormat
    planeData:(NSArray<InputImagePlaneMetadata *> *)planeData {
  InputImageData* pigeonResult = [[InputImageData alloc] init];
  pigeonResult.height = height;
  pigeonResult.width = width;
  pigeonResult.imageRotation = imageRotation;
  pigeonResult.inputImageFormat = inputImageFormat;
  pigeonResult.planeData = planeData;
  return pigeonResult;
}
+ (InputImageData *)fromMap:(NSDictionary *)dict {
  InputImageData *pigeonResult = [[InputImageData alloc] init];
  pigeonResult.height = GetNullableObject(dict, @"height");
  NSAssert(pigeonResult.height != nil, @"");
  pigeonResult.width = GetNullableObject(dict, @"width");
  NSAssert(pigeonResult.width != nil, @"");
  pigeonResult.imageRotation = GetNullableObject(dict, @"imageRotation");
  NSAssert(pigeonResult.imageRotation != nil, @"");
  pigeonResult.inputImageFormat = GetNullableObject(dict, @"inputImageFormat");
  NSAssert(pigeonResult.inputImageFormat != nil, @"");
  pigeonResult.planeData = GetNullableObject(dict, @"planeData");
  NSAssert(pigeonResult.planeData != nil, @"");
  return pigeonResult;
}
+ (nullable InputImageData *)nullableFromMap:(NSDictionary *)dict { return (dict) ? [InputImageData fromMap:dict] : nil; }
- (NSDictionary *)toMap {
  return @{
    @"height" : (self.height ?: [NSNull null]),
    @"width" : (self.width ?: [NSNull null]),
    @"imageRotation" : (self.imageRotation ?: [NSNull null]),
    @"inputImageFormat" : (self.inputImageFormat ?: [NSNull null]),
    @"planeData" : (self.planeData ?: [NSNull null]),
  };
}
@end

@implementation InputImagePlaneMetadata
+ (instancetype)makeWithBytesPerRow:(NSNumber *)bytesPerRow
    bytesPerPixel:(nullable NSNumber *)bytesPerPixel
    height:(nullable NSNumber *)height
    width:(nullable NSNumber *)width {
  InputImagePlaneMetadata* pigeonResult = [[InputImagePlaneMetadata alloc] init];
  pigeonResult.bytesPerRow = bytesPerRow;
  pigeonResult.bytesPerPixel = bytesPerPixel;
  pigeonResult.height = height;
  pigeonResult.width = width;
  return pigeonResult;
}
+ (InputImagePlaneMetadata *)fromMap:(NSDictionary *)dict {
  InputImagePlaneMetadata *pigeonResult = [[InputImagePlaneMetadata alloc] init];
  pigeonResult.bytesPerRow = GetNullableObject(dict, @"bytesPerRow");
  NSAssert(pigeonResult.bytesPerRow != nil, @"");
  pigeonResult.bytesPerPixel = GetNullableObject(dict, @"bytesPerPixel");
  pigeonResult.height = GetNullableObject(dict, @"height");
  pigeonResult.width = GetNullableObject(dict, @"width");
  return pigeonResult;
}
+ (nullable InputImagePlaneMetadata *)nullableFromMap:(NSDictionary *)dict { return (dict) ? [InputImagePlaneMetadata fromMap:dict] : nil; }
- (NSDictionary *)toMap {
  return @{
    @"bytesPerRow" : (self.bytesPerRow ?: [NSNull null]),
    @"bytesPerPixel" : (self.bytesPerPixel ?: [NSNull null]),
    @"height" : (self.height ?: [NSNull null]),
    @"width" : (self.width ?: [NSNull null]),
  };
}
@end

@interface PlatformPoseDetectorCodecReader : FlutterStandardReader
@end
@implementation PlatformPoseDetectorCodecReader
- (nullable id)readValueOfType:(UInt8)type 
{
  switch (type) {
    case 128:     
      return [InputImageData fromMap:[self readValue]];
    
    case 129:     
      return [InputImagePlaneMetadata fromMap:[self readValue]];
    
    case 130:     
      return [PlatformInputImage fromMap:[self readValue]];
    
    case 131:     
      return [PlatformPose fromMap:[self readValue]];
    
    case 132:     
      return [PlatformPoseLandmark fromMap:[self readValue]];
    
    default:    
      return [super readValueOfType:type];
    
  }
}
@end

@interface PlatformPoseDetectorCodecWriter : FlutterStandardWriter
@end
@implementation PlatformPoseDetectorCodecWriter
- (void)writeValue:(id)value 
{
  if ([value isKindOfClass:[InputImageData class]]) {
    [self writeByte:128];
    [self writeValue:[value toMap]];
  } else 
  if ([value isKindOfClass:[InputImagePlaneMetadata class]]) {
    [self writeByte:129];
    [self writeValue:[value toMap]];
  } else 
  if ([value isKindOfClass:[PlatformInputImage class]]) {
    [self writeByte:130];
    [self writeValue:[value toMap]];
  } else 
  if ([value isKindOfClass:[PlatformPose class]]) {
    [self writeByte:131];
    [self writeValue:[value toMap]];
  } else 
  if ([value isKindOfClass:[PlatformPoseLandmark class]]) {
    [self writeByte:132];
    [self writeValue:[value toMap]];
  } else 
{
    [super writeValue:value];
  }
}
@end

@interface PlatformPoseDetectorCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation PlatformPoseDetectorCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[PlatformPoseDetectorCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[PlatformPoseDetectorCodecReader alloc] initWithData:data];
}
@end


NSObject<FlutterMessageCodec> *PlatformPoseDetectorGetCodec() {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    PlatformPoseDetectorCodecReaderWriter *readerWriter = [[PlatformPoseDetectorCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void PlatformPoseDetectorSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PlatformPoseDetector> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.PlatformPoseDetector.processImage"
        binaryMessenger:binaryMessenger
        codec:PlatformPoseDetectorGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(processImageInputImage:completion:)], @"PlatformPoseDetector api (%@) doesn't respond to @selector(processImageInputImage:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        PlatformInputImage *arg_inputImage = GetNullableObjectAtIndex(args, 0);
        [api processImageInputImage:arg_inputImage completion:^(PlatformPose *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.PlatformPoseDetector.closeDetector"
        binaryMessenger:binaryMessenger
        codec:PlatformPoseDetectorGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(closeDetectorWithError:)], @"PlatformPoseDetector api (%@) doesn't respond to @selector(closeDetectorWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api closeDetectorWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
