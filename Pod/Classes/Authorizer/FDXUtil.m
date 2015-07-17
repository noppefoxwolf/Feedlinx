//
//  FDXUtil.m
//  FDXOauth2Client
//
//  Created by Tomoya_Hirano on 7/16/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import "FDXUtil.h"

@implementation NSURL(Extention)
-(NSDictionary *) dictionaryFromQueryString{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSRange range = [pair rangeOfString:@"="];
        NSString *key = range.length ? [pair substringToIndex:range.location] : pair;
        NSString *val = range.length ? [pair substringFromIndex:range.location+1] : @"";
        key = [key stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        val = [val stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        val = [val stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end

@implementation NSDictionary (Extention)
- (NSDictionary*)encodeValues{
    NSCharacterSet* chars = [NSCharacterSet alphanumericCharacterSet];
    NSMutableDictionary*result = [NSMutableDictionary dictionary];
    for (NSString*key in self.allKeys) {
        [result setObject:[self[key] stringByAddingPercentEncodingWithAllowedCharacters:chars] forKey:key];
    }
    return result;
}
@end