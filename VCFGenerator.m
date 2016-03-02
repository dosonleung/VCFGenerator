//
//  VCFGenerator.m
//  EasyContact
//
//  Created by dosonleung on 2/29/16.
//  Copyright © 2016 dosonleung. All rights reserved.
//

#import "VCFGenerator.h"
#import <ContactsUI/ContactsUI.h>

@implementation VCFGenerator

//
static NSInteger itemCounter;
+ (NSInteger)itemCounter { return  itemCounter; };
+ (void)setItemCounter:(NSInteger)value { itemCounter = value; };

//
+ (NSString *)generateVCardStringWithRecID:(NSString *)contactIdString
{
    if (contactIdString != nil) {
        NSString *vcard = [VCFGenerator generateVCardStringWithContactID:contactIdString];
        return vcard;
    }else{
        return @"";
    }
}

+ (NSString *)generateVCardStringWithContactID:(NSString *)contactID
{
    [VCFGenerator setItemCounter:0];
    NSString *vcard = @"BEGIN:VCARD\nVERSION:3.0\n";
    CNContactStore *stroe = [[CNContactStore alloc]init];
    id keysToFetch = @[[CNContactViewController descriptorForRequiredKeys]];
    CNContact *contact = [stroe unifiedContactWithIdentifier:contactID keysToFetch:keysToFetch error:nil];
    // Name
    vcard = [vcard stringByAppendingFormat:@"N:%@;%@;%@;%@;%@\n",
             ([contact isKeyAvailable:CNContactFamilyNameKey] ? contact.familyName : @""),
             ([contact isKeyAvailable:CNContactGivenNameKey] ? contact.givenName : @""),
             ([contact isKeyAvailable:CNContactMiddleNameKey] ? contact.middleName : @""),
             ([contact isKeyAvailable:CNContactNamePrefixKey] ? contact.namePrefix : @""),
             ([contact isKeyAvailable:CNContactNameSuffixKey] ? contact.nameSuffix : @"")
             ];
    vcard = [vcard stringByAppendingFormat:@"FN:%@%@%@\n",
             [contact isKeyAvailable:CNContactGivenNameKey] ? contact.givenName : @"" ,
             [contact isKeyAvailable:CNContactMiddleNameKey] ? contact.middleName : @"" ,
             [contact isKeyAvailable:CNContactFamilyNameKey] ? contact.familyName : @"" ];
    if([contact isKeyAvailable:CNContactNicknameKey]) vcard = [vcard stringByAppendingFormat:@"NICKNAME:%@\n",contact.nickname];
    if([contact isKeyAvailable:CNContactPhoneticGivenNameKey]) vcard = [vcard stringByAppendingFormat:@"X-PHONETIC-FIRST-NAME:%@\n",contact.phoneticGivenName];
    if([contact isKeyAvailable:CNContactPhoneticFamilyNameKey]) vcard = [vcard stringByAppendingFormat:@"X-PHONETIC-LAST-NAME:%@\n",contact.phoneticFamilyName];
    // Work
    if( [contact isKeyAvailable:CNContactOrganizationNameKey]) vcard = [vcard stringByAppendingFormat:@"ORG:%@;%@\n",contact.organizationName,[contact isKeyAvailable:CNContactDepartmentNameKey] ? contact.departmentName : @""];
    if([contact isKeyAvailable:@"jobTitle"]) vcard = [vcard stringByAppendingFormat:@"TITLE:%@\n",contact.jobTitle];
    // Mail
    if ([contact isKeyAvailable:CNContactEmailAddressesKey])
    vcard = [vcard stringByAppendingString:[VCFGenerator toVcardField:@"email" items:contact.emailAddresses]];
    
    // Tel
    if ([contact isKeyAvailable:CNContactPhoneNumbersKey])
    vcard = [vcard stringByAppendingString:[VCFGenerator toVcardField:@"phone" items:contact.phoneNumbers]];
    
    // Adress
    if ([contact isKeyAvailable:CNContactPostalAddressesKey])
    vcard = [vcard stringByAppendingString:[VCFGenerator toVcardField:@"address" items:contact.postalAddresses]];
    
    // url
    if ([contact isKeyAvailable:CNContactUrlAddressesKey])
    vcard = [vcard stringByAppendingString:[VCFGenerator toVcardField:@"url" items:contact.urlAddresses]];
    
    // IM
    if ([contact isKeyAvailable:CNContactInstantMessageAddressesKey])
    vcard = [vcard stringByAppendingString:[VCFGenerator toVcardField:@"im" items:contact.instantMessageAddresses]];
    
    // birthday
    if ([contact isKeyAvailable:CNContactBirthdayKey]){
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *birthday = [gregorian dateFromComponents:contact.birthday];
        if (birthday)
        {
            NSString *bday = [NSString stringWithFormat:@"%@",birthday];
            NSArray *bdayArr = [bday componentsSeparatedByString:@" "];
            bday = [bdayArr objectAtIndex:0];
            vcard = [vcard stringByAppendingFormat:@"BDAY;value=date:%@\n",bday];
        }
    }
    
    // Photo
    if ([contact isKeyAvailable:CNContactThumbnailImageDataKey]){
        NSData *imageData = contact.thumbnailImageData;//contact.imageData;
        if (imageData)
        {
            vcard = [vcard stringByAppendingFormat:@"PHOTO;BASE64:%@\n",[imageData base64Encoding]];
        }
    }
    
    // end
    vcard = [vcard stringByAppendingString:@"END:VCARD"];
    
    return vcard;
}

