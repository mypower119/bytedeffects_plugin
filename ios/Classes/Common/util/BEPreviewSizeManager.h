//
//  BEPreviewSizeManager.h
//  BytedEffects
//
//  Created by qun on 2021/2/28.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEPreviewSizeManager_h
#define BEPreviewSizeManager_h

#import <Foundation/Foundation.h>

//   {zh} / 主要用于在 view（手机屏幕）和 preview（预览图像）之间做坐标系转换，     {en} /Mainly used for coordinate system conversion between view (mobile phone screen) and preview (preview image), 
//   {zh} / view 和 preview 之间由于比例、尺寸不一样，需要对 preview 做缩放、剪裁，     {en} Due to the different proportions and sizes between/view and preview, you need to zoom and cut the preview. 
//   {zh} / 造成 view 和 preview 之间的坐标需要做一层转换才能对得上     {en} /Cause the coordinates between view and preview need to be converted to match 
@interface BEPreviewSizeManager : NSObject

+ (instancetype)singletonInstance;

//   {zh} / 更新 view 和 preview 的尺寸和剪裁方式     {en} /Update the size and tailoring of view and preview 
//   {zh} / @param viewWidth view 宽     {en} /@param viewWidth view 
//   {zh} / @param viewHeight view 高     {en} /@param viewHeight view 
//   {zh} / @param previewWidth preview 宽     {en} /@param previewWidth preview 
//   {zh} / @param previewHeight preview 高     {en} /@param previewHeight preview height 
//   {zh} / @param fitCenter 是否居中 fit     {en} /@param fitCenter fit 
- (void)updateViewWidth:(float)viewWidth viewHeight:(float)viewHeight previewWidth:(float)previewWidth previewHeight:(float)previewHeight fitCenter:(BOOL)fitCenter;

//   {zh} / 获取缩放倍数，view -> preview     {en} /Get the zoom factor, view - > preview 
- (float)ratio;

//   {zh} / 根据在 preview 坐标系中的 x，求在 view 坐标系的 x     {en} /According to x in the preview coordinate system, find x in the view coordinate system 
//   {zh} / @param x preview 坐标系的 x     {en} /@param x preview coordinate system x 
- (float)previewToViewX:(float)x;

//   {zh} / 根据在 preview 坐标系中的 y，求在 view 坐标系的 y     {en} /According to y in the preview coordinate system, find y in the view coordinate system 
//   {zh} / @param y preview 坐标系的 y     {en} /@param y preview the y of the coordinate system 
- (float)previewToViewY:(float)y;

//   {zh} / 根据在 view 坐标系中的 x，求在 preview 坐标系的 x     {en} /According to x in the view coordinate system, find x in the preview coordinate system 
//   {zh} / @param x view 坐标系的 x     {en} /@param x view coordinate system x 
- (float)viewToPreviewX:(float)x;

//   {zh} / 根据在 view 坐标系中的 y，求在 preview 坐标系的 y     {en} /According to y in the view coordinate system, find y in the preview coordinate system 
//   {zh} / @param y view 坐标系的 y     {en} /@param y view coordinate system y 
- (float)viewToPreviewY:(float)y;

//   {zh} / 根据在 view 坐标系中的 x，求在 preview 坐标系的 x 在 preview 中的比例     {en} /According to x in the view coordinate system, find the proportion of x in the preview coordinate system in the preview 
//   {zh} / @param x view 坐标系的 x     {en} /@param x view coordinate system x 
- (float)viewToPreviewXFactor:(float)x;

//   {zh} / 根据在 view 坐标系中的 y，求在 preview 坐标系的 y 在 preview 中的比例     {en} /According to y in the view coordinate system, find the ratio of y in the preview coordinate system in the preview 
//   {zh} / @param y view 坐标系的 y     {en} /@param y view coordinate system y 
- (float)viewToPreviewYFactor:(float)y;

@end

#endif /* BEPreviewSizeManager_h */
