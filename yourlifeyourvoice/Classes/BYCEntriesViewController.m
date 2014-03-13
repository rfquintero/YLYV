#import "BYCEntriesViewController.h"
#import "BYCEntriesModel.h"
#import "BYCEntriesView.h"
#import "BYCEntryDetailsViewController.h"

@interface BYCEntriesViewController ()<BYCEntriesViewDelegate>
@property (nonatomic) BYCEntriesModel *model;
@property (nonatomic) BYCEntriesView *entryView;
@end

@implementation BYCEntriesViewController

-(void)loadView {
    [super loadView];
    
    self.model = [[BYCEntriesModel alloc] initWithDatabase:self.applicationState.database queue:self.applicationState.queue];

    self.entryView = [[BYCEntriesView alloc] initWithFrame:self.view.bounds];
    self.entryView.delegate = self;
 
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"My Moods"];
    self.screenName = @"My Moods";
    [self setupMenuButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entriesRefreshed) name:BYCEntriesModelRefreshed object:self.model];
    if(self.model.entries.count == 0) {
        [self.model nextPage];
    } else {
        [self entriesRefreshed];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)entriesRefreshed {
    [self.entryView setEntries:self.model.entries hasMore:self.model.hasMore];
}

-(void)entrySelected:(BYCEntry *)entry {
    BYCEntryDetailsViewController *vc = [[BYCEntryDetailsViewController alloc] initWithApplicationState:self.applicationState];
    vc.entry = entry;
    vc.entriesModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loadMore {
    [self.model nextPage];
}

@end
