//
//  SolsticeObject.h
//  FeedReader
//
//  Created by Bharath G M on 3/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SolsticeObject : NSObject
{
    NSString *m_cTitle;
    NSString *m_cContent;
    NSString *m_cPublishedDate;
    NSString *m_cAuthorName;
    NSString *m_cEmail;
    NSString *m_cImageSource;
}

@property (nonatomic,strong)    NSString *m_cTitle;
@property (nonatomic,strong)    NSString *m_cContent;
@property (nonatomic,strong)    NSString *m_cPublishedDate;
@property (nonatomic,strong)    NSString *m_cAuthorName;
@property (nonatomic,strong)    NSString *m_cEmail;
@property (nonatomic,strong)    NSString *m_cImageSource;
@end
