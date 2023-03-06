package nibblessoft.unicode.data {
	
	public class MirrorableCharacter {
		private var _glyphCodepoint:uint;
		private var _mirroredGlyphCodepoint:Number;
		
		public function MirrorableCharacter(glyphCodepoint:uint, mirroredGlyphCodepoint:Number) {
			_glyphCodepoint = glyphCodepoint;
			_mirroredGlyphCodepoint = mirroredGlyphCodepoint;
		}
		
		public function get glyphCodepoint():uint { return _glyphCodepoint; }
		/** 
		 * Gets the corresponding mirrored glyph codepoint. If the Unicode<sup>&reg;</sup>
		 * standard doesn't have assigned a codepoint for the mirrored glyph, this value will be
		 * <code>NaN</code>, then it would be up to the rendering system to provide the mirrored glyph. 
		 */
		public function get mirroredGlyphCodepoint():Number { return _mirroredGlyphCodepoint; }
	}
}