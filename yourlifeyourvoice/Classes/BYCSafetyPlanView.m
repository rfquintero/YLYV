#import "BYCSafetyPlanView.h"
#import "BYCAccordionView.h"
#import "BYCUI.h"

@interface BYCSafetyPlanView()<BYCAccordionViewDelegate>
@property (nonatomic) UILabel *title;
@property (nonatomic) UIView *separator;
@property (nonatomic) UILabel* instructions;
@property (nonatomic) BYCAccordionView *about;
@property (nonatomic) BYCAccordionView *creating;
@property (nonatomic) BYCAccordionView *use;
@property (nonatomic) UIButton *email;
@property (nonatomic) UIButton *example;
@end

@implementation BYCSafetyPlanView

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor bgLightGray];
        
        self.title = [BYCUI labelWithFont:[UIFont boldSystemFontOfSize:18.0f]];
        self.title.text = @"Creating a Safety Plan";
        
        self.separator = [[UIView alloc] initWithFrame:CGRectZero];
        self.separator.backgroundColor = [UIColor bgSidebarGray];
        
        self.instructions = [BYCUI labelWithFont:[UIFont systemFontOfSize:14.0f]];
        self.instructions.numberOfLines = 0;
        self.instructions.text = @"Click the button below to email a blank version of the Safety Plan to yourself. Then fill it out on a computer to save and share it with someone else. You might even find it helpful to store a copy of your Safety Plan in your phone.";
        
        self.about = [self accordionWithTitle:@"What is a Safety Plan?" text:@"A Safety Plan is a personal list of strategies that can help you cope with life’s challenges and the negative emotions that may come with them. If you’ve been logging your moods over time and start to notice a trend of feeling anxious, sad, overwhelmed, or even invisible, a Safety Plan can help you identify the source of those feelings and outlines steps you can take to handle them without letting them take control over your life."];
        
        self.creating = [self accordionWithTitle:@"How is a Safety Plan created?" text:@"The first step in creating your safety plan is to think about and write down the situations, people, or places that most often make you feel down. Then, think about the things that make you feel good. Afterwards, reflect and record your most favorite activities, places, or belongings that help you feel better when you’re feeling anxious, sad, overwhelmed, or depressed. Your Safety Plan should also include a list of resources and people who you know will support you no matter what like a family member, friend, school counselor, teacher or YourLifeYourVoice."];
        
        self.use = [self accordionWithTitle:@"How can a Safety Plan be used?" text:@"It is best to create your Safety Plan before you are in a crisis so you are prepared to deal with stressful situations in a safe and healthy way. Your plan is uniquely yours, and should help you to identify personal strategies and support networks that can help you cope. You may also find that things change over time, so don’t hesitate to update it regularly. Overall, you can think of your Safety Plan like a roadmap to staying safe and emotionally healthy during difficult times, especially if you feel like taking a path towards harming yourself."];
        
        self.email = [BYCUI standardButtonWithTitle:@"EMAIL" target:self action:@selector(emailSelected)];
        self.example = [BYCUI standardButtonWithTitle:@"EXAMPLE SAFETY PLAN" target:self action:@selector(exampleSelected)];
        
        [self.scrollView addSubview:self.title];
        [self.scrollView addSubview:self.about];
        [self.scrollView addSubview:self.creating];
        [self.scrollView addSubview:self.use];
        [self.scrollView addSubview:self.separator];
        [self.scrollView addSubview:self.instructions];
        [self.scrollView addSubview:self.email];
        [self.scrollView addSubview:self.example];
    }
    return self;
}

-(BYCAccordionView*)accordionWithTitle:(NSString*)title text:(NSString*)text {
    BYCAccordionView *view = [[BYCAccordionView alloc] initWithFrame:CGRectZero];
    [view setTitle:title text:text];
    [view setDelegate:self];
    return view;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat padding = 15;
    CGFloat spacing = 10;
    CGSize size = CGSizeMake(width-2*padding, CGFLOAT_MAX);
    
    [self.title centerHorizonallyAtY:padding inBounds:self.bounds thatFits:CGSizeUnbounded];
    [self.about setFrameAtOrigin:CGPointMake(padding, CGRectGetMaxY(self.title.frame)+spacing) thatFits:size];
    [self.creating setFrameAtOrigin:CGPointMake(padding, CGRectGetMaxY(self.about.frame)+spacing) thatFits:size];
    [self.use setFrameAtOrigin:CGPointMake(padding, CGRectGetMaxY(self.creating.frame)+spacing) thatFits:size];
    
    self.separator.frame = CGRectMake(padding, CGRectGetMaxY(self.use.frame)+spacing, width-2*padding, 1);
    [self.instructions setFrameAtOrigin:CGPointMake(padding, CGRectGetMaxY(self.separator.frame)+spacing) thatFits:size];
    
    CGSize buttonSize = CGSizeMake(width-2*padding, [self.email sizeThatFits:size].height);
    self.email.frame = CGRectMake(padding, CGRectGetMaxY(self.instructions.frame)+spacing, buttonSize.width, buttonSize.height);
    self.example.frame = CGRectMake(padding, CGRectGetMaxY(self.email.frame)+spacing, buttonSize.width, buttonSize.height);
    
    [self setContentHeight:CGRectGetMaxY(self.example.frame)+padding];
}

- (void)accordionView:(BYCAccordionView *)view tappedWhenShowing:(BOOL)showing {
    [view setShowing:!showing animated:YES];
    [UIView animateWithDuration:0.2f animations:^{
        [self layoutSubviews];
    }];
}

-(void)emailSelected {
    [self.delegate emailSelected];
}

-(void)exampleSelected {
    [self.delegate exampleSelected];
}

@end
