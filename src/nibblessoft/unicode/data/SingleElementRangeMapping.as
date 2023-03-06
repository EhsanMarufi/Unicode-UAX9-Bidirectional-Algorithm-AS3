package nibblessoft.unicode.data {
	
	internal class SingleElementRangeMapping implements IRangeMapping {
		private var _rangeMinMax:uint;
		private var _value:uint;
		
		public function SingleElementRangeMapping(rangeMinMax:uint, value:uint) {
			_rangeMinMax = rangeMinMax;
			_value = value;
		}
		
		public function getRangeMin():uint { return _rangeMinMax; }
		public function getRangeMax():uint { return _rangeMinMax; }
		public function    getValue():uint { return _value;       }
	}
}