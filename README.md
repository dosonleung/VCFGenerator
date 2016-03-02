
#### What is VCF
vCard is a file format standard for electronic business cards. vCards are often attached to e-mail messages, but can be exchanged in other ways, such as on the World Wide Web or instant messaging. They can contain name and address information, telephone numbers, e-mail addresses, URLs, logos, photographs, and audio clips.

#### History
I have use Sadun's vcf tools but not compatible in iOS9.0 or later.So i rewrite the new one base on it.You can find the Sadun's code [here](http://ericasadun.com).

#### How to use
**Generate VCard String**
Just add VCGGenerator class files to the project and use method:
```Objective-C
+ (NSString *)generateVCardStringWithRecID:(NSString *)contactIdString")
```
which would return the VCard String.  

**Write VCardString**

```Objective-C
//It's better that you save the contactId in NSUserDefaults or others.
CNContactStore *stroe = [[CNContactStore alloc]init];
id keysToFetch = @[[CNContactViewController descriptorForRequiredKeys]];
CNContact *contact = [stroe unifiedContactWithIdentifier:contactID keysToFetch:keysToFetch error:nil];
NSString *vcard = [VCFGenerator generateVCardStringWithContactID:contactIdString];
//Then you just need to write the result to the new xxxxx.vcf file.
[vcard writeToFile:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] atomically:YES encoding:NSUTF8StringEncoding error:nil];

```
#### Availability
iOS (9.0 and later)

#### Contributor guide

Thanks for Erica Sadun, http://ericasadun.com
Copyright (c) 2010 Altosh

#### License
 Copyright (c) 2016 Doson
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

#### Contacts

If you have improvements or concerns, feel free to post [email](dosonleungs@gmail.com) and write details.

