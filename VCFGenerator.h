//
//  VCFGenerator.h
//  EasyContact
//
//  Created by dosonleung on 2/29/16.
//  Copyright © 2016 dosonleung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCFGenerator : NSObject
+ (NSString *)generateVCardStringWithContactID:(NSString *)contactID;

@end
