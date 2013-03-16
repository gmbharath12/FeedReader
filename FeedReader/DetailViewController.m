//
//  DetailViewController.m
//  FeedReader
//
//  Created by Bharath G M on 3/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize m_cDetailViewObject,m_cContent;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableAttributedString *lattributedString = [[NSMutableAttributedString alloc] initWithString:m_cDetailViewObject.m_cContent];
    [lattributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 16)];
    m_cContenView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 280, 300)];
    [m_cContenView setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
    [m_cContenView setUserInteractionEnabled:YES];
    m_cContenView.editable = NO;
    m_cContenView.attributedText = lattributedString;
    [self.view addSubview:m_cContenView];
    self.view.backgroundColor = [UIColor whiteColor];
    [[[self view] layer] setCornerRadius:4.0];
    m_cDetails = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 280, 80)];
    [m_cDetails setText:[NSString stringWithFormat:@"Title : %@ \n Email : %@ \n Author : %@ \n Published date : %@",m_cDetailViewObject.m_cTitle,m_cDetailViewObject.m_cEmail,m_cDetailViewObject.m_cAuthorName,m_cDetailViewObject.m_cPublishedDate]];
    m_cDetails.editable = NO;
    [self.view addSubview:m_cDetails];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
