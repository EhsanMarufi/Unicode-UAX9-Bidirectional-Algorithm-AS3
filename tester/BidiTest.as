/*
* In the name of God
* Ehsan Marufi Azar, Oct. 2016 (c)
* Bidirectional Conformance Testing for the implementation of the Unicode Bidirectional Algorithm (UBA) 9.0.0
* Examining the test cases inside the "BidiTest.txt" file.
*/
package biditests
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getTimer;
	
	import nibblessoft.unicode.bidi.Bidi;
	import nibblessoft.unicode.bidi.BidiPBA;

	/**
	 * <a href="http://www.unicode.org/reports/tr9/tr9-35.html#Bidi_Conformance_Testing">Bidirectional Conformance Testing</a>
	 * class for the Unicode<sup>&reg;</sup> Bidirectional Algorithm
	 * (described in <a href="http://www.unicode.org/reports/tr9/tr9-35.html">UAX#9-r35</a>).
	 * The <i>Unicode Character Database (<a href="http://www.unicode.org/reports/tr41/tr41-19.html#UCD">UCD</a>)</i>
	 * includes two files that provide conformance tests for implementations of the Bidirectional Algorithm [Tests9].
	 * One of the test files, <code>BidiTest.txt</code>, comprises exhaustive test sequences of bidirectional types 
	 * up to a given length, currently 4. This class tests that file.
	 * 
	 * @author Ehsan Marufi
	 * 
	 */
	public class BidiTest
	{
		private var _logFileStream:FileStream = null;
		private var _traceEnalged:Boolean = true;
		
		private static var sTypesMap:Array = new Array();
		
		// Static initializer:
		{
			sTypesMap["L"  ] = Bidi.L;
			sTypesMap["LRE"] = Bidi.LRE;
			sTypesMap["LRO"] = Bidi.LRO;
			sTypesMap["R"  ] = Bidi.R;
			sTypesMap["AL" ] = Bidi.AL;
			sTypesMap["RLE"] = Bidi.RLE;
			sTypesMap["RLO"] = Bidi.RLO;
			sTypesMap["PDF"] = Bidi.PDF;
			sTypesMap["EN" ] = Bidi.EN;
			sTypesMap["ES" ] = Bidi.ES;
			sTypesMap["ET" ] = Bidi.ET;
			sTypesMap["AN" ] = Bidi.AN;
			sTypesMap["CS" ] = Bidi.CS;
			sTypesMap["NSM"] = Bidi.NSM;
			sTypesMap["BN" ] = Bidi.BN;
			sTypesMap["B"  ] = Bidi.B;
			sTypesMap["S"  ] = Bidi.S;
			sTypesMap["WS" ] = Bidi.WS;
			sTypesMap["ON" ] = Bidi.ON;
			sTypesMap["LRI"] = Bidi.LRI;
			sTypesMap["RLI"] = Bidi.RLI;
			sTypesMap["FSI"] = Bidi.FSI;
			sTypesMap["PDI"] = Bidi.PDI;
		}
		
		
		public function BidiTest(logFileName:String = "out.txt", traceEnabled:Boolean = true)
		{
			_traceEnalged = traceEnabled;
			
			var myFile:File = File.applicationDirectory.resolvePath("BidiTest.txt");
			var myFileStream:FileStream = new FileStream();
			myFileStream.open(myFile, FileMode.READ);
			var txt:String = myFileStream.readUTFBytes(myFileStream.bytesAvailable);
			myFileStream.close();
			
			if (logFileName != null && logFileName != "") {
				var pathToFile:String = File.applicationDirectory.resolvePath(logFileName).nativePath;
				var logFile:File = new File(pathToFile);
				_logFileStream = new FileStream();
				_logFileStream.open(logFile, FileMode.WRITE);
			}
			
			
			var testIndex:uint = 0;
			
			var regex1:RegExp = /@(.+):\t(.*)/;
			var datalineRegex:RegExp = /(.+);\s*(\d+)\s*/;
			
			var allLines:Array = txt.split(String.fromCharCode(10));
			
			var currentValidLevels:Vector.<uint>, currentValidReorder:Vector.<int>;
			var currentExpectedLevels:Vector.<String>;
			var count:uint = 0;

			for (var lineNumber:uint = 0; lineNumber < allLines.length; ++lineNumber) {
				var line:String = allLines[lineNumber];
				var firstChar:String = line.charAt(0);
				// skip comments and empty lines
				if (line=="" || firstChar=="#")
					continue;
				
				if (firstChar == "@") {
					var arr:Array = regex1.exec(line);
					
					// There's a bug in AS3 RegExp in which the last (.*) is not accounted!
					
					// If the line has a valid pattern
					if (arr.length == 3) {
						if (arr[1] == "Levels") {
							currentExpectedLevels = generateExpectedLevelsVector(arr[2]);
							log("-----------------");
							log("Expected levels: "+arr[2]);
						} else if (arr[1] == "Reorder") {
							currentValidReorder = generageReordersVector(arr[2]);
							log("Expected reorder: "+arr[2]);
						}
					}
					
					continue;
				}
				
				
				// If we're here, then most probably it's a data line
				var arr2:Array = datalineRegex.exec(line);
				if (arr2.length == 3) {
					var paragraphLvls:Array = getParagraphLevels(arr2[2]);
					var types:Vector.<uint> = generateTypesVector(arr2[1]);
					log("Types: "+arr2[1]);
					var l:uint = types.length;
					var pairTypes:Vector.<uint> = new Vector.<uint>(l, true);
					var pairValues:Vector.<int> = new Vector.<int>(l, true);
					for (var j:uint = 0; j<l; ++j) {
						pairTypes[j] = BidiPBA.n;
						pairValues[j] = 0;
					}
					
					for each(var paragraphLvl:uint in paragraphLvls) {
						var bidi:Bidi = new Bidi(types, pairTypes, pairValues, paragraphLvl);
						var linebreakVec:Vector.<int> = new Vector.<int>(1, true);
						linebreakVec[0] = l;
						var currentLvls:Vector.<uint> = bidi.getLevels(linebreakVec);
						log("  >> #ln: "+lineNumber+", #testIndex: "+ (testIndex++)+ ", paraEmbedLvl: "+getParagraphEmbeddingLevelReadable(paragraphLvl));
						
						log("   > Current level: "+getLevlesReadable(currentLvls));
						if (!isWhatExpected(currentLvls, currentExpectedLevels))
							throw new Error("NO, NO, NOO! The levels don't match! :(");
						else log("      Levels Test passed.");
						
						var currentReordering:Vector.<int> = bidi.getReordering(linebreakVec);
						log("   > Current reorder: "+currentReordering);
						if (!isWhatExpectedReorder(currentReordering, currentValidReorder, currentExpectedLevels))
							throw new Error("NOOOOO! The reorders don't match! :(");
						else log("      Reorder Test passed.");
					}
				}
			}
			
			log("\n\nExecution took "+getElapsedTimeReadable(getTimer()));
			if (_logFileStream != null)
				_logFileStream.close();
		}
		
		private function log(str:String):void {
			if (_logFileStream != null)
				_logFileStream.writeUTFBytes(str+"\n");
			
			if (_traceEnalged)
				trace(str);
		}
		
		private static function getParagraphLevels(rawData:String):Array {
			var n:uint = uint(rawData);
			var arr:Array = new Array();
			if (n & 1)
				arr.push(Bidi.PARAGRAPH_EMBEDDING_LEVEL_IMPLICIT); // Auto
			if (n & 2) 
				arr.push(Bidi.PARAGRAPH_EMBEDDING_LEVEL_LEFT); // LTR
			if (n & 4)
				arr.push(Bidi.PARAGRAPH_EMBEDDING_LEVEL_RIGHT); // RTL
			return arr;
		}
		private static function generateTypesVector(rawData:String):Vector.<uint> {
			var arr:Array = rawData.split(" ");
			var len:uint = arr.length;
			var vec:Vector.<uint> = new Vector.<uint>(len, true);
			for (var i:uint = 0; i<len; ++i)
				vec[i] = sTypesMap[arr[i]];
			return vec;
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
		private static function isTotallyIgnored(expected:Vector.<String>):Boolean {
			var len:uint = expected.length;
			for (var i:uint = 0; i<len; ++i)
				if (expected[i] != "x")
					return false;
			return true;
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