//
//  DetailViewController.h
//  FeedReader
//
//  Created by Bharath G M on 3/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolsticeObject.h"

@interface DetailViewController : UIViewController
{
    SolsticeObject *m_cDetailViewObject;
    NSString *m_cContent;
    UITextView *m_cContenView;
    UITextView *m_cDetails;
    
}
@property (nonatomic,strong)  SolsticeObject *m_cDetailViewObject;
@property (nonatomic,strong)    NSString *m_cContent;

@end
