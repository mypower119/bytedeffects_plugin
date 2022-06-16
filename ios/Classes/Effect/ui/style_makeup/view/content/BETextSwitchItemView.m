//
//  BETextSwitchItemView.m
//  Effect
//
//  Created by qun on 2021/5/26.
//

#import "BETextSwitchItemView.h"
#import "BETextSizeUtils.h"
#import "Masonry.h"

@implementation BETextSwitchItem

+ (instancetype)initWithTitle:(NSString *)title pointColor:(UIColor *)pointColor highlightTextColor:(UIColor *)highlightTextColor normalTextColor:(UIColor *)normalTextColor {
    BETextSwitchItem *item = [[self alloc] init];
    item.title = title;
    item.pointColor = pointColor;
    item.highlightTextColor = highlightTextColor;
    item.normalTextColor = normalTextColor;
    return item;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _minTextWidth = [BETextSizeUtils calculateTextWidth:title size:15];
}

@end

@interface BETextSwitchItemView ()

@property (nonatomic, strong) UILabel *lTitle;
@property (nonatomic, strong) UIView *vPoint;

@end

@implementation BETextSwitchItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lTitle];
        [self addSubview:self.vPoint];
        self.vPoint.layer.cornerRadius = 2;
        self.vPoint.hidden = YES;
        
        [self.vPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(4);
            make.centerY.equalTo(self);
            make.leading.equalTo(self);
        }];
        
        [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.vPoint.mas_trailing).offset(4);
            make.top.bottom.trailing.equalTo(self);
        }];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)setItem:(BETextSwitchItem *)item {
    _item = item;
    
    self.lTitle.text = item.title;
    self.lTitle.textColor = item.normalTextColor;
    self.vPoint.backgroundColor = item.pointColor;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    self.lTitle.textColor = selected ? self.item.highlightTextColor : self.item.normalTextColor;
    self.vPoint.hidden = !selected;
}

- (void)tapGestureEvent:(UIGestureRecognizer *)recognizer {
    [self.delegate textSwitchItemView:self didSelect:self.item];
}

#pragma mark - getter
- (UILabel *)lTitle {
    if (_lTitle) {
        return _lTitle;
    }
    
    _lTitle = [UILabel new];
    _lTitle.font = [UIFont systemFontOfSize:13];
    _lTitle.textAlignment = NSTextAlignmentCenter;
    return _lTitle;
}

- (UIView *)vPoint {
    if (_vPoint) {
        return _vPoint;
    }
    
    _vPoint = [UIView new];
    _vPoint.clipsToBounds = YES;
    return _vPoint;
}

@end
