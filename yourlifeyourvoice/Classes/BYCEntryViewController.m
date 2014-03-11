#import "BYCEntryViewController.h"
#import "BYCEntryView.h"
#import "BYCImagePickerController.h"
#import "BYCAddReasonsViewController.h"
#import "BYCAddAudioViewController.h"
#import "BYCEntryModel.h"

#define kDeleteAlert 122

@interface BYCEntryViewController ()<BYCEntryViewDelegate, BYCImagePickerControllerDelegate>
@property (nonatomic) BYCEntryModel *model;
@property (nonatomic) BYCEntryView *entryView;
@property (nonatomic) BYCImagePickerController *imagePicker;
@end

@implementation BYCEntryViewController

-(void)loadView {
    [super loadView];
    
    self.model = [[BYCEntryModel alloc] initWithDatabase:self.applicationState.database queue:self.applicationState.queue];
    
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackError) name:BYCEntryModelPlaybackError object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStopped) name:BYCEntryModelPlaybackStopped object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSuccessful) name:BYCEntryModelSaveSuccessful object:self.model];
    [self refreshView];
    self.entryView.animating = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.entryView.animating = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.applicationState.database isFirstLaunch]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DISCLAIMER" message:@"You might be entering some personal information in this app. For your own privacy you might want to consider updating the security settings on your device." delegate:nil cancelButtonTitle:@"I Understand" otherButtonTitles:nil];
        [alert show];
        [self.applicationState.database setLaunched];
    }
}

-(void)refreshView {
    self.entryView.image = self.model.image;
    self.entryView.reasons = self.model.reasons;
    self.entryView.audioDuration = self.model.recordingDuration;
    self.entryView.speakerMode = self.model.speakerMode;
}

#pragma mark BYCEntryViewDelegate

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
    [self.model save];
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
    [self.entryView setSpeakerMode:self.model.speakerMode];
}

-(void)typeSelected:(BYCMoodType)type {
    self.model.type = type;
}

-(void)noteChanged:(NSString*)note {
    self.model.note = note;
}

-(void)deleteSelected {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete this entry?" message:@"Are you sure you want to delete this entry?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes, delete it.", nil];
    alert.tag = kDeleteAlert;
    [alert show];
}

-(void)deleteEntry {
    [self.entryView discardEntry];
    [self.navView setNavTitleHidden:NO animated:YES];
    [self.navView setLeftButtonHidden:YES animated:YES];
    [self.model reset];
    [self refreshView];
}

-(void)entryStarted {
    [self.navView setLeftButtonHidden:NO animated:YES];
    [self.navView setNavTitleHidden:YES animated:YES];
}

-(void)backSelected {
    [self deleteEntry];
}

-(void)setNavActive:(BOOL)active {
    [self.navView setButtonsAcive:active];
}

#pragma mark BYCEntrySavedViewDelegate {

-(void)cancelSelected {
    [self deleteEntry];
}

-(void)reminderSelected {
    [self showViewController:BYCNotificationShowRootController_Reminder];
}

-(void)talkSelected {
    [self showViewController:BYCNotificationShowRootController_Talk];
}

-(void)reportSelected {
    [self showViewController:BYCNotificationShowRootController_Reports];
}

-(void)infoSelected {
    [self showViewController:BYCNotificationShowRootController_Info];
}

-(void)tipsSelected {
    [self showViewController:BYCNotificationShowRootController_Tips];
}

-(void)callSelected {
    [self callYLYV];
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
    [self.entryView playbackStopped];
}

-(void)saveSuccessful {
    BOOL hasReminder = [self.applicationState.database getReminderTime].active;
    BYCMoodCategory category = [BYCMood categoryForMood:self.model.type];
    NSString *response = [BYCMood responseForCategory:category];
    
    [self.entryView setMoodCategory:category title:response moodString:[BYCMood moodString:self.model.type] hideReminders:hasReminder];
}

#pragma mark BYCImagePickerControllerDelegate

-(void)imagePickerSelected:(UIImage *)image {
    self.model.image = image;
    [self refreshView];
}

-(void)imagePickerRemoveSelected {
    self.model.image = nil;
    [self refreshView];
}

@end
