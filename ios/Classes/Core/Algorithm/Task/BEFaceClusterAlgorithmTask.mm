//
//  BEFaceClusterAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/10.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEFaceClusterAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"
#import "bef_effect_ai_face_clustering.h"
#import "bef_effect_ai_face_detect.h"
#import "bef_effect_ai_face_verify.h"
#include <vector>

@interface BEFaceClusterAlgorithmTask () {
    bef_effect_handle_t             _handle;
    BEFaceVerifyAlgorithmTask       *_faceVerifyTask;
}

@property (nonatomic, strong) id<BEFaceClusterResourceProvider> provider;

@end

@implementation BEFaceClusterAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)FACE_CLUSTER {
    GET_TASK_KEY(faceCluster, YES)
}

- (instancetype)initWithProvider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>)licenseProvider{
    if (self = [super initWithProvider:provider licenseProvider:licenseProvider]) {
        _faceVerifyTask = [[BEFaceVerifyAlgorithmTask alloc] initWithProvider:provider licenseProvider:licenseProvider];
    }
    return self;
}

- (int)initTask {
#if BEF_FACE_CLUSTER_TOB
    bef_effect_result_t ret = bef_effect_ai_fc_create(&_handle);
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_face_cluster_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_face_cluster_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        const char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_face_cluster_check_online_license(_handle, licensePath);        
        CHECK_RET_AND_RETURN(bef_effect_ai_face_cluster_check_online_license, ret)
    }
    
    ret = [_faceVerifyTask initTask];
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
    
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
    return nil;
}