+ (NSString *)toVcardField:(NSString *)type items:(NSArray *)items
{
    if (!items)
    {
        return @"";
    }
    
    NSString *vcard = @"";
    
    if (items && [items count] > 0)
    {
        NSInteger len = [items count];
        for (int i = 0; i < len; i++)
        {
            if ([type isEqualToString:@"email"]) vcard = [vcard stringByAppendingString:[VCFGenerator emailToVcardField:[items objectAtIndex:i]]];
            else if ([type isEqualToString:@"phone"]) vcard = [vcard stringByAppendingString:[VCFGenerator phoneToVcardField:[items objectAtIndex:i]]];
            else if ([type isEqualToString:@"address"]) vcard = [vcard stringByAppendingString:[VCFGenerator addressToVcardField:[items objectAtIndex:i]]];
            else if ([type isEqualToString:@"url"]) vcard = [vcard stringByAppendingString:[VCFGenerator urlToVcardField:[items objectAtIndex:i]]];
            else if ([type isEqualToString:@"im"]) vcard = [vcard stringByAppendingString:[VCFGenerator imToVcardField:[items objectAtIndex:i]]];
        }
    }
    return vcard;
}

+ (NSString *)emailToVcardField:(CNLabeledValue *)email
{
    NSString *labelLower = [email.label lowercaseString];
    NSString *vcard = @"";
    
    if ([labelLower isEqualToString:@"_$!<home>!$_"]) vcard = [NSString stringWithFormat:@"EMAIL;type=INTERNET;type=HOME:%@\n",email.label];
    else if ([labelLower isEqualToString:@"_$!<work>!$_"]) vcard = [NSString stringWithFormat:@"EMAIL;type=INTERNET;type=WORK:%@\n",email.label];
    else
    {
        NSInteger counter = [VCFGenerator itemCounter]+1;
        vcard = [NSString stringWithFormat:@"item%ld.EMAIL;type=INTERNET:%@\nitem%ld.X-ABLabel:%@\n",(long)counter,email.label,(long)counter,email.label];
        [VCFGenerator setItemCounter:counter];
    }
    return vcard;
}

