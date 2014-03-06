#import "BYCSideView.h"
#import "BYCUI.h"
#import "BYCSideViewCell.h"
#import "BYCConstants.h"

@interface BYCSideView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *items;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) NSUInteger selectedIndex;
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
    CGFloat extra = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 20 : 0;
    CGFloat offsetY = 44 + extra;
    [self.closeButton setFrameAtOriginThatFitsUnbounded:CGPointMake(10, 2+extra)];
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
    [cell setCellSelected:indexPath.row == self.selectedIndex];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row) {
        case 0:
            [self.delegate entrySelected];
            break;
        case 1:
            [self.delegate moodsSelected];
            break;
        case 2:
            [self.delegate reportsSelected];
            break;
        case 5:
            [self.delegate talkSelected];
            break;
        default:
            break;
    }
    if(indexPath.row != self.selectedIndex) {
        NSArray *paths = @[[NSIndexPath indexPathForRow:self.selectedIndex inSection:0], indexPath];
        self.selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end