//  Copyright © 2019 ailab. All rights reserved.

#import <Foundation/Foundation.h>
#import "BEFaceDistanceInfoVC.h"
#import <Masonry/Masonry.h>

@interface BEFaceDistanceInfoVC ()

@property(nonatomic, strong) NSMutableArray* labelArray;

@end

@implementation BEFaceDistanceInfoVC

-(void) viewDidLoad{
    [super viewDidLoad];
    [self addLabels];

    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

// {zh} 添加label数组 {en} Add label array
- (void) addLabels{
    int maxCount = BEF_MAX_FACE_NUM;

    for (int i = 0; i < maxCount; i ++){
        UILabel *label = [[UILabel alloc] init];

        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        label.hidden = NO;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.whiteColor;
        label.userInteractionEnabled = NO;
        label.textAlignment = NSTextAlignmentCenter;

        [self.view addSubview:label];
        [self.labelArray addObject:label];
    }
}

- (void)updateFaceDistance:(bef_ai_face_info)faceInfo distance:(bef_ai_human_distance_result)distance {
    int faceCount = faceInfo.face_count;

    // {zh} 显示有效face的距离 {en} Display distance of effective face
    for (int i = 0; i < faceCount && i < self.labelArray.count; i++){
        UILabel *label = self.labelArray[i];

        label.hidden = NO;
        label.text = [NSString stringWithFormat:@"%@%.2f", NSLocalizedString(@"dist", nil), distance.distances[i]];

        CGSize maxRowSize = [label.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        maxRowSize = CGSizeMake(maxRowSize.width + 6, maxRowSize.height + 6);

        bef_ai_rect rect = faceInfo.base_infos[i].rect;
        int top = [self offsetYWithRect:rect];
        int left = [self offsetXWithRect:rect];
        if (top < maxRowSize.height) top = maxRowSize.height;
        if (left < 0) left = 0;
        label.frame = CGRectMake(left, top - maxRowSize.height, maxRowSize.width, maxRowSize.height);
    }

    // {zh} 对剩下的label，进行隐藏 {en} Hide the remaining labels
    for (int i = faceCount; i < BEF_MAX_FACE_NUM && i < self.labelArray.count; i ++){
        UILabel *label = self.labelArray[i];
        label.hidden = YES;
    }
}

-(NSMutableArray *) labelArray{
    if (!_labelArray){
        _labelArray = [[NSMutableArray alloc] init];
    }
    return _labelArray;
}
@end
