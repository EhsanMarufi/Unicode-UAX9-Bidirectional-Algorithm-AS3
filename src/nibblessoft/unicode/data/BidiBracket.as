package nibblessoft.unicode.data {
	
	public class BidiBracket {
		
		private var _codepoint:uint;
		private var _pairedBracket:uint;
		private var _bracketType:uint;
		
		public function BidiBracket(codepoint:uint, pairedBracket:uint, bracketType:uint) {
			_codepoint = codepoint;
			_pairedBracket = pairedBracket;
			_bracketType = bracketType;
		}
		
		public function copyFrom(copy:BidiBracket):void {
			_codepoint = copy.codepoint;
			_pairedBracket = copy.pairedBracket;
			_bracketType = copy.bracketType;
		}
		
		public function get codepoint():uint     { return _codepoint;     }
		public function get pairedBracket():uint { return _pairedBracket; }
		public function get bracketType():uint   { return _bracketType;   }
	}
}