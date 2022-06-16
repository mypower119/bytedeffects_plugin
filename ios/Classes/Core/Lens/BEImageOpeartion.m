//
//  BEImageOpeartion.m
//  BytedEffects
//
//  Created by Bytedance on 2020/11/26.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEImageOpeartion.h"
#import <Accelerate/Accelerate.h>
#import <CoreVideo/CoreVideo.h>

/*  {zh} 在这里记录这个文件处理的方法，首先一个问题是demo进入页面后什么也不做，tob4.0.2.2, iPhone 7上内存占用在200m左右，这是一个相当高的值
 * 当进入视频模式打开一个视频之后，发现demo的内存在400m - 500m，通过xcode 的内存分析工具，会发现大部分的内存都是cvpixelbuffer，
 * 每次创建cvpixelbuffer 然后调用cfrelease方法，引用计数确实变为了0，但是实际的内存并没有释放，伴随着cvpixelbuffer 还会有另一种
 * 内存，一个1080p 的文件，创建之后，大概会占用10m的内存，这个内存十分的大。当时实际上，我们的demo并没有进行异步的操作，有这么大的内存不符合预期，
 * 所以这里需要一种内存复用的方法就是下面的CVPiexelBufferPool,每次需要生产pixelBuffer的时候，内存都从池里面来，由内存池来为避免仿佛创建的开销
 * 这点在苹果的官网也可以看到。
 * 下面的pixelBufferPoolWithDifferentProperty这个字典的dict 是ostype_hegith_width, value 是齐对应的pixelbufferPool
 * 通过使用这种方法来得到pixelbuffer， 预览模式下的内存从200m -> 100m，视频模式下，内存从400->500m 降到了200m
 */
/*  {en} Here record this file processing method, the first problem is demo into the page after doing nothing, tob4.0.2.2, iPhone 7 memory occupies about 200m, this is a very high value
 *  when entering the video mode to open a video, found demo memory in 400m - 500m, through xcode memory analysis tools, will find that most of the memory is cvpixelbuffer,
 *  each time create cvpixelbuffer and then call cfrelease method, the reference count does become 0, but the actual memory is not released, along with cvpixelbuffer will have another
 *  memory, a 1080p file, after creation, will occupy about 10m of memory, this memory is very large. At that time, in fact, our demo did not perform asynchronous operations, and there was such a large amount of memory that it did not meet expectations.
 *  So the need for a method of memory reuse here is the following CVPiexelBufferPool. Every time you need to produce pixelBuffer, the memory comes from the pool, and the memory pool is used to avoid the overhead of creating as if
 * This can also be seen on Apple's official website.
 * The following pixelBufferPoolWithDifferentProperty The dictionary's dict is ostype_hegith_width, and the value is the corresponding pixelBufferPool
 * By using this method to obtain pixelbuffer, the memory in preview mode is from 200m - > 100m, and in video mode, the memory is reduced from 400- > 500m to 200m
 */



@interface BEImageBufferOperation ()
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSValue*>* pixelBufferPoolWithDifferentProperty;
@end

@implementation BEImageBufferOperation

+ (instancetype) sharedInstance{
    static BEImageBufferOperation *helper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (helper == nil){
            helper = [BEImageBufferOperation new];
        }
    });
    return helper;
}

-(void)dealloc{
    for (NSString *key in self.pixelBufferPoolWithDifferentProperty){
        CVPixelBufferPoolRef poolAddress = [[self.pixelBufferPoolWithDifferentProperty objectForKey:key] pointerValue];
        CVPixelBufferPoolRelease(poolAddress);
    }
}

#pragma mark - Image buffer format transfer

//TODO: later should use a pixelBuffer pool in case of frequently create and destory
// check whether the format change can be done
/*Format conversion supported now
 *          source PixelBuffer format   -------     dest PixelBuffer format
 *          YUV420f                     -------     BRGA8888
 *          YUV420p                     -------     BRGA8888
 *          BRGA8888                    -------     YUV420f
 *          BRG888                      -------     YUV420f
 */