+ (NSString *)phoneToVcardField:(CNLabeledValue<CNPhoneNumber*>*)phone
{
    //_$!<Mobile>!$_, iPhone, _$!<Home>!$_, _$!<Work>!$_, _$!<Main>!$_, _$!<HomeFAX>!$_, _$!<WorkFAX>!$_, _$!<Pager>!$_
    
    NSString *labelLower = [phone.label lowercaseString];
    NSString *vcard = @"";
    
    if ([labelLower isEqualToString:@"_$!<mobile>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=CELL:%@\n",phone.label];
    else if ([labelLower isEqualToString:@"iphone"]) vcard = [NSString stringWithFormat:@"TEL;type=IPHONE:%@\n",phone.label];
    else if ([labelLower isEqualToString:@"_$!<home>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=HOME:%@\n",phone.label];
    else if ([labelLower isEqualToString:@"_$!<work>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=WORK:%@\n",phone.label];
    else if ([labelLower isEqualToString:@"_$!<main>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=MAIN:%@\n",phone.label];
    else if ([labelLower isEqualToString:@"_$!<homefax>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=HOME;type=FAX:%@\n",phone.label];
    else if ([labelLower isEqualToString:@"_$!<workfax>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=WORK;type=FAX:%@\n",phone.label];
    else if ([labelLower isEqualToString:@"_$!<pager>!$_"]) vcard = [NSString stringWithFormat:@"TEL;type=PAGER:%@\n",phone.label];
    else
    {
        NSInteger counter = [VCFGenerator itemCounter]+1;
        vcard = [NSString stringWithFormat:@"item%ld.TEL:%@\nitem%ld.X-ABLabel:%@\n",(long)counter,phone.label,(long)counter,phone.label];
        [VCFGenerator setItemCounter:counter];
    }
    
    return vcard;
}

+ (NSString *)addressToVcardField:(CNLabeledValue<CNPostalAddress*>*)address
{
    NSString *vcard = @"";
    NSString *labelField = @"";
    NSString *labelLower = [address.label lowercaseString];
    NSString *type = @"HOME";
    
    NSInteger counter = [VCFGenerator itemCounter]+1;
    
    //
    if([labelLower isEqualToString:@"_$!<work>!$_"]) type = @"WORK";
    else if([labelLower isEqualToString:@"_$!<home>!$_"]) {}
    else if( address.label && [address.label length] > 0 )
    {
        labelField = [NSString stringWithFormat:@"item%ld.X-ABLabel:%@\n",(long)counter,address.label];
    }
    
    //
    CNPostalAddress *value = address.value;
    NSString *street = value.street != nil ? value.street : @"";
    if ([street rangeOfString:@"\n"].location != NSNotFound)
    {
        NSArray *arr = [street componentsSeparatedByString:@"\n"];
        street = [arr componentsJoinedByString:@"\\n"];
    }
    
    NSString *City = value.city != nil ? value.city : @"";
    NSString *State = value.state != nil ? value.state : @"";
    NSString *ZIP = value.postalCode != nil ? value.postalCode : @"";
    NSString *Country = value.country != nil ? value.country : @"";
    NSString *CountryCode = value.ISOCountryCode != nil ? value.ISOCountryCode : @"";
    
    //
    vcard = [NSString stringWithFormat:@"item%ld.ADR;type=%@:;;%@;%@;%@;%@;%@\n%@item%ld.X-ABADR:%@\n",
             (long)counter,
             type,
             street,
             City,
             State,
             ZIP,
             Country,
             labelField,
             (long)counter,
             CountryCode
             ];
    
    //
    [VCFGenerator setItemCounter:counter];
    return vcard;
}

+ (NSString *)urlToVcardField:(CNLabeledValue<NSString *>*)url
{
    NSString *labelLower = [url.label lowercaseString];
    NSString *vcard = @"";
    
    if ([labelLower isEqualToString:@"_$!<home>!$_"]) vcard = [NSString stringWithFormat:@"URL;type=HOME:%@\n",url.label];
    else if ([labelLower isEqualToString:@"_$!<work>!$_"]) vcard = [NSString stringWithFormat:@"URL;type=WORK:%@\n",url.label];
    else
    {
        NSInteger counter = [VCFGenerator itemCounter]+1;
        vcard = [NSString stringWithFormat:@"item%ld.URL:%@\nitem%ld.X-ABLabel:%@\n",(long)counter,url.label,(long)counter,url.label];
        [VCFGenerator setItemCounter:counter];
    }
    
    return vcard;
}

+ (NSString *)imToVcardField:(CNLabeledValue<CNInstantMessageAddress*>*)im
{
    NSString *labelLower = [im.label lowercaseString];
    NSString *vcard = @"";
    CNInstantMessageAddress *value = im.value;
    NSString *service = value.service != nil ? value.service : @"";
    service = [service uppercaseString];
    NSString *username = value.username != nil ? value.username : @"";
    //
    if ([labelLower isEqualToString:@"_$!<home>!$_"] || [labelLower isEqualToString:@"_$!<work>!$_"])
    {
        NSString *type = [labelLower isEqualToString:@"_$!<home>!$_"] ? @"HOME" : @"WORK";
        vcard = [NSString stringWithFormat:@"X-%@;type=%@:%@\n",service,type,username];
    }
    else
    {
        NSInteger counter = [VCFGenerator itemCounter]+1;
        vcard = [NSString stringWithFormat:@"item%ld.X-%@:%@\nitem%ld.X-ABLabel:%@\n",(long)counter,service,username,(long)counter,im.label];
        [VCFGenerator setItemCounter:counter];
    }
    
    return vcard;
}

@end
