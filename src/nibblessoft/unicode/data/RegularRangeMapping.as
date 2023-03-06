package nibblessoft.unicode.data {
	
	internal class RegularRangeMapping implements IRangeMapping {
		private var _rangeMin:uint;
		private var _rangeMax:uint;
		private var _value:uint;
		
		public function RegularRangeMapping(min:uint, max:uint, value:uint) {
			_rangeMin = min;
			_rangeMax = max;
			_value = value;
		}
		
		public function getRangeMin():uint { return _rangeMin; }
		public function getRangeMax():uint { return _rangeMax; }
		public function    getValue():uint { return _value;    }
	}
}