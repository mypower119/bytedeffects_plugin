//  Copyright © 2019 ailab. All rights reserved.

#import <Foundation/Foundation.h>
#import "DGActivityIndicatorView.h"

#import "BEFaceClusteringView.h"
#import "UICollectionViewCell+BEAdd.h"
#import "Masonry.h"
#import <Toast/UIView+Toast.h>
#import "BESelectableButton.h"
#import "BELightUpSelectableView.h"
#import "BEButtonViewCell.h"
#import "BEDeviceInfoHelper.h"
#import "Common.h"

@interface BEFaceClusteringView () <UICollectionViewDelegate, UICollectionViewDataSource, BESelectableButtonDelegate>
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) BESelectableButton *btnClose;
@property (nonatomic, strong) BESelectableButton *btnSelect;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) DGActivityIndicatorView *aivLoading;

@property (nonatomic, strong) NSArray<UIImage *> *selectedPhotos;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, NSMutableArray*> * clusterResultDict;
@property (nonatomic, assign) int curCluster;
@property (nonatomic, assign) CGPoint lastResultPosition;

@end

@implementation BEFaceClusteringView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
//        [self addSubview:self.btnClose];
        [self addSubview:self.btnSelect];
        [self addSubview:self.contentCollectionView];
        [self addSubview:self.startBtn];
        [self addSubview:self.backBtn];
        [self addSubview:self.aivLoading];
        
//        [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(100, 70));
//            make.leading.mas_equalTo(self.mas_leading).with.offset(20);
//            make.centerY.mas_equalTo(self);
//        }];
        [self.btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 70));
            make.center.equalTo(self);
//            make.trailing.mas_equalTo(self.mas_trailing).with.offset(-20);
//            make.centerY.mas_equalTo(self);
        }];
        
        [self.contentCollectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).with.offset(-30);
        }];
        
        if(![BEDeviceInfoHelper isIPhoneXSeries])
        {
            [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentCollectionView.mas_bottom);
                make.centerX.mas_equalTo(self);
            }];
            [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentCollectionView.mas_bottom);
                make.centerX.mas_equalTo(self);
            }];
        }
        else
        {
            [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentCollectionView.mas_bottom);
                make.bottom.equalTo(self).with.mas_offset(-20);
                make.centerX.mas_equalTo(self);
            }];
            [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentCollectionView.mas_bottom);
                make.bottom.equalTo(self).with.mas_offset(-20);
                make.centerX.mas_equalTo(self);
            }];
        }
        
        [self.aivLoading mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.backBtn);
        }];
        
        self.startBtn.hidden = YES;
        self.backBtn.hidden= YES;
        self.aivLoading.hidden = YES;
        self.contentCollectionView.hidden = YES;
        _curCluster = -1;
    }
    return self;
}

#pragma mark - public
- (void)configuraClusteringWithImages:(NSArray<UIImage *> *)images{
    _selectedPhotos = images;
    _viewStatus = BEFaceClusteringViewShowingImage;
    [self.contentCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.contentCollectionView reloadData];
    self.startBtn.hidden = NO;
    self.contentCollectionView.hidden = NO;
    self.btnClose.hidden = YES;
    self.btnSelect.hidden = YES;
}

- (void)configuraClusteringResult:(NSMutableDictionary<NSNumber*, NSMutableArray*>*) result {
    _clusterResultDict = result;
    _viewStatus = BEFaceClusteringViewClusteringResult;
    [self.contentCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.contentCollectionView reloadData];
    self.startBtn.hidden = YES;
    [self.aivLoading stopAnimating];
}


