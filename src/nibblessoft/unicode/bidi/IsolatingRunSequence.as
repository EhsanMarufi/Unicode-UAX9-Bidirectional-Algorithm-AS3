/*
* In the name of God
* Ehsan Marufi Azar, Oct. 2016 (c)
* The "Isolating Run Sequence" class
*
*/
package nibblessoft.unicode.bidi
{
	internal class IsolatingRunSequence {
		private var indexes:Vector.<int>; // indexes to the original string
		private var types:Vector.<uint>; // type of each character using the index
		private var typesPriorW1:Vector.<uint>; // the original bidirectional character types prior to the application of W1 
		private var resolvedLevels:Vector.<uint>; // resolved levels after application of rules
		private var length:int; // length of isolating run sequence in characters
		private var level:uint;
		private var sos:uint, eos:uint;
		
		private var bidiRef:Bidi;
		
		/**
		 * Rule X10, second bullet: Determine the start-of-sequence (sos) and end-of-sequence (eos) types,
		 * 			 either L or R, for each isolating run sequence.
		 * @param inputIndexes
		 */
		public function IsolatingRunSequence(inputIndexes:Vector.<int>, bidiRef:Bidi) {
			this.bidiRef = bidiRef;
			
			indexes = inputIndexes;
			length = indexes.length;
			
			typesPriorW1 = new Vector.<uint>(length, true);
			types = new Vector.<uint>(length, true);
			for (var i:int = 0; i < length; ++i) {
				typesPriorW1[i] = bidiRef.resultTypes[indexes[i]];
				types[i] = typesPriorW1[i];
			}
			
			// assign level, sos and eos
			level = bidiRef.resultLevels[indexes[0]];
			
			var prevChar:int = indexes[0] - 1;
			while (prevChar >= 0 && Bidi.isRemovedByX9(bidiRef.initialTypes[prevChar])) {
				--prevChar;
			}
			var prevLevel:uint = prevChar >= 0 ? bidiRef.resultLevels[prevChar] : bidiRef.paragraphEmbeddingLevel;
			sos = Bidi.typeForLevel(Math.max(prevLevel, level));
			
			var lastType:uint = types[length - 1];
			var succLevel:uint;
			if (lastType == Bidi.LRI || lastType == Bidi.RLI || lastType == Bidi.FSI) {
				succLevel = bidiRef.paragraphEmbeddingLevel;
			} else {
				var limit:uint = indexes[length - 1] + 1; // the first character
				// after the end of
				// run sequence
				while (limit < bidiRef.textLength && Bidi.isRemovedByX9(bidiRef.initialTypes[limit])) {
					++limit;
				}
				succLevel = limit < bidiRef.textLength ? bidiRef.resultLevels[limit] : bidiRef.paragraphEmbeddingLevel;
			}
			eos = Bidi.typeForLevel(Math.max(succLevel, level));
		}
		
		/**
		 * Resolving bidi paired brackets  Rule N0
		 */
		
		public function resolvePairedBrackets():void 
		{
			bidiRef.pba = new BidiPBA();
			bidiRef.pba.resolvePairedBrackets(indexes, types, typesPriorW1, bidiRef.pairTypes, bidiRef.pairValues, sos, level);
		}
		
		
		/**
		 * Resolving weak types Rules W1-W7.
		 *
		 * Note that some weak types (EN, AN) remain after this processing is
		 * complete.
		 */
		public function resolveWeakTypes():void {
			// At this point, any bidirectional type is one of the followings: (count: 17)
			// L, R, AL, EN, ES, ET, AN, CS, B, S, WS, ON, NSM, LRI, RLI, FSI, PDI;
			
			// Rule W1.
			// Changes all NSMs.
			var preceedingCharacterType:uint = sos;
			var i:int, t:uint, j:int;
			for (i = 0; i < length; ++i) {
				t = types[i];
				if (t == Bidi.NSM) {
					types[i] = preceedingCharacterType;
				} else {
					if (t == Bidi.LRI || t == Bidi.RLI || t == Bidi.FSI || t == Bidi.PDI) {
						preceedingCharacterType = Bidi.ON;
					}
					preceedingCharacterType = t;
				}
			}
			
			// Rule W2.
			// EN does not change at the start of the run, because sos != AL.
			for (i = 0; i < length; ++i) {
				if (types[i] == Bidi.EN) {
					for (j = i - 1; j >= 0; --j) {
						t = types[j];
						if (t == Bidi.L || t == Bidi.R || t == Bidi.AL) {
							if (t == Bidi.AL) {
								types[i] = Bidi.AN;
							}
							break;
						}
					}
				}
			}
			
			// Rule W3.
			for (i = 0; i < length; ++i) {
				if (types[i] == Bidi.AL) {
					types[i] = Bidi.R;
				}
			}
			
			// Rule W4.
			// Since there must be values on both sides for this rule to have an
			// effect, the scan skips the first and last value.
			//
			// Although the scan proceeds left to right, and changes the type
			// values in a way that would appear to affect the computations
			// later in the scan, there is actually no problem. A change in the
			// current value can only affect the value to its immediate right,
			// and only affect it if it is ES or CS. But the current value can
			// only change if the value to its right is not ES or CS. Thus
			// either the current value will not change, or its change will have
			// no effect on the remainder of the analysis.
			
			for (i = 1; i < length - 1; ++i) {
				if (types[i] == Bidi.ES || types[i] == Bidi.CS) {
					var prevSepType:uint = types[i - 1];
					var succSepType:uint = types[i + 1];
					if (prevSepType == Bidi.EN && succSepType == Bidi.EN) {
						types[i] = Bidi.EN;
					} else if (types[i] == Bidi.CS && prevSepType == Bidi.AN && succSepType == Bidi.AN) {
						types[i] = Bidi.AN;
					}
				}
			}
			
			// Rule W5.
			for (i = 0; i < length; ++i) {
				if (types[i] == Bidi.ET) {
					// locate end of sequence
					var runstart:int = i;
					var validSet:Vector.<uint> = new Vector.<uint>(1, true);
					validSet[0] = Bidi.ET;
					var runlimit:int = findRunLimit(runstart, length, validSet);
					
					// check values at ends of sequence
					t = runstart == 0 ? sos : types[runstart - 1];
					
					if (t != Bidi.EN) {
						t = runlimit == length ? eos : types[runlimit];
					}
					
					if (t == Bidi.EN) {
						setTypes(runstart, runlimit, Bidi.EN);
					}
					
					// continue at end of sequence
					i = runlimit;
				}
			}
			
			// Rule W6.
			for (i = 0; i < length; ++i) {
				t = types[i];
				if (t == Bidi.ES || t == Bidi.ET || t == Bidi.CS) {
					types[i] = Bidi.ON;
				}
			}
			
			// Rule W7.
			for (i = 0; i < length; ++i) {
				if (types[i] == Bidi.EN) {
					// set default if we reach start of run
					var prevStrongType:uint = sos;
					for (j = i - 1; j >= 0; --j) {
						t = types[j];
						if (t == Bidi.L || t == Bidi.R) { // AL's have been changed to R
							prevStrongType = t;
							break;
						}
					}
					if (prevStrongType == Bidi.L) {
						types[i] = Bidi.L;
					}
				}
			}
		}
		
		/**
		 * 6) resolving neutral types Rules N1-N2.
		 */
		public function resolveNeutralTypes():void {
			// At this point, any bidirectional type is one of the followings: (count: 12)
			// L, R, EN, AN, B, S, WS, ON, RLI, LRI, FSI, PDI;
			
			for (var i:int = 0; i < length; ++i) {
				var t:uint = types[i];
				if (t == Bidi.WS || t == Bidi.ON || t == Bidi.B || t == Bidi.S || t == Bidi.RLI || t == Bidi.LRI || t == Bidi.FSI || t == Bidi.PDI) {
					// find bounds of run of neutrals
					var runstart:int = i;
					
					var validSet:Vector.<uint> = new Vector.<uint>(8, true);
					vectorSet(validSet, [Bidi.B, Bidi.S, Bidi.WS, Bidi.ON, Bidi.RLI, Bidi.LRI, Bidi.FSI, Bidi.PDI]);
					var runlimit:int = findRunLimit(runstart, length, validSet);
					
					// determine effective types at ends of run
					var leadingType:uint;
					var trailingType:uint;
					
					// Note that the character found can only be L, R, AN, or
					// EN.
					if (runstart == 0) {
						leadingType = sos;
					} else {
						leadingType = types[runstart - 1];
						if (leadingType == Bidi.AN || leadingType == Bidi.EN) {
							leadingType = Bidi.R;
						}
					}
					
					if (runlimit == length) {
						trailingType = eos;
					} else {
						trailingType = types[runlimit];
						if (trailingType == Bidi.AN || trailingType == Bidi.EN) {
							trailingType = Bidi.R;
						}
					}
					
					var resolvedType:uint;
					if (leadingType == trailingType) {
						// Rule N1.
						resolvedType = leadingType;
					} else {
						// Rule N2.
						// Notice the embedding level of the run is used, not
						// the paragraph embedding level.
						resolvedType = Bidi.typeForLevel(level);
					}
					
					setTypes(runstart, runlimit, resolvedType);
					
					// skip over run of (former) neutrals
					i = runlimit;
				}
			}
		}
		
		/**
		 * 7) resolving implicit embedding levels Rules I1, I2.
		 */
		public function resolveImplicitLevels():void {
			// At this point, any bidirectional type is one of the followings: (count: 4)
			// L, R, EN, AN;
			
			resolvedLevels = new Vector.<uint>(length, true);
			bidiRef.setLevels(resolvedLevels, 0, length, level);
			
			var i:int, t:uint;
			if ((level & 1) == 0) { // even level
				for (i = 0; i < length; ++i) {
					t = types[i];
					// Rule I1.
					if (t == Bidi.L) {
						// no change
					} else if (t == Bidi.R) {
						resolvedLevels[i] += 1;
					} else { // t == AN || t == EN
						resolvedLevels[i] += 2;
					}
				}
			} else { // odd level
				for (i = 0; i < length; ++i) {
					t = types[i];
					// Rule I2.
					if (t == Bidi.R) {
						// no change
					} else { // t == L || t == AN || t == EN
						resolvedLevels[i] += 1;
					}
				}
			}
		}
		
		/**
		* Applies the levels and types resolved in rules W1-I2 to the
		* bidiRef.resultLevels array.
		*/
		public function applyLevelsAndTypes():void {
			for (var i:int = 0; i < length; ++i) {
				var originalIndex:int = indexes[i];
				bidiRef.resultTypes[originalIndex] = types[i];
				bidiRef.resultLevels[originalIndex] = resolvedLevels[i];
			}
		}
		
		/**
		 * Return the limit of the run consisting only of the types in validSet
		 * starting at index. This checks the value at index, and will return
		 * index if that value is not in validSet.
		 */
		private function findRunLimit(index:int, limit:int, validSet:Vector.<uint>):int {
			loop: while (index < limit) {
				var t:uint = types[index];
				for (var i:int = 0; i < validSet.length; ++i) {
					if (t == validSet[i]) {
						++index;
						continue loop;
					}
				}
				// didn't find a match in validSet
				return index;
			}
			return limit;
		}
		
		/**
		 * Set types from start up to (but not including) limit to newType.
		 */
		private function setTypes(start:int, limit:int, newType:uint):void {
			for (var i:int = start; i < limit; ++i) {
				types[i] = newType;
			}
		}
		
		/**
		 * Algorithm validation. Assert that all values in types are in the
		 * provided set.
		 */
		/*
		private function assertOnly(codes:Vector.<uint>):void {
			loop: for (var i:int = 0; i < length; ++i) {
				var t:uint = types[i];
				for (var j:int = 0; j < codes.length; ++j) {
					if (t == codes[j]) {
						continue loop;
					}
				}
				
				throw new Error("invalid bidi code " + BiDi.typenames[t] + " present in assertOnly at position " + indexes[i]);
			}
		}
		*/
		/**
		 * A utility method to "initialize" the provided vector with values already inside the provided array.
		 */
		private static function vectorSet(vec:Vector.<uint>, arr:Array):void {
			var len:uint = vec.length;
			for (var i:uint = 0; i<len; ++i)
				vec[i] = arr[i];
		}
	}
}