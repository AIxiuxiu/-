//
//  ZZVaccinationTimeVC.m
//  萌宝派
//
//  Created by zhizhen on 15-3-24.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZVaccinationTimeVC.h"

@interface ZZVaccinationTimeVC ()
@property(nonatomic,strong)UIScrollView*   vaccScrollView;
@end

@implementation ZZVaccinationTimeVC
#pragma mark  lazy

#pragma mark  life  cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"疫苗接种";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self  initVaccinationInterface];
    // Do any additional setup after loading the view.
}
-(void)initVaccinationInterface{
    
    CGFloat  scrViewW = ScreenWidth ;
    CGFloat  scrViewH = ScreenHeight;
   //创建scrollview
    self.vaccScrollView = [[UIScrollView  alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, scrViewH)];
    CGFloat  margin = 10;
    CGFloat  separSpace = 5;
    CGSize size = CGSizeMake(ScreenWidth-20, 2000);
    
      CGFloat  x = ZZLRmargin;
    CGFloat y = 0;
    //第一部分文字
    NSString  *textOne = @"Part1：计划内疫苗\n\t计划内疫苗（一类疫苗）是国家规定纳入计划免疫，属于免费疫苗，是从宝宝出生后必须进行接种的。计划免疫包括两个程序：一个是全程足量的基础免疫，即在1周岁内完成的初次接种；二是以后的加强免疫，即根据疫苗的免疫持久性及人群的免疫水平和疾病流行情况适时地进行复种。";
    UILabel*  partOneLabel = [[UILabel  alloc]init];
    partOneLabel.font = ZZContentFont;
    partOneLabel.textColor = ZZLightGrayColor;
    partOneLabel.numberOfLines = 0;
    partOneLabel.attributedText = [partOneLabel  getAttributedStringWithText:textOne paragraphSpacing:ZZParagraphSpace lineSpace:ZZLineSpace stringCharacterSpacing:ZZCharSpace textAlignment:NSTextAlignmentLeft font:partOneLabel.font color:partOneLabel.textColor];
    CGSize partOneLabelSize = [partOneLabel  sizeThatFits:size];
    
    partOneLabel.frame = (CGRect){{x,margin},partOneLabelSize};
    
    [self.vaccScrollView  addSubview:partOneLabel];
 //第一部分图片
    //尺寸
    CGFloat partOneIVH = 975;
    CGFloat partOneIVW = 300;
    CGFloat partOneIVY = CGRectGetMaxY(partOneLabel.frame)+separSpace;
    CGFloat partOneIVX = (scrViewW - partOneIVW)/2 ;
    
    UIImageView*  partOneImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(partOneIVX,partOneIVY, partOneIVW, partOneIVH)];
    partOneImageView.image =[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"vaccination_300x975.jpg" ofType:nil]];
    [self.vaccScrollView   addSubview:partOneImageView];
    
    
    //Part2
   NSString *partTwo = @"Part2：计划外疫苗\n\t除了国家规定宝宝必须接种的疫苗外，其它需要接种的疫苗都属于计划外疫苗（二类疫苗）。这些疫苗都是本着自费、自愿的原则，家长可以根据宝宝的实际需要有选择性地为其接种。";
    CGFloat partTwoY = CGRectGetMaxY(partOneImageView.frame) + margin +separSpace;
    
    UILabel*  partTwoLabel = [[UILabel  alloc]init];
    partTwoLabel.font = ZZContentFont;
    partTwoLabel.textColor = ZZLightGrayColor;
    partTwoLabel.numberOfLines=0;
    partTwoLabel.attributedText = [partTwoLabel  getAttributedStringWithText:partTwo paragraphSpacing:ZZParagraphSpace lineSpace:ZZLineSpace stringCharacterSpacing:ZZCharSpace textAlignment:NSTextAlignmentLeft font:partTwoLabel.font color:partTwoLabel.textColor];
    CGSize partTwoLabelSize = [partTwoLabel  sizeThatFits:size];
    
    partTwoLabel.frame = (CGRect){{x,partTwoY},partTwoLabelSize};
    [self.vaccScrollView  addSubview:partTwoLabel];
    //第2部分图片
    CGFloat partTwoIVH = 455;
    CGFloat partTwoIVW = 300;
    CGFloat partTwoIVY = CGRectGetMaxY(partTwoLabel.frame) + separSpace;
    CGFloat partTwoIVX = (scrViewW - partTwoIVW)/2 ;
    
    UIImageView*  partTwoImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(partTwoIVX,partTwoIVY,partTwoIVW,partTwoIVH)];
    partTwoImageView.image =[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"vaccination_other_300x455.jpg" ofType:nil]];
    [self.vaccScrollView  addSubview:partTwoImageView];
    
    //3
    NSString *partThree = @"接种注意事项\nQ：宝宝接种疫苗之前，家长应该做好哪些准备工作？\nA：接触疫苗前，家长做好准备工作很有必要，避免宝宝因发烧、腹泻等常见的呼吸道及消化道疾病而延期接种。准备工作包括：\n•	局部注射部位皮肤的清洁。\n•	饮食宜清淡，不要吃太油的食物。食量适中，预防腹泻、呕吐。\n•	不要到人多拥挤的场所，不要与有伤风感冒者接触，避免传染上疾病。睡眠时避免受凉，夏季不要吃冷饮等。\n•	已有疾病争取早日治愈。\n\nQ：宝宝打疫苗处出现硬结，会自行消失吗？\nA：接种卡介苗的部位所形成的小硬结一般不会消退，及时热敷也无效。由注射其它疫苗引起的硬结，只要加强热敷多数可以消失。下次再次注射疫苗时要避开硬结部位。\n\nQ：一般打完疫苗后医生会要求观察半小时，如果有不适这半小内就会发现吗？\nA：接种疫苗后要求观察半小时，就是要观察是否出现前面所讲的异常反应，尤其是对疫苗的过敏反应，这类反应绝大多数发生在接种疫苗后30分钟内。如果接种后没有别的事再延长一些时间也可以。\n\nQ：宝宝回老家几个月，又正好碰到疫苗接种日，请问在外地可以接种吗？还是必须回原来的医院接种？\nA：按理是可以在异地接种，但是需要带好预防接种手册，根据手册上登记记录的情况决定。国家有最低要求免费接种内容，但全国友协省市（如上海、北京、广东等）有地方的接种内容及顺序。当地卫生部门执行当地的规定，如果两者不一致时可能出现困难，所以异地是否接种还应尊重当地的意见。";
    CGFloat partThreeY = CGRectGetMaxY(partTwoImageView.frame) + margin +separSpace;
    
    UILabel*  partThreeLabel = [[UILabel  alloc]init];
    partThreeLabel.font = ZZContentFont;
    partThreeLabel.numberOfLines=0;
    partThreeLabel.textColor = ZZLightGrayColor;
    partThreeLabel.attributedText = [partThreeLabel  getAttributedStringWithText:partThree paragraphSpacing:ZZParagraphSpace lineSpace:ZZLineSpace stringCharacterSpacing:ZZCharSpace textAlignment:NSTextAlignmentLeft font:partThreeLabel.font color:partThreeLabel.textColor];
    CGSize partThreeLabelSize = [partThreeLabel  sizeThatFits:size];
    partThreeLabel.frame = (CGRect){{x,partThreeY},partThreeLabelSize};
    [self.vaccScrollView  addSubview:partThreeLabel];
    
    self.vaccScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(partThreeLabel.frame) + 2*y + CGRectGetMinY(self.vaccScrollView.frame)+margin);
    
    [self.view  addSubview:self.vaccScrollView];
}

@end
