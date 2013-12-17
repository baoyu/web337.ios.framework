//
//  ElxUser.m
//  web337
//
//  Created by elex on 13-8-23.
//  Copyright (c) 2013年 elex. All rights reserved.
//

#import "ElxUser.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface ElxUser () <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (NSArray *)propertyKeys;

@end

@implementation ElxUser

-(id)init {
    if ((self = [super init])) {
        return self;
    }
    return nil;
}
- (NSString *)description {
    NSString *type = nil;
    switch (self.type) {
        case ElxUser_337:
            type = @"337 User";
            break;
        case ElxUser_FACEBOOK:
            type = @"Facebook User";
            break;
        default:
            type = @"Unknown User Type";
            break;
    }
    
    return [NSString stringWithFormat: @"\n(%@){\n\tuid:%@\n\tnickname:%@\n\tusername:%@\n\temail:%@\n\tavatar:%@\n}",
            type,
            self.uid,
            self.nickname,
            self.username,
            self.email,
            self.avatar
    ];
}

-(id)initWithDict:(NSDictionary *)dict{
    if ((self = [super init])) {
        id uid = [dict objectForKey:@"uid"];
        id identify_id = [dict objectForKey:@"identify_id"];

        id username = [dict objectForKey:@"username"];
        
        id nickname = [dict objectForKey:@"nickname"];
        id gender = [dict objectForKey:@"gender"];
        id birthday = [dict objectForKey:@"birthday"];
        id avatar = [dict objectForKey:@"avatar"];
        
        id language = [dict objectForKey:@"language"];
        id loginkey = [dict objectForKey:@"loginkey"];

        id email = [dict objectForKey:@"email"];
        id emailverify = [dict objectForKey:@"emailverify"];

        id country = [dict objectForKey:@"country"];
        id phone = [dict objectForKey:@"phone"];
        id fromgame = [dict objectForKey:@"fromgame"];

        id level = [dict objectForKey:@"level"];
        id vip = [dict objectForKey:@"vip"];
        id vipendtime = [dict objectForKey:@"vipendtime"];
        
        id type = [dict objectForKey:@"type"];
        
        if (uid) {
            self.uid = [NSString stringWithFormat:@"%@",uid];
        }
        if (identify_id) {
            self.identify_id = [NSString stringWithFormat:@"%@",identify_id];
        }
        if (username) {
            self.username = [NSString stringWithFormat:@"%@",username];
        }
        if (nickname) {
            self.nickname = [NSString stringWithFormat:@"%@",nickname];
        }
        if (gender) {
            self.gender = [NSString stringWithFormat:@"%@",gender];
        }
        if (birthday) {
            self.birthday = [NSString stringWithFormat:@"%@",birthday];
        }
        if (avatar) {
            self.avatar = [NSString stringWithFormat:@"%@",avatar];
        }
        if (level) {
            self.level = [NSString stringWithFormat:@"%@",level];
        }
        if (language) {
            self.language = [NSString stringWithFormat:@"%@",language];
        }
        if (loginkey) {
            self.loginkey = [NSString stringWithFormat:@"%@",loginkey];
        }
        if (email) {
            self.email = [NSString stringWithFormat:@"%@",email];
        }
        if (emailverify) {
            self.emailverify = [NSString stringWithFormat:@"%@",emailverify];
        }
        if (country) {
            self.country = [NSString stringWithFormat:@"%@",country];
        }
        if (phone) {
            self.phone = [NSString stringWithFormat:@"%@",phone];
        }
        if (fromgame) {
            self.fromgame = [NSString stringWithFormat:@"%@",fromgame];
        }
        if (vip) {
            self.vip = [vip intValue];
        }
        if (vipendtime) {
            self.vipendtime = [vipendtime intValue];
        }
        
        if(type){
            //set to default user
            self.type = [type intValue];
        }else{
            //set to default user
            self.type = ElxUser_337;
        }

        return self;
    }
    return nil;
    
}

- (NSArray *)propertyKeys
{
    NSMutableArray *array = [NSMutableArray array];
    Class class = [self class];
    while (class != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (int i = 0; i < propertyCount; i++)
        {
            //get property
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            //check if read-only
            BOOL readonly = NO;
            const char *attributes = property_getAttributes(property);
            NSString *encoding = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
            if ([[encoding componentsSeparatedByString:@","] containsObject:@"R"])
            {
                readonly = YES;
                
                //see if there is a backing ivar with a KVC-compliant name
                NSRange iVarRange = [encoding rangeOfString:@",V"];
                if (iVarRange.location != NSNotFound)
                {
                    NSString *iVarName = [encoding substringFromIndex:iVarRange.location + 2];
                    if ([iVarName isEqualToString:key] ||
                        [iVarName isEqualToString:[@"_" stringByAppendingString:key]])
                    {
                        //setValue:forKey: will still work
                        readonly = NO;
                    }
                }
            }
            
            if (!readonly)
            {
                //exclude read-only properties
                [array addObject:key];
            }
        }
        free(properties);
        class = [class superclass];
    }
    return array;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init]))
    {
        for (NSString *key in [self propertyKeys])
        {
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [self propertyKeys])
    {
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

-(void)dealloc {
    [_uid release];
    [_identify_id release];
    [_username release];
    [_nickname release];
    [_gender release];
    [_birthday release];
    [_avatar release];
    [_level release];
    [_language release];
    [_loginkey release];
    [_email release];
    [_emailverify release];
    [_country release];
    [_phone release];
    [_fromgame release];
    [super dealloc];
}


@end
