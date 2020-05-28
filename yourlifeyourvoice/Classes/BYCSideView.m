#import "BYCSideView.h"
#import "BYCUI.h"
#import "BYCSideViewCell.h"
#import "BYCConstants.h"
#import "BYCNavigationView.h"

@interface BYCSideView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *items;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) BYCSideViewItem selectedItem;
@property (nonatomic, weak) id<BYCSideViewDelegate> delegate;
@end

@implementation BYCSideView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor bgSidebarGray];
        
        self.items = @[@(BYCSideView_Entry), @(BYCSideView_Moods), @(BYCSideView_Reports), @(BYCSideView_Reminders), @(BYCSideView_Tips), @(BYCSideView_SafetyPlan), @(BYCSideView_Talk), @(BYCSideView_Info)];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = YES;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundView = nil;
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton addTarget:self action:@selector(closeSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.closeButton setImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
        [self.closeButton setContentEdgeInsets:UIEdgeInsetsMake(2, 6, 2, 6)];
        
        [self addSubview:self.tableView];
        [self addSubview:self.closeButton];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offsetY = [BYCNavigationView navbarHeight];
    [self.closeButton setFrameAtOriginThatFitsUnbounded:CGPointMake(10, 2+[BYCNavigationView navbarInset])];
    self.tableView.frame = CGRectMake(0, offsetY, self.bounds.size.width, self.bounds.size.height-offsetY);
}

-(void)closeSelected {
    [self.delegate hideSidebar];
}

-(void)setSelectedMenuItem:(BYCSideViewItem)item {
    _selectedItem = item;
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYCSideViewItem item = [self.items[indexPath.row] intValue];
    return [BYCSideViewCell heightForCellWithWidth:tableView.bounds.size.width text:[self titleForItem:item]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BYCSideViewCell";
    BYCSideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[BYCSideViewCell alloc] initWithReuseIdentifier:identifier];
    }
    BYCSideViewItem item = [self.items[indexPath.row] intValue];
    [cell setTitleText:[self titleForItem:item]];
    [cell setCellSelected:item == self.selectedItem];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BYCSideViewItem item = [self.items[indexPath.row] intValue];
    switch(item) {
        case BYCSideView_Entry:
            [self.delegate entrySelected];
            break;
        case BYCSideView_Moods:
            [self.delegate moodsSelected];
            break;
        case BYCSideView_Reports:
            [self.delegate reportsSelected];
            break;
        case BYCSideView_Reminders:
            [self.delegate reminderSelected];
            break;
        case BYCSideView_Tips:
            [self.delegate tipsSelected];
            break;
        case BYCSideView_Talk:
            [self.delegate talkSelected];
            break;
        case BYCSideView_Info:
            [self.delegate infoSelected];
            break;
        case BYCSideView_SafetyPlan:
            [self.delegate safetyPlanSelected];
        default:
            break;
    }
    if(item != self.selectedItem) {
        NSUInteger index = [self.items indexOfObject:@(self.selectedItem)];
        NSArray *paths = @[[NSIndexPath indexPathForRow:index inSection:0], indexPath];
        self.selectedItem = item;
        [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(NSString*)titleForItem:(BYCSideViewItem)item {
    switch(item) {
        case BYCSideView_Entry:
            return @"I'm feeling...";
        case BYCSideView_Moods:
            return @"My Moods";
        case BYCSideView_Reports:
            return @"Reports";
        case BYCSideView_Reminders:
            return @"Reminders";
        case BYCSideView_Tips:
            return @"Life Tips";
        case BYCSideView_Talk:
            return @"Talk";
        case BYCSideView_Info:
            return @"YourLife YourVoice";
        case BYCSideView_SafetyPlan:
            return @"Safety Plan";
    }
}

@end
