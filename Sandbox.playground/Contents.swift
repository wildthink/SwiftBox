//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

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
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
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

text.topics(NSLinguisticTagPersonalName)


text.getNames()


