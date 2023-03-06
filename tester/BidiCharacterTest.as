/*
* In the name of God
* Ehsan Marufi Azar, Oct. 2016 (c)
* Bidirectional Conformance Testing for the implementation of the Unicode Bidirectional Algorithm (UBA) 9.0.0
* Examining the test cases inside the "BidiCharacterTest.txt" file.
*/
package biditests
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getTimer;
	
	import nibblessoft.unicode.bidi.Bidi;
	import nibblessoft.unicode.data.BidiBrackets;
	import nibblessoft.unicode.data.BidiClasses;

	public class BidiCharacterTest {
		
		/**
		 * <a href="http://www.unicode.org/reports/tr9/tr9-35.html#Bidi_Conformance_Testing">Bidirectional Conformance Testing</a>
		 * class for the Unicode<sup>&reg;</sup> Bidirectional Algorithm
		 * (described in <a href="http://www.unicode.org/reports/tr9/tr9-35.html">UAX#9-r35</a>).
		 * The <i>Unicode Character Database (<a href="http://www.unicode.org/reports/tr41/tr41-19.html#UCD">UCD</a>)</i>
		 * includes two files that provide conformance tests for implementations of the Bidirectional Algorithm [Tests9].
		 * One of the test files, <code>BidiCharacterTest.txt</code>, contains test sequences of explicit code points,
		 * including, for example, bracket pairs. This class tests that file.
		 * 
		 * @author Ehsan Marufi
		 * 
		 */
		public function BidiCharacterTest() {
			var testFile:File = File.applicationDirectory.resolvePath("BidiCharacterTest.txt");
			var testFileStream:FileStream = new FileStream();
			testFileStream.open(testFile, FileMode.READ);
			var txt:String = testFileStream.readUTFBytes(testFileStream.bytesAvailable);
			testFileStream.close();
			
			var allLines:Array = txt.split(String.fromCharCode(10));
			for (var lineIndex:uint = 0; lineIndex < allLines.length; ++lineIndex) {
				var line:String = allLines[lineIndex];
				var firstChar:String = line.charAt(0);
				// skip comments and empty lines
				if (line=="" || firstChar=="#")
					continue;
				
				var fields:Array = line.split(";");
				
				var rawCodepointsArr:Array = fields[0].split(" ");
				var codepoints:Vector.<uint> = new Vector.<uint>(rawCodepointsArr.length, true);
				var rawStr:String = "";
				for (var i:uint = 0; i<rawCodepointsArr.length; ++i) {
					codepoints[i] = parseInt(rawCodepointsArr[i], 16);
					rawStr += String.fromCharCode(codepoints[i]);
				}
				
				var paragraphDirection:uint = getParagraphLevel(fields[1]);
				
				var expectedResolvedParagraphEmbeddingLevel:uint = fields[2];
				
				var expectedLevels:Vector.<String> = generateExpectedLevelsVector(fields[3]);
				var expectedReorders:Vector.<int> = generageReordersVector(fields[4]);
				
				
				// The main test
				var pairBrackets:Object = BidiBrackets.generatePairedBracketInfo(codepoints);
				var types:Vector.<uint> = BidiClasses.generateTypesVector(codepoints);
				

				log(">> #ln: "+(lineIndex+1));
				log("    String: "+rawStr);
				log("    Types: "+getTypesReadable(types));
				
				var bidi:Bidi = new Bidi(
					types,
					pairBrackets.types,
					pairBrackets.values,
					paragraphDirection
				);
				
				
				log("  > The paragraph level:: applied: "+getParagraphEmbeddingLevelReadable(paragraphDirection)+
					", expected: "+getParagraphEmbeddingLevelReadable(expectedResolvedParagraphEmbeddingLevel)+
					", resolved: "+getParagraphEmbeddingLevelReadable(bidi.getBaseLevel()));
				if (expectedResolvedParagraphEmbeddingLevel != bidi.getBaseLevel())
					throw new Error("No, no! The expected paragraph level is not resolved!");
				else log("    Expected paragraph level resolved.");
				
				
				var linebreakVec:Vector.<int> = new Vector.<int>(1, true);
				linebreakVec[0] = rawCodepointsArr.length;
				var resolvedLevels:Vector.<uint> = bidi.getLevels(linebreakVec);

				
				log("  > Resolved levels: "+getLevlesReadable(resolvedLevels)+"\n"+
					"    Expected levels: "+expectedLevels);
				if (!isWhatExpected(resolvedLevels, expectedLevels))
					throw new Error("NO, NO, NOO! The levels don't match! :(");
				else log("    Levels Test passed.");
				
				
				var resolvedReordering:Vector.<int> = bidi.getReordering(linebreakVec);
				log("  > Resolved reorder: "+resolvedReordering+"\n"+
					"    Expected reorder: "+expectedReorders);
				if (!isWhatExpectedReorder(resolvedReordering, expectedReorders, expectedLevels))
					throw new Error("NOOOOO! The reorders don't match! :(");
				else log("    Reorder Test passed.");
			}
			
			log("\n\nExecution took "+getElapsedTimeReadable(getTimer()));
		}
		
		private static function log(str:String):void {
			trace(str);
		}
		
		private static function getParagraphLevel(rawData:String):uint {
			var n:uint = parseInt(rawData, 10);
			if (n == 0) 
				return Bidi.PARAGRAPH_EMBEDDING_LEVEL_LEFT; // LTR
			else if (n == 1)
				return Bidi.PARAGRAPH_EMBEDDING_LEVEL_RIGHT; // RTL
			else if (n == 2)
				return Bidi.PARAGRAPH_EMBEDDING_LEVEL_IMPLICIT; // Auto
			else
				return n;
		}
		
		private static function getTypesReadable(types:Vector.<uint>):String {
			var len:uint = types.length;
			var arr:Array = new Array(len)
			for (var i:uint = 0; i<len; ++i) {
				arr[i] = Bidi.typenames[types[i]];
			}
			return arr.join(", ");
		}
		
		private static function getLevlesReadable(lvls:Vector.<uint>):String {
			var out:String = "", len:uint = lvls.length;
			for (var i:uint = 0; i<len-1; ++i) {
				if (lvls[i] == Bidi.UINT_NEGATIVE_ONE)
					out += "x,";
				else out += lvls[i]+",";
			}
			if (len > 0)
				out += lvls[len-1] == Bidi.UINT_NEGATIVE_ONE ? "x" : lvls[len-1].toString();
			return out;
		}
		
		private static function generateExpectedLevelsVector(rawData:String):Vector.<String> {
			var arr:Array = rawData.split(" ");
			var out:Vector.<String> = new Vector.<String>(arr.length, true);
			for (var i:uint = 0; i < arr.length; ++i) {
				out[i] = arr[i];
			}
			return out;
		}
		
		private static function generageReordersVector(rawData:String):Vector.<int> {
			if (rawData == "")
				return new Vector.<int>(0, true);
			
			var arr:Array = rawData.split(" ");
			var len:uint = arr.length;
			var vec:Vector.<int> = new Vector.<int>(len, true);
			for (var i:uint = 0; i<len; i++) {
				vec[i] = uint(arr[i])
			}
			return vec;
		}
		
		private static function isWhatExpected(lvl:Vector.<uint>, expected:Vector.<String>):Boolean {
			var lenLvl:uint = lvl.length, lenExpected:uint = expected.length;
			
			if (lenLvl != lenExpected)
				return false;
			
			for (var i:uint = 0; i<lenLvl; ++i) {
				if (expected[i] == "x")
					continue;
				else if (lvl[i].toString() != expected[i])
					return false;
			}
			return true;
		}
		private static function isWhatExpectedReorder(reorder:Vector.<int>, expected:Vector.<int>, expectedLvl:Vector.<String>):Boolean {
			var lenReorder:uint = reorder.length, lenExpected:uint = expected.length;
			
			if (lenReorder < lenExpected)
				return false;
			
			var expectedIndex:uint = 0;
			for (var i:uint = 0; i<lenReorder; ++i) {
				if (expectedLvl[reorder[i]] == "x")
					continue;
				if (reorder[i] != expected[expectedIndex++])
					return false;
			}
			
			return true;
		}
		
		private static function getParagraphEmbeddingLevelReadable(lvl:uint):String {
			switch(lvl) {
				case 0: return "LTR";
				case 1: return "RTL";
					// Auto-LTR (standard BIDI) uses the first L/R/AL character, and is LTR if none is found.
				case 2: return "auto-LTR";
				default: return "<Invalid>";
			}
		}
		
		private static function getElapsedTimeReadable(milisecondsElapsed:int):String {
			var seconds:Number = milisecondsElapsed/1000, minutes:Number;
			var out:String = seconds + " seconds";
			if (seconds > 60) {
				minutes = seconds / 60;
				out += " (= " + minutes + " minutes)";
			}
			out += ".";
			return out;
		}
	}
}