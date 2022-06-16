//  Copyright © 2019 ailab. All rights reserved.

#import "BEHandInfoVC.h"
#import <Masonry/Masonry.h>
#import "UIView+BEAdd.h"

static NSString *const BEGesturePropertyTextGesture = @"";

@interface BEHandInfoVC ()

@property (nonatomic, assign) bef_ai_hand info;
@property (nonatomic, strong) UILabel *lGesture;
@property (nonatomic, strong) UIView  *vSegment;
@property (nonatomic, strong) UILabel *lPunch;
@property (nonatomic, strong) UILabel *lClap;

@end

@implementation BEHandInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.lGesture];
    [self.view addSubview:self.vSegment];
    [self.view addSubview:self.lPunch];
    [self.view addSubview:self.lClap];
    
    [self.lGesture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    [self.vSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.lGesture.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.lPunch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.vSegment.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    [self.lClap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.lPunch.mas_bottom);
        make.height.mas_equalTo(20);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    bef_ai_hand info = _info;
    CGSize maxRowSize = [self.lGesture.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 20) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    int top = [self offsetYWithRect:info.rect];
    float left = [self offsetXWithRect:info.rect];
    CGFloat height = 60;
    if (top < height) top = height;
    if (left < 0) left = 0;
    self.view.frame = CGRectMake(left, top - height, maxRowSize.width + 1, height);
}

- (void)updateHandInfo:(bef_ai_hand)info {
    // store value
    _info = info;
    
    // logic & display
    NSString *gestureStr = @"unknown";
    if (info.action != 99 && info.action < BEHandTypes().count) {
        gestureStr = BEHandTypes()[info.action];
    }
    
    self.lGesture.text = [NSLocalizedString(@"gesture_title", nil) stringByAppendingFormat:@"  %@", gestureStr];
    self.lPunch.backgroundColor = info.seq_action == 1 ? UIColor.blueColor : [UIColor colorWithWhite:0 alpha:0.4];
    self.lClap.backgroundColor = info.seq_action == 2 ? UIColor.blueColor : [UIColor colorWithWhite:0 alpha:0.4];

    // relayout
    [self.view setNeedsLayout];
}

#pragma mark - getter && setter

- (UILabel *)lGesture {
    if (!_lGesture) {
        _lGesture = [UILabel new];
        _lGesture.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _lGesture.textColor = UIColor.whiteColor;
        _lGesture.font = [UIFont systemFontOfSize:13];
    }
    return _lGesture;
}

- (UIView *)vSegment {
    if (!_vSegment) {
        _vSegment = [UIView new];
        _vSegment.backgroundColor = UIColor.whiteColor;
    }
    return _vSegment;
}

- (UILabel *)lPunch {
    if (!_lPunch) {
        _lPunch = [UILabel new];
        _lPunch.text = NSLocalizedString(@"gesture_punching", nil);
        _lPunch.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _lPunch.textColor = UIColor.whiteColor;
        _lPunch.font = [UIFont systemFontOfSize:13];
    }
    return _lPunch;
}

- (UILabel *)lClap {
    if (!_lClap) {
        _lClap = [UILabel new];
        _lClap.text = NSLocalizedString(@"gesture_applaud", nil);
        _lClap.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _lClap.textColor = UIColor.whiteColor;
        _lClap.font = [UIFont systemFontOfSize:13];
    }
    return _lClap;
}

static NSArray *BEHandTypes() {
    static NSArray *handTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handTypes =
        @[
          @"heart_a",
          @"heart_b",
          @"heart_c",
          @"heart_d",
          @"ok",
          @"hand_open",
          @"thumb_up",
          @"thumb_down",
          @"rock",
          @"namaste",
          @"palm_up",
          @"fist",
          @"index_finger_up",
          @"double_finger_up",
          @"victory",
          @"big_v",
          @"phonecall",
          @"beg",
          @"thanks",
          @"unknown",
          @"cabbage",
          @"three",
          @"four",
          @"pistol",
          @"rock2",
          @"swear",
          @"holdface",
          @"salute",
          @"spread",
          @"pray",
          @"qigong",
          @"slide",
          @"palm_down",
          @"pistol2",
          @"naturo1",
          @"naturo2",
          @"naturo3",
          @"naturo4",
          @"naturo5",
          @"naturo7",
          @"naturo8",
          @"naturo9",
          @"naturo10",
          @"naturo11",
          @"naturo12",
          @"spiderman",
          @"avengers",
          @"raise",
          ];
    });
    return handTypes;
};

@end
