#import "BYCActionView.h"
#import "BYCUI.h"
#import "BYCSideViewCell.h"

@interface BYCActionViewItem : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger tag;
@end

@implementation BYCActionViewItem
@end

@interface BYCActionView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *items;
@property (nonatomic, weak) id<BYCActionViewDelegate> delegate;
@end

@implementation BYCActionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor bgSidebarGray];
        
        self.items = [NSMutableArray array];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)addTitle:(NSString *)title withTag:(NSInteger)tag {
    BYCActionViewItem *item = [[BYCActionViewItem alloc] init];
    item.title = title;
    item.tag = tag;
    [self.items addObject:item];
    [self.tableView reloadData];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offsetY = 20;
    self.tableView.frame = CGRectMake(0, offsetY, self.bounds.size.width, self.bounds.size.height-offsetY);
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYCActionViewItem *item = self.items[indexPath.row];
    return [BYCSideViewCell heightForCellWithWidth:tableView.bounds.size.width text:item.title];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BYCActionViewCell";
    BYCSideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[BYCSideViewCell alloc] initWithReuseIdentifier:identifier];
    }
    BYCActionViewItem *item = self.items[indexPath.row];
    
    [cell setTitleText:item.title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BYCActionViewItem *item = self.items[indexPath.row];
    [self.delegate actionSelectedWithTag:item.tag];
}

@end