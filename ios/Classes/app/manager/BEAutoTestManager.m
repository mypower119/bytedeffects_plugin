//
//  BEAutoTestManager.m
//  app
//
//  Created by qun on 2021/7/6.
//

//#if BEF_AUTO_TEST
#import "BEAutoTestManager.h"
#import "YYModel.h"

#define BEF_CUSTOM_CONFIG_JSON false
static NSString *const CONFIG_FILE_NAME = @"bef_config_file";
static NSString *const LOG_FILE_NAME = @"bef_log_file";
static NSString *const INVALID_CHARACTERSET = @"\t\n";

static int originErrorFd = 0;
static NSFileHandle *redirectedErrorHandle = nil;
static int originOutFd = 0;
static NSFileHandle *redirectedOutHandle = nil;
static NSString *logFilePath = nil;

@interface BEAutoTestManager ()

@end

@implementation BEAutoTestManager

+ (BEFeatureConfig *)featureConfigFromDucoments {
#if BEF_CUSTOM_CONFIG_JSON
    NSString *jsonContent = @"{\"viewControllerClass\":\"BEEffectVC\",\"videoSourceConfig\":{\"type\":0,\"devicePosition\":2,\"mediaPath\":\"\"},\"effectConfig\":{\"composerNodes\":[{\"path\":\"beauty_IOS_live\",\"keyArray\":[\"smooth\",\"whiten\"],\"tag\":\"\",\"valueArray\":[1.2,3.4]},{\"path\":\"reshape_live\",\"keyArray\":[\"Internal_Deform_Overall\",\"Internal_Deform_Eye\"],\"tag\":\"\",\"valueArray\":[1.2,3.4]}],\"filterName\":\"Filter_18_18\",\"filterIntensity\":0.7,\"stickerConfig\":{\"stickerPath\":\"chitushaonv\"}},\"algorithmConfig\":{\"type\":\"face\",\"params\":{\"face\":true,\"face280\":true,\"faceMask\":true}},\"lensConfig\":{\"type\":3,\"open\":true}}";
    NSString *logFileName = @"log.log";
#else
    NSDictionary *environments = [[NSProcessInfo processInfo] environment];
    NSString *configFileName = environments[CONFIG_FILE_NAME];
    NSString *logFileName = environments[LOG_FILE_NAME];
    
    if (configFileName == nil) {
        NSLog(@"config file name not found in environments");
        return nil;
    }
    
    NSString *jsonContent = [self readConfigContent:configFileName];
    if (jsonContent == nil) {
        NSLog(@"read config file failed");
        return nil;
    }
#endif
    
    //  {zh} 重定向 log  {en} Redirect log
    if (logFileName != nil) {
        logFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"log.log"];
        [@"" writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [self redirectNSLog];
    }
    
    BEFeatureConfig *config = [BEFeatureConfig yy_modelWithJSON:jsonContent];
    
    //  {zh} 解决一些 YYModel 处理不了的  {en} Solve some problems that YYModel can't handle
    if (config.effectConfig != nil && config.effectConfig.composerNodes != nil) {
        NSMutableArray<BEComposerNodeModel *> *nodes = [NSMutableArray array];
        for (id item in config.effectConfig.composerNodes) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                BEComposerNodeModel *node = [BEComposerNodeModel new];
                node.path = item[@"path"];
                node.tag = item[@"tag"];
                node.keyArray = item[@"keyArray"];
                node.valueArray = item[@"valueArray"];
                [nodes addObject:node];
            } else if ([item isKindOfClass:[BEComposerNodeModel class]]) {
                [nodes addObject:item];
            } else {
                NSLog(@"could not extract valid composer nodes in %@", config.effectConfig.composerNodes);
            }
        }
        config.effectConfig.composerNodes = nodes;
    }
    
    return config;
}

+ (NSString *)readConfigContent:(NSString *)configFileName {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *configFilePath = [documentPath stringByAppendingPathComponent:configFileName];
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:configFilePath];
    if (!exist) {
        return nil;
    }
    
    NSString *content = [NSString stringWithContentsOfFile:configFilePath encoding:NSUTF8StringEncoding error:nil];
    return [[content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:INVALID_CHARACTERSET]] componentsJoinedByString:@""];
}

+ (void)redirectErrNotificationHandle:(NSNotification *)nf {
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSFileHandle *fileHandle = [nf object];
    
    //  {zh} 输出到原 NSLog 位置  {en} Output to original NSLog location
    if (fileHandle == redirectedErrorHandle) {
        write(originErrorFd, [str cStringUsingEncoding:NSUTF8StringEncoding], [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    } else if (fileHandle == redirectedOutHandle) {
        write(originOutFd, [str cStringUsingEncoding:NSUTF8StringEncoding], [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    }
    
    //  {zh} 写到 log 文件  {en} Write to log file
    if ([[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
    } else {
        [data writeToFile:logFilePath atomically:YES];
    }
    
    [fileHandle readInBackgroundAndNotify];
}

+ (void)redirectNSLog {
    //  {zh} 记录 NSLog 对应的文件描述符  {en} Record the file descriptor corresponding to NSLog
    originErrorFd = dup(STDERR_FILENO);
    stderr->_flags = 10;
    //  {zh} 创建新的 pipe，并将 STDERR 重定向到这里  {en} Create a new pipe and redirect STDERR here
    NSPipe *errPipe = [NSPipe pipe];
    redirectedErrorHandle = [errPipe fileHandleForReading];
    dup2([[errPipe fileHandleForWriting] fileDescriptor], STDERR_FILENO);
    //  {zh} 给新的 pipe 添加监听，在回调里面得到 NSLog 的内容  {en} Add listening to the new pipe and get the NSLog content in the callback
    [redirectedErrorHandle readInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectErrNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:redirectedErrorHandle];
    
    //  {zh} 记录 print  {en} Record printing
    originOutFd = dup(STDOUT_FILENO);
    stdout->_flags = 10;
    NSPipe *outPipe = [NSPipe pipe];
    redirectedOutHandle = [outPipe fileHandleForReading];
    dup2([[outPipe fileHandleForWriting] fileDescriptor], STDOUT_FILENO);
    [redirectedOutHandle readInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectErrNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:redirectedOutHandle];
}

+ (void)recoverNSLog {
    if (originErrorFd != 0) {
        dup2(originErrorFd, STDERR_FILENO);
    }
    if (originOutFd != 0) {
        dup2(originOutFd, STDOUT_FILENO);
    }
    if (redirectedErrorHandle != nil) {
        [redirectedErrorHandle closeFile];
    }
    if (redirectedOutHandle != nil) {
        [redirectedOutHandle closeFile];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)stopAutoTest {
    [self recoverNSLog];
}

@end
//#endif
