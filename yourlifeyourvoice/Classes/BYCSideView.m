#import "BYCSideView.h"
#import "BYCUI.h"
#import "BYCSideViewCell.h"

@interface BYCSideView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *items;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic, weak) id<BYCSideViewDelegate> delegate;
@end

@implementation BYCSideView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor bgSidebarGray];
        
        self.items = @[@"I'm feeling...", @"My Moods", @"Reports", @"Reminders", @"Life Tips", @"Talk", @"YourLife YourVoice"];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
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
    CGFloat offsetY = 44;
    [self.closeButton setFrameAtOriginThatFitsUnbounded:CGPointMake(10, 2)];
    self.tableView.frame = CGRectMake(0, offsetY, self.bounds.size.width, self.bounds.size.height-offsetY);
}

-(void)closeSelected {
    [self.delegate hideSidebar];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BYCSideViewCell heightForCellWithWidth:tableView.bounds.size.width text:self.items[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BYCSideViewCell";
    BYCSideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[BYCSideViewCell alloc] initWithReuseIdentifier:identifier];
    }
    [cell setTitleText:self.items[indexPath.row]];
    [cell setCellSelected:indexPath.row == 0];
    return cell;
}

@end