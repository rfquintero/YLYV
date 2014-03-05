#import "BYCEntriesViewController.h"
#import "BYCEntriesModel.h"
#import "BYCEntriesView.h"

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
    [self setupMenuButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entriesRefreshed) name:BYCEntriesModelRefreshed object:self.model];
    if(self.model.entries.count == 0) {
        [self.model nextPage];
    }
}

-(void)entriesRefreshed {
    [self.entryView setEntries:self.model.entries hasMore:self.model.hasMore];
}

-(void)entrySelected:(BYCEntry *)entry {
    
}

-(void)loadMore {
    [self.model nextPage];
}

@end
