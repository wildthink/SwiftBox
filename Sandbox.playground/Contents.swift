//: Playground - noun: a place where people can play

import Cocoa

class Name : NSObject {
    var text : String
    var category : String
    
    init (_ cat: String, _ nomen: String) {
        text = nomen;
        category = cat;
    }
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    subscript (r: NSRange) -> String {
        get {
            return self[Range(start: r.location, end: r.location + r.length)]
        }
    }

}

extension String {
    
    func linguisticElements(linguisticTypes: String...) -> [Name] {
        var token : dispatch_once_t = 0
        var tagger : NSLinguisticTagger!
        
        let options :NSLinguisticTaggerOptions =
            [NSLinguisticTaggerOptions.OmitOther,
            NSLinguisticTaggerOptions.JoinNames,
            NSLinguisticTaggerOptions.OmitWhitespace,
            NSLinguisticTaggerOptions.OmitPunctuation]
        
        dispatch_once(&token) {
            tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeNameType], options: 0)
        }
        tagger.string = self
        let fullRange = NSMakeRange(0, self.lengthOfBytesUsingEncoding(NSISOLatin1StringEncoding));
        
        var names: [Name] = [];
        let types : NSSet = NSSet(array: linguisticTypes)
        
        tagger.enumerateTagsInRange(fullRange,
            scheme: NSLinguisticTagSchemeLexicalClass, options: options)
            { (type, tokenRange, sentenceRange, stop) -> Void in
                if types.containsObject(type) {
                    let word :String = self[tokenRange]
                    names.append(Name(type, word))
            }
        }
        return names;
    }
    
    func getNames() -> [Name] {
        return self.linguisticElements(NSLinguisticTagPersonalName,
            NSLinguisticTagPlaceName,
            NSLinguisticTagOrganizationName)
    }
    
    func topics(linguisticTypes: String...) -> NSMutableSet
    {
        var token : dispatch_once_t = 0
        var tagger : NSLinguisticTagger!
        
        let options :NSLinguisticTaggerOptions =
            [NSLinguisticTaggerOptions.OmitOther,
            NSLinguisticTaggerOptions.JoinNames,
            NSLinguisticTaggerOptions.OmitWhitespace,
            NSLinguisticTaggerOptions.OmitPunctuation]
        
        dispatch_once(&token) {
            tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLexicalClass, NSLinguisticTagSchemeLemma], options: 0)
        }
        tagger.string = self
        let fullRange = NSMakeRange(0, self.lengthOfBytesUsingEncoding(NSISOLatin1StringEncoding));
        
        let names = NSMutableSet();
        let types = NSSet (array: linguisticTypes)
        
        tagger.enumerateTagsInRange(fullRange,
            scheme: NSLinguisticTagSchemeNameType, // NSLinguisticTagSchemeNameTypeOrLexicalClass,
            options: options)
            {
                (type, tokenRange, sentenceRange, stop) -> Void in
                
                if types.containsObject(type) {
                    let word :String = self[tokenRange]
                    names.addObject(word)
                }
                if type == NSLinguisticTagNoun {
                    let lemma = tagger.tagAtIndex(tokenRange.location,
                        scheme: NSLinguisticTagSchemeLemma, tokenRange: nil, sentenceRange: nil);
                    
                    if ((lemma?.isEmpty) != nil) {
                        names.addObject(lemma!);
                    }
                    else {
                        let word :String = self[tokenRange]
                        names.addObject(word)
                    }
                }
        }
        
        return names
    }
    
}

let text = "Tom Jones went to New York to find some toys."

text.topics(NSLinguisticTagPlaceName)


text.getNames()

//var item :CSSearchableItemAttributeSet

// Create an attribute set for an item that represents an image.
//CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString*)kUTTypeImage];
//// Set properties that describe attributes of the item such as title, description, and image.
//[attributeSet setTitle:@"..."];
//[attributeSet setContentDescription:@"..."];


