
#### What is VCF
vCard is a file format standard for electronic business cards. vCards are often attached to e-mail messages, but can be exchanged in other ways, such as on the World Wide Web or instant messaging. They can contain name and address information, telephone numbers, e-mail addresses, URLs, logos, photographs, and audio clips.

#### History
I have use Sadun's vcf tools but not compatible in iOS9.0 or later.So i rewrite the new one base on it.You can find the Sadun's code [here](http://ericasadun.com).

#### How to use
**Generate VCard String**
Just add VCGGenerator class files to the project and use method("+ (NSString *)generateVCardStringWithRecID:(NSString *)contactIdString") which would return the VCard String.  

**Write VCardString**

```Objective-C
self.addressBook.loadContacts(
    { (contacts: [APContact]?, error: NSError?) in
        if let uwrappedContacts = contacts {
            // do something with contacts
        }
        else if let unwrappedError = error {
            // show error
        }
    })
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

