# Unicode UAX9 Bidirectional Algorithm in ActionScript3

An ActionScript3 implementaion of the [Unicode UAX9 Bidirectional Algorithm.](https://unicode.org/reports/tr9/)

> The Unicode Standard prescribes a memory representation order known as logical order. When text is presented in horizontal lines, most scripts display characters from left to right. However, there are several scripts (such as Arabic or Hebrew) where the natural ordering of horizontal text in display is from right to left. If all of the text has a uniform horizontal direction, then the ordering of the display text is unambiguous. However, because these right-to-left scripts use digits that are written from left to right, the text is actually bidirectional: a mixture of right-to-left and left-to-right text. In addition to digits, embedded words from English and other scripts are also written from left to right, also producing bidirectional text. Without a clear specification, ambiguities can arise in determining the ordering of the displayed characters when the horizontal direction of the text is not uniform.

## Usage sample
The followng class utilizes the Bidirectional Algorithm API to reshape an Arabic (or Persian) string.

```as3
package nibblessoft.unicode
{
   
   import nibblessoft.unicode.bidi.Bidi;
   import nibblessoft.unicode.data.ArabicScriptPresentationalForms;
   import nibblessoft.unicode.data.BidiBrackets;
   import nibblessoft.unicode.data.BidiClasses;
   import nibblessoft.unicode.data.JoiningType;
   import nibblessoft.unicode.data.JoiningTypes;
   import nibblessoft.unicode.data.PresentationalForms;

   public class ArabicShaper
   {
      public function ArabicShaper() {}
      
      public static function reshapeArabicText(str:String):String {
         var out:String = "", len:uint = str.length;
         var joiningTypes:Vector.<uint> = JoiningTypes.generateJoiningTypesVectorStr(str);
         
         for (var i:uint = 0; i < len; ++i) {
            var jt:uint = joiningTypes[i];
            
            var codepoint:uint = str.charCodeAt(i);
            var presForms:PresentationalForms = ArabicScriptPresentationalForms.getPresentationalForms(codepoint);
   
            // Rule R1
            if (jt == JoiningType.T && presForms != null) {
               out += String.fromCharCode(presForms.isolatedForm);
               continue;
            }
            
            // determine the next non-Transparent joining-type
            var nextNonT_JoiningType:uint = JoiningType.INVALID;
            for (var j:uint = i+1; j < len; ++j) {
               if (joiningTypes[j] != JoiningType.T) {
                  nextNonT_JoiningType = joiningTypes[j];
                  break;
               }
            }
            var hasRight:Boolean = nextNonT_JoiningType != JoiningType.INVALID;
            
            // determine the previous non-Transparent joining-type
            var prevNonT_JoiningType:uint = JoiningType.INVALID;
            for (var k:int = i-1; k >= 0; --k) {
               if (joiningTypes[k] != JoiningType.T) {
                  prevNonT_JoiningType = joiningTypes[k];
                  break;
               }
            }
            var hasLeft:Boolean = prevNonT_JoiningType != JoiningType.INVALID;            
            
            if (presForms == null) {
               out += String.fromCharCode(codepoint);
               continue;
            }
            
            // Rule R2
            if (jt == JoiningType.R && hasRight && isRightJoinCausing(nextNonT_JoiningType))
               // adopt the form Xr
               out += String.fromCharCode(presForms.finalForm);
            
            // Rule R3
            else if (jt == JoiningType.L && hasLeft && isLeftJoinCausing(prevNonT_JoiningType))
               // adopt the form Xl
               out += String.fromCharCode(presForms.initialForm);
            
            // Rule R4
            else if (jt == JoiningType.D && 
               hasRight && isRightJoinCausing(nextNonT_JoiningType) &&
               hasLeft && isLeftJoinCausing(prevNonT_JoiningType))
               // adopt the form Xm
               out += String.fromCharCode(presForms.medialForm);
            
            // Rule R5
            else if (jt == JoiningType.D &&
               hasRight && isRightJoinCausing(nextNonT_JoiningType) &&
               (!hasLeft || (hasLeft && !isLeftJoinCausing(prevNonT_JoiningType))))
               // adopt the form Xr
               out += String.fromCharCode(presForms.finalForm);
            
            // Rule R6
            else if (jt == JoiningType.D &&
               hasLeft && isLeftJoinCausing(prevNonT_JoiningType) &&
               (!hasRight || (hasRight && !isRightJoinCausing(nextNonT_JoiningType))))
               // adopt the form Xl
               out += String.fromCharCode(presForms.initialForm);
            
            // Rule R7
            else
               // adopt the nonjoining   form Xn
               out += String.fromCharCode(presForms.isolatedForm);
         }
         return out;
      }
      
      private static function isRightJoinCausing(jt:uint):Boolean {
         return (jt == JoiningType.D || jt == JoiningType.L || jt == JoiningType.C);
      }
      
      private static function isLeftJoinCausing(jt:uint):Boolean {
         return (jt == JoiningType.D || jt == JoiningType.R || jt == JoiningType.C);
      }
      
      
      public static function processBidiString(str:String, paragraphEmbeddingLevel:uint = Bidi.PARAGRAPH_EMBEDDING_LEVEL_IMPLICIT):String {
         var len:uint = str.length;
         
         var types:Vector.<uint> = BidiClasses.generateTypesVectorStr(str);
         var pairBrackets:Object = BidiBrackets.generatePairedBracketInfoStr(str);
         
         var bidi:Bidi = Bidi.analyzeInput(types, pairBrackets.types, pairBrackets.values, paragraphEmbeddingLevel);
         
         var lineBreaks:Vector.<int> = new Vector.<int>(1, true);
         lineBreaks[0] = len;
         var reorder:Vector.<int> = bidi.getReordering(lineBreaks);
         var reorderedStr:String = "";
         for (var i:uint = 0; i<len; ++i)
            reorderedStr += str.charAt(reorder[i]);
         
         var resolvedLevels:Vector.<uint> = bidi.getLevels(lineBreaks);
         reorderedStr = Bidi.mirrorCharactersAppropriatly(reorderedStr, resolvedLevels);
         
         return reshapeArabicText(reorderedStr);
      }
   }
}
```

All the code is released to Public Domain. Patches and comments are welcome. It makes me happy to hear if someone finds the implementations useful.

Ehsan Marufi<br />
<sup>October 2016</sup>