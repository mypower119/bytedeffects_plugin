//
//  BEDownloadView.h
//  BECommon
//
//  Created by qun on 2021/10/28.
//

#ifndef BEDownloadView_h
#define BEDownloadView_h

#import <UIKit/UIkit.h>

typedef NS_ENUM(NSInteger, BEDownloadViewState) {
    BEDownloadViewStateInit,
    BEDownloadViewStateDownloading,
    BEDownloadViewStateDownloaded,
};

@interface BEDownloadView : UIView

/// 当前状态，默认 BEDownloadViewStateInit
@property (nonatomic, assign) BEDownloadViewState state;

/// 进度条，0.f - 1.f
@property (nonatomic, assign) CGFloat downloadProgress;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat backgroundLineWidth;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat progressLineWidth;
@property (nonatomic, strong) UIImage *downloadImage;

@end

#endif /* BEDownloadView_h */
