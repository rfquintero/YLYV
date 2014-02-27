#import <Foundation/Foundation.h>

@protocol BYCImagePickerControllerDelegate <NSObject>
-(void)imagePickerSelected:(UIImage*)image;
-(void)imagePickerRemoveSelected;
@end

@interface BYCImagePickerController : NSObject
-(id)initWithDelegate:(id<BYCImagePickerControllerDelegate>)delegate presentingVC:(UIViewController*)vc;
-(void)chooseImage:(UIView*)view existing:(BOOL)existing;
-(void)dismissAllAnimated:(BOOL)animated;
@end