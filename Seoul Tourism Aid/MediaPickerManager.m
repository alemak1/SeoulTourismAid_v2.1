//
//  MediaPickerManager.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "MediaPickerManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface MediaPickerManager () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property UIViewController* presentingViewController;
@property (nonatomic, readonly) UIImagePickerController* imagePickerController;

@end

@implementation MediaPickerManager

@synthesize imagePickerController = _imagePickerController;


-(instancetype)initWithPresentingViewController:(UIViewController*)presentingViewController{
    
    if(self = [super init]){
        self.presentingViewController = presentingViewController;
    }
    
    return self;
}


-(UIImagePickerController *)imagePickerController{
    
    if(_imagePickerController == nil){
        _imagePickerController = [[UIImagePickerController alloc] init];
        
        [_imagePickerController setDelegate:self];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            [_imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [_imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            
        } else {
            [_imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        
        [_imagePickerController setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeImage]];
        
    }
    
    return _imagePickerController;
}


-(void)presentImagePickerController:(BOOL)animated{
    
    [self.presentingViewController presentViewController:self.imagePickerController animated:animated completion:nil];
    
}

-(void)dismissImagePickerController:(BOOL)animated withCompletionHandler:(void(^)(void))completion{
    
    [self.imagePickerController dismissViewControllerAnimated:animated completion:completion];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    [self.delegate mediaPickerManager:self didFinishPickingImage:image];
}

@end
