//
//  BEFaceInfoVC.m
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#import "BEFaceInfoVC.h"
#import "BEPropertyTextView.h"
#import "BEScrollablePropertyTextView.h"
#import "BEFaceActionView.h"
#import "BELocaleManager.h"
#import "Masonry.h"
#import "Common.h"

static const float CONFUSE_PROB = 0.3F;

@interface BEFaceInfoVC ()

@property (nonatomic, strong) BEScrollablePropertyTextView *ptvTotalCount;
@property (nonatomic, strong) BEScrollablePropertyTextView *ptvCurrentCount;

@property (nonatomic, strong) BEScrollablePropertyTextView *ptvYaw;
@property (nonatomic, strong) BEScrollablePropertyTextView *ptvRoll;
@property (nonatomic, strong) BEScrollablePropertyTextView *ptvPitch;

@property (nonatomic, strong) BEFaceActionView *actionView;

@property (nonatomic, strong) BEScrollablePropertyTextView *ptvAge;
@property (nonatomic, strong) BEScrollablePropertyTextView *ptvSex;
@property (nonatomic, strong) BEScrollablePropertyTextView *ptvBeauty;
@property (nonatomic, strong) BEScrollablePropertyTextView *ptvHappy;
@property (nonatomic, strong) BEScrollablePropertyTextView *ptvExpression;
@property (nonatomic, strong) BEScrollablePropertyTextView *ptvConfuse;

@property (nonatomic, strong) NSArray *attrArr;

@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int lastCount;

@end

@implementation BEFaceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    self.view.userInteractionEnabled = NO;
}

- (void)updateFaceInfo:(bef_ai_face_106)info faceCount:(int)count {
    if (_lastCount == 0 && count > 0) {
        _totalCount += 1;
    }
    
    [self.ptvTotalCount setValue:[NSString stringWithFormat:@"%d", _totalCount]];
    [self.ptvCurrentCount setValue:[NSString stringWithFormat:@"%d", count]];
    
    self.ptvYaw.value = [NSString stringWithFormat:@"%.2f", info.yaw];
    self.ptvRoll.value = [NSString stringWithFormat:@"%.2f", info.roll];
    self.ptvPitch.value = [NSString stringWithFormat:@"%.2f", info.pitch];
    
    for (int i = 0; i < 6; i++) {
        if ((1 << (i + 1)) & info.action) {
            [self.actionView setIndex:i selected:YES];
        } else {
            [self.actionView setIndex:i selected:NO];
        }
    }
    
    _lastCount = count;
}

- (void)updateFaceExtraInfo:(bef_ai_face_attribute_result *)attrInfo {
    BOOL hasFace = attrInfo->face_count > 0;
    bef_ai_face_attribute_info info = attrInfo->attr_info[0];
    self.ptvAge.value = hasFace ? [NSString stringWithFormat:@"%.0f", info.age] : @"";
    self.ptvSex.value = hasFace ? info.boy_prob > 0.5 ? NSLocalizedString(@"male", nil): NSLocalizedString(@"female", nil) : @"";
    self.ptvBeauty.value = hasFace ? [NSString stringWithFormat:@"%.0f", info.attractive] : @"";
    self.ptvHappy.value = hasFace ? [NSString stringWithFormat:@"%.0f", info.happy_score] : @"";
    self.ptvExpression.value = hasFace ? (info.exp_type >= 0 && info.exp_type < BEExpressionTypes().count)
                                ? BEExpressionTypes()[info.exp_type]
                                : BEExpressionTypes().lastObject : @"";
    self.ptvConfuse.value = hasFace ? info.confused_prob > CONFUSE_PROB ? NSLocalizedString(@"yes", nil) : NSLocalizedString(@"no", nil) : @"";
}

- (void)setShowAttrInfo:(BOOL)showAttrInfo {
    _showAttrInfo = showAttrInfo;
    
    for (UIView *v in self.attrArr) {
        v.hidden = !showAttrInfo;
    }
}

