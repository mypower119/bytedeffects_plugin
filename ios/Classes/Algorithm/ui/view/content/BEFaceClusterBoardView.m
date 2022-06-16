//
//  BEFaceClusterBoardView.m
//  Algorithm
//
//  Created by qun on 2021/6/1.
//

#import "BEFaceClusterBoardView.h"
#import "Masonry.h"

@interface BEFaceClusterBoardView ()

@property (nonatomic, strong) BETitleBoardView *titleBoardView;

@end

@implementation BEFaceClusterBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        [self addSubview:self.titleBoardView];
        [self.titleBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.titleBoardView.boardContentView = self.clusteringView;
    }
    return self;
}

- (void)setDelegate:(id<BEFaceClusterBoardViewDelegate>)delegate {
    _delegate = delegate;
    
    self.titleBoardView.delegate = delegate;
    self.clusteringView.delegate = delegate;
}

#pragma mark - getter
- (BETitleBoardView *)titleBoardView {
    if (_titleBoardView) {
        return _titleBoardView;
    }
    
    _titleBoardView = [BETitleBoardView new];
    [_titleBoardView updateBoardTitle:NSLocalizedString(@"feature_face_cluster", nil)];
    return _titleBoardView;
}

- (BEFaceClusteringView *)clusteringView {
    if (_clusteringView) {
        return _clusteringView;
    }
    
    _clusteringView = [BEFaceClusteringView new];
    return _clusteringView;
}

@end
