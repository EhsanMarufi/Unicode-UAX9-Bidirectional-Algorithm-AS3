package nibblessoft.unicode.data
{

	/**
	 * Each Arabic letter must be depicted by one of a number of possible contextual glyph forms.
	 * The appropriate form is determined on the basis of the cursive joining behavior of that 
	 * character as it interacts with the cursive joining behavior of adjacent characters.<br>
	 * This class holds a list of these presentational forms for the Arabic script. 
	 * @author Ehsan
	 * 
	 */
	public class ArabicScriptPresentationalForms
	{
		private static const ENTRIES_COUNT:uint = 84;
		private static var D:Vector.<PresentationalForms>;
		
		
		/**
		 * Returns the <em>presentational forms</em> object associated with each Unicode<sup>&reg;</sup> codepoint using an efficient
		 * binary search algorithm.
		 * @param codepoint The Unicode<sup>&reg;</sup> codepoint to retrieve the "presentational forms" of. 
		 * @return The <em>presentational forms</em> of the specified codepoint.
		 * 
		 */
		public static function getPresentationalForms(codepoint:uint):PresentationalForms {
			// Uses the Binary Search Algorithm
			var L:int = 0, R:int = ENTRIES_COUNT-1;
			var m:int;
			var pressentationalForms:PresentationalForms;
			
			while (true) {
				if (L > R)
					// Search should be terminated as unsuccessful
					break;
				
				m = Math.floor((L+R)/2);
				
				pressentationalForms = D[m];
				if (pressentationalForms.codepoint < codepoint)
					L = m + 1;
				else if (pressentationalForms.codepoint > codepoint)
					R = m - 1;
				else
					// Found it!
					return pressentationalForms;
			}
			
			// Search terminates as unsuccessful
			return null;
		}

		
		
		// Static initializer
		{
			D = new Vector.<PresentationalForms>(ENTRIES_COUNT, true);
			
			// Because of the frequent need of the data to be present in memory, the reference
			// array is implemented "static".
			// It is prefered to have the data hard-coded as it provides some preformance gains 
			// compared to other methods of loading the data into the array (like through an 
			// external binary file), while the file size of the source-code increases!
			// The followings are sorted based on the codepoints (the first argument);
			D[0] = new PresentationalForms(1569, 65152, 0, 0, 0);
			D[1] = new PresentationalForms(1570, 65153, 65154, 0, 0);
			D[2] = new PresentationalForms(1571, 65155, 65156, 0, 0);
			D[3] = new PresentationalForms(1572, 65157, 65158, 0, 0);
			D[4] = new PresentationalForms(1573, 65159, 65160, 0, 0);
			D[5] = new PresentationalForms(1574, 65161, 65162, 65163, 65164);
			D[6] = new PresentationalForms(1575, 65165, 65166, 0, 0);
			D[7] = new PresentationalForms(1576, 65167, 65168, 65169, 65170);
			D[8] = new PresentationalForms(1577, 65171, 65172, 0, 0);
			D[9] = new PresentationalForms(1578, 65173, 65174, 65175, 65176);
			D[10] = new PresentationalForms(1579, 65177, 65178, 65179, 65180);
			D[11] = new PresentationalForms(1580, 65181, 65182, 65183, 65184);
			D[12] = new PresentationalForms(1581, 65185, 65186, 65187, 65188);
			D[13] = new PresentationalForms(1582, 65189, 65190, 65191, 65192);
			D[14] = new PresentationalForms(1583, 65193, 65194, 0, 0);
			D[15] = new PresentationalForms(1584, 65195, 65196, 0, 0);
			D[16] = new PresentationalForms(1585, 65197, 65198, 0, 0);
			D[17] = new PresentationalForms(1586, 65199, 65200, 0, 0);
			D[18] = new PresentationalForms(1587, 65201, 65202, 65203, 65204);
			D[19] = new PresentationalForms(1588, 65205, 65206, 65207, 65208);
			D[20] = new PresentationalForms(1589, 65209, 65210, 65211, 65212);
			D[21] = new PresentationalForms(1590, 65213, 65214, 65215, 65216);
			D[22] = new PresentationalForms(1591, 65217, 65218, 65219, 65220);
			D[23] = new PresentationalForms(1592, 65221, 65222, 65223, 65224);
			D[24] = new PresentationalForms(1593, 65225, 65226, 65227, 65228);
			D[25] = new PresentationalForms(1594, 65229, 65230, 65231, 65232);
			D[26] = new PresentationalForms(1601, 65233, 65234, 65235, 65236);
			D[27] = new PresentationalForms(1602, 65237, 65238, 65239, 65240);
			D[28] = new PresentationalForms(1603, 65241, 65242, 65243, 65244);
			D[29] = new PresentationalForms(1604, 65245, 65246, 65247, 65248);
			D[30] = new PresentationalForms(1605, 65249, 65250, 65251, 65252);
			D[31] = new PresentationalForms(1606, 65253, 65254, 65255, 65256);
			D[32] = new PresentationalForms(1607, 65257, 65258, 65259, 65260);
			D[33] = new PresentationalForms(1608, 65261, 65262, 0, 0);
			D[34] = new PresentationalForms(1609, 65263, 65264, 64488, 64489);
			D[35] = new PresentationalForms(1610, 65265, 65266, 65267, 65268);
			D[36] = new PresentationalForms(1611, 65136, 0, 0, 65137);
			D[37] = new PresentationalForms(1612, 65138, 0, 0, 0);
			D[38] = new PresentationalForms(1613, 65140, 0, 0, 0);
			D[39] = new PresentationalForms(1614, 65142, 0, 0, 65143);
			D[40] = new PresentationalForms(1615, 65144, 0, 0, 65145);
			D[41] = new PresentationalForms(1616, 65146, 0, 0, 65147);
			D[42] = new PresentationalForms(1617, 65148, 0, 0, 65149);
			D[43] = new PresentationalForms(1618, 65150, 0, 0, 65151);
			D[44] = new PresentationalForms(1649, 64336, 64337, 0, 0);
			D[45] = new PresentationalForms(1655, 64477, 0, 0, 0);
			D[46] = new PresentationalForms(1657, 64358, 64359, 64360, 64361);
			D[47] = new PresentationalForms(1658, 64350, 64351, 64352, 64353);
			D[48] = new PresentationalForms(1659, 64338, 64339, 64340, 64341);
			D[49] = new PresentationalForms(1662, 64342, 64343, 64344, 64345);
			D[50] = new PresentationalForms(1663, 64354, 64355, 64356, 64357);
			D[51] = new PresentationalForms(1664, 64346, 64347, 64348, 64349);
			D[52] = new PresentationalForms(1667, 64374, 64375, 64376, 64377);
			D[53] = new PresentationalForms(1668, 64370, 64371, 64372, 64373);
			D[54] = new PresentationalForms(1670, 64378, 64379, 64380, 64381);
			D[55] = new PresentationalForms(1671, 64382, 64383, 64384, 64385);
			D[56] = new PresentationalForms(1672, 64392, 64393, 0, 0);
			D[57] = new PresentationalForms(1676, 64388, 64389, 0, 0);
			D[58] = new PresentationalForms(1677, 64386, 64387, 0, 0);
			D[59] = new PresentationalForms(1678, 64390, 64391, 0, 0);
			D[60] = new PresentationalForms(1681, 64396, 64397, 0, 0);
			D[61] = new PresentationalForms(1688, 64394, 64395, 0, 0);
			D[62] = new PresentationalForms(1700, 64362, 64363, 64364, 64365);
			D[63] = new PresentationalForms(1702, 64366, 64367, 64368, 64369);
			D[64] = new PresentationalForms(1705, 64398, 64399, 64400, 64401);
			D[65] = new PresentationalForms(1709, 64467, 64468, 64469, 64470);
			D[66] = new PresentationalForms(1711, 64402, 64403, 64404, 64405);
			D[67] = new PresentationalForms(1713, 64410, 64411, 64412, 64413);
			D[68] = new PresentationalForms(1715, 64406, 64407, 64408, 64409);
			D[69] = new PresentationalForms(1722, 64414, 64415, 0, 0);
			D[70] = new PresentationalForms(1723, 64416, 64417, 64418, 64419);
			D[71] = new PresentationalForms(1726, 64426, 64427, 64428, 64429);
			D[72] = new PresentationalForms(1728, 64420, 64421, 0, 0);
			D[73] = new PresentationalForms(1729, 64422, 64423, 64424, 64425);
			D[74] = new PresentationalForms(1733, 64480, 64481, 0, 0);
			D[75] = new PresentationalForms(1734, 64473, 64474, 0, 0);
			D[76] = new PresentationalForms(1735, 64471, 64472, 0, 0);
			D[77] = new PresentationalForms(1736, 64475, 64476, 0, 0);
			D[78] = new PresentationalForms(1737, 64482, 64483, 0, 0);
			D[79] = new PresentationalForms(1739, 64478, 64479, 0, 0);
			D[80] = new PresentationalForms(1740, 65263, 65264, 65267, 65268); // FARSI YEH
			D[81] = new PresentationalForms(1744, 64484, 64485, 64486, 64487);
			D[82] = new PresentationalForms(1746, 64430, 64431, 0, 0);
			D[83] = new PresentationalForms(1747, 64432, 64433, 0, 0);
		}
	}
}