- (CVPixelBufferRef)transforFrom:(CVPixelBufferRef)srcPixelBuffer toDestFormat:(OSType)destType{
    OSType srcType = CVPixelBufferGetPixelFormatType(srcPixelBuffer);
    
    if (srcType == destType){
        return nil;
    }
    
    // yuv420f  to bgra
    if (srcType == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange && destType == kCVPixelFormatType_32BGRA){
        return [self YUV420TOBGRA:srcPixelBuffer];
    } //YUV420v to BRGA8888
    else if (srcType == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange && destType == kCVPixelFormatType_32BGRA){
        return [self YUV420TOBGRA:srcPixelBuffer];
    }//BRGA8888  to YUV420f
    else if (srcType == kCVPixelFormatType_32BGRA && destType == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange){
        return [self BGRATOYUV420:srcPixelBuffer];
    }//BRG888   to YUV420f
    else if (srcType == kCVPixelFormatType_24BGR && destType == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange){
        return [self BGRATOYUV420:srcPixelBuffer];
    }
    else{
        NSLog(@"Format conversion not support now");
    }
    
    return nil;
}


typedef struct yuvBufferInfo{
    vImage_Buffer yPlaneInfo;
    vImage_Buffer uvPlaneInfo;
}yuvBufferInfo;


typedef enum yuv420type{
    YUV420F,
    YUV420V
}yuv420type;

typedef struct yuv420ToBGRAParameter{
    yuvBufferInfo yuvInfo;
    vImage_Buffer  rgbInfo;
    yuv420type type;
}yuv420fToBGRAParameter;

/// using accelerate to accelerate  conversion
/// NOTES: Details of usage could be find in Accelerate/Frameworks/vImage/conversion
/// use bool type as the return type to indcicate whether it had finished the conversion correctlly
-(bool) yuv420ToBGRAUsingAccelerateLib:(const yuv420fToBGRAParameter*)params
{
    const uint8_t permuteMap[4] = {3, 2, 1, 0}; // transfer ARGB to BGRA
    
    vImage_Flags flags = kvImageNoFlags;
    const vImage_Buffer* destBGRA = &params->rgbInfo;
    const vImage_Buffer* srcYPlane  = &params->yuvInfo.yPlaneInfo;
    const vImage_Buffer* srcUVPlane = &params->yuvInfo.uvPlaneInfo;
    
    //make the parameters for format conversion
    //This step is to generate the conversion information
    vImage_YpCbCrToARGB conversionInfo;
    vImage_Error error;
    {
        vImage_YpCbCrPixelRange pixelRange; // This means the different range of YCBCR format
        
        /*
        Bi-Planar Component Y'CbCr 8-bit 4:2:0, full-range (luma=[0,255] chroma=[1,255]).  baseAddr points to a big-endian CVPlanarPixelBufferInfo_YCbCrBiPlanar struct
         */
        
        // (vImage_YpCbCrPixelRange){ 0, 128, 255, 255, 255, 1, 255, 0 }       // full range 8-bit, clamped to full range
        if (params->type == YUV420F){
            pixelRange.Yp_bias = 0;
            pixelRange.CbCr_bias = 128;
            pixelRange.YpRangeMax = 255;
            pixelRange.CbCrRangeMax = 255;
            pixelRange.YpMax = 255;
            pixelRange.YpMin = 0;
            pixelRange.CbCrMax = 255;
            pixelRange.CbCrMin = 0;
        }
        /* Bi-Planar Component Y'CbCr 8-bit 4:2:0, video-range (luma=[16,235] chroma=[16,240]).  baseAddr points to a big-endian CVPlanarPixelBufferInfo_YCbCrBiPlanar struct */
        //(vImage_YpCbCrPixelRange){ 16, 128, 235, 240, 235, 16, 240, 16 }    // video range 8-bit, clamped to video range
        else if (params->type == YUV420V){
            pixelRange.Yp_bias = 16;
            pixelRange.CbCr_bias = 128;
            pixelRange.YpRangeMax = 235;
            pixelRange.CbCrRangeMax = 240;
            pixelRange.YpMax = 235;
            pixelRange.YpMin = 16;
            pixelRange.CbCrMax = 240;
            pixelRange.CbCrMin = 16;
        }
        
        error = vImageConvert_YpCbCrToARGB_GenerateConversion(kvImage_YpCbCrToARGBMatrix_ITU_R_601_4, // format change rule
                                                      &pixelRange, // pixle range to the yuv buffer
                                                      &conversionInfo, // output conversion information
                                                      kvImage420Yp8_CbCr8, // yuv format
                                                      kvImageARGB8888, // output rgba format
                                                      flags);
        
        if (error != kvImageNoError){
            NSLog(@"Error doing vImageConvert_YpCbCrToARGB_GenerateConversion error is %zd", error);
            return false;
        }
    }
    
    error = vImageConvert_420Yp8_CbCr8ToARGB8888(srcYPlane, srcUVPlane, destBGRA, &conversionInfo, permuteMap, 255, flags);
    if (error != kvImageNoError){
        NSLog(@"Error doing vImageConvert_420Yp8_CbCr8ToARGB8888 error is %zd", error);
        return false;
    }
    
    return true;
}

-(bool) BGRAToYUV420UsingAccelerateLib:(const yuv420fToBGRAParameter*)params
{
    const vImage_Buffer* srcBgrBuffer = &params->rgbInfo;
    const vImage_Buffer* destYPlaneBuffer = &params->yuvInfo.yPlaneInfo;
    const vImage_Buffer* destUVPlaneBuffer = &params->yuvInfo.uvPlaneInfo;
    
    vImage_Error error;
    
    vImage_YpCbCrPixelRange pixelRange;
    /*
    Bi-Planar Component Y'CbCr 8-bit 4:2:0, full-range (luma=[0,255] chroma=[1,255]).  baseAddr points to a big-endian CVPlanarPixelBufferInfo_YCbCrBiPlanar struct
     */
    
    // (vImage_YpCbCrPixelRange){ 0, 128, 255, 255, 255, 1, 255, 0 }       // full range 8-bit, clamped to full range
    if (params->type == YUV420F){
        pixelRange.Yp_bias = 0;
        pixelRange.CbCr_bias = 128;
        pixelRange.YpRangeMax = 255;
        pixelRange.CbCrRangeMax = 255;
        pixelRange.YpMax = 255;
        pixelRange.YpMin = 0;
        pixelRange.CbCrMax = 255;
        pixelRange.CbCrMin = 0;
    }
    /* Bi-Planar Component Y'CbCr 8-bit 4:2:0, video-range (luma=[16,235] chroma=[16,240]).  baseAddr points to a big-endian CVPlanarPixelBufferInfo_YCbCrBiPlanar struct */
    //(vImage_YpCbCrPixelRange){ 16, 128, 235, 240, 235, 16, 240, 16 }    // video range 8-bit, clamped to video range
    else if (params->type == YUV420V){
        pixelRange.Yp_bias = 16;
        pixelRange.CbCr_bias = 128;
        pixelRange.YpRangeMax = 235;
        pixelRange.CbCrRangeMax = 240;
        pixelRange.YpMax = 235;
        pixelRange.YpMin = 16;
        pixelRange.CbCrMax = 240;
        pixelRange.CbCrMin = 16;
    }
    
    //fill the function parma
    const uint8_t permuteMap[4] = {3, 2, 1, 0}; //ARGB -- BGRA
    {
        vImageARGBType ARGBType = kvImageARGB8888;
        vImageYpCbCrType YUVType = kvImage420Yp8_CbCr8;
        vImage_ARGBToYpCbCr conversionInfo;
        vImage_Flags flags = kvImageNoFlags;
        
        error = vImageConvert_ARGBToYpCbCr_GenerateConversion(kvImage_ARGBToYpCbCrMatrix_ITU_R_601_4,
                                                              &pixelRange, &conversionInfo,
                                                              ARGBType, YUVType, flags);
        
        if (error != kvImageNoError){
            NSLog(@"vImageConvert_ARGBToYpCbCr_GenerateConversion is %zd", error);
            return false;
        }
        error = vImageConvert_ARGB8888To420Yp8_CbCr8(srcBgrBuffer, destYPlaneBuffer, destUVPlaneBuffer, &conversionInfo, permuteMap, flags);
        
        if (error != kvImageNoError){
            NSLog(@"vImageConvert_ARGB8888To420Yp8_CbCr8 is %zd", error);
            return false;
        }
    }
    
    return true;
}
 

