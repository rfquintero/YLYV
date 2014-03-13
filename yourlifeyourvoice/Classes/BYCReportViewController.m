#import "BYCReportViewController.h"
#import "BYCReportModel.h"
#import "BYCReportView.h"

@interface BYCReportViewController ()<BYCReportViewDelegate>
@property (nonatomic) BYCReportModel *model;
@property (nonatomic) BYCReportView *entryView;
@end

@implementation BYCReportViewController

-(void)loadView {
    [super loadView];
    self.model = [[BYCReportModel alloc] initWithDatabase:self.applicationState.database queue:self.applicationState.queue];
    
    self.entryView = [[BYCReportView alloc] initWithFrame:self.view.bounds];
    self.entryView.delegate = self;
    
    [self.navView setContentView:self.entryView];
    [self.navView setNavTitle:@"Reports"];
    self.screenName = @"Reports";
    [self setupMenuButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculationFinished) name:BYCReportModelFinished object:self.model];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated {
    if(self.model.totalCount == 0) {
        [self.model calculate];
    }
}

-(void)calculationFinished {
    [self.entryView setRecentCount:self.model.recentCount allCount:self.model.totalCount];
    [self recentSelected];
}

-(void)recentSelected {
    [self.entryView setReportItems:self.model.recentEntries recent:YES];
}

-(void)allSelected {
    [self.entryView setReportItems:self.model.allEntries recent:NO];
}

-(void)sidebarShown:(BOOL)shown animated:(BOOL)animated {
    [super sidebarShown:shown animated:animated];
    [self.entryView setBottomBarFaded:shown animated:animated];
}

@end
