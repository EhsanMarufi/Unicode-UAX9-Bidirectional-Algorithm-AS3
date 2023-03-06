/*
 * In the name of God
 * Ehsan Marufi Azar, Oct. 2016 (c)
 * The Paired Bracket Algorithm (PBA) implementation of the Unicode Bidirectional Algorithm (UBA) 9.0.0 (the N0 rule)
 *
 */
package nibblessoft.unicode.bidi {

	/**
	 * Birectional Pair Bracket Algorithm.<br>
	 * An implementation that closely follows the specification of the paired bracket part 
	 * (rule <a href="http://www.unicode.org/reports/tr9/tr9-35.html#N0">N0</a>) of the
	 * Bidirectional Algorithm (UBA) in the Unicode<sup>&reg;</sup> standard version 9.0.0
	 * (<a href="http://www.unicode.org/reports/tr9/tr9-35.html">UAX#9-r35</a>).<br>
	 * The implementation covers definitions BD14-BD16 and rule N0.
	 * <p>
	 * 
	 * In this implementation, a <em>unique</em> numerical identifier common to BOTH parts of the pair
	 * (i.e. the opening bracket and the closing bracket) is expected in the <code>pairValues</code> argument.
	 * The value of <code>0</code> (or any other unique value) may be used as an special identifier for all 
	 * <em>non-bracket</em> characters.<br>
	 * The actual values of these identifiers are not defined and are arbitrary as long as they are unique.
	 * So, one way to assign them is to use the <i>code position value</i> for the closing element of a paired 
	 * set for both opening and closing character &mdash; paying attention to first applying canonical decomposition.
	 * <p>
	 * 
	 * In implementing BD16, this implementation departs slightly from the "logical" algorithm defined
	 * in UAX#9. In particular, the stack referenced there supports operations that go beyond a "basic"
	 * stack. An equivalent implementation based on a linked list is used here.
	 * <p>
	 * 
	 * @author Ehsan Marufi
	 */
	public class BidiPBA {
		
		/*
		 * BD14: An opening paired bracket is a character whose Bidi_Paired_Bracket_Type property value is Open and whose current bidirectional character type is ON.
		 * BD15: A closing paired bracket is a character whose Bidi_Paired_Bracket_Type property value is Close and whose current bidirectional character type is ON.
		 */
		
		// Bidi_Paired_Bracket_Type
		/** Bidi Paired Bracket type: none */
		public static const n:uint = 0;
		/** Bidi Paired Bracket type: opening */
		public static const o:uint = 1;
		/** Bidi Paired Bracket type: closing */
		public static const c:uint = 2;
		
		internal var sos:uint; // direction corresponding to start of sequence
		
		public function BidiPBA() {}
		
		
		
		// The following is a restatement of BD 16 using non-algorithmic language. 
		//
		// A bracket pair is a pair of characters consisting of an opening
		// paired bracket and a closing paired bracket such that the
		// Bidi_Paired_Bracket property value of the former equals the latter,
		// subject to the following constraints.
		// - both characters of a pair occur in the same isolating run sequence
		// - the closing character of a pair follows the opening character
		// - any bracket character can belong at most to one pair, the earliest possible one
		// - any bracket character not part of a pair is treated like an ordinary character
		// - pairs may nest properly, but their spans may not overlap otherwise
		
		// Bracket characters with canonical decompositions are supposed to be treated
		// as if they had been normalized, to allow normalized and non-normalized text
		// to give the same result. In this implementation that step is pushed out to
		// the caller - see definition of the pairValues array.
		
		internal var openers:Vector.<int>; // list of positions for opening brackets
		
		// bracket pair positions sorted by location of opening bracket
		private var pairPositions:Vector.<BracketPair>;
		
		public function getPairPositionsString():String
		{
			var tempPositions:Vector.<BracketPair> = new Vector.<BracketPair>();
			for each (var pair:BracketPair in pairPositions) {
				tempPositions.push(new BracketPair(indexes[pair.getOpener()], indexes[pair.getCloser()]));
			}
			return tempPositions.toString();
		}
		
		
		public var codesIsolatedRun:Vector.<uint>; // directional bidi codes for an isolated run
		private var typesPriorW1:Vector.<uint>;
		private var indexes:Vector.<int>; // array of index values into the original string
		
		/**
		 * check whether characters at putative positions could form a bracket pair
		 * based on the paired bracket character properties
		 * 
		 * @param pairValues
		 *            - unique ID for the pair (or set) of canonically matched
		 *            brackets
		 * @param ichOpener
		 *            - position of the opening bracket
		 * @param ichCloser
		 *            - position of the closing bracket
		 * @return true if match
		 */
		private function matchOpener(pairValues:Vector.<int>, ichOpener:int, ichCloser:int):Boolean {
			return pairValues[indexes[ichOpener]] == pairValues[indexes[ichCloser]];
		}
		
		
		
		/**
		 * locate all Paired Bracket characters and determine whether they form
		 * pairs according to BD16. This implementation uses a linked list instead
		 * of a stack, because, while elements are added at the front (like a push)
		 * there are not generally removed in atomic 'pop' operations, reducing the
		 * benefit of the stack archetype.
		 * 
		 * @param pairTypes
		 *            - array of paired Bracket types
		 * @param pairValues
		 *            - array of characters codes such that for all bracket
		 *            characters it contains the same unique value if their
		 *            Bidi_Paired_Bracket properties map between them. For 
		 *            brackets hat have canonical decompositions (singleton 
		 *            mappings) it contains the same value as for the canonically 
		 *            decomposed character. For characters that have paired 
		 *            bracket type of "n" the value is ignored.
		 */
		private function locateBrackets(pairTypes:Vector.<uint>, pairValues:Vector.<int>):void {
			openers = new Vector.<int>();
			var openersFound:uint = 0;
			pairPositions = new Vector.<BracketPair>();
			
			// traverse the run
			// do that explicitly (not in a for-each) so we can record position
			for (var ich:int = 0; ich < indexes.length; ich++) {
				
				if (codesIsolatedRun[ich] != Bidi.ON)
					continue;
				
				// look at the bracket type for each character
				switch (pairTypes[indexes[ich]]) {
					case n: // default - non paired
						continue; // continue scanning
						
					// opening bracket found, note location
					case o:
						// According to the standard (>=UBA8) the code should proccess at most 63 opening paired bracket! 
						if (++openersFound > 63)
							// Stop processing BD16 for the remainder of the isolating run sequence.
							return;
						
						// remember opener location, most recent first
						openers.insertAt(0, ich);
						break;
					
					// closing bracket found
					case c:
						// see if there is a match
						if (openers.length == 0) // isEmpty?
							continue; // no opening bracket defined
						
						for (var iOpeners:int in openers) {
							var opener:int = openers[iOpeners];
							if (matchOpener(pairValues, opener, ich)) {
								// if the opener matches, add nested pair to the list (not currently sorted)
								pairPositions.push(new BracketPair(opener, ich));
								// remove head, up to and including matched opener
								openers.splice(0, iOpeners+1);
								break;
							}
						}
						// if we get here, the closing bracket matched no openers
						// and gets ignored
						continue;
				}	
			} // end for
			
			// sort by location of opening bracket
			pairPositions.sort(BracketPair.compare);
		}
		
		/*
		* Bracket pairs within an isolating run sequence are processed as units so
		* that both the opening and the closing paired bracket in a pair resolve to
		* the same direction.
		* 
		* N0. Process bracket pairs in an isolating run sequence sequentially in
		* the logical order of the text positions of the opening paired brackets
		* using the logic given below. Within this scope, bidirectional types EN
		* and AN are treated as R.
		* 
		* Identify the bracket pairs in the current isolating run sequence
		* according to BD16. For each bracket-pair element in the list of pairs of
		* text positions:
		* 
		* a Inspect the bidirectional types of the characters enclosed within the
		* bracket pair.
		* 
		* b If any strong type (either L or R) matching the embedding direction is
		* found, set the type for both brackets in the pair to match the embedding
		* direction.
		* 
		* o [ e ] o -> o e e e o
		* 
		* o [ o e ] -> o e o e e
		* 
		* o [ NI e ] -> o e NI e e
		* 
		* c Otherwise, if a strong type (opposite the embedding direction) is
		* found, test for adjacent strong types as follows: 1 First, check
		* backwards before the opening paired bracket until the first strong type
		* (L, R, or sos) is found. If that first preceding strong type is opposite
		* the embedding direction, then set the type for both brackets in the pair
		* to that type. 2 Otherwise, set the type for both brackets in the pair to
		* the embedding direction.
		* 
		* o [ o ] e -> o o o o e
		* 
		* o [ o NI ] o -> o o o NI o o
		* 
		* e [ o ] o -> e e o e o
		* 
		* e [ o ] e -> e e o e e
		* 
		* e ( o [ o ] NI ) e -> e e o o o o NI e e
		* 
		* d Otherwise, do not set the type for the current bracket pair. Note that
		* if the enclosed text contains no strong types the paired brackets will
		* both resolve to the same level when resolved individually using rules N1
		* and N2.
		* 
		* e ( NI ) o -> e ( NI ) o
		*/
		
		/**
		 * map character's directional code to strong type as required by rule N0
		 * 
		 * @param ich
		 *            - index into array of directional codes
		 * @return R or L for strong directional codes, ON for anything else
		 */
		private function getStrongTypeN0(ich:int):uint {
			
			switch (codesIsolatedRun[ich]) {
				default:
					return Bidi.ON;
					// in the scope of N0, number types are treated as R
				case Bidi.EN:
				case Bidi.AN:
				case Bidi.AL:
				case Bidi.R:
					return Bidi.R;
				case Bidi.L:
					return Bidi.L;
			}
		}
		
		/**
		 * determine which strong types are contained inside a Bracket Pair
		 * 
		 * @param pairedLocation
		 *            - a bracket pair
		 * @param dirEmbed
		 *            - the embedding direction
		 * @return ON if no strong type found, otherwise return the embedding
		 *         direction, unless the only strong type found is opposite the
		 *         embedding direction, in which case that is returned
		 */
		internal function classifyPairContent(pairedLocation:BracketPair, dirEmbed:uint):uint {
			var dirOpposite:uint = Bidi.ON;
			for (var ich:int = pairedLocation.getOpener() + 1; ich < pairedLocation.getCloser(); ich++) {
				var dir:uint = getStrongTypeN0(ich);
				if (dir == Bidi.ON)
					continue;
				if (dir == dirEmbed)
					return dir; // type matching embedding direction found
				dirOpposite = dir;
			}
			// return ON if no strong type found, or class opposite to dirEmbed
			return dirOpposite;
		}
		
		/**
		 * determine which strong types are present before a Bracket Pair
		 * 
		 * @param pairedLocation
		 *            - a bracket pair
		 * @return R or L if strong type found, otherwise ON
		 */
		internal function classBeforePair(pairedLocation:BracketPair):uint {
			for (var ich:int = pairedLocation.getOpener() - 1; ich >= 0; --ich) {
				var dir:uint = getStrongTypeN0(ich);
				if (dir != Bidi.ON)
					return dir;
			}
			// no strong types found, return sos
			return sos;
		}
		
		/**
		 * Implement rule N0 for a single bracket pair
		 * 
		 * @param pairedLocation
		 *            - a bracket pair
		 * @param dirEmbed
		 *            - the embedding direction
		 */
		internal function assignBracketType(pairedLocation:BracketPair, dirEmbed:uint):void {
			// rule "N0, a", inspect contents of pair
			var dirPair:uint = classifyPairContent(pairedLocation, dirEmbed);
			
			// dirPair is now L, R, or N (no strong type found)
			
			// the following logical tests are performed out of order compared to
			// the statement of the rules but yield the same results
			if (dirPair == Bidi.ON)
				return; // case "d" - nothing to do
			
			if (dirPair != dirEmbed) {
				// case "c": strong type found, opposite - check before (c.1)
				dirPair = classBeforePair(pairedLocation);
				if (dirPair == dirEmbed || dirPair == Bidi.ON) {
					// no strong opposite type found before - use embedding (c.2)
					dirPair = dirEmbed;
				}
			}
			// else: case "b", strong type found matching embedding,
			// no explicit action needed, as dirPair is already set to embedding
			// direction
			
			// set the bracket types to the type found
			setBracketsToType(pairedLocation, dirPair);
		}
		
		private function setBracketsToType(pairedLocation:BracketPair, dirPair:uint):void {
			codesIsolatedRun[pairedLocation.getOpener()] = dirPair;
			var closerIndex:int = pairedLocation.getCloser();
			codesIsolatedRun[closerIndex] = dirPair;
			
			// Any number of characters that had original bidirectional character type NSM prior to
			// the application of W1 that immediately follow a paired bracket which changed to L or R 
			// under N0 should change to match the type of their preceding bracket.
			var typesLen:uint = typesPriorW1.length, i:uint = closerIndex;
			while (++i < typesLen) {
				if (typesPriorW1[i] == Bidi.NSM)
					codesIsolatedRun[i] = dirPair;
				else break;
			}
		}
		
		// this implements rule N0 for a list of pairs
		public function resolveBrackets(dirEmbed:uint):void {
			for each (var pair:BracketPair in pairPositions) {
				assignBracketType(pair, dirEmbed);
			}
		}
		
		/**
		 * runAlgorithm - runs the paired bracket part of the UBA algorithm
		 * 
		 * @param indexes
		 *            - indexes into the original string
		 * @param codes
		 *            - bidi classes (directional codes) for each character in the
		 *            original string
		 * @param pairTypes
		 *            - array of paired bracket types for each character in the
		 *            original string 
		 * @param pairValues
		 *            - array of unique integers identifying which pair of brackets 
		 *            (or canonically equivalent set) a bracket character
		 *            belongs to. For example in the string "[Test(s)>" the
		 *            characters "(" and ")" would share one value and "[" and ">"
		 *            share another (assuming that "]" and ">" are canonically equivalent).
		 *            Characters that have pairType = n might always get pairValue = 0.
		 *            
		 *            The actual values are no important as long as they are unique,
		 *            so one way to assign them is to use the code position value for
		 *            the closing element of a paired set for both opening and closing
		 *            character - paying attention to first applying canonical decomposition.
		 * @param sos
		 *            - direction for sos
		 * @param level
		 *            - the embedding level
		 */
		public function resolvePairedBrackets(indexes:Vector.<int>, codes:Vector.<uint>, typesPriorW1:Vector.<uint>, pairTypes:Vector.<uint>,
			pairValues:Vector.<int>, sos:uint, level:uint):void {
				var dirEmbed:uint = (1 == (level & 1) ? Bidi.R : Bidi.L);
				this.sos = sos;
				this.indexes = indexes;
				codesIsolatedRun = codes;
				this.typesPriorW1 = typesPriorW1;
				locateBrackets(pairTypes, pairValues);
				resolveBrackets(dirEmbed);
			}
		
		/**
		 * Entry point for testing the BPA algorithm in isolation. Does not use an indexes
		 * array for indirection. Actual work is carried out by resolvePairedBrackets.
		 * 
		 * @param codes
		 *            - bidi classes (directional codes) for each character
		 * @param pairTypes
		 *            - array of paired bracket type values for each character
		 * @param pairValues
		 *            - array of unique integers identifying which bracket pair
		 *            see resolvePairedBrackets for details.
		 * @param sos
		 *            - direction for sos
		 * @param level
		 *            - the embedding level
		 */
		public function runAlgorithm(codes:Vector.<uint>, typesPriorW1:Vector.<uint>, pairTypes:Vector.<uint>,
			pairValues:Vector.<int>, sos:uint, level:uint):void {
				
				// dummy up an indexes array that represents an identity mapping
				this.indexes = new int[codes.length];
				for (var ich:int = 0; ich < indexes.length; ich++)
					indexes[ich] = ich;
				resolvePairedBrackets(indexes, codes, typesPriorW1, pairTypes, pairValues, sos, level);
			}
	}
}
// Holds a pair of index values for opening and closing bracket location of
// a bracket pair
// Contains additional methods to allow pairs to be sorted by the location
// of the opening bracket
internal class BracketPair {
	private var ichOpener:int;
	private var ichCloser:int;
	
	public function BracketPair(ichOpener:int, ichCloser:int) {
		this.ichOpener = ichOpener;
		this.ichCloser = ichCloser;
	}
	
	public function equals(other:Object):Boolean {
		if (other is BracketPair) {
			var otherPair:BracketPair = BracketPair(other);
			return this.ichOpener == otherPair.ichOpener
				&& this.ichCloser == otherPair.ichCloser;
		}
		
		return false;
	}
	
	public static function compare(pairL:BracketPair, pairR:BracketPair):int {
		if (pairL.ichOpener == pairR.ichOpener)
			return 0;
		if (pairL.ichOpener < pairR.ichOpener)
			return -1;
		else
			return 1;
	}
	
	public function toString():String {
		return "(" + ichOpener + ", " + ichCloser + ")";
	}
	
	public function getOpener():int {
		return ichOpener;
	}
	
	public function getCloser():int {
		return ichCloser;
	}
}