/// Entry point of the conversion from  yuv 420f to bgra
- (CVPixelBufferRef)YUV420TOBGRA:(CVPixelBufferRef)srcPixelBuffer{
    //Genration dest pixelbuffer,
    CVPixelBufferRef destPixelBuffer;
    //here to make the real conversion
    //first, prepare the params
    struct yuv420ToBGRAParameter params;
    [self getYUVCVPixelBufferInfo:srcPixelBuffer info:&params.yuvInfo];
    size_t width  = params.yuvInfo.yPlaneInfo.width;
    size_t height = params.yuvInfo.yPlaneInfo.height;
    destPixelBuffer = [self genPixelBuffer:(OSType)kCVPixelFormatType_32BGRA height:height width:width];
    [self getRGBCVPixelBufferInfor:destPixelBuffer info:&params.rgbInfo];
    
    //fill type info
    if(CVPixelBufferGetPixelFormatType(srcPixelBuffer) == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)
    {
        params.type = YUV420V;
    }else {
        params.type = YUV420F;
    }

    // lock the src and dest pixelbuffer
    if (!CVPixelBufferLockBaseAddress(srcPixelBuffer, kCVPixelBufferLock_ReadOnly)
        && !CVPixelBufferLockBaseAddress(destPixelBuffer, 0)){
        
        //second, make the real conversion
        
        CVPixelBufferRetain(srcPixelBuffer);
        
        if (![self yuv420ToBGRAUsingAccelerateLib:&params]){
            CVPixelBufferRelease(destPixelBuffer);
            return NULL;
        }
        CVPixelBufferRelease(srcPixelBuffer);
        
        CVPixelBufferUnlockBaseAddress(destPixelBuffer, 0);
        CVPixelBufferUnlockBaseAddress(srcPixelBuffer, kCVPixelBufferLock_ReadOnly);
    }else { // if the conversion cannot be made, just return null
        return NULL;
    }
    
    return destPixelBuffer;
}


/// Entry point of transfer bga or bgra buffer to yuv420f
-(CVPixelBufferRef)BGRATOYUV420:(CVPixelBufferRef)srcBuffer
{
    OSType srcFormat = CVPixelBufferGetPixelFormatType(srcBuffer);
    if (srcFormat != kCVPixelFormatType_24BGR && srcFormat != kCVPixelFormatType_32BGRA){
        return NULL;
    }
    CVPixelBufferRef destBuffer = NULL;
    struct yuv420ToBGRAParameter params;
    
    // prepare the param
    [self getRGBCVPixelBufferInfor:srcBuffer info:&params.rgbInfo];
    size_t width = params.rgbInfo.width;
    size_t height = params.rgbInfo.height;
    destBuffer = [self genPixelBuffer:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange height:height width:width];
    
    if (!destBuffer){
        return NULL;
    }
    [self getYUVCVPixelBufferInfo:destBuffer info:&params.yuvInfo];
    params.type = YUV420F;
    
    // lock the src and dest pixelbuffer
    if (!CVPixelBufferLockBaseAddress(srcBuffer, kCVPixelBufferLock_ReadOnly)
        && !CVPixelBufferLockBaseAddress(destBuffer, 0)){
        
        /// second, make the real conversion
        /// Need to retain in case of mutilthread destory when f
        CVPixelBufferRetain(srcBuffer);
        if (![self BGRAToYUV420UsingAccelerateLib:&params]){
            NSLog(@"Format change failed from BGRA TO YUV420");
            CVPixelBufferRelease(destBuffer);
            return NULL;
        }
        
        CVPixelBufferRelease(srcBuffer);
        
        CVPixelBufferUnlockBaseAddress(destBuffer, 0);
        CVPixelBufferUnlockBaseAddress(srcBuffer, kCVPixelBufferLock_ReadOnly);
    }else { // if the conversion cannot be made, just return null
        return NULL;
    }

    return destBuffer;
    
}