- (void)initView {
    self.ptvTotalCount = [[BEScrollablePropertyTextView alloc] init];
    self.ptvTotalCount.title = NSLocalizedString(@"detect_count", nil);
    self.ptvCurrentCount = [[BEScrollablePropertyTextView alloc] init];
    self.ptvCurrentCount.title = NSLocalizedString(@"current_face", nil);
    
    self.ptvYaw = [[BEPropertyTextView alloc] init];
    self.ptvYaw.title = NSLocalizedString(@"yaw", nil);
    self.ptvRoll = [[BEPropertyTextView alloc] init];
    self.ptvRoll.title = NSLocalizedString(@"roll", nil);
    self.ptvPitch = [[BEPropertyTextView alloc] init];
    self.ptvPitch.title = NSLocalizedString(@"pitch", nil);
    
    self.actionView = [[BEFaceActionView alloc] init];
    self.actionView.items = faceActionTypes();
    self.actionView.hightlightTextColor = [UIColor whiteColor];
    self.actionView.normalTextColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0];
    
    self.ptvAge = [[BEScrollablePropertyTextView alloc] init];
    self.ptvAge.title = NSLocalizedString(@"age", nil);
    self.ptvSex = [[BEScrollablePropertyTextView alloc] init];
    self.ptvSex.title = NSLocalizedString(@"gender", nil);
    self.ptvBeauty = [[BEScrollablePropertyTextView alloc] init];
    self.ptvBeauty.title = NSLocalizedString(@"beauty", nil);
    self.ptvHappy = [[BEScrollablePropertyTextView alloc] init];
    self.ptvHappy.title = NSLocalizedString(@"happiness", nil);
    self.ptvExpression = [[BEScrollablePropertyTextView alloc] init];
    self.ptvExpression.title = NSLocalizedString(@"expression", nil);
    self.ptvConfuse = [[BEScrollablePropertyTextView alloc] init];
    self.ptvConfuse.title = NSLocalizedString(@"confuse", nil);
    
    NSArray *countArr = [NSArray arrayWithObjects:self.ptvTotalCount, self.ptvCurrentCount, nil];
    NSArray *yawArr = [NSArray arrayWithObjects:self.ptvYaw, self.ptvPitch, self.ptvRoll, nil];
    self.attrArr = BELocaleManager.isSupportFaceVerify ? [NSArray arrayWithObjects:self.ptvAge, self.ptvSex, self.ptvBeauty, self.ptvHappy, self.ptvExpression, self.ptvConfuse, nil] : [NSArray arrayWithObjects:self.ptvHappy, self.ptvExpression, self.ptvConfuse, nil];
    
    NSArray *allArr = [[[[NSArray arrayWithArray:countArr] arrayByAddingObjectsFromArray:yawArr] arrayByAddingObjectsFromArray:self.attrArr] arrayByAddingObject:self.actionView];
    for (UIView *v in allArr) {
        [self.view addSubview:v];
        if (v != self.actionView) {
            v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        }
    }
    
    int sectionInterval = 2;
    int traling = -ALGORITHM_INFO_LEFT_MARGIN;
    int lineHeight = 20;
    int countTop = ALGORITHM_INFO_TOP_MARGIN;
    for (UIView *v in countArr) {
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view).offset(traling);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(lineHeight);
            make.top.equalTo(self.view).offset(countTop);
        }];
        countTop += lineHeight;
    }
    
    countTop += sectionInterval;
    for (UIView *v in yawArr) {
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.width.height.equalTo(self.ptvTotalCount);
            make.top.equalTo(self.view).offset(countTop);
        }];
        countTop += lineHeight;
    }
    
    countTop += 2;
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.equalTo(self.ptvTotalCount);
        make.top.equalTo(self.view).offset(countTop);
        make.height.mas_equalTo(50);
    }];
    countTop += 50;
    
    countTop += sectionInterval;
    for (UIView *v in self.attrArr) {
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.width.height.equalTo(self.ptvTotalCount);
            make.top.equalTo(self.view).offset(countTop);
        }];
        countTop += lineHeight;
    }
}

static NSArray *BEColorTypes(){
    static NSArray *colorTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorTypes =@[
                      NSLocalizedString(@"white", nil),
                      NSLocalizedString(@"yellow", nil),
                      NSLocalizedString(@"brown", nil),
                      NSLocalizedString(@"black", nil),
                    ];
    });
    return colorTypes;
}

static NSArray *BEExpressionTypes(){
    static NSArray *expressionTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expressionTypes =@[
                           NSLocalizedString(@"anger", nil),
                           NSLocalizedString(@"nausea", nil),
                           NSLocalizedString(@"fear", nil),
                           NSLocalizedString(@"happy", nil),
                           NSLocalizedString(@"sad", nil),
                           NSLocalizedString(@"surprise", nil),
                           NSLocalizedString(@"poker_face", nil),];
    });
    return expressionTypes;
}

static NSArray *faceActionTypes(){
    static dispatch_once_t onceToken;
    static NSArray* types;
    
    dispatch_once(&onceToken, ^{
        types = @[
                  NSLocalizedString(@"closing_eye", nil),
                  NSLocalizedString(@"open_mouth", nil),
                  NSLocalizedString(@"shake_head", nil),
                  NSLocalizedString(@"nod", nil),
                  NSLocalizedString(@"raise_eyebrow", nil),
                  NSLocalizedString(@"pout", nil),];
        
    });
    return types;
}

@end
