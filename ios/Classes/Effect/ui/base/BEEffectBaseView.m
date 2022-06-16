//
//  BEEffectBaseView.m
//  Effect
//
//  Created by qun on 2021/5/25.
//

#import "BEEffectBaseView.h"
#import "Masonry.h"
#import "Common.h"

@interface BEEffectBaseView ()

@property (nonatomic, strong) UIButton *btnCompare;

@property (nonatomic, assign) int bottomMargin;

@end
 
@implementation BEEffectBaseView

- (instancetype)initWithButtomMargin:(int)bottomMargin {
    self = [super init];
    if (self) {
        self.bottomMargin = bottomMargin;
        [self addSubview:self.btnCompare];
        
        CGFloat BUTTON_WIDTH = BEF_DESIGN_SIZE(28);
        
        [self.btnCompare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(BUTTON_WIDTH);
//            make.trailing.equalTo(self).offset(-10);
            make.right.mas_equalTo(-20);
            make.bottom.equalTo(self).offset(-bottomMargin-20);
        }];
    }
    return self;
}

- (void)updateShowCompare:(BOOL)showCompare {
    self.btnCompare.hidden = !showCompare;
}

- (void)updateButtomMargin:(int)bottomMargin delay:(NSTimeInterval)delay {
    [UIView animateWithDuration:0.2 animations:^{
        [self.btnCompare mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-bottomMargin);
        }];
        [self layoutIfNeeded];
    }];
    
//    [UIView animateWithDuration:0.2 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self.btnCompare mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).offset(-bottomMargin);
//        }];
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        
//    }];
}

//  {zh} 事件透传  {en} Event transmission
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if (v == self) {
        return nil;
    }
    return v;
}

- (void)onEffectBaseViewTouchDown:(UIView *)sender {
    [self.delegate effectBaseView:self onTouchDownCompare:sender];
}

- (void)onEffectBaseViewTouchUp:(UIView *)sender {
    [self.delegate effectBaseView:self onTouchUpCompare:sender];
}

#pragma mark - getter
- (UIButton *)btnCompare {
    if (_btnCompare == nil) {
        _btnCompare = [UIButton new];
        [_btnCompare setImage:[UIImage imageNamed:@"ic_compare"] forState:UIControlStateNormal];
        [_btnCompare addTarget:self action:@selector(onEffectBaseViewTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_btnCompare addTarget:self action:@selector(onEffectBaseViewTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [_btnCompare addTarget:self action:@selector(onEffectBaseViewTouchUp:) forControlEvents:UIControlEventTouchCancel];
        [_btnCompare addTarget:self action:@selector(onEffectBaseViewTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnCompare;
}

@end
