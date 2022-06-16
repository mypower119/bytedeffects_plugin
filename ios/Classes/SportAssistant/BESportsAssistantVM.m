//
//  BESportsAssistantVM.m
//  BEAlgorithm
//
//  Created by liqing on 2021/7/15.
//

#import "BESportsAssistantVM.h"


@implementation BESportsAssistantVM

static BESportsAssistantVM *_sportsAssistantVM;
+ (BESportsAssistantVM *)instance
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _sportsAssistantVM = [[BESportsAssistantVM alloc]init];
    });
    return _sportsAssistantVM;
}

- (NSMutableArray<BESportsAssistantClassItem *> *)classArray
{
    if(_classArray == nil)
    {
        _classArray = [NSMutableArray array];
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"openclose";
            model.image_path = @"ic_sa_home_openclose";
            model.name = NSLocalizedString(@"sport_assistance_open_close_jump", nil);
            model.isLandscape = NO;
            model.readyPoseType = 1;
            model.video_path = @"sa_openclose";
            model.tutor_wrong = @"ic_sa_tutor_openclose";
            model.tutor_right = @"ic_sa_tutor_right_openclose";
            model.finish_logo = @"ic_sa_finish_openclose";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"squat";
            model.image_path = @"ic_sa_home_squat";
            model.name = NSLocalizedString(@"sport_assistance_deep_squat", nil);
            model.isLandscape = NO;
            model.readyPoseType = 1;
            model.video_path = @"sa_squat";
            model.tutor_wrong = @"ic_sa_tutor_openclose";
            model.tutor_right = @"ic_sa_tutor_right_openclose";
            model.finish_logo = @"ic_sa_finish_squat";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"plank";
            model.image_path = @"ic_sa_home_plank";
            model.name = NSLocalizedString(@"sport_assistance_plank", nil);
            model.isLandscape = YES;
            model.readyPoseType = 2;
            model.video_path = @"sa_plank";
            model.tutor_wrong = @"ic_sa_tutor_pushup";
            model.tutor_right = @"ic_sa_tutor_right_pushup";
            model.finish_logo = @"ic_sa_finish_plank";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"pushup";
            model.image_path = @"ic_sa_home_pushup";
            model.name = NSLocalizedString(@"sport_assistance_push_up", nil);
            model.isLandscape = YES;
            model.readyPoseType = 2;
            model.video_path = @"sa_pushup";
            model.tutor_wrong = @"ic_sa_tutor_pushup";
            model.tutor_right = @"ic_sa_tutor_right_pushup";
            model.finish_logo = @"ic_sa_finish_pushup";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"situp";
            model.image_path = @"ic_sa_home_situp";
            model.name = NSLocalizedString(@"sport_assistance_sit_up", nil);
            model.isLandscape = YES;
            model.readyPoseType = 3;
            model.video_path = @"sa_situp";
            model.tutor_wrong = @"ic_sa_tutor_situp";
            model.tutor_right = @"ic_sa_tutor_right_situp";
            model.finish_logo = @"ic_sa_finish_situp";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"high_run";
            model.image_path = @"ic_sa_home_high_run";
            model.name = NSLocalizedString(@"sport_assistance_high_run", nil);
            model.isLandscape = NO;
            model.readyPoseType = 1;
            model.video_path = @"sa_high_run";
            model.tutor_wrong = @"ic_sa_tutor_openclose";
            model.tutor_right = @"ic_sa_tutor_right_openclose";
            model.finish_logo = @"ic_sa_finish_high_run";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"lunge";
            model.image_path = @"ic_sa_home_lunge_squat";
            model.name = NSLocalizedString(@"sport_assistance_lunge", nil);
            model.isLandscape = NO;
            model.readyPoseType = 5;
            model.video_path = @"sa_lunge";
            model.tutor_wrong = @"ic_sa_tutor_squat";
            model.tutor_right = @"ic_sa_tutor_right_squat";
            model.finish_logo = @"ic_sa_finish_lunge_squat";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"hip_bridge";
            model.image_path = @"ic_sa_home_hip_bridge";
            model.name = NSLocalizedString(@"sport_assistance_hip_bridge", nil);
            model.isLandscape = YES;
            model.readyPoseType = 3;
            model.video_path = @"sa_hip_bridge";
            model.tutor_wrong = @"ic_sa_tutor_situp";
            model.tutor_right = @"ic_sa_tutor_right_situp";
            model.finish_logo = @"ic_sa_finish_hip_bridge";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"lunge_squat";
            model.image_path = @"ic_sa_home_lunge";
            model.name = NSLocalizedString(@"sport_assistance_lunge_squat", nil);
            model.isLandscape = NO;
            model.readyPoseType = 5;
            model.video_path = @"sa_lunge_squat";
            model.tutor_wrong = @"ic_sa_tutor_squat";
            model.tutor_right = @"ic_sa_tutor_right_squat";
            model.finish_logo = @"ic_sa_finish_lunge";
            [_classArray addObject:model];
        }
        
        {
            BESportsAssistantClassItem* model = [BESportsAssistantClassItem new];
            model.key = @"kneeling_pushup";
            model.image_path = @"ic_sa_home_kneeling_pushup";
            model.name = NSLocalizedString(@"sport_assistance_kneeling_pushup", nil);
            model.isLandscape = YES;
            model.readyPoseType = 2;
            model.video_path = @"sa_kneeling_pushup";
            model.tutor_wrong = @"ic_sa_tutor_pushup";
            model.tutor_right = @"ic_sa_tutor_right_pushup";
            model.finish_logo = @"ic_sa_finish_kneeling_pushup";
            [_classArray addObject:model];
        }
    }
    
    return _classArray;
}

@end