/// If it should work for every thread as a singleton, it should not keep internal status
-(CVPixelBufferRef)
transforPixelbuffer:(CVPixelBufferRef)srcPixelBuffer destFormat:(OSType)type {
    // valid the input buffer and dest format
    return [self transforFrom:srcPixelBuffer toDestFormat:type];
}


#pragma mark - Image buffer rotation

-(CVPixelBufferRef)rotateRGBA8888WithAccelerateLib:(CVPixelBufferRef)srcPixelBuffer angle:(int)angle
{
    CVPixelBufferRetain(srcPixelBuffer);
    
    /// Support 90 180 270 only
    if (!(angle == 90 || angle == 180 || angle == 270)){
        CVPixelBufferRelease(srcPixelBuffer);
        return NULL;
    }
    vImage_Buffer srcBuffer;
    vImage_Buffer destBuffer;
    [self getRGBCVPixelBufferInfor:srcPixelBuffer info:&srcBuffer];

    /// Get the dest size
    CGSize srcSize = CGSizeMake(srcBuffer.width, srcBuffer.height);
    
    CGSize destSize = srcSize;
    if (angle != 180){
        destSize.width = srcSize.height;
        destSize.height = srcSize.width;
    }
    
    CVPixelBufferRef destPixelBuffer = [self genPixelBuffer:CVPixelBufferGetPixelFormatType(srcPixelBuffer) height:destSize.height width:destSize.width];

    /// If failed, just return
    if (destPixelBuffer == NULL){
        CVPixelBufferRelease(srcPixelBuffer);
        return NULL;
    }
    
    /// Real rotation
    [self getRGBCVPixelBufferInfor:destPixelBuffer info:&destBuffer];
    const Pixel_8888 backFillColor = {255, 255, 255, 1}; ///BGRA
    
    /// vImage rotate 90 is counterclockwise, how ever the input angle is always clockwise, we need to transfor it
    angle = 360 - angle;
    
    vImageRotate90_ARGB8888(&srcBuffer, &destBuffer, (angle / 90), backFillColor, kvImageNoFlags);
    CVPixelBufferRelease(srcPixelBuffer);

    return destPixelBuffer;
}