#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)indexPath.row;
    
    BEButtonViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEButtonViewCell be_identifier] forIndexPath:indexPath];
    if (row == 0 && _viewStatus != BEFaceClusteringViewShowSingleCluster) {
        [cell setSelectImg:[UIImage imageNamed:@"iconCloseButtonNormal.png"]
               unselectImg:[UIImage imageNamed:@"iconCloseButtonNormal.png"]
                     title:NSLocalizedString(@"close", nil)
                    expand:NO
                 withPoint:NO];
    } else if (_viewStatus == BEFaceClusteringViewShowingImage){ // {zh} 展示所有选择的photo {en} Show all selected photos
        UIImage *image = _selectedPhotos[row - 1];
        [cell setSelectImg:image
               unselectImg:image];
    }else if (_viewStatus == BEFaceClusteringViewClusteringResult){ // {zh} 现在处理展示聚类结果的状态 {en} Now process the state that shows the clustering results
        NSNumber *photoIndex;
        if ([_clusterResultDict objectForKey:[NSNumber numberWithInt:-1]] != nil){
            photoIndex = [_clusterResultDict objectForKey:[NSNumber numberWithInt:row - 2]][0];
        }
        else{
            photoIndex = [_clusterResultDict objectForKey:[NSNumber numberWithInt:row - 1]][0];
        }
        
        NSString *title = [self be_itemTitle:indexPath];
        if (title) {
            [cell setSelectImg:_selectedPhotos[[photoIndex intValue]]
                   unselectImg:_selectedPhotos[[photoIndex intValue]]
                         title:title
                        expand:NO
                        withPoint:NO];
        } else {
            [cell setSelectImg:_selectedPhotos[[photoIndex intValue]]
                   unselectImg:_selectedPhotos[[photoIndex intValue]]];
        }
        cell.userInteractionEnabled = YES; // {zh} 设置这些cell可选，打开之后是二级页面 {en} Set these cells optional, after opening is the secondary page
    }else if (_viewStatus == BEFaceClusteringViewShowSingleCluster){ // {zh} 展示聚类之后某一项 {en} Show a certain item after clustering
        NSMutableArray *array = [_clusterResultDict objectForKey:[NSNumber numberWithInteger:_curCluster]];
        
        UIImage* image = _selectedPhotos[[array[row] intValue]];
        [cell setSelectImg:image
               unselectImg:image];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_viewStatus == BEFaceClusteringViewShowingImage){ // {zh} 展示所有选择的photo {en} Show all selected photos
        return 1 + self.selectedPhotos.count;
    }else if (_viewStatus == BEFaceClusteringViewClusteringResult){ // {zh} 现在处理展示聚类结果的状态 {en} Now process the state that shows the clustering results
        return 1 + self.clusterResultDict.count;
    }else if (_viewStatus == BEFaceClusteringViewShowSingleCluster){ // {zh} 现在处于展示其中一个类别状态的阶段 {en} Now in the stage of displaying the status of one of the categories
        return _clusterResultDict[[NSNumber numberWithInt:_curCluster]].count;
    }else
        return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 70);
}

#pragma mark - UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)indexPath.row;
    
    //  {zh} 关闭按钮  {en} Close button
    if (row == 0 && _viewStatus != BEFaceClusteringViewShowSingleCluster){
        [self onClose];
        return;
    }
    
    if (_viewStatus == BEFaceClusteringViewClusteringResult) { // {zh} 现在处理展示聚类结果的状态 {en} Now process the state that shows the clustering results
        _curCluster = [self be_hasFacelessItem] ? row - 2 : row - 1;
        
        _viewStatus = BEFaceClusteringViewShowSingleCluster;
        self.lastResultPosition = self.contentCollectionView.contentOffset;
        [self.contentCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.contentCollectionView reloadData];
        self.backBtn.hidden = NO;
    }else if (_viewStatus == BEFaceClusteringViewShowSingleCluster) { //  {zh} 展示某一类的结果  {en} Show a certain type of result
        self.backBtn.hidden = NO;
    }else
        return ;
}

#pragma mark - BEButtonViewDelegate
- (void)selectableButton:(BESelectableButton *)button didTap:(UITapGestureRecognizer *)sender {
    if (button == self.btnSelect) {
        if ([self.delegate respondsToSelector:@selector(faceClusteringDidSelectedOpenAlbum)]) {
            [self.delegate faceClusteringDidSelectedOpenAlbum];
        }
    }
}

#pragma mark - BECloseableDelegate
- (void)onClose {
    _selectedPhotos = nil;
    self.btnClose.hidden = NO;
    self.btnSelect.hidden = NO;
    self.backBtn.hidden = YES;
    self.startBtn.hidden = YES;
    self.contentCollectionView.hidden = YES;
}

#pragma mark - selector
-(void)onFCStartButtonClicked{
    if (self.selectedPhotos.count == 0){
        [self makeToast:@"请选择大于一张图片进行聚类"];
        return ;
    }else {
        NSLog(@"test start animation");
        self.startBtn.hidden = YES;
        [self.aivLoading startAnimating];
        [self.delegate didStartCluster:_selectedPhotos];
    }
}

-(void) onBackButtonClicked{
    _viewStatus = BEFaceClusteringViewClusteringResult;
    [self.contentCollectionView reloadData];
    [self.contentCollectionView setContentOffset:self.lastResultPosition animated:NO];
    self.backBtn.hidden = YES;
}

#pragma mark - private
- (BOOL)be_hasFacelessItem
{
    return _clusterResultDict != nil && [_clusterResultDict objectForKey:[NSNumber numberWithInt:-1]] != nil;
}

- (NSString *)be_itemTitle:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row < 1) {
        return nil;
    }
    if ([self be_hasFacelessItem]) {
        if (row == 1) {
            return NSLocalizedString(@"face_cluster_faceless", nil);
        } else {
            row = row - 1;
        }
    }
    
    return [NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"face_cluster_person", nil), (long)row];
}

#pragma mark - getter
- (UICollectionView *)contentCollectionView{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 10;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _contentCollectionView.backgroundColor = [UIColor clearColor];
//        [_contentCollectionView registerClass:[BEModernBasePickerViewCell class] forCellWithReuseIdentifier:[BEModernBasePickerViewCell be_identifier]];
//
//        [_contentCollectionView registerClass:[BEModernFaceCollectionViewCell class] forCellWithReuseIdentifier:[BEModernFaceCollectionViewCell be_identifier]];
        
        [_contentCollectionView registerClass:[BEButtonViewCell class] forCellWithReuseIdentifier:[BEButtonViewCell be_identifier]];
        
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
    }
    return _contentCollectionView;
}

- (UIButton *)startBtn{
    if (!_startBtn){
        _startBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_startBtn setTitle:NSLocalizedString(@"btn_cluster_start", nil) forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(onFCStartButtonClicked) forControlEvents:UIControlEventTouchDown];
    }
    return _startBtn;
}
-(UIButton *)backBtn{
    if (!_backBtn){
        _backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_backBtn setTitle:NSLocalizedString(@"btn_back", nil) forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(onBackButtonClicked) forControlEvents:UIControlEventTouchDown];
    }
    return _backBtn;
}

- (BESelectableButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[BESelectableButton alloc]
                     initWithSelectableConfig:
                       [BELightUpSelectableConfig
                        initWithUnselectImage:@"ic_close_normal"
                        imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
        _btnClose.title = NSLocalizedString(@"close", nil);
        _btnClose.delegate = self;
    }
    return _btnClose;
}

- (BESelectableButton *)btnSelect {
    if (!_btnSelect) {
        _btnSelect = [[BESelectableButton alloc]
                      initWithSelectableConfig:
                        [BELightUpSelectableConfig
                         initWithUnselectImage:@"ic_upload_normal"
                         imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
        _btnSelect.title = NSLocalizedString(@"face_cluster_choose_photos", nil);
        _btnSelect.delegate = self;
    }
    return _btnSelect;
}

- (DGActivityIndicatorView *)aivLoading {
    if (!_aivLoading) {
        _aivLoading = [[DGActivityIndicatorView alloc]
                       initWithType:DGActivityIndicatorAnimationTypeBallClipRotate
                       tintColor:[UIColor whiteColor]
                       size:20];
    }
    return _aivLoading;
}
@end