- (int)destroyTask {
#if BEF_FACE_CLUSTER_TOB
    [_faceVerifyTask destroyTask];
    bef_effect_ai_fc_release(_handle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEFaceClusterAlgorithmTask.FACE_CLUSTER;
}

- (NSMutableDictionary<NSNumber *,NSMutableArray *> *)faceClusterImages:(NSArray<UIImage *> *)images {
#if BEF_FACE_CLUSTER_TOB
    std::vector<float *> features; //   {zh} 保存所有临时malloc的feature空间的地址     {en} Save the address of all temporary malloc feature spaces 
        std::vector<std::vector<int>> faceClusterFeatures(images.count, std::vector<int>());
        NSMutableDictionary<NSNumber*, NSMutableArray*> *clusterDictResult = [NSMutableDictionary dictionary];
        
        int validFeatureCnt = 0;
        for (int index = 0; index < images.count; index++){
            bef_ai_face_verify_info featureInfo;
            memset(&featureInfo, 0, sizeof(bef_ai_face_verify_info));
            int valid_count = [self be_genFeatures:images[index] featureInfo:&featureInfo];
            
            if (valid_count == 0) faceClusterFeatures[index] = {-1};
            
            //   {zh} 特征的index放入到数组中     {en} The index of the feature is put into the array 
            for (int featureIndex = 0; featureIndex < valid_count; featureIndex++){
                // {zh} 每个image的特征 index放在一起 {en} The feature index of each image is put together
                faceClusterFeatures[index].push_back(validFeatureCnt++);
                
                float* feature = featureInfo.features[featureIndex];
                float* tmpAddress = (float*)malloc(BEF_AI_FACE_FEATURE_DIM * sizeof(float));
                
                memcpy(tmpAddress, feature, BEF_AI_FACE_FEATURE_DIM * sizeof(float));
                features.push_back(tmpAddress);
            }
        }
        
        //   {zh} 存放最终保存的聚类结果的地方     {en} Where to store the final saved clustering results 
        int *finalResult = (int*)malloc(validFeatureCnt * sizeof(int));
        // {zh} 传入SDK的地址，保存形式为连续的features {en} The address of the incoming SDK is saved as a continuous feature
        float *totalFeatures = (float*)malloc(validFeatureCnt * sizeof(float) * BEF_AI_FACE_FEATURE_DIM);
        
        //   {zh} 把原来的每一个临时保存的内存move过来，然后释放临时的     {en} Each of the original temporarily saved memory is moved over, and then the temporary 
        for (int index = 0; index < validFeatureCnt; index++){
            memmove(totalFeatures + (index * BEF_AI_FACE_FEATURE_DIM),
                    features[index],
                    BEF_AI_FACE_FEATURE_DIM * sizeof(float));
            
            //   {zh} 释放临时分配的内存     {en} Release temporarily allocated memory 
            free(features[index]);
        }
        
        bef_effect_result_t result = bef_effect_ai_fc_do_clustering(_handle, totalFeatures, validFeatureCnt, finalResult);
        if (result != BEF_RESULT_SUC){
             NSLog(@"bef_effect_ai_fc_do_clustering error: %d", result);
        }
        
        // {zh} 当前的result array 存放的是对一个的feature的index， 现在吧index换成对应的result中的聚类结果 {en} The current result array stores the index of a feature. Now replace the index with the clustering result in the corresponding result
        for (int preImageIndex = 0; preImageIndex < faceClusterFeatures.size(); preImageIndex++){
            for (int preFeatureIndex = 0; preFeatureIndex < faceClusterFeatures[preImageIndex].size(); preFeatureIndex++){
    //            if (faceClusterResult[preImageIndex][preFeatureIndex] >= 0){
    //                faceClusterResult[preImageIndex][preFeatureIndex] = finalResult[faceClusterResult[preImageIndex][preFeatureIndex]];
    //            }
                //   {zh} 没有检测到人脸     {en} No faces detected 
                if (faceClusterFeatures[preImageIndex][preFeatureIndex] == -1){
                    // {zh} 没有就创建 {en} Create without
                    if ([clusterDictResult objectForKey:[NSNumber numberWithInteger:-1]] == nil){
                        NSMutableArray *array = [NSMutableArray array];
                        [clusterDictResult setObject:array forKey:[NSNumber numberWithInteger:-1]];
                    }
                    
                    [clusterDictResult[[NSNumber numberWithInteger:-1]] addObject:[NSNumber numberWithInt:preImageIndex]];
                    break;
                }else {
                    if ([clusterDictResult objectForKey:
                         [NSNumber numberWithInteger:finalResult[faceClusterFeatures[preImageIndex][preFeatureIndex]]]] == nil){
                        
                        NSMutableArray *array = [NSMutableArray array];
                        [clusterDictResult setObject:array forKey:[NSNumber numberWithInteger:finalResult[faceClusterFeatures[preImageIndex][preFeatureIndex]]]];
                    }
                    
                    [clusterDictResult[[NSNumber numberWithInteger:finalResult[faceClusterFeatures[preImageIndex][preFeatureIndex]]]] addObject:[NSNumber numberWithInt:preImageIndex]];
                }
            }
                
        }
        
        BELog(@"%@", clusterDictResult);
        
        free (finalResult);
        free (totalFeatures);
        return clusterDictResult;
#endif
    return nil;
}

- (int)be_genFeatures:(UIImage *)image featureInfo:(bef_ai_face_verify_info *)features {
    int width = (int)CGImageGetWidth(image.CGImage);
    int height = (int)CGImageGetHeight(image.CGImage);
    int bytesPerRow = 4 * width;
    unsigned char *buffer = (unsigned char *)malloc(bytesPerRow * height);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(buffer, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGContextRelease(context);
    
    BEFaceVerifyAlgorithmResult *verifyRet = [_faceVerifyTask process:(unsigned char *)buffer width:(int)width height:(int)height stride:(int)bytesPerRow format:BEF_AI_PIX_FMT_RGBA8888 rotation:BEF_AI_CLOCKWISE_ROTATE_0];
    if (verifyRet.verifyInfo != nil) {
        memcpy(features, verifyRet.verifyInfo, sizeof(bef_ai_face_verify_info));
    }
    
    free(buffer);
    
    return features == nil ? 0 : features->valid_face_num;
}

@end
