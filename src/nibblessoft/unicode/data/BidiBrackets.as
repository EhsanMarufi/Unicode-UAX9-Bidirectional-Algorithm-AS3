package nibblessoft.unicode.data {
	import nibblessoft.unicode.bidi.BidiPBA;
	
	public class BidiBrackets {
		
		private static const ENTRIES_COUNT:uint = 120;
		private static var D:Vector.<BidiBracket>;
		
		/**
		 * Returns the BiDi BracketType associated with each Unicode<sup>&reg;</sup> codepoint using an efficient
		 * binary search algorithm.
		 * @param codepoint The Unicode<sup>&reg;</sup> codepoint to retrieve the BiDi BracketType of. 
		 * @return The BiDi BracketType of the specified codepoint.
		 * 
		 */
		public static function getBiDiBracketInfo(codepoint:uint):Object {
			// Uses the Binary Search Algorithm
			var L:int = 0, R:int = ENTRIES_COUNT-1;
			var m:int;
			var bidiBracket:BidiBracket;
			
			while (true) {
				if (L > R)
					// Search should be terminated as unsuccessful
					break;
				
				m = Math.floor((L+R)/2);
				
				bidiBracket = BidiBracket(D[m]);
				if (bidiBracket.codepoint < codepoint)
					L = m + 1;
				else if (bidiBracket.codepoint > codepoint)
					R = m - 1;
				else {
					// Found it!
					return {type:bidiBracket.bracketType, foundBracket:bidiBracket};
				}
			}
			
			// Search terminates as unsuccessful
			return {type:BidiPBA.n, foundBracket:null};
		}
		
		
		/**
		 * Generates and returns the paired bracket information regarding the specified string. 
		 * @param codepoints The codepoints to which the information should be generated.
		 * @return An object holding two vectors, one for the <em>pairBracket-types</em> (through the <code>types</code>
		 * property) and one for the <em>pairBracket-values</em> (through the <code>values</code> property.)
		 * 
		 */
		public static function generatePairedBracketInfo(codepoints:Vector.<uint>):Object {
			var len:uint = codepoints.length;
			var pairedBracketTypes:Vector.<uint> = new Vector.<uint>(len, true);
			// All the pairBracket values will be assigned with a '0' by default (it's the
			// typical case for the "BiDiPBA.n" types, and the value will remain unchanged
			// for the "unpaired brackets".)
			var pairedBracketValues:Vector.<int> = new Vector.<int>(len, true);
			
			var out:Object = {types:pairedBracketTypes, values:pairedBracketValues};
			
			
			var currentBracketInfo:Object, bracketValue:int, openBracketsEncountered:uint;
			for (var i:uint = 0; i < len; ++i) {
				currentBracketInfo = getBiDiBracketInfo(codepoints[i]);
				pairedBracketTypes[i] = currentBracketInfo.type;
				
				
				if (currentBracketInfo.type == BidiPBA.o) {
					var foundBidiBracket:BidiBracket = currentBracketInfo.foundBracket;
					// The value of '0' is reserved for the "BiDiPBA.n" and the "unpaired brackets".
					// The actual values are not important, but they need to be unique; hence the
					// 'bracketValue' cannot be assigned with '0' (its minimum value would be '1').
					bracketValue = i+1;
					
					// Traverse through the rest of the string (from the current stand point) to
					// find the matching closed bracket.
					openBracketsEncountered = 0;
					for (var j:uint = i+1; j < len; ++j) {
						if (openBracketsEncountered == 0 && codepoints[j] == foundBidiBracket.pairedBracket) {
							pairedBracketValues[i] = bracketValue;
							pairedBracketValues[j] = bracketValue;
							break;
						}
						if (codepoints[j] == foundBidiBracket.codepoint)
							openBracketsEncountered++;
						else if (codepoints[j] == foundBidiBracket.pairedBracket)
							openBracketsEncountered--;
					}
				}
			}
			
			return out;
		}
		
		/**
		 * Generates and returns the paired bracket information regarding the specified string, but
		 * expectes an string as an input instead of a list of codepoints. 
		 * @param str The string to which the information should be generated.
		 * @return An object holding two vectors, one for the <em>pairBracket-types</em> (through the <code>types</code>
		 * property) and one for the <em>pairBracket-values</em> (through the <code>values</code> property.)
		 * 
		 */
		public static function generatePairedBracketInfoStr(str:String):Object {
			var len:uint = str.length;
			var codepoints:Vector.<uint> = new Vector.<uint>(len, true);
			for (var c:uint = 0; c < len; ++c)
				codepoints[c] = str.charCodeAt(c);
			
			return generatePairedBracketInfo(codepoints);
		}
		
		// Static initializer
		{
			D = new Vector.<BidiBracket>(ENTRIES_COUNT, true);
			
			D[0] = new BidiBracket(40, 41, BidiPBA.o);
			D[1] = new BidiBracket(41, 40, BidiPBA.c);
			D[2] = new BidiBracket(91, 93, BidiPBA.o);
			D[3] = new BidiBracket(93, 91, BidiPBA.c);
			D[4] = new BidiBracket(123, 125, BidiPBA.o);
			D[5] = new BidiBracket(125, 123, BidiPBA.c);
			D[6] = new BidiBracket(3898, 3899, BidiPBA.o);
			D[7] = new BidiBracket(3899, 3898, BidiPBA.c);
			D[8] = new BidiBracket(3900, 3901, BidiPBA.o);
			D[9] = new BidiBracket(3901, 3900, BidiPBA.c);
			D[10] = new BidiBracket(5787, 5788, BidiPBA.o);
			D[11] = new BidiBracket(5788, 5787, BidiPBA.c);
			D[12] = new BidiBracket(8261, 8262, BidiPBA.o);
			D[13] = new BidiBracket(8262, 8261, BidiPBA.c);
			D[14] = new BidiBracket(8317, 8318, BidiPBA.o);
			D[15] = new BidiBracket(8318, 8317, BidiPBA.c);
			D[16] = new BidiBracket(8333, 8334, BidiPBA.o);
			D[17] = new BidiBracket(8334, 8333, BidiPBA.c);
			D[18] = new BidiBracket(8968, 8969, BidiPBA.o);
			D[19] = new BidiBracket(8969, 8968, BidiPBA.c);
			D[20] = new BidiBracket(8970, 8971, BidiPBA.o);
			D[21] = new BidiBracket(8971, 8970, BidiPBA.c);
			D[22] = new BidiBracket(9001, 9002, BidiPBA.o);
			D[23] = new BidiBracket(9002, 9001, BidiPBA.c);
			D[24] = new BidiBracket(10088, 10089, BidiPBA.o);
			D[25] = new BidiBracket(10089, 10088, BidiPBA.c);
			D[26] = new BidiBracket(10090, 10091, BidiPBA.o);
			D[27] = new BidiBracket(10091, 10090, BidiPBA.c);
			D[28] = new BidiBracket(10092, 10093, BidiPBA.o);
			D[29] = new BidiBracket(10093, 10092, BidiPBA.c);
			D[30] = new BidiBracket(10094, 10095, BidiPBA.o);
			D[31] = new BidiBracket(10095, 10094, BidiPBA.c);
			D[32] = new BidiBracket(10096, 10097, BidiPBA.o);
			D[33] = new BidiBracket(10097, 10096, BidiPBA.c);
			D[34] = new BidiBracket(10098, 10099, BidiPBA.o);
			D[35] = new BidiBracket(10099, 10098, BidiPBA.c);
			D[36] = new BidiBracket(10100, 10101, BidiPBA.o);
			D[37] = new BidiBracket(10101, 10100, BidiPBA.c);
			D[38] = new BidiBracket(10181, 10182, BidiPBA.o);
			D[39] = new BidiBracket(10182, 10181, BidiPBA.c);
			D[40] = new BidiBracket(10214, 10215, BidiPBA.o);
			D[41] = new BidiBracket(10215, 10214, BidiPBA.c);
			D[42] = new BidiBracket(10216, 10217, BidiPBA.o);
			D[43] = new BidiBracket(10217, 10216, BidiPBA.c);
			D[44] = new BidiBracket(10218, 10219, BidiPBA.o);
			D[45] = new BidiBracket(10219, 10218, BidiPBA.c);
			D[46] = new BidiBracket(10220, 10221, BidiPBA.o);
			D[47] = new BidiBracket(10221, 10220, BidiPBA.c);
			D[48] = new BidiBracket(10222, 10223, BidiPBA.o);
			D[49] = new BidiBracket(10223, 10222, BidiPBA.c);
			D[50] = new BidiBracket(10627, 10628, BidiPBA.o);
			D[51] = new BidiBracket(10628, 10627, BidiPBA.c);
			D[52] = new BidiBracket(10629, 10630, BidiPBA.o);
			D[53] = new BidiBracket(10630, 10629, BidiPBA.c);
			D[54] = new BidiBracket(10631, 10632, BidiPBA.o);
			D[55] = new BidiBracket(10632, 10631, BidiPBA.c);
			D[56] = new BidiBracket(10633, 10634, BidiPBA.o);
			D[57] = new BidiBracket(10634, 10633, BidiPBA.c);
			D[58] = new BidiBracket(10635, 10636, BidiPBA.o);
			D[59] = new BidiBracket(10636, 10635, BidiPBA.c);
			D[60] = new BidiBracket(10637, 10640, BidiPBA.o);
			D[61] = new BidiBracket(10638, 10639, BidiPBA.c);
			D[62] = new BidiBracket(10639, 10638, BidiPBA.o);
			D[63] = new BidiBracket(10640, 10637, BidiPBA.c);
			D[64] = new BidiBracket(10641, 10642, BidiPBA.o);
			D[65] = new BidiBracket(10642, 10641, BidiPBA.c);
			D[66] = new BidiBracket(10643, 10644, BidiPBA.o);
			D[67] = new BidiBracket(10644, 10643, BidiPBA.c);
			D[68] = new BidiBracket(10645, 10646, BidiPBA.o);
			D[69] = new BidiBracket(10646, 10645, BidiPBA.c);
			D[70] = new BidiBracket(10647, 10648, BidiPBA.o);
			D[71] = new BidiBracket(10648, 10647, BidiPBA.c);
			D[72] = new BidiBracket(10712, 10713, BidiPBA.o);
			D[73] = new BidiBracket(10713, 10712, BidiPBA.c);
			D[74] = new BidiBracket(10714, 10715, BidiPBA.o);
			D[75] = new BidiBracket(10715, 10714, BidiPBA.c);
			D[76] = new BidiBracket(10748, 10749, BidiPBA.o);
			D[77] = new BidiBracket(10749, 10748, BidiPBA.c);
			D[78] = new BidiBracket(11810, 11811, BidiPBA.o);
			D[79] = new BidiBracket(11811, 11810, BidiPBA.c);
			D[80] = new BidiBracket(11812, 11813, BidiPBA.o);
			D[81] = new BidiBracket(11813, 11812, BidiPBA.c);
			D[82] = new BidiBracket(11814, 11815, BidiPBA.o);
			D[83] = new BidiBracket(11815, 11814, BidiPBA.c);
			D[84] = new BidiBracket(11816, 11817, BidiPBA.o);
			D[85] = new BidiBracket(11817, 11816, BidiPBA.c);
			D[86] = new BidiBracket(12296, 12297, BidiPBA.o);
			D[87] = new BidiBracket(12297, 12296, BidiPBA.c);
			D[88] = new BidiBracket(12298, 12299, BidiPBA.o);
			D[89] = new BidiBracket(12299, 12298, BidiPBA.c);
			D[90] = new BidiBracket(12300, 12301, BidiPBA.o);
			D[91] = new BidiBracket(12301, 12300, BidiPBA.c);
			D[92] = new BidiBracket(12302, 12303, BidiPBA.o);
			D[93] = new BidiBracket(12303, 12302, BidiPBA.c);
			D[94] = new BidiBracket(12304, 12305, BidiPBA.o);
			D[95] = new BidiBracket(12305, 12304, BidiPBA.c);
			D[96] = new BidiBracket(12308, 12309, BidiPBA.o);
			D[97] = new BidiBracket(12309, 12308, BidiPBA.c);
			D[98] = new BidiBracket(12310, 12311, BidiPBA.o);
			D[99] = new BidiBracket(12311, 12310, BidiPBA.c);
			D[100] = new BidiBracket(12312, 12313, BidiPBA.o);
			D[101] = new BidiBracket(12313, 12312, BidiPBA.c);
			D[102] = new BidiBracket(12314, 12315, BidiPBA.o);
			D[103] = new BidiBracket(12315, 12314, BidiPBA.c);
			D[104] = new BidiBracket(65113, 65114, BidiPBA.o);
			D[105] = new BidiBracket(65114, 65113, BidiPBA.c);
			D[106] = new BidiBracket(65115, 65116, BidiPBA.o);
			D[107] = new BidiBracket(65116, 65115, BidiPBA.c);
			D[108] = new BidiBracket(65117, 65118, BidiPBA.o);
			D[109] = new BidiBracket(65118, 65117, BidiPBA.c);
			D[110] = new BidiBracket(65288, 65289, BidiPBA.o);
			D[111] = new BidiBracket(65289, 65288, BidiPBA.c);
			D[112] = new BidiBracket(65339, 65341, BidiPBA.o);
			D[113] = new BidiBracket(65341, 65339, BidiPBA.c);
			D[114] = new BidiBracket(65371, 65373, BidiPBA.o);
			D[115] = new BidiBracket(65373, 65371, BidiPBA.c);
			D[116] = new BidiBracket(65375, 65376, BidiPBA.o);
			D[117] = new BidiBracket(65376, 65375, BidiPBA.c);
			D[118] = new BidiBracket(65378, 65379, BidiPBA.o);
			D[119] = new BidiBracket(65379, 65378, BidiPBA.c);
		}
	}
}