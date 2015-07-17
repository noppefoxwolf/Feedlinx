//
//  FDXUtil.h
//  FDXOauth2Client
//
//  Created by Tomoya_Hirano on 7/16/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL(Extention)
- (NSDictionary *) dictionaryFromQueryString;
@end

@interface NSDictionary(Extention)
- (NSDictionary *)encodeValues;
@end
