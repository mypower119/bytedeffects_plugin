//
//  CommonSize.h
//  Common
//
//  Created by qun on 2021/6/17.
//

#ifndef CommonSize_h
#define CommonSize_h

#import "BEDeviceInfoHelper.h"

//#define BEF_DESIGN_SIZE(SIZE) ((SIZE) * [UIScreen mainScreen].bounds.size.width / 375.f)
#define BEF_DESIGN_SIZE(SIZE) (SIZE)
//    {zh} 底部面板高度，根据是否是刘海屏会有区别        {en} Bottom panel height, depending on whether it is bangs  
#define BEF_BOARD_HEIGHT (BEF_BOARD_BOTTOM_BOTTOM_MARGIN + BEF_BOARD_BOTTOM_HEIGHT + BEF_BOARD_CONTENT_HEIGHT + BEF_SWITCH_TAB_HEIGHT)
//    {zh} 人脸聚类面板高度，人脸聚类要显示的东西比较多，额外多加 20        {en} Face clustering panel height, face clustering to display more things, add 20 extra  
#define BEF_FACE_CLUSTER_BOARD_HEIGHT (BEDeviceInfoHelper.isIPhoneXSeries ? 248 : 228)
//    {zh} 滑杆高度        {en} Slider height  
#define BEF_SLIDE_HEIGHT 60
//    {zh} 滑杆距离面板的距离        {en} Slider distance from the panel  
#define BEF_SLIDE_BOTTOM_MARGIN 22
//    {zh} 重置按钮距离面板距离        {en} Reset button distance from panel  
#define BEF_RESET_BUTTON_BOTTOM_MARGIN 16
//    {zh} 标签栏高度        {en} Label bar height  
#define BEF_SWITCH_TAB_HEIGHT 44
//    {zh} 面板底部按钮（拍照、收起）高度        {en} Panel bottom button (photo, retract) height  
#define BEF_BOARD_BOTTOM_HEIGHT 44
//    {zh} 面板底部按钮（拍照、收起）距离屏幕底部距离        {en} Buttons at the bottom of the panel (photo, retract) distance from the bottom of the screen  
#define BEF_BOARD_BOTTOM_BOTTOM_MARGIN (BEDeviceInfoHelper.isIPhoneXSeries ? 34 : 24)
//    {zh} 顶部按钮宽度        {en} Top button width  
#define BEF_TOP_BUTTON_WIDTH 32

//    {zh} 算法信息左边距        {en} Algorithm information left margin  
#define ALGORITHM_INFO_LEFT_MARGIN 20
//    {zh} 算法信息上边距        {en} Algorithm information upper margin  
#define ALGORITHM_INFO_TOP_MARGIN 100
// 面板内容高度
#define BEF_BOARD_CONTENT_HEIGHT 120

#define SDK_CHEAT_APP_VERSION @"4.3.1_standard"

#endif /* CommonSize_h */