-(CVPixelBufferRef)rotateYUV420WithAccelerateLib:(CVPixelBufferRef)srcPixelBuffer angle:(int)angle{
    CVPixelBufferRetain(srcPixelBuffer);
    
    /// Support 90 180 270 only
    if (!(angle == 90 || angle == 180 || angle == 270)){
        CVPixelBufferRelease(srcPixelBuffer);
        return NULL;
    }
    yuvBufferInfo srcBufferInfo, destBufferInfo;
    

    [self getYUVCVPixelBufferInfo:srcPixelBuffer info:&srcBufferInfo];

    /// Get the dest size
    CGSize srcSize = CGSizeMake(srcBufferInfo.yPlaneInfo.width, srcBufferInfo.yPlaneInfo.height);
    CGSize destSize = srcSize;
    if (angle != 180){
        destSize.width = srcSize.height;
        destSize.height = srcSize.width;
    }
    
    CVPixelBufferRef destPixelBuffer = [self genPixelBuffer:CVPixelBufferGetPixelFormatType(srcPixelBuffer) height:destSize.height width:destSize.width];

    /// If failed, just return
    if (destPixelBuffer == NULL){
        CVPixelBufferRelease(srcPixelBuffer);
        return NULL;
    }
    
    /// Real rotation
    [self getYUVCVPixelBufferInfo:destPixelBuffer info:&destBufferInfo];
    const Pixel_8 backFillColor = 0;
    
    CVPixelBufferLockBaseAddress(srcPixelBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferLockBaseAddress(destPixelBuffer, 0);
    /// Rotate bin planer
    vImage_Error error;
    
    /// vImage rotate 90 is counterclockwise, how ever the input angle is always clockwise, we need to transfor it
    angle = 360 - angle;
    
    error = vImageRotate90_Planar8(&srcBufferInfo.yPlaneInfo, &destBufferInfo.yPlaneInfo, (angle / 90), backFillColor, kvImageNoFlags);
    
    if (error != kvImageNoError){
        NSLog(@"Rotate yuv buffer y plane errer %zd", error);
        CVPixelBufferRelease(destPixelBuffer);
        CVPixelBufferRelease(srcPixelBuffer);
        
        return NULL;
    }
    
    error = vImageRotate90_Planar16U(&srcBufferInfo.uvPlaneInfo, &destBufferInfo.uvPlaneInfo, (angle / 90), backFillColor, kvImageNoFlags);
    if (error != kvImageNoError){
        NSLog(@"Rotate yuv buffer uv plane errer %zd", error);
        CVPixelBufferRelease(srcPixelBuffer);
        CVPixelBufferRelease(destPixelBuffer);
        
        return NULL;
    }
    
    CVPixelBufferUnlockBaseAddress(srcPixelBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferUnlockBaseAddress(destPixelBuffer, 0);
    
    CVPixelBufferRelease(srcPixelBuffer);
    return destPixelBuffer;
}

/// Rotate a pixel buffer, when success, it will reture a new pixelbuffer with same format
/// @param srcPixelBuffer The input pixel buffer
/// @param angle rotate angle  in radians
-(CVPixelBufferRef)rotatePixelBuffer:(nonnull CVPixelBufferRef)srcPixelBuffer angle:(float)angle
{
    if (srcPixelBuffer == NULL)
        return NULL;
    
    OSType format = CVPixelBufferGetPixelFormatType(srcPixelBuffer);
    
    // 420p 420f
    if (format == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange || format == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange){
        return [self rotateYUV420WithAccelerateLib:srcPixelBuffer angle:angle];
    }else if (format == kCVPixelFormatType_32BGRA){ // 32bit bgra8888
        return [self rotateRGBA8888WithAccelerateLib:srcPixelBuffer angle:angle];
    }
    
    return  NULL;
}

#pragma mark - Cvpixelbuffer helper

/// just gen bgra or yuv 420f
-(CVPixelBufferRef)genPixelBuffer:(OSType)type height:(size_t)height width:(size_t)width{
    CVPixelBufferRef buffer = NULL;
    
    if (type != kCVPixelFormatType_32BGRA && type != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange &&
        type != kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)
    {
        return buffer;
    }
    
    buffer = [self genPixelBufferFromBufferPoolWithType:type height:(int)height width:(int)width];
    return buffer;
}


/// get yuv cvpixelbuffer infomation
-(void)getYUVCVPixelBufferInfo:(CVPixelBufferRef)buffer info:(yuvBufferInfo*)info{
    CVPixelBufferLockBaseAddress(buffer, kCVPixelBufferLock_ReadOnly);
    uint8_t* yPlanePtr =  CVPixelBufferGetBaseAddressOfPlane(buffer, 0);
    size_t bytesPerRowOfYPlane = CVPixelBufferGetBytesPerRowOfPlane(buffer, 0);
    size_t widthOfYPlane = CVPixelBufferGetWidthOfPlane(buffer, 0);
    size_t heightOfYPlane = CVPixelBufferGetHeightOfPlane(buffer, 0);
    
    uint8_t* uvPlanePtr = CVPixelBufferGetBaseAddressOfPlane(buffer, 1);
    size_t widthOfUVPlane = CVPixelBufferGetWidthOfPlane(buffer, 1);
    size_t heightOfUVPlane = CVPixelBufferGetHeightOfPlane(buffer, 1);
    size_t bytesPerRowOfUVPlane = CVPixelBufferGetBytesPerRowOfPlane(buffer, 1);
    CVPixelBufferUnlockBaseAddress(buffer, kCVPixelBufferLock_ReadOnly);
    
    vImage_Buffer *yBuffer  = &info->yPlaneInfo;
    vImage_Buffer *uvBuffer = &info->uvPlaneInfo;
    
    yBuffer->data       = yPlanePtr;
    yBuffer->height     = heightOfYPlane;
    yBuffer->width      = widthOfYPlane;
    yBuffer->rowBytes   = bytesPerRowOfYPlane;
    
    uvBuffer->data      = uvPlanePtr;
    uvBuffer->height    = heightOfUVPlane;
    uvBuffer->width     = widthOfUVPlane;
    uvBuffer->rowBytes  = bytesPerRowOfUVPlane;
    
}

/// get bgra cvpixelbuffer infomation
-(void)getRGBCVPixelBufferInfor:(CVPixelBufferRef)buffer info:(vImage_Buffer*) info{
    CVPixelBufferLockBaseAddress(buffer, 0);
    info->data = CVPixelBufferGetBaseAddress(buffer);
    info->rowBytes = CVPixelBufferGetBytesPerRow(buffer);
    info->width = CVPixelBufferGetWidth(buffer);
    info->height = CVPixelBufferGetHeight(buffer);
    CVPixelBufferUnlockBaseAddress(buffer, 0);
}


/// Get a pixelbuffer from pixelbuffer pool
-(CVPixelBufferRef)genPixelBufferFromBufferPoolWithType:(OSType)type height:(int)height width:(int)width{
    NSString* key = [NSString stringWithFormat:@"%u_%d_%d", (unsigned int)type, height, width];
    CVPixelBufferPoolRef pixelBufferPool = NULL;
    NSValue *bufferPoolAddress = [self.pixelBufferPoolWithDifferentProperty objectForKey:key];
    
    /// Means we have not allocate such a pool
    if (!bufferPoolAddress){
        pixelBufferPool = [self genPixelBufferPoolWith:type heigth:height width:width];
        bufferPoolAddress = [NSValue valueWithPointer:pixelBufferPool];
        [self.pixelBufferPoolWithDifferentProperty setValue:bufferPoolAddress forKey:key];
    }else {
        pixelBufferPool = [bufferPoolAddress pointerValue];
    }
    
    CVPixelBufferRef buffer = NULL;
    CVReturn ret = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &buffer);
    if (ret != kCVReturnSuccess){
        NSLog(@"Generate pixel from bufferpool failed");
    }
    return buffer;
}



#pragma mark - getter
-(CVPixelBufferPoolRef)genPixelBufferPoolWith:(OSType)type heigth:(int)height width:(int)width{
    CVPixelBufferPoolRef pool = NULL;
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    
    [attributes setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCVPixelBufferOpenGLCompatibilityKey];
    [attributes setObject:[NSNumber numberWithInt:type] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    [attributes setObject:[NSNumber numberWithInt:width] forKey: (NSString*)kCVPixelBufferWidthKey];
    [attributes setObject:[NSNumber numberWithInt:height] forKey: (NSString*)kCVPixelBufferHeightKey];
    [attributes setObject:@(16) forKey:(NSString*)kCVPixelBufferBytesPerRowAlignmentKey];
    [attributes setObject:[NSDictionary dictionary] forKey:(NSString*)kCVPixelBufferIOSurfacePropertiesKey];
        
    CVReturn ret = CVPixelBufferPoolCreate(kCFAllocatorDefault, NULL, (__bridge CFDictionaryRef)attributes, &pool);
    
    if (ret != kCVReturnSuccess){
        NSLog(@"Create pixbuffer pool failed %d", ret);
        return NULL;
    }
    
    CVPixelBufferRef buffer;
    ret = CVPixelBufferPoolCreatePixelBuffer(NULL, pool, &buffer);
    if (ret != kCVReturnSuccess){
        NSLog(@"Create pixbuffer from pixelbuffer pool failed %d", ret);
        return NULL;
    }
    
    return pool;
}


-(NSDictionary*)pixelBufferPoolWithDifferentProperty{
    if (!_pixelBufferPoolWithDifferentProperty){
        _pixelBufferPoolWithDifferentProperty = [NSMutableDictionary<NSString*, NSValue*> new];
    }
    return _pixelBufferPoolWithDifferentProperty;
}
@end
