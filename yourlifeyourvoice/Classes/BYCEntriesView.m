#import "BYCEntriesView.h"
#import "BYCEntriesCell.h"
#import "BYCUI.h"

@interface BYCEntriesView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *entries;
@property (nonatomic) BOOL loadingMore;
@property (nonatomic, weak) id<BYCEntriesViewDelegate> delegate;
@end

@implementation BYCEntriesView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 70.0f;
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.backgroundColor = [UIColor bgLightGray];
        [BYCUI setContentInsets:self.tableView];
        
        
        self.loadingMore = YES;
        
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

-(void)setEntries:(NSArray*)entries hasMore:(BOOL)hasMore {
    _loadingMore = !hasMore;
    _entries = entries;
    [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if(!self.loadingMore && offsetY > (scrollView.contentSize.height-scrollView.frame.size.height-self.tableView.rowHeight)) {
        self.loadingMore = YES;
        [self.delegate loadMore];
    }
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entries.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BYCEntriesViewCell";
    BYCEntriesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[BYCEntriesCell alloc] initWithReuseIdentifier:identifier];
    }
    
    [cell setEntry:self.entries[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate entrySelected:self.entries[indexPath.row]];
}

@end
