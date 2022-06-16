//
//  BEStudentIdOcrViewController.m
//  BytedEffects
//
//  Created by Bytedance on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEStudentIdOcrViewController.h"
#import "BEStudentIdOcrView.h"
#import "Masonry.h"
#import "BEStudentIdOcrTask.h"
#import "UIResponder+BEAdd.h"

@interface BEStudentIdOcrViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, BEStudentIdOcrCloseDelegate>
@property (nonatomic, strong) BEStudentIdOcrView *studentIdOcrView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) BEStudentIdOcrTask* studentIdOcrTask;

@end


@implementation BEStudentIdOcrViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.studentIdOcrView];
    
    [self.studentIdOcrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if (self.studentIdOcrTask == nil){
        [self.studentIdOcrTask initTask];
//    }
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.studentIdOcrTask destroyTask];
//    self.studentIdOcrTask = nil;
}

// draw rect in uiimage
- (UIImage*)drawUimage:(UIImage*) source withRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(source.size, NO, source.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetGrayFillColor(context, <#CGFloat gray#>, c)
//    CGContextFillRect(context, rect);
    [source drawAtPoint:CGPointZero];
    CGContextSetLineWidth(context, 10.0);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
//    CGFloat redColor[4] = {1.0, 0.0, 0.0, 1.0};
//    CGContextSetStrokeColor(context, redColor);
    CGContextStrokeRect(context, rect);
    
    UIImage *dstImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return dstImage;
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //Current logic is like this:
    //1. get the image 2. set image in imageView
    //3.draw rect in dest image 4. set result image and show ocr result
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //process image
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//        [self.delegate didSelecteImage:image];
                               
        [self.studentIdOcrView studentIdOcrSetImage:image];
        
        size_t width = 0, height = 0, bytesPerRow = 0;
        CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
        const uint8_t *data = CFDataGetBytePtr(pixelData);
        
        width = CGImageGetWidth(image.CGImage);
        height = CGImageGetHeight(image.CGImage);
        bytesPerRow = CGImageGetBytesPerRow(image.CGImage);
        
        // {zh} 图片模式下，检测先放在这里，等到以后有需要，再放入正确的逻辑中 {en} In picture mode, the detection is put here first, and then put into the correct logic when it is needed later
//        BEProcessInput *input =  [[BEProcessInput alloc] init];
//        BEBuffer *buffer = [[BEBuffer alloc] init];
//        buffer.buffer = (unsigned char *)data;
//        buffer.width = (int)width;
//        buffer.height = (int)height;
//        buffer.format = BE_RGBA;
//        buffer.bytesPerRow = (int)bytesPerRow;
//        input.inputBuffer = buffer;
//        input.rotation = BEF_AI_CLOCKWISE_ROTATE_0;
        
        // {zh} output 的内存在函数调用的时候回被分配 {en} The memory of the output is allocated when the function is called
//        BEProcessOutput *output = [self.studentIdOcrTask process:input];
//
//        if (output.studentIdOcrInfo == nil) {
//            NSLog(@"output is nil");
//            CFRelease(pixelData);
//            return ;
//        }
//        bef_student_id_ocr_result* ocrResult = output.studentIdOcrInfo;
//        NSLog(@"x=%d, y=%d, width=%d, height=%d", ocrResult->x, ocrResult->y, ocrResult->height, ocrResult->width);
        
//        CGRect rect = CGRectMake(ocrResult->x, ocrResult->y, ocrResult->width, ocrResult->height);
//        UIImage* dst_image = [self drawUimage:image withRect:rect];
//        
//        NSString* result = [NSString stringWithUTF8String:ocrResult->result];
//        free(ocrResult->result);
//        [self.studentIdOcrView setOcrResultImage:dst_image numbers:result];
//        CFRelease(pixelData);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    [self studentIdOcrClose];
//    [self.be_topViewController hideContentController:self];
}

#pragma mark  - studentView delegate
- (void) studentIdOcrClose{
    if (self.delegate && [self.delegate respondsToSelector:@selector(studentIdOcrFinish)]){
        [self.delegate studentIdOcrFinish];
    }
}
#pragma mark  - gettter
- (BEStudentIdOcrView *) studentIdOcrView{
    if (!_studentIdOcrView){
        _studentIdOcrView = [[BEStudentIdOcrView alloc] init];
        _studentIdOcrView.delegate = self;
    }
    return _studentIdOcrView;
}


- (UIImagePickerController*)imagePickerController{
    if (!_imagePickerController){
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

- (BEStudentIdOcrTask *) studentIdOcrTask{
    if (!_studentIdOcrTask){
//        _studentIdOcrTask = [[BEStudentIdOcrTask alloc] initWithResourceProvider:[BEResourceHelper new]];
    }
    return _studentIdOcrTask;
}

@end
