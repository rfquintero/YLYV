#import "BYCEntryDetailsViewController.h"
#import "BYCEntryModel.h"
#import "BYCEntryDetailsView.h"
#import "BYCImagePickerController.h"
#import "BYCAddReasonsViewController.h"
#import "BYCAddAudioViewController.h"

#define kDeleteAlert 1031

@interface BYCEntryDetailsViewController ()<BYCAddEntryViewDelegate, BYCImagePickerControllerDelegate>
@property (nonatomic) BYCEntryModel *model;
@property (nonatomic) BYCEntryDetailsView *entryView;
@property (nonatomic) BYCImagePickerController *imagePicker;
@end

@implementation BYCEntryDetailsViewController

-(void)loadView {
    [super loadView];
    self.model = [[BYCEntryModel alloc] initWithDatabase:self.applicationState.database queue:self.applicationState.queue];
    self.model.entry = self.entry;
    
    self.entryView = [[BYCEntryDetailsView alloc] initWithFrame:self.view.bounds type:self.entry.type];
    self.entryView.addEntry.delegate = self;
    self.entryView.navView = self.navView;
    self.entryView.addEntry.note = self.model.note;
    
    self.imagePicker = [[BYCImagePickerController alloc] initWithDelegate:self presentingVC:self.navigationController];
    
    [self.navView setContentView:self.entryView];
    [self.entryView setNavView:self.navView];
    [self.navView setupBackButton:self action:@selector(saveSelected)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackError) name:BYCEntryModelPlaybackError object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStopped) name:BYCEntryModelPlaybackStopped object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSuccessful) name:BYCEntryModelSaveSuccessful object:self.model];
    [self refreshView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshView {
    self.entryView.addEntry.image = self.model.image;
    self.entryView.addEntry.reasons = self.model.reasons;
    self.entryView.addEntry.audioDuration = self.model.recordingDuration;
    self.entryView.addEntry.speakerMode = self.model.speakerMode;
}

#pragma mark BYCAddEntryViewDelegate

-(void)photoSelected {
    [self.imagePicker chooseImage:self.view existing:(self.model.image != nil)];
}

-(void)becauseSelected {
    UIViewController *vc = [[BYCAddReasonsViewController alloc] initWithApplicationState:self.applicationState model:self.model];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)audioSelected {
    UIViewController *vc = [[BYCAddAudioViewController alloc] initWithApplicationState:self.applicationState model:self.model];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)saveSelected {
    [self.model update];
}

-(void)deleteSelected {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete this entry?" message:@"Are you sure you want to delete this entry?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes, delete it.", nil];
    alert.tag = kDeleteAlert;
    [alert show];
}

-(void)deleteEntry {
    [self.model deleteEntry];
    [self.entriesModel removeEntry:self.entry];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)playRecording {
    if(![self.model playRecording]) {
        [self playbackError];
    }
}

-(void)stopPlayback {
    [self.model stopPlayback];
    [self playbackStopped];
}

-(void)toggleSpeaker {
    [self.model useSpeaker:!self.model.speakerMode];
    [self.entryView.addEntry setSpeakerMode:self.model.speakerMode];
}

-(void)noteChanged:(NSString*)note {
    self.model.note = note;
}

-(void)offsetChanged:(CGFloat)percent {
    [self.entryView offsetChanged:percent];
}

-(void)setNavActive:(BOOL)active {
    [self.navView setButtonsAcive:active];
}

#pragma mark BYCImagePickerControllerDelegate
-(void)imagePickerSelected:(UIImage *)image {
    [self.model deleteImage];
    self.model.image = image;
    [self refreshView];
}

-(void)imagePickerRemoveSelected {
    [self.model deleteImage];
    self.model.image = nil;
    [self refreshView];
}

#pragma mark callbacks

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag == kDeleteAlert && buttonIndex != alertView.cancelButtonIndex) {
        [self deleteEntry];
    } else {
        [super alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}

-(void)playbackError {
    [self showError:@"Audio Error" message:@"An error occurred during playback."];
    [self playbackStopped];
}

-(void)playbackStopped {
    [self.entryView.addEntry playbackStopped];
}

-(void)saveSuccessful {
    [self.entriesModel updateEntry:self.entry with:self.model.updatedEntry];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ugly
-(void)reminderSelected {}
-(void)talkSelected {}
-(void)moodsSelected {}
-(void)infoSelected {}
-(void)cancelSelected {}
-(void)tipsSelected {}
-(void)callSelected {}

@end
