#import "BYCAddReasonsView.h"
#import "BYCUI.h"
#import "BYCNavigationView.h"

@interface BYCAddReasonsView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *reasons;
@property (nonatomic) NSMutableSet *selectedReasons;
@property (nonatomic, weak) id<BYCAddReasonsViewDelegate> delegate;
@end

@implementation BYCAddReasonsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _reasons = @[@"Parents", @"Family", @"Friends", @"Relationship", @"Don't Know", @"School", @"Bully", @"Past",
                     @"Myself", @"Future", @"Job", @"Sister", @"Brother", @"Pet"];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 50.0f;
        self.tableView.backgroundColor = [UIColor bgLightGray];
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
        
        UIButton *clear = [BYCUI deleteButtonWithTarget:self action:@selector(clearSelected)];
        [clear setTitle:@"CLEAR" forState:UIControlStateNormal];
        [clear setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 20, 0)];
        [clear sizeToFit];
        self.tableView.tableFooterView = clear;
        
        self.selectedReasons = [NSMutableSet set];
        
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

-(void)setReasons:(NSArray *)reasons {
    [self.selectedReasons removeAllObjects];
    for(NSString* reason in reasons) {
        [self.selectedReasons addObject:reason];
    }
    [self.tableView reloadData];
}

-(void)clearSelected {
    for(NSString *reason in self.selectedReasons) {
        [self.delegate reasonRemoved:reason];
    }
    [self.selectedReasons removeAllObjects];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reasons.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BYCReasonsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [BYCUI roundFontOfSize:18.0f];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSString *reason = self.reasons[indexPath.row];
    cell.textLabel.text = reason;
    if([self.selectedReasons containsObject:reason]) {
        cell.textLabel.textColor = [UIColor textOrange];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *reason = self.reasons[indexPath.row];
    if([self.selectedReasons containsObject:reason]) {
        [self.selectedReasons removeObject:reason];
        [self.delegate reasonRemoved:reason];
    } else {
        [self.selectedReasons addObject:reason];
        [self.delegate reasonAdded:reason];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
