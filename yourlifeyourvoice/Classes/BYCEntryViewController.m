#import "BYCEntryViewController.h"
#import "BYCEntryView.h"
#import "BYCImagePickerController.h"
#import "BYCEntryModel.h"

@interface BYCEntryViewController ()<BYCEntryViewDelegate, BYCImagePickerControllerDelegate>
@property (nonatomic) BYCEntryModel *model;
@property (nonatomic) BYCEntryView *entryView;
@property (nonatomic) BYCImagePickerController *imagePicker;
@end

@implementation BYCEntryViewController

-(void)loadView {
    [super loadView];
    
    self.model = [[BYCEntryModel alloc] init];
    
    self.entryView = [[BYCEntryView alloc] initWithFrame:self.view.bounds];
    self.entryView.delegate = self;
    
    self.imagePicker = [[BYCImagePickerController alloc] initWithDelegate:self presentingVC:self.navigationController];
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"I'm feeling..."];
    [self.navView setupBackButton:self action:@selector(backSelected)];
    [self.navView setLeftButtonHidden:YES animated:NO];
    [self.entryView setNavView:self.navView];
    [self setupMenuButton];
}

#pragma mark BYCEntryViewDelegate

-(void)photoSelected {
    [self.imagePicker chooseImage:self.view existing:(self.model.image != nil)];
}

-(void)becauseSelected {
    
}

-(void)audioSelected {
    
}

-(void)saveSelected {
    
}

-(void)noteChanged:(NSString*)note {
    self.model.note = note;
}

-(void)deleteSelected {
    [self.entryView discardEntry];
    [self.navView setNavTitleHidden:NO animated:YES];
    [self.navView setLeftButtonHidden:YES animated:YES];

}

-(void)entryStarted {
    [self.navView setLeftButtonHidden:NO animated:YES];
    [self.navView setNavTitleHidden:YES animated:YES];
}

-(void)backSelected {
    [self deleteSelected];
}

-(void)setNavActive:(BOOL)active {
    [self.navView setButtonsAcive:active];
}

#pragma mark BYCImagePickerControllerDelegate

-(void)imagePickerSelected:(UIImage *)image {
    self.model.image = self.entryView.image = image;
}

-(void)imagePickerRemoveSelected {
    self.model.image = self.entryView.image = nil;
}

@end
