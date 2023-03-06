package nibblessoft.unicode.data
{
	public class PresentationalForms
	{
		private var _codepoint:uint;
		private var _isolatedForm:uint;
		private var _finalForm:uint;
		private var _initialForm:uint;
		private var _medialForm:uint;
		
		public function PresentationalForms(codepoint:uint, isolatedForm:uint, finalForm:uint, initialForm:uint, medialForm:uint) {
			_codepoint = codepoint;
			_isolatedForm = isolatedForm;
			_finalForm = finalForm;
			_initialForm = initialForm;
			_medialForm = medialForm;
		}
		
		public function get codepoint()    :uint { return _codepoint;    }
		public function get isolatedForm() :uint { return _isolatedForm; }
		public function get finalForm()    :uint { return _finalForm;    }
		public function get initialForm()  :uint { return _initialForm;  }
		public function get medialForm()   :uint { return _medialForm;   }
	}
}