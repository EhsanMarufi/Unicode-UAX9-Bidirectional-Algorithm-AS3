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
					// adopt the nonjoining	form Xn
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