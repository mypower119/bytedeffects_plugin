//
//  BESportsAssistantVC.m
//  BEAlgorithm
//
//  Created by liqing on 2021/7/5.
//

#import "BESportsAssistantVC.h"
#import "BESportsAssistantTimerVC.h"
#import "BESportsAssistantClassItem.h"
#import "Masonry.h"
#import "BEDeviceInfoHelper.h"
#import "BECommonUtils.h"
#import "BESportsAssistantVM.h"

#define iPhoneX [BEDeviceInfoHelper isIPhoneXSeries]

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define COLLECTION_VIEW_GAP 20

@interface BESportsAssistantVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<UIGestureRecognizerDelegate> savedGestureDelegate;

@end

@implementation BESportsAssistantVC
{
    UIView* _homepage;
    UICollectionView* _collectionView;
    int _cellWidth;
    int _cellHeight;
    NSArray* _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:nil];
//    [self.view addGestureRecognizer:pan];

    
    _homepage = self.view;
    _homepage.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.layer.masksToBounds=YES;
    label.layer.backgroundColor = [UIColor clearColor].CGColor;
    label.layer.borderWidth =1.0f;
    label.layer.borderColor = [UIColor clearColor].CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    label.textColor = [BECommonUtils colorWithHexString:@"#1D2129"];
    label.text = NSLocalizedString(@"feature_sport_assistance", nil);
    [_homepage addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_homepage).mas_offset(iPhoneX ? 44 : 20);
        make.left.equalTo(_homepage);
        make.width.mas_equalTo(_homepage.bounds.size.width);
        make.height.mas_equalTo(label.bounds.size.height);
    }];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    btn.backgroundColor = [UIColor clearColor];
    UIImage* icon = [UIImage imageNamed:@"ic_sa_back"];
    [btn setBackgroundImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_homepage addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_homepage).mas_offset(16);
        make.centerY.equalTo(label);
        make.width.mas_equalTo(btn.bounds.size.width);
        make.height.mas_equalTo(btn.bounds.size.height);
    }];
    
    _cellWidth = (SCREEN_WIDTH - COLLECTION_VIEW_GAP*2 - 7)/2;    
    _cellHeight = _cellWidth * 96 / 164;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
    _collectionView.delegate = self;
    [_collectionView setShowsVerticalScrollIndicator:NO];
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [_homepage addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_homepage).mas_offset(COLLECTION_VIEW_GAP);
        make.right.equalTo(_homepage).mas_offset(-COLLECTION_VIEW_GAP);
        make.top.equalTo(label.mas_bottom).mas_offset(16);
        make.bottom.equalTo(_homepage).mas_offset(iPhoneX ? -34 : 0);
    }];
    
    [self loadData];
    
    [_collectionView reloadData];
}

-(void)loadData
{
    _modelArray = [BESportsAssistantVM instance].classArray;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [BESportsAssistantVM instance].classIndex = indexPath.row;
    BESportsAssistantTimerVC* vc = [BESportsAssistantTimerVC new];
    vc.classItem = [_modelArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _modelArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    UIColor* bg = [BECommonUtils colorWithHexString:@"#6A8BAE"];
    UIColor* textbg = [BECommonUtils colorWithHexString:@"#59000000"];
    
    cell.contentView.layer.cornerRadius =4.0f;
    cell.contentView.layer.borderWidth =1.0f;
    cell.contentView.layer.borderColor = bg.CGColor;
    cell.contentView.backgroundColor = bg;
    cell.contentView.layer.masksToBounds =YES;
    
    BESportsAssistantClassItem* model = [_modelArray objectAtIndex:indexPath.row];
    
    UIImageView *icon = [cell viewWithTag:101];
    if(icon == nil)
    {
        icon = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,_cellWidth,_cellHeight)];
        icon.tag = 101;
        [cell addSubview:icon];
    }
    icon.image = [UIImage imageNamed:model.image_path];
    
    UILabel *label = [cell viewWithTag:100];
    if(label == nil)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, _cellHeight-32, _cellWidth, 32)];
        label.tag = 100;
        [cell addSubview:label];
    }
    
    label.text = model.name;
    label.layer.masksToBounds=YES;
    label.layer.backgroundColor = textbg.CGColor;
    label.layer.cornerRadius =4.0f;
    label.layer.borderWidth =1.0f;
    label.layer.borderColor = [UIColor clearColor].CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];

    return cell;
    
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_cellWidth, _cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0,  0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 7;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 7;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.savedGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self.savedGestureDelegate;
}

@end
