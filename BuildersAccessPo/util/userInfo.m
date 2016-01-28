//
//  userInfo.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-7.
//  Copyright (c) 2012年 april. All rights reserved.
//

#import "userInfo.h"

static NSString *userPwd;
static NSString *userName;
static NSString *ciaName;
static NSString *userNameserver;
static int ciaId=0;

@implementation userInfo

+(void)setUserName:(NSString *)name andPwd:(NSString *)pwd{
    userName=name;
    userPwd=pwd;
}

+(void)initCiaInfo:(int)_ciaid andNm:(NSString *)ciaNm{
    ciaId=_ciaid;
    ciaName=ciaNm;
//    ciaId=[[NSString alloc] init];
//    ciaId=[NSString stringWithFormat:@"%d", _ciaid];
    
}


+(void)initUsernameServer:(NSString *)nm{
    userNameserver=nm;
}
+(NSString *)getUserNameService{
    return userNameserver;
}

+(NSString *)getUserName{
    return userName;
}

+(NSString *)getUserPwd{
    return userPwd;
}

+(int)getCiaId{
    return ciaId;
}

+(NSString *)getCiaName{
    return  ciaName;
}

@end
