/*
* In the name of God
* Ehsan Marufi Azar, Oct. 2016 (c)
* An implementation of the Unicode Bidirectional Algorithm (UBA) 9.0.0
*
*/
package nibblessoft.unicode.bidi {
	import nibblessoft.unicode.data.MirrorableCharacter;
	import nibblessoft.unicode.data.MirrorableCharacters;

	
	/**
	 * An implementation of the Unicode<sup>&reg;</sup> Bidirectional Algorithm
	 * (described in <a href="http://www.unicode.org/reports/tr9/tr9-35.html">UAX#9-r35</a>).<br>
	 * The implementation closely follows the specification of the Bidirectional Algorithm in the
	 * Unicode<sup>&reg;</sup> standard version 9.0.0.
	 * <p>
	 * To enable clients to evaluate various aspects of implementation conformance, the following
	 * features are retrievable:
	 * <ul>
	 *   <li>Levels array over the entire paragraph,
	 *   <li>Reordering array over the entire paragraph,
	 *   <li>Levels array over a line,
	 *   <li>Reordering array over a line.
	 * </ul>
	 * <p>
	 * The algorithm is defined to operate on a single paragraph at a time, so does this implementation.
	 * <p>
	 * The <em>mapping</em> of the Unicode<sup>&reg;</sup> codepoints to the Unicode<sup>&reg;</sup> properties
	 * is irrelevant to this context. The implementaion expects an array of the
	 * <a href="http://www.unicode.org/reports/tr9/tr9-35.html#Bidirectional_Character_Types"><em>bidirectional types</em></a>
	 * and an array of <em>birectional paired Bracket types</em> corresponding to each input "character" as the input,
	 * not the Unicode<sup>&reg;</sup> codepoints; such mappings are to be performed by the caller.
	 * <p>
	 * Also note that rules L3 and L4 depend on the rendering engine that uses the
	 * result of the Bidi algorithm. This implementation assumes that the rendering
	 * engine expects combining marks in visual order (e.g. to the left of their
	 * base character in RTL runs) and that it adjusts the glyphs used to render
	 * mirrored characters that are in RTL runs so that they render appropriately.
	 * 
	 * <hr>
	 * <small>Note that for conformance to the Unicode<sup>&reg;</sup> Bidirectional Algorithm,
	 * the implementation is only required to generate correct reordering and
	 * character directionality (<em>odd</em> or <em>even</em> levels) over a line. Generating
	 * identical level arrays over a line is not required, while the implementaion generates
	 * identical levels arrays over a line.<br>
	 * The <em>bidirectional explicit format types</em> (LRE, RLE, LRO, RLO, PDF) and BN are assigned
	 * with the arbitrary level value of <code>uint(-1)</code>.</small>
	 * 
	 * @author Ehsan Marufi
	 */
	
	public class Bidi {
		public static const UINT_NEGATIVE_ONE:uint = uint(-1);
		
		/**
		 * A value for the class constructor parameter by which the <em>paragraph embedding level</em>
		 * will be explicitly set to be <code>0</code> (a <em>left-to-right</em> text will always end up with an <em>even</em> level).
		 */
		public static const PARAGRAPH_EMBEDDING_LEVEL_LEFT:uint = 0;
		/**
		 * A value for the class constructor parameter by which the <em>paragraph embedding level</em>
		 * will be explicitly set to be <code>1</code> (a <em>right-to-left</em> text will always end up with an <em>odd</em> level).
		 */
		public static const PARAGRAPH_EMBEDDING_LEVEL_RIGHT:uint = 1;
		/**
		 * A value for the class constructor parameter by which the <em>paragraph embedding level</em> will be
		 * determined implicitly (causes the <em>paragraph embedding level</em> to be eventually render
		 * to eighter <code>0</code> or <code>1</code>, through the rules P2 and P3).
		 */
		public static const PARAGRAPH_EMBEDDING_LEVEL_IMPLICIT:uint = UINT_NEGATIVE_ONE;
		
		internal var paragraphEmbeddingLevel:uint; 
		internal var initialTypes:Vector.<uint>;
		internal var textLength:int; // for convenience
		internal var resultTypes:Vector.<uint>; // for paragraph, not lines
		internal var resultLevels:Vector.<uint>; // for paragraph, not lines
		
		
		/**
		* Index of matching PDI for isolate initiator characters. For other
		* characters, the value of matchingPDI will be set to -1. For isolate
		* initiators with no matching PDI, matchingPDI will be set to the length of
		* the input string.
		*/
		private var matchingPDI:Vector.<int>;
		
		/**
		* Index of matching isolate initiator for PDI characters. For other
		* characters, and for PDIs with no matching isolate initiator, the value of
		* matchingIsolateInitiator will be set to -1.
		*/
		private var matchingIsolateInitiator:Vector.<int>;
		
		
		// Arrays of properties needed for paired bracket evaluation in N0 
		internal var pairTypes:Vector.<uint>; // paired Bracket types for paragraph
		internal var pairValues:Vector.<int>; // paired Bracket values for paragraph
		
		public var pba:BidiPBA; // to allow access to internal pba state for diagnostics
		
		// The bidi types
		
		/** Left-to-right */
		public static const L   : uint = 0;
		
		/** Left-to-Right Embedding */
		public static const LRE : uint = 1;
		
		/** Left-to-Right Override */
		public static const LRO : uint = 2;
		
		/** Right-to-Left */
		public static const R   : uint = 3;
		
		/** Right-to-Left Arabic */
		public static const AL  : uint = 4;
		
		/** Right-to-Left Embedding */
		public static const RLE : uint = 5;
		
		/** Right-to-Left Override */
		public static const RLO : uint = 6;
		
		/** Pop Directional Format */
		public static const PDF : uint = 7;
		
		/** European Number */
		public static const EN  : uint = 8;
		
		/** European Number Separator */
		public static const ES  : uint = 9;
		
		/** European Number Terminator */
		public static const ET  : uint = 10;
		
		/** Arabic Number */
		public static const AN  : uint = 11;
		
		/** Common Number Separator */
		public static const CS  : uint = 12;
		
		/** Non-Spacing Mark */
		public static const NSM : uint = 13;
		
		/** Boundary Neutral */
		public static const BN  : uint = 14;
		
		/** Paragraph Separator */
		public static const B   : uint = 15;
		
		/** Segment Separator */
		public static const S   : uint = 16;
		
		/** Whitespace */
		public static const WS  : uint = 17;
		
		/** Other Neutrals */
		public static const ON  : uint = 18;
		
		/** Left-to-Right Isolate */
		public static const LRI : uint = 19;
		
		/** Right-to-Left Isolate */
		public static const RLI : uint = 20;
		
		/** First-Strong Isolate */
		public static const FSI : uint = 21;
		
		/** Pop Directional Isolate */
		public static const PDI : uint = 22;
		
		/** Minimum bidi type value. */
		public static const TYPE_MIN:uint = 0;
		
		/** Maximum bidi type value. */
		public static const TYPE_MAX:uint = 22;
		
		/** Shorthand names of bidi type values, for error reporting. */
		public static const typenames:Vector.<String> = new Vector.<String>(TYPE_MAX+1, true);
		typenames[ 0] = "L";
		typenames[ 1] = "LRE";
		typenames[ 2] = "LRO";
		typenames[ 3] = "R";
		typenames[ 4] = "AL";
		typenames[ 5] = "RLE";
		typenames[ 6] = "RLO";
		typenames[ 7] = "PDF";
		typenames[ 8] = "EN";
		typenames[ 9] = "ES";
		typenames[10] = "ET";
		typenames[11] = "AN";
		typenames[12] = "CS";
		typenames[13] = "NSM";
		typenames[14] = "BN";
		typenames[15] = "B";
		typenames[16] = "S";
		typenames[17] = "WS";
		typenames[18] = "ON";
		typenames[19] = "LRI";
		typenames[20] = "RLI";
		typenames[21] = "FSI";
		typenames[22] = "PDI";
		
		//*
		//* Input
		//*
		
		/**
		 * The Unicode<sup>&reg;</sup> Bidirectional Algorithm entry point.<p>
		 *
		 * @param types
		 *            An array of <a href="http://www.unicode.org/reports/tr9/tr9-35.html#Bidirectional_Character_Types">bidirectional types</a>:
		 *            Array of types ranging from <code>TYPE_MIN</code> to <code>TYPE_MAX</code>, inclusive, 
		 *            representing the directional codes of the characters in the text.<br>
		 *            The algorithm is defined to operate on a single paragraph at a time, so does this implementation;
		 *            thus rule P1 is presumed by this implementation &mdash; the data provided to the implementation is
		 *            assumed to be a single paragraph, so, the input data either contains no <code>B</code> bidirectional-type,
		 *            or has a single <code>B</code> type at the end of the input.<p>
		 * 
		 * @param pairTypes
		 *           A paired bracket types array: Array of paired bracket types for each character, whose 
		 *           entries are one of:
		 *           <ul>
		 *             <li><code>BidiPBA.n</code> (equivalent to the value of <code>0</code>), 
		 *             <li><code>BidiPBA.o</code> (equivalent to the value of <code>1</code>), or
		 *             <li><code>BidiPBA.c</code> (equivalent to the value of <code>2</code>);
		 *           </ul>
		 *           representing a <em>none</em>, <em>opening</em> or <em>closing</em> paired bracket character types, respectively.<p>
		 * 
		 * @param pairValues
		 *           An array of <em>unique</em> integers identifying which pair of brackets 
		 *           (or canonically equivalent set) a bracket character belongs to. For example in the
		 *           string "[Test(s)>" the characters "(" and ")" would share one value and "[" and ">"
		 *           share another (assuming that "]" and ">" are canonically equivalent).
		 *           Characters that have <code>pairType=n</code>, might always get <code>pairValue=0</code>.<br>
		 *            
		 *           The actual values are no important as long as they are unique,
		 *           so one way to assign them is to use the <i>code position value</i> for
		 *           the closing element of a paired set for both opening and closing
		 *           character &mdash; paying attention to first applying canonical decomposition.<p>
		 * 
		 * @param paragraphEmbeddingLevel
		 *            The externally supplied paragraph embedding level.<br>
		 *            Use <code>PARAGRAPH_EMBEDDING_LEVEL_IMPLICIT</code> to detect the paragraph embedding level
		 *            implicitly using the default behaviour of the algorithm (rules P2 and P3). Also, you may use the
		 *            <code>PARAGRAPH_EMBEDDING_LEVEL_LEFT</code> for left-to-right paragraphs or use the
		 *            <code>PARAGRAPH_EMBEDDING_LEVEL_RIGHT</code> for right-to-left paragraphs.
		 */
		public function Bidi(types:Vector.<uint>, pairTypes:Vector.<uint>, pairValues:Vector.<int>, paragraphEmbeddingLevel:uint = PARAGRAPH_EMBEDDING_LEVEL_IMPLICIT) {
			validateTypes(types);
			validatePbTypes(pairTypes);
			validatePbValues(pairValues, pairTypes);
			validateParagraphEmbeddingLevel(paragraphEmbeddingLevel);
			
			this.paragraphEmbeddingLevel = paragraphEmbeddingLevel;
			
			// Store an independent clone of the input types.
			// The 'concat' method is the tricky way of cloning a vector array
			this.initialTypes = types.concat();

			this.pairTypes = pairTypes;
			this.pairValues = pairValues;
			
			runAlgorithm();
		}
		
		/**
		 * The algorithm. Does not include line-based processing (Rules L1, L2).
		 * These are applied later in the line-based phase of the algorithm.
		 */
		private function runAlgorithm():void {
			textLength = initialTypes.length;
			
			// Initialize output types.
			// Result types initialized to input types.
			resultTypes = initialTypes.concat(); // The 'concat' method causes an independent clone to be generated
			
			// Preprocessing to find the matching isolates
			determineMatchingIsolates();
			
			// 1) determining the paragraph level
			// Rule P1 is the requirement for entering this algorithm.
			// Rules P2, P3.
			// If no externally supplied paragraph embedding level, use default.
			if (paragraphEmbeddingLevel == PARAGRAPH_EMBEDDING_LEVEL_IMPLICIT) {
				paragraphEmbeddingLevel = determineParagraphEmbeddingLevel(0, textLength);
			}
			
			resultLevels = new Vector.<uint>(textLength, true); // Initializes all of them with 0
			
			// 2) Explicit levels and directions
			// Rules X1-X8.
			determineExplicitEmbeddingLevels();
			
			// Rule X9.
			// We do not remove the embeddings, the overrides, the PDFs, and the BNs
			// from the string explicitly. But the types are not copied into isolating run
			// sequences when they are created, so they are removed for all practical purposes.
			
			
			// Rule X10.
			// Run remainder of the algorithm one isolating run sequence at a time
			var sequences:Vector.<IsolatingRunSequence> = determineIsolatingRunSequences();
			
			for (var i:int = 0; i < sequences.length; ++i) {
				var sequence:IsolatingRunSequence = sequences[i];
				
				// 3) resolving weak types
				// Rules W1-W7.
				sequence.resolveWeakTypes();
				
				// 4a) resolving paired brackets
				// Rule N0
				sequence.resolvePairedBrackets();
				
				// 4b) resolving neutral types
				// Rules N1-N3.
				sequence.resolveNeutralTypes();
				
				// 5) resolving implicit embedding levels
				// Rules I1, I2.
				sequence.resolveImplicitLevels();
				
				// Apply the computed levels and types
				sequence.applyLevelsAndTypes();
			}
			
			// Assign appropriate levels to 'hide' LREs, RLEs, LROs, RLOs, PDFs, and
			// BNs. This is for convenience, so the resulting level array will have
			// a value for every character.
			assignLevelsToCharactersRemovedByX9();
		}
		
		/**
		 * Determine the matching PDI for each isolate initiator and vice versa.
		 * <p>
		 * Definition BD9.
		 * <p>
		 * At the end of this function:
		 * <ul>
		 * <li>The member variable matchingPDI is set to point to the index of the
		 * matching PDI character for each isolate initiator character. If there is
		 * no matching PDI, it is set to the length of the input text. For other
		 * characters, it is set to -1.
		 * <li>The member variable matchingIsolateInitiator is set to point to the
		 * index of the matching isolate initiator character for each PDI character.
		 * If there is no matching isolate initiator, or the character is not a PDI,
		 * it is set to -1.
		 * </ul>
		 */
		private function determineMatchingIsolates():void {
			matchingPDI = new Vector.<int>(textLength, true);
			matchingIsolateInitiator = new Vector.<int>(textLength, true);
			
			var i:int;
			for (i = 0; i < textLength; ++i) {
				matchingIsolateInitiator[i] = -1;
			}
			
			for (i = 0; i < textLength; ++i) {
				matchingPDI[i] = -1;
				
				var t:uint = resultTypes[i];
				if (t == LRI || t == RLI || t == FSI) {
					var depthCounter:int = 1;
					for (var j:int = i + 1; j < textLength; ++j) {
						var u:uint = resultTypes[j];
						if (u == LRI || u == RLI || u == FSI) {
							++depthCounter;
						} else if (u == PDI) {
							--depthCounter;
							if (depthCounter == 0) {
								matchingPDI[i] = j;
								matchingIsolateInitiator[j] = i;
								break;
							}
						}
					}
					if (matchingPDI[i] == -1) {
						matchingPDI[i] = textLength;
					}
				}
			}
		}
		
		/**
		 * Determines the paragraph level based on rules P2, P3. This is also used
		 * in rule X5c to find if an FSI should resolve to LRI or RLI.
		 *
		 * @param startIndex
		 *            the index of the beginning of the substring
		 * @param endIndex
		 *            the index of the character after the end of the string
		 *
		 * @return the resolved paragraph direction of the substring limited by
		 *         startIndex and endIndex
		 */
		private function determineParagraphEmbeddingLevel(startIndex:int, endIndex:int):uint {
			var strongType:uint = Bidi.UINT_NEGATIVE_ONE; // unknown
			
			// Rule P2.
			for (var i:int = startIndex; i < endIndex; ++i) {
				var t:uint = resultTypes[i];
				if (t == L || t == AL || t == R) {
					strongType = t;
					break;
				} else if (t == FSI || t == LRI || t == RLI) {
					i = matchingPDI[i]; // skip over to the matching PDI
					
					if (i > endIndex)
						throw new Error("Assertion failed!");
				}
			}
			
			// Rule P3.
			if (strongType == Bidi.UINT_NEGATIVE_ONE) { // none found
				// default embedding level when no strong types found is 0.
				return 0;
			} else if (strongType == L) {
				return 0;
			} else { // AL, R
				return 1;
			}
		}
		
		public static const MAX_DEPTH:int = 125;
		

		/**
		 * Determine explicit levels using rules X1 - X8
		 */
		private function determineExplicitEmbeddingLevels():void {
			var stack:directionalStatusStack = new directionalStatusStack();
			var overflowIsolateCount:int, overflowEmbeddingCount:int, validIsolateCount:int;
			
			// Rule X1.
			stack.empty();
			stack.push(paragraphEmbeddingLevel, ON, false);
			overflowIsolateCount = 0;
			overflowEmbeddingCount = 0;
			validIsolateCount = 0;
			for (var i:int = 0; i < textLength; ++i) {
				var t:uint = resultTypes[i];
				
				var newLevel:uint, lastDirectionalOverride:uint;
				switch (t) {
					// Rule X2
					case RLE:
						newLevel = (uint) ((stack.lastEmbeddingLevel() + 1) | 1); // least greater odd
						if (newLevel <= MAX_DEPTH && overflowIsolateCount == 0 && overflowEmbeddingCount == 0) {
							// valid RLE
							stack.push(newLevel, ON, false);
						} else // this is an overflow RLE 
							if (overflowIsolateCount == 0) {
							++overflowEmbeddingCount;
						}
						break;
					
					// Rule X3
					case LRE:
						newLevel = (uint) ((stack.lastEmbeddingLevel() + 2) & ~1); // least greater even
						if (newLevel <= MAX_DEPTH && overflowIsolateCount == 0 && overflowEmbeddingCount == 0) {
							// valid LRE
							stack.push(newLevel, ON, false);
						} else // this is an overflow LRE 
							if (overflowIsolateCount == 0) {
							++overflowEmbeddingCount;
						}
						break;
					
					// Rule X4
					case RLO:
						newLevel = (uint) ((stack.lastEmbeddingLevel() + 1) | 1); // least greater odd
						if (newLevel <= MAX_DEPTH && overflowIsolateCount == 0 && overflowEmbeddingCount == 0) {
							// valid RLO
							stack.push(newLevel, R, false);
						} else // this is an overflow RLO
							if (overflowIsolateCount == 0) {
								++overflowEmbeddingCount;
							}
						break;
					
					// Rule X5
					case LRO:
						newLevel = (uint) ((stack.lastEmbeddingLevel() + 2) & ~1); // least greater even
						if (newLevel <= MAX_DEPTH && overflowIsolateCount == 0 && overflowEmbeddingCount == 0) {
							// valid RLO
							stack.push(newLevel, L, false);
						} else // this is an overflow RLO
							if (overflowIsolateCount == 0) {
								++overflowEmbeddingCount;
							}
						break;
					
					// Rule X5a
					case RLI:
						resultLevels[i] = stack.lastEmbeddingLevel();
						lastDirectionalOverride = stack.lastDirectionalOverrideStatus();
						if (lastDirectionalOverride != ON)
							resultTypes[i] = lastDirectionalOverride;
						
						newLevel = (uint) ((stack.lastEmbeddingLevel() + 1) | 1); // least greater odd
						if (newLevel <= MAX_DEPTH && overflowIsolateCount == 0 && overflowEmbeddingCount == 0) {
							// valid RLI
							++validIsolateCount;
							stack.push(newLevel, ON, true);
						} else // this is an overflow RLI
							++overflowIsolateCount;
						break;
					
					// Rule X5b
					case LRI:
						resultLevels[i] = stack.lastEmbeddingLevel();
						lastDirectionalOverride = stack.lastDirectionalOverrideStatus();
						if (lastDirectionalOverride != ON)
							resultTypes[i] = lastDirectionalOverride;
						
						newLevel = (uint) ((stack.lastEmbeddingLevel() + 2) & ~1); // least greater even
						if (newLevel <= MAX_DEPTH && overflowIsolateCount == 0 && overflowEmbeddingCount == 0) {
							// valid LRI
							++validIsolateCount;
							stack.push(newLevel, ON, true);
						} else // this is an overflow LRI
							++overflowIsolateCount;
						break;
					
					// Rule X5c
					case FSI:
						if (determineParagraphEmbeddingLevel(i + 1, matchingPDI[i]) == 1) {
							// Treat the FSI as an RLI in rule X5a
							resultLevels[i] = stack.lastEmbeddingLevel();
							lastDirectionalOverride = stack.lastDirectionalOverrideStatus();
							if (lastDirectionalOverride != ON)
								resultTypes[i] = lastDirectionalOverride;
							
							newLevel = (uint) ((stack.lastEmbeddingLevel() + 1) | 1); // least greater odd
							if (newLevel <= MAX_DEPTH && overflowIsolateCount == 0 && overflowEmbeddingCount == 0) {
								// valid RLI
								++validIsolateCount;
								stack.push(newLevel, ON, true);
							} else // this is an overflow RLI
								++overflowIsolateCount;
							
						} else {
							// Otherwise, treat it as an LRI in rule X5b
							resultLevels[i] = stack.lastEmbeddingLevel();
							lastDirectionalOverride = stack.lastDirectionalOverrideStatus();
							if (lastDirectionalOverride != ON)
								resultTypes[i] = lastDirectionalOverride;
							
							newLevel = (uint) ((stack.lastEmbeddingLevel() + 2) & ~1); // least greater even
							if (newLevel <= MAX_DEPTH && overflowIsolateCount == 0 && overflowEmbeddingCount == 0) {
								// valid LRI
								++validIsolateCount;
								stack.push(newLevel, ON, true);
							} else // this is an overflow LRI
								++overflowIsolateCount;
						}
						
						break;
					
					// Rule X6a
					case PDI:
						if (overflowIsolateCount > 0) {
							// This PDI matches an overflow isolate initiator
							--overflowIsolateCount;
						} else if (validIsolateCount == 0) {
							// This PDI does not match any isolate initiator, valid or overflow.
							// Do nothing
						} else {
							// This PDI matches a valid isolate initiator
							overflowEmbeddingCount = 0;
							while (!stack.lastDirectionalIsolateStatus()) {
								stack.pop();
							}
							stack.pop();
							--validIsolateCount;
						}
						resultLevels[i] = stack.lastEmbeddingLevel();
						lastDirectionalOverride = stack.lastDirectionalOverrideStatus();
						if (lastDirectionalOverride != ON)
							resultTypes[i] = lastDirectionalOverride;
						break;
					
					// Rule X7
					case PDF:
						if (overflowIsolateCount > 0) {
							// This PDF is within the scope of an overflow isolate initiator.
							// It either matches and terminates the scope of an overflow embedding initiator
							// within that overflow isolate, or does not match any embedding initiator.
							// Do nothing.
						} else if (overflowEmbeddingCount > 0) {
							// This PDF matches and terminates the scope of an overflow embedding initiator
							// that is not within the scope of an overflow isolate initiator.
							--overflowEmbeddingCount;
						} else if (!stack.lastDirectionalIsolateStatus() && stack.depth() >= 2) {
							// This PDF matches and terminates the scope of a valid embedding initiator.
							stack.pop();
						} else {
							// This PDF does not match any embedding initiator.
							// Do nothing
						}
						break;
					
					// Rule X8.
					case B:
						// These values are reset for clarity, in this implementation B
						// can only occur as the last code in the array.
						stack.empty();
						overflowIsolateCount = 0;
						overflowEmbeddingCount = 0;
						validIsolateCount = 0;
						resultLevels[i] = paragraphEmbeddingLevel;
						break;
					
					default:
						if (t != BN) { // The BN is not considered in any of the cases above, and the
							           // following instructions are not neighter supposed to be carried 
									   // on it nor on any of the other cases considered above.
							resultLevels[i] = stack.lastEmbeddingLevel();
							lastDirectionalOverride = stack.lastDirectionalOverrideStatus();
							if (lastDirectionalOverride != ON)
								resultTypes[i] = lastDirectionalOverride;
						}
						
						break;
				}
			}
		}
		

		
		/**
		 * Determines the level runs. Rule X9 will be applied in determining the
		 * runs, in the way that makes sure the characters that are supposed to be
		 * removed are not included in the runs.
		 *
		 * @return an array of level runs. Each level run is described as an array
		 *         of indexes into the input string.
		 */
		private function determineLevelRuns():Vector.<Vector.<int>> {
			// temporary array to hold the run
			var temporaryRun:Vector.<int> = new Vector.<int>(textLength, true);
			// temporary array to hold the list of runs
			var allRuns:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(textLength, true);
			var numRuns:int = 0;
			
			var currentLevel:uint = Bidi.UINT_NEGATIVE_ONE;
			var runLength:int = 0, run:Vector.<int>;
			for (var i:int = 0; i < textLength; ++i) {
				if (!isRemovedByX9(initialTypes[i])) {
					if (resultLevels[i] != currentLevel) { 
						// we just encountered a new run
						// Wrap up last run
						if (currentLevel != Bidi.UINT_NEGATIVE_ONE) { // only wrap it up if there was a run
							run = VectorUtil.copyIntVector(temporaryRun, runLength);
							allRuns[numRuns++] = run;
						}
						// Start new run
						currentLevel = resultLevels[i];
						runLength = 0;
					}
					temporaryRun[runLength++] = i;
				}
			}
			// Wrap up the final run, if any
			if (runLength != 0) {
				run = VectorUtil.copyIntVector(temporaryRun, runLength);
				allRuns[numRuns++] = run;
			}
			
			return VectorUtil.copy2DIntVector(allRuns, numRuns);
		}
		
		
		
		/**
		 * Definition BD13. Determine isolating run sequences.
		 *
		 * @return an array of isolating run sequences.
		 */
		private function determineIsolatingRunSequences():Vector.<IsolatingRunSequence> {
			var levelRuns:Vector.<Vector.<int>> = determineLevelRuns();
			var numRuns:int = levelRuns.length, i:int;
			
			// Compute the run that each character belongs to
			var runForCharacter:Vector.<int> = new Vector.<int>(textLength, true);
			for (var runNumber:int = 0; runNumber < numRuns; ++runNumber) {
				for (i = 0; i < levelRuns[runNumber].length; ++i) {
					var characterIndex:int = levelRuns[runNumber][i];
					runForCharacter[characterIndex] = runNumber;
				}
			}
			
			var sequences:Vector.<IsolatingRunSequence> = new Vector.<IsolatingRunSequence>(numRuns, true);
			var numSequences:int = 0;
			var currentRunSequence:Vector.<int> = new Vector.<int>(textLength, true);
			for (i = 0; i < levelRuns.length; ++i) {
				var firstCharacter:int = levelRuns[i][0];
				if (initialTypes[firstCharacter] != PDI || matchingIsolateInitiator[firstCharacter] == -1) {
					var currentRunSequenceLength:int = 0;
					var run:int = i;
					do {
						// Copy this level run into currentRunSequence
						VectorUtil.vectorCopyInt(levelRuns[run], 0, currentRunSequence, currentRunSequenceLength, levelRuns[run].length);
						currentRunSequenceLength += levelRuns[run].length;
						
						var lastCharacter:int = currentRunSequence[currentRunSequenceLength - 1];
						var lastType:uint = initialTypes[lastCharacter];
						if ((lastType == LRI || lastType == RLI || lastType == FSI) &&
							matchingPDI[lastCharacter] != textLength) {
							run = runForCharacter[matchingPDI[lastCharacter]];
						} else {
							break;
						}
					} while (true);
					
					sequences[numSequences++] = new IsolatingRunSequence(
						VectorUtil.copyIntVector(currentRunSequence, currentRunSequenceLength),
						this
					);
				}
			}

			var seqCopy:Vector.<IsolatingRunSequence> = new Vector.<IsolatingRunSequence>(numSequences, true);
			for (var l:uint = 0; l<numSequences; l++)
				seqCopy[l] = sequences[l];
			return seqCopy;
		}
		
		/**
		 * Assign level information to characters removed by rule X9. This is for
		 * ease of relating the level information to the original input data. Note
		 * that the levels assigned to these bidi types are arbitrary, they're chosen 
		 * in such a way to avoid breaking level runs.
		 */
		private function assignLevelsToCharactersRemovedByX9():void {
			var i:int;
			for (i = 0; i < initialTypes.length; ++i) {
				var t:uint = initialTypes[i];
				if (t == LRE || t == RLE || t == LRO || t == RLO || t == PDF || t == BN) {
					resultTypes[i] = t;
					resultLevels[i] = UINT_NEGATIVE_ONE;
				}
			}
			
			// now propagate forward the levels information (could have
			// propagated backward, the main thing is not to introduce a level
			// break where one doesn't already exist).
			/*
			if (resultLevels[0] == -1) {
				resultLevels[0] = paragraphEmbeddingLevel;
			}
			for (i = 1; i < initialTypes.length; ++i) {
				if (resultLevels[i] == -1) {
					resultLevels[i] = resultLevels[i - 1];
				}
			}
			*/
			// Embedding information is for informational purposes only
			// so need not be adjusted.
		}
		
		
		
		//*
		//* Output
		//*
		
		// for display in test mode
		public function getResultTypes():Vector.<uint> {
			return resultTypes.concat();
		}
		
		/**
		 * Return levels array breaking lines at offsets in linebreaks. <br>
		 * Rule L1.
		 * <p>
		 * The returned levels array contains the resolved level for each bidi code
		 * passed to the constructor.
		 * <p>
		 * The linebreaks array must include at least one value. The values must be
		 * in strictly increasing order (no duplicates) between 1 and the length of
		 * the text, inclusive. The last value must be the length of the text.
		 *
		 * @param linebreaks
		 *            the offsets at which to break the paragraph
		 * @return the resolved levels of the text
		 */
		public function getLevels(linebreaks:Vector.<int>):Vector.<uint> {
			
			// Note that since the previous processing has removed all
			// P, S, and WS values from resultTypes, the values referred to
			// in these rules are the initial types, before any processing
			// has been applied (including processing of overrides).
			//
			// This example implementation has reinserted explicit format codes
			// and BN, in order that the levels array correspond to the
			// initial text. Their final placement is not normative.
			// These codes are treated like WS in this implementation,
			// so they don't interrupt sequences of WS.
			
			validateLineBreaks(linebreaks, textLength);
			
			var result:Vector.<uint> = resultLevels.concat();
			
			// don't worry about linebreaks since if there is a break within
			// a series of WS values preceding S, the linebreak itself
			// causes the reset.
			var i:int, j:int;
			for (i = 0; i < result.length; ++i) {
				var t:uint = initialTypes[i];
				if (t == B || t == S) {
					// Rule L1, clauses one and two.
					result[i] = paragraphEmbeddingLevel;
					
					// Rule L1, clause three.
					for (j = i - 1; j >= 0; --j) {
						if (isWhitespace(initialTypes[j])) { // including format codes
							result[j] = paragraphEmbeddingLevel;
						} else {
							break;
						}
					}
				}
			}
			
			// Rule L1, clause four.
			var start:int = 0;
			for (i = 0; i < linebreaks.length; ++i) {
				var limit:int = linebreaks[i];
				for (j = limit - 1; j >= start; --j) {
					if (isWhitespace(initialTypes[j])) { // including format codes
						result[j] = paragraphEmbeddingLevel;
					} else {
						break;
					}
				}
				
				start = limit;
			}
			
			return result;
		}
		
		/**
		 * Return reordering array breaking lines at offsets in linebreaks.
		 * <p>
		 * The reordering array maps from a visual index to a logical index. Lines
		 * are concatenated from left to right. So for example, the fifth character
		 * from the left on the third line is
		 *
		 * <pre>
		 * getReordering(linebreaks)[linebreaks[1] + 4]
		 * </pre>
		 *
		 * (linebreaks[1] is the position after the last character of the second
		 * line, which is also the index of the first character on the third line,
		 * and adding four gets the fifth character from the left).
		 * <p>
		 * The linebreaks array must include at least one value. The values must be
		 * in strictly increasing order (no duplicates) between 1 and the length of
		 * the text, inclusive. The last value must be the length of the text.
		 *
		 * @param linebreaks
		 *            the offsets at which to break the paragraph.
		 */
		public function getReordering(linebreaks:Vector.<int>):Vector.<int> {
			validateLineBreaks(linebreaks, textLength);
			
			var levels:Vector.<uint> = getLevels(linebreaks);
			
			return computeMultilineReordering(levels, linebreaks);
		}
		
		/**
		 * Return multiline reordering array for a given level array.
		 * Reordering does not occur across a line break.
		 */
		private static function computeMultilineReordering(levels:Vector.<uint>, linebreaks:Vector.<int>):Vector.<int> {
			var result:Vector.<int> = new Vector.<int>(levels.length, true);
			
			var start:int = 0;
			for (var i:int = 0; i < linebreaks.length; ++i) {
				var limit:int = linebreaks[i];
				
				var templevels:Vector.<uint> = new Vector.<uint>(limit - start, true);
				VectorUtil.vectorCopyUint(levels, start, templevels, 0, templevels.length);
				
				var temporder:Vector.<int> = computeReordering(templevels);
				for (var j:int = 0; j < temporder.length; ++j) {
					result[start + j] = temporder[j] + start;
				}
				
				start = limit;
			}
			
			return result;
		}
		
		/**
		 * Return reordering array for a given level array. This reorders a single
		 * line. The reordering is a visual to logical map. For example, the
		 * leftmost char is string.charAt(order[0]). Rule L2.
		 */
		private static function computeReordering(levels:Vector.<uint>):Vector.<int> {
			var lineLength:int = levels.length;
			
			var result:Vector.<int> = new Vector.<int>(lineLength, true);
			
			// initialize order
			for (var i:int = 0; i < lineLength; ++i) {
				result[i] = i;
			}
			
			// locate highest level found on line.
			// Note the rules say text, but no reordering across line bounds is
			// performed, so this is sufficient.
			var highestLevel:uint = 0;
			var lowestOddLevel:uint = MAX_DEPTH + 2;
			var level:uint;

			for (i = 0; i < lineLength; ++i) {
				level = levels[i];
				if (level != Bidi.UINT_NEGATIVE_ONE && level > highestLevel) {
					highestLevel = level;
				}
				if (((level & 1) != 0) && level < lowestOddLevel) {
					lowestOddLevel = level;
				}
			}
			
			for (level = highestLevel; level >= lowestOddLevel; --level) {
				for (i = 0; i < lineLength; ++i) {
					if (levels[i] >= level) {
						// find range of text at or above this level
						var start:int = i;
						var limit:int = i + 1;
						while (limit < lineLength && levels[limit] >= level) {
							++limit;
						}
						
						// reverse run
						for (var j:int = start, k:int = limit - 1; j < k; ++j, --k) {
							var temp:int = result[j];
							result[j] = result[k];
							result[k] = temp;
						}
						
						// skip to end of level run
						i = limit;
					}
				}
			}
			
			return result;
		}
	
		
		/**
		 * Rule L4 
		 * @param str
		 * @param resolvedLevels
		 * @return 
		 * 
		 */
		public static function mirrorCharactersAppropriatly(str:String, resolvedLevels:Vector.<uint>):String {
			var len:uint = str.length;
			if (len != resolvedLevels.length)
				throw new Error("The length of the string and the resolved-levels' count don't match!");
			
			var arrOut:Vector.<String> = new Vector.<String>(len, true);
			var mirrorableCharacter:MirrorableCharacter;
			for (var i:uint = 0; i < len; ++i) {
				// By default, the input character is copied over.
				// (It will be changed, if the criteria of the rule L4 holds.)
				arrOut[i] = str.charAt(i);
				
				// L4-a: if the resolved directionality of that character is R (is an odd value)
				if ((resolvedLevels[i] & 1) == 1) {
					// L4-b: if the 'Bidi_Mirrored' property value of that character is 'Yes'.
					mirrorableCharacter = MirrorableCharacters.getMirroredCharacter(str.charCodeAt(i));
					if (mirrorableCharacter != null && !isNaN(mirrorableCharacter.mirroredGlyphCodepoint)) {
						arrOut[i] = String.fromCharCode(mirrorableCharacter.mirroredGlyphCodepoint);
					}
				}
			}
			
			return arrOut.join("");
		}
		
		/**
		 * Returns the base level of the paragraph.
		 */
		public function getBaseLevel():uint {
			return paragraphEmbeddingLevel;
		}
		
		// --- internal utilities -------------------------------------------------
		
		/**
		 * Returns <code>true</code>, if the specified type is considered a whitespace type for the line break rules.
		 */
		private static function isWhitespace(bidiType:uint):Boolean {
			switch (bidiType) {
				case LRE:
				case RLE:
				case LRO:
				case RLO:
				case PDF:
				case LRI:
				case RLI:
				case FSI:
				case PDI:
				case BN:
				case WS:
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * Returns <code>true</code>, if the specified type is one of the types removed in X9.
		 * Made public so callers can duplicate the effect.
		 */
		public static function isRemovedByX9(bidiType:uint):Boolean {
			switch (bidiType) {
				case LRE:
				case RLE:
				case LRO:
				case RLO:
				case PDF:
				case BN:
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * Returns the strong type (L or R) corresponding to the level.<br>
		 * <em>Even-numbered levels</em> result in an 'L' and <em>odd-numbered levels</em> result in an 'R'. 
		 */
		internal static function typeForLevel(level:int):uint {
			return ((level & 0x1) == 0) ? L : R;
		}
		
		/**
		 * Set levels from start up to (but not including) limit to newLevel.
		 */
		internal function setLevels(levels:Vector.<uint>, start:int, limit:int, newLevel:uint):void {
			for (var i:int = start; i < limit; ++i) {
				levels[i] = newLevel;
			}
		}
		
		// --- input validation ---------------------------------------------------
		
		/**
		 * Throw exception if type array is invalid.
		 */
		private static function validateTypes(types:Vector.<uint>):void {
			if (types == null) {
				throw new ArgumentError("types is null");
			}
			var i:int;
			for (i = 0; i < types.length; ++i) {
				if (types[i] < TYPE_MIN || types[i] > TYPE_MAX) {
					throw new ArgumentError("illegal type value at " + i + ": " + types[i]);
				}
			}
			for (i = 0; i < types.length - 1; ++i) {
				if (types[i] == B) {
					throw new ArgumentError("B type before end of paragraph at index: " + i);
				}
			}
		}
		
		/**
		 * Throw exception if paragraph embedding level is invalid. Special
		 * allowance for implicitEmbeddinglevel so that default processing of the
		 * paragraph embedding level as implicit can still be performed when
		 * using this API.
		 */
		private static function validateParagraphEmbeddingLevel(paragraphEmbeddingLevel:uint):void {
			if (paragraphEmbeddingLevel != PARAGRAPH_EMBEDDING_LEVEL_IMPLICIT &&
				paragraphEmbeddingLevel != 0 &&
				paragraphEmbeddingLevel != 1) {
				throw new ArgumentError("illegal paragraph embedding level: " + paragraphEmbeddingLevel);
			}
		}
		
		/**
		 * Throw exception if line breaks array is invalid.
		 */
		private static function validateLineBreaks(linebreaks:Vector.<int>, textLength:int):void {
			var prev:int = 0;
			for (var i:int = 0; i < linebreaks.length; ++i) {
				var next:int = linebreaks[i];
				if (next <= prev) {
					throw new ArgumentError("bad linebreak: " + next + " at index: " + i);
				}
				prev = next;
			}
			if (prev != textLength) {
				throw new ArgumentError("last linebreak must be at " + textLength);
			}
		}
		
		/**
		 * Throw exception if pairTypes array is invalid
		 */
		private static function validatePbTypes(pairTypes:Vector.<uint>):void {
			if (pairTypes == null) {
				throw new ArgumentError("pairTypes is null");
			}
			for (var i:int = 0; i < pairTypes.length; ++i) {
				if (pairTypes[i] < BidiPBA.n || pairTypes[i] > BidiPBA.c) {
					throw new ArgumentError("illegal pairType value at " + i + ": " + pairTypes[i]);
				}
			}
		}
		
		/**
		 * Throw exception if pairValues array is invalid or doesn't match pairTypes in length
		 * Unfortunately there's little we can do in terms of validating the values themselves
		 */
		private static function validatePbValues(pairValues:Vector.<int>, pairTypes:Vector.<uint>):void {
			if (pairValues == null) {
				throw new ArgumentError("pairValues is null");
			}
			if (pairTypes.length != pairValues.length) {
				throw new ArgumentError("pairTypes is different length from pairValues");
			}
		}
		
		/**
		 * Static entry point for the Unicode<sup>&reg;</sup> Bidirectional Algorithm.<p>
		 * @see #Bidi() Bidi()
		 */
		public static function analyzeInput(types:Vector.<uint>, pairTypes:Vector.<uint>, pairValues:Vector.<int>, paragraphEmbeddingLevel:uint):Bidi {
			return new Bidi(types, pairTypes, pairValues, paragraphEmbeddingLevel);
		}
		
	}
}

import org.unicode.bidi.Bidi;

// This stack will store the embedding levels and override and isolated statuses
internal class directionalStatusStack {
	private var stackCounter:int = 0;
	private var embeddingLevelStack:Vector.<uint> = new Vector.<uint>(Bidi.MAX_DEPTH + 1, true);
	private var overrideStatusStack:Vector.<uint> = new Vector.<uint>(Bidi.MAX_DEPTH + 1, true);
	private var isolateStatusStack:Vector.<Boolean> = new Vector.<Boolean>(Bidi.MAX_DEPTH + 1, true);
	
	public function empty():void {
		stackCounter = 0;
	}
	
	public function push(level:uint, overrideStatus:uint, isolateStatus:Boolean):void {
		embeddingLevelStack[stackCounter] = level;
		overrideStatusStack[stackCounter] = overrideStatus;
		isolateStatusStack[stackCounter] = isolateStatus;
		++stackCounter;
	}
	
	public function pop():void {
		--stackCounter;
	}
	
	public function depth():int {
		return stackCounter;
	}
	
	public function lastEmbeddingLevel():uint {
		return embeddingLevelStack[stackCounter - 1];
	}
	
	public function lastDirectionalOverrideStatus():uint {
		return overrideStatusStack[stackCounter - 1];
	}
	
	public function lastDirectionalIsolateStatus():Boolean {
		return isolateStatusStack[stackCounter - 1];
	}
}


/**
 * Some basic vector utilites needed for the operations. As the ActionScript-3 does not support
 * method overloading and since some implementations needed to be treated sligtly differently, there 
 * are concepually identical implementations in the class. The use of the <code>&#42;</code> notation
 * (for <em>untyped</em> variable) is also inapproprite; since, where the <code>uint</code> value
 * should've been initialized to <code>0</code>, it would've been assigned the unexpected <code>null</code>
 * value, by using the <code>&#42;</code> notation, for example.<p>
 * 
 * @author Ehsan Marufi
 */
internal class VectorUtil {
	/**
	 * Deep copies the provided 2-dimentional vector into a new one havig the specified "new" length 
	 * @param originalVec
	 * @param newLen If the specified new lenght is greater than the length of the original array,
	 * then the "new" elements will be initialized with <code>null</code>. 
	 * @return A deep copy of the provided two dimentional array having the specified "new" length.
	 * 
	 */
	public static function copy2DIntVector(originalVec:Vector.<Vector.<int>>, newLen:uint):Vector.<Vector.<int>> {
		var copy:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(newLen, true);
		var l:uint = Math.min(originalVec.length, newLen);
		var i:uint;
		for (i = 0; i < l; i++)
			copy[i] = originalVec[i].concat();
		for (i = l; i < newLen; i++)
			copy[i] = null;
		return copy;
	}
	
	/**
	 * Deep copies the provided int vector into a new one havig the specified "new" length
	 * @param originalVec
	 * @param newLen If the specified new lenght is greater than the length of the original array,
	 * then the "new" elements will be initialized with <code>0</code>. 
	 * @return A deep copy of the provided array having the specified "new" length.
	 * 
	 */
	public static function copyIntVector(originalVec:Vector.<int>, newLen:uint):Vector.<int> {
		var copy:Vector.<int> = new Vector.<int>(newLen, true);
		var l:uint = Math.min(originalVec.length, newLen);
		for (var i:uint = 0; i < l; i++)
			copy[i] = originalVec[i];
		// There's no need to initialize the possibly remaining "new" elements to 0,
		// because the constructor of the copy vector has already done that.
		return copy;
	}
	
	
	public static function vectorCopyInt(src:Vector.<int>, srcPos:uint, dest:Vector.<int>, destPos:uint, length:uint):void {
		for (var i:uint = 0; i < length; i++) {
			dest[destPos+i] = src[srcPos+i];
		}
	}
	
	public static function vectorCopyUint(src:Vector.<uint>, srcPos:uint, dest:Vector.<uint>, destPos:uint, length:uint):void {
		for (var i:uint = 0; i < length; i++) {
			dest[destPos+i] = src[srcPos+i];
		}
	}
}