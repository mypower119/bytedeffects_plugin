//
//  BEFaceClusterBoardView.h
//  Algorithm
//
//  Created by qun on 2021/6/1.
//

#ifndef BEFaceClusterBoardView_h
#define BEFaceClusterBoardView_h

#import "BETitleBoardView.h"
#import "BEFaceClusteringView.h"

@protocol BEFaceClusterBoardViewDelegate <BETitleBoardViewDelegate, BEFaceClusteringViewDelegate>



@end

// {zh} / 人脸聚类底部面板 {en} /Face clustering bottom panel
@interface BEFaceClusterBoardView : UIView

@property (nonatomic, weak) id<BEFaceClusterBoardViewDelegate> delegate;
@property (nonatomic, strong) BEFaceClusteringView *clusteringView;

@end

#endif /* BEFaceClusterBoardView_h */
