#import "BYCImagePickerController.h"

@interface BYCImagePickerController()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) BOOL hasCamera;
@property (nonatomic, weak) UIViewController *presenter;
@property (nonatomic, weak) id<BYCImagePickerControllerDelegate> delegate;
@end

@implementation BYCImagePickerController

-(id)initWithDelegate:(id<BYCImagePickerControllerDelegate>)delegate presentingVC:(UIViewController*)vc {
    if(self = [super init]) {
        self.presenter = vc;
        self.delegate = delegate;
        self.hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    }
    return self;
}

-(void)chooseImage:(UIView*)view existing:(BOOL)existing {
    NSString *destructive = existing ? @"Remove Photo" : nil;
    if(self.hasCamera) {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructive
                                              otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    } else {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructive
                                              otherButtonTitles:@"Choose Existing", nil];
    }
    [self.actionSheet showInView:view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == actionSheet.destructiveButtonIndex) {
        [self.delegate imagePickerRemoveSelected];
    } else if(buttonIndex != actionSheet.cancelButtonIndex) {
        NSInteger source;
        if(self.hasCamera) {
            source = buttonIndex == actionSheet.firstOtherButtonIndex ? UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            source = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:source];
        [imagePicker setDelegate:self];
        [imagePicker setAllowsEditing:YES];
        [self.presenter presentViewController:imagePicker animated:YES completion:^{ }];
    }
    self.actionSheet = nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.delegate imagePickerSelected:image];
}

-(void)dismissAllAnimated:(BOOL)animated {
    [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
}


@end
