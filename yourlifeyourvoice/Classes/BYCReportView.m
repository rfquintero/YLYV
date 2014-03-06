#import "BYCReportView.h"
#import "BYCReportBar.h"
#import "BYCUI.h"
#import "BYCReportModel.h"
#import "BYCNavigationView.h"

@interface BYCReportView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *bottomBar;
@property (nonatomic) UIButton *recentButton;
@property (nonatomic) UIButton *allButton;
@property (nonatomic) NSArray *items;
@property (nonatomic) BOOL recent;
@property (nonatomic, weak) id<BYCReportViewDelegate> delegate;
@end

@implementation BYCReportView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60.0f;
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.backgroundColor = [UIColor bgLightGray];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, [BYCNavigationView navbarHeight])];
        
        self.bottomBar = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomBar.backgroundColor = [UIColor bgSidebarGray];
        
        self.recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.recentButton.titleLabel setFont:[BYCUI roundFontOfSize:16.0f]];
        [self.recentButton addTarget:self action:@selector(recentSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.allButton.titleLabel setFont:[BYCUI roundFontOfSize:16.0f]];
        [self.allButton addTarget:self action:@selector(allSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomBar addSubview:self.recentButton];
        [self.bottomBar addSubview:self.allButton];
        [self addSubview:self.bottomBar];
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat barHeight = 60;
    
    self.tableView.frame = CGRectMake(0, 0, width, self.bottomBar.hidden ? height : height-barHeight);
    
    self.bottomBar.frame = CGRectMake(0, height-barHeight, width, barHeight);
    self.recentButton.frame = CGRectMake(0, 0, width/2, barHeight);
    self.allButton.frame = CGRectMake(width/2, 0, width/2, barHeight);
}

-(void)setRecentCount:(NSUInteger)count allCount:(NSUInteger)allCount {
    [self.recentButton setTitle:[NSString stringWithFormat:@"recent (%@)", [BYCUI formatNumber:@(count)]] forState:UIControlStateNormal];
    [self.allButton setTitle:[NSString stringWithFormat:@"view all (%@)", [BYCUI formatNumber:@(allCount)]] forState:UIControlStateNormal];
    self.bottomBar.hidden = (count == allCount);
}

-(void)setReportItems:(NSArray*)items recent:(BOOL)recent {
    _recent = recent;
    _items = items;
    [self.recentButton setTitleColor:(recent ? [UIColor textOrange] : [UIColor whiteColor]) forState:UIControlStateNormal];
    [self.allButton setTitleColor:(recent ? [UIColor whiteColor] : [UIColor textOrange]) forState:UIControlStateNormal];
    [self setNeedsLayout];
    [self.tableView reloadData];
    
    CGFloat delay = 0.2f;
    for(BYCReportBar *bar in self.tableView.visibleCells) {
        [bar animateWithDelay:delay];
        delay += 0.1f;
    }
}

-(void)setBottomBarFaded:(BOOL)faded animated:(BOOL)animated {
    if(animated) {
        self.bottomBar.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.bottomBar.alpha = faded ? 0.5f : 1.0f;
        }];
    } else {
        self.bottomBar.alpha = faded ? 0.5f : 1.0f;
    }
}

-(void)recentSelected {
    if(!self.recent) {
        [self.delegate recentSelected];
    }
}

-(void)allSelected {
    if(self.recent) {
        [self.delegate allSelected];
    }
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = @"BYCReportCell";
    BYCReportBar *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if(!cell) {
        cell = [[BYCReportBar alloc] initWithReuseIdentifier:identifer];
    }
    
    BYCReportItem *item = self.items[indexPath.row];
    [cell setMoodType:item.type count:item.count percent:item.percent];
    return cell;
}

@end
