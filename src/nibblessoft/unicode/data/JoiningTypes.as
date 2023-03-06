package nibblessoft.unicode.data {
	

	public class JoiningTypes {
		private static const ENTRIES_COUNT:uint = 421;
		private static var D:Vector.<IRangeMapping>;
		
		
		/**
		 * Returns the <em>joining type</em> associated with each Unicode<sup>&reg;</sup> codepoint using an efficient
		 * binary search algorithm.
		 * @param codepoint The Unicode<sup>&reg;</sup> codepoint to retrieve the joining type of. 
		 * @return The <em>joining type</em> of the specified codepoint.
		 * 
		 */
		public static function getJoiningType(codepoint:uint):uint {
			// Uses the Binary Search Algorithm
			var L:int = 0, R:int = ENTRIES_COUNT-1;
			var m:int;
			var rangeMapping:IRangeMapping;
			
			while (true) {
				if (L > R)
					// Search should be terminated as unsuccessful
					break;
				
				m = Math.floor((L+R)/2);
				
				rangeMapping = IRangeMapping(D[m]);
				if (rangeMapping.getRangeMax() < codepoint)
					L = m + 1;
				else if (rangeMapping.getRangeMin() > codepoint)
					R = m - 1;
				else
					// Found it!
					return rangeMapping.getValue();
			}
			
			// Search terminates as unsuccessful
			return JoiningType.U;
		}
		
		public static function generateJoiningTypesVector(codepoints:Vector.<uint>):Vector.<uint> {
			var len:uint = codepoints.length;
			var joiningTypes:Vector.<uint> = new Vector.<uint>(len, true);
			
			for (var i:uint = 0; i < len; ++i) {
				joiningTypes[i] = getJoiningType(codepoints[i]);
			}
			return joiningTypes;
		}
		
		public static function generateJoiningTypesVectorStr(str:String):Vector.<uint> {
			var len:uint = str.length;
			var joiningTypes:Vector.<uint> = new Vector.<uint>(len, true);
			
			for (var i:uint = 0; i < len; ++i) {
				joiningTypes[i] = getJoiningType(str.charCodeAt(i));
			}
			return joiningTypes;
		}
		
		
		// Static initializer
		{
			D = new Vector.<IRangeMapping>(ENTRIES_COUNT, true);
			
			// Because of the frequent need of the data to be present in memory, the reference
			// array is implemented "static".
			// It is prefered to have the data hard-coded as it provides some preformance gains 
			// compared to other methods of loading the data into the array (like through an 
			// external binary file), while the file size of the source-code increases!
			// The following ranges are sorted based on the codepoint intervals; the missed
			// codepoints have the Joining-Type of "Non_Joining" (JoiningType.U).
			D[0] = new SingleElementRangeMapping(173, JoiningType.T);
			D[1] = new RegularRangeMapping(768, 879, JoiningType.T);
			D[2] = new RegularRangeMapping(1155, 1159, JoiningType.T);
			D[3] = new RegularRangeMapping(1160, 1161, JoiningType.T);
			D[4] = new RegularRangeMapping(1425, 1469, JoiningType.T);
			D[5] = new SingleElementRangeMapping(1471, JoiningType.T);
			D[6] = new RegularRangeMapping(1473, 1474, JoiningType.T);
			D[7] = new RegularRangeMapping(1476, 1477, JoiningType.T);
			D[8] = new SingleElementRangeMapping(1479, JoiningType.T);
			D[9] = new RegularRangeMapping(1552, 1562, JoiningType.T);
			D[10] = new SingleElementRangeMapping(1564, JoiningType.T);
			D[11] = new SingleElementRangeMapping(1568, JoiningType.D);
			D[12] = new RegularRangeMapping(1570, 1573, JoiningType.R);
			D[13] = new SingleElementRangeMapping(1574, JoiningType.D);
			D[14] = new SingleElementRangeMapping(1575, JoiningType.R);
			D[15] = new SingleElementRangeMapping(1576, JoiningType.D);
			D[16] = new SingleElementRangeMapping(1577, JoiningType.R);
			D[17] = new RegularRangeMapping(1578, 1582, JoiningType.D);
			D[18] = new RegularRangeMapping(1583, 1586, JoiningType.R);
			D[19] = new RegularRangeMapping(1587, 1599, JoiningType.D);
			D[20] = new SingleElementRangeMapping(1600, JoiningType.C);
			D[21] = new RegularRangeMapping(1601, 1607, JoiningType.D);
			D[22] = new SingleElementRangeMapping(1608, JoiningType.R);
			D[23] = new RegularRangeMapping(1609, 1610, JoiningType.D);
			D[24] = new RegularRangeMapping(1611, 1631, JoiningType.T);
			D[25] = new RegularRangeMapping(1646, 1647, JoiningType.D);
			D[26] = new SingleElementRangeMapping(1648, JoiningType.T);
			D[27] = new RegularRangeMapping(1649, 1651, JoiningType.R);
			D[28] = new RegularRangeMapping(1653, 1655, JoiningType.R);
			D[29] = new RegularRangeMapping(1656, 1671, JoiningType.D);
			D[30] = new RegularRangeMapping(1672, 1689, JoiningType.R);
			D[31] = new RegularRangeMapping(1690, 1727, JoiningType.D);
			D[32] = new SingleElementRangeMapping(1728, JoiningType.R);
			D[33] = new RegularRangeMapping(1729, 1730, JoiningType.D);
			D[34] = new RegularRangeMapping(1731, 1739, JoiningType.R);
			D[35] = new SingleElementRangeMapping(1740, JoiningType.D);
			D[36] = new SingleElementRangeMapping(1741, JoiningType.R);
			D[37] = new SingleElementRangeMapping(1742, JoiningType.D);
			D[38] = new SingleElementRangeMapping(1743, JoiningType.R);
			D[39] = new RegularRangeMapping(1744, 1745, JoiningType.D);
			D[40] = new RegularRangeMapping(1746, 1747, JoiningType.R);
			D[41] = new SingleElementRangeMapping(1749, JoiningType.R);
			D[42] = new RegularRangeMapping(1750, 1756, JoiningType.T);
			D[43] = new RegularRangeMapping(1759, 1764, JoiningType.T);
			D[44] = new RegularRangeMapping(1767, 1768, JoiningType.T);
			D[45] = new RegularRangeMapping(1770, 1773, JoiningType.T);
			D[46] = new RegularRangeMapping(1774, 1775, JoiningType.R);
			D[47] = new RegularRangeMapping(1786, 1788, JoiningType.D);
			D[48] = new SingleElementRangeMapping(1791, JoiningType.D);
			D[49] = new SingleElementRangeMapping(1807, JoiningType.T);
			D[50] = new SingleElementRangeMapping(1808, JoiningType.R);
			D[51] = new SingleElementRangeMapping(1809, JoiningType.T);
			D[52] = new RegularRangeMapping(1810, 1812, JoiningType.D);
			D[53] = new RegularRangeMapping(1813, 1817, JoiningType.R);
			D[54] = new RegularRangeMapping(1818, 1821, JoiningType.D);
			D[55] = new SingleElementRangeMapping(1822, JoiningType.R);
			D[56] = new RegularRangeMapping(1823, 1831, JoiningType.D);
			D[57] = new SingleElementRangeMapping(1832, JoiningType.R);
			D[58] = new SingleElementRangeMapping(1833, JoiningType.D);
			D[59] = new SingleElementRangeMapping(1834, JoiningType.R);
			D[60] = new SingleElementRangeMapping(1835, JoiningType.D);
			D[61] = new SingleElementRangeMapping(1836, JoiningType.R);
			D[62] = new RegularRangeMapping(1837, 1838, JoiningType.D);
			D[63] = new SingleElementRangeMapping(1839, JoiningType.R);
			D[64] = new RegularRangeMapping(1840, 1866, JoiningType.T);
			D[65] = new SingleElementRangeMapping(1869, JoiningType.R);
			D[66] = new RegularRangeMapping(1870, 1880, JoiningType.D);
			D[67] = new RegularRangeMapping(1881, 1883, JoiningType.R);
			D[68] = new RegularRangeMapping(1884, 1898, JoiningType.D);
			D[69] = new RegularRangeMapping(1899, 1900, JoiningType.R);
			D[70] = new RegularRangeMapping(1901, 1904, JoiningType.D);
			D[71] = new SingleElementRangeMapping(1905, JoiningType.R);
			D[72] = new SingleElementRangeMapping(1906, JoiningType.D);
			D[73] = new RegularRangeMapping(1907, 1908, JoiningType.R);
			D[74] = new RegularRangeMapping(1909, 1911, JoiningType.D);
			D[75] = new RegularRangeMapping(1912, 1913, JoiningType.R);
			D[76] = new RegularRangeMapping(1914, 1919, JoiningType.D);
			D[77] = new RegularRangeMapping(1958, 1968, JoiningType.T);
			D[78] = new RegularRangeMapping(1994, 2026, JoiningType.D);
			D[79] = new RegularRangeMapping(2027, 2035, JoiningType.T);
			D[80] = new SingleElementRangeMapping(2042, JoiningType.C);
			D[81] = new RegularRangeMapping(2070, 2073, JoiningType.T);
			D[82] = new RegularRangeMapping(2075, 2083, JoiningType.T);
			D[83] = new RegularRangeMapping(2085, 2087, JoiningType.T);
			D[84] = new RegularRangeMapping(2089, 2093, JoiningType.T);
			D[85] = new SingleElementRangeMapping(2112, JoiningType.R);
			D[86] = new RegularRangeMapping(2113, 2117, JoiningType.D);
			D[87] = new RegularRangeMapping(2118, 2119, JoiningType.R);
			D[88] = new SingleElementRangeMapping(2120, JoiningType.D);
			D[89] = new SingleElementRangeMapping(2121, JoiningType.R);
			D[90] = new RegularRangeMapping(2122, 2131, JoiningType.D);
			D[91] = new SingleElementRangeMapping(2132, JoiningType.R);
			D[92] = new SingleElementRangeMapping(2133, JoiningType.D);
			D[93] = new RegularRangeMapping(2137, 2139, JoiningType.T);
			D[94] = new RegularRangeMapping(2208, 2217, JoiningType.D);
			D[95] = new RegularRangeMapping(2218, 2220, JoiningType.R);
			D[96] = new SingleElementRangeMapping(2222, JoiningType.R);
			D[97] = new RegularRangeMapping(2223, 2224, JoiningType.D);
			D[98] = new RegularRangeMapping(2225, 2226, JoiningType.R);
			D[99] = new RegularRangeMapping(2227, 2228, JoiningType.D);
			D[100] = new RegularRangeMapping(2230, 2232, JoiningType.D);
			D[101] = new SingleElementRangeMapping(2233, JoiningType.R);
			D[102] = new RegularRangeMapping(2234, 2237, JoiningType.D);
			D[103] = new RegularRangeMapping(2260, 2273, JoiningType.T);
			D[104] = new RegularRangeMapping(2275, 2306, JoiningType.T);
			D[105] = new SingleElementRangeMapping(2362, JoiningType.T);
			D[106] = new SingleElementRangeMapping(2364, JoiningType.T);
			D[107] = new RegularRangeMapping(2369, 2376, JoiningType.T);
			D[108] = new SingleElementRangeMapping(2381, JoiningType.T);
			D[109] = new RegularRangeMapping(2385, 2391, JoiningType.T);
			D[110] = new RegularRangeMapping(2402, 2403, JoiningType.T);
			D[111] = new SingleElementRangeMapping(2433, JoiningType.T);
			D[112] = new SingleElementRangeMapping(2492, JoiningType.T);
			D[113] = new RegularRangeMapping(2497, 2500, JoiningType.T);
			D[114] = new SingleElementRangeMapping(2509, JoiningType.T);
			D[115] = new RegularRangeMapping(2530, 2531, JoiningType.T);
			D[116] = new RegularRangeMapping(2561, 2562, JoiningType.T);
			D[117] = new SingleElementRangeMapping(2620, JoiningType.T);
			D[118] = new RegularRangeMapping(2625, 2626, JoiningType.T);
			D[119] = new RegularRangeMapping(2631, 2632, JoiningType.T);
			D[120] = new RegularRangeMapping(2635, 2637, JoiningType.T);
			D[121] = new SingleElementRangeMapping(2641, JoiningType.T);
			D[122] = new RegularRangeMapping(2672, 2673, JoiningType.T);
			D[123] = new SingleElementRangeMapping(2677, JoiningType.T);
			D[124] = new RegularRangeMapping(2689, 2690, JoiningType.T);
			D[125] = new SingleElementRangeMapping(2748, JoiningType.T);
			D[126] = new RegularRangeMapping(2753, 2757, JoiningType.T);
			D[127] = new RegularRangeMapping(2759, 2760, JoiningType.T);
			D[128] = new SingleElementRangeMapping(2765, JoiningType.T);
			D[129] = new RegularRangeMapping(2786, 2787, JoiningType.T);
			D[130] = new SingleElementRangeMapping(2817, JoiningType.T);
			D[131] = new SingleElementRangeMapping(2876, JoiningType.T);
			D[132] = new SingleElementRangeMapping(2879, JoiningType.T);
			D[133] = new RegularRangeMapping(2881, 2884, JoiningType.T);
			D[134] = new SingleElementRangeMapping(2893, JoiningType.T);
			D[135] = new SingleElementRangeMapping(2902, JoiningType.T);
			D[136] = new RegularRangeMapping(2914, 2915, JoiningType.T);
			D[137] = new SingleElementRangeMapping(2946, JoiningType.T);
			D[138] = new SingleElementRangeMapping(3008, JoiningType.T);
			D[139] = new SingleElementRangeMapping(3021, JoiningType.T);
			D[140] = new SingleElementRangeMapping(3072, JoiningType.T);
			D[141] = new RegularRangeMapping(3134, 3136, JoiningType.T);
			D[142] = new RegularRangeMapping(3142, 3144, JoiningType.T);
			D[143] = new RegularRangeMapping(3146, 3149, JoiningType.T);
			D[144] = new RegularRangeMapping(3157, 3158, JoiningType.T);
			D[145] = new RegularRangeMapping(3170, 3171, JoiningType.T);
			D[146] = new SingleElementRangeMapping(3201, JoiningType.T);
			D[147] = new SingleElementRangeMapping(3260, JoiningType.T);
			D[148] = new SingleElementRangeMapping(3263, JoiningType.T);
			D[149] = new SingleElementRangeMapping(3270, JoiningType.T);
			D[150] = new RegularRangeMapping(3276, 3277, JoiningType.T);
			D[151] = new RegularRangeMapping(3298, 3299, JoiningType.T);
			D[152] = new SingleElementRangeMapping(3329, JoiningType.T);
			D[153] = new RegularRangeMapping(3393, 3396, JoiningType.T);
			D[154] = new SingleElementRangeMapping(3405, JoiningType.T);
			D[155] = new RegularRangeMapping(3426, 3427, JoiningType.T);
			D[156] = new SingleElementRangeMapping(3530, JoiningType.T);
			D[157] = new RegularRangeMapping(3538, 3540, JoiningType.T);
			D[158] = new SingleElementRangeMapping(3542, JoiningType.T);
			D[159] = new SingleElementRangeMapping(3633, JoiningType.T);
			D[160] = new RegularRangeMapping(3636, 3642, JoiningType.T);
			D[161] = new RegularRangeMapping(3655, 3662, JoiningType.T);
			D[162] = new SingleElementRangeMapping(3761, JoiningType.T);
			D[163] = new RegularRangeMapping(3764, 3769, JoiningType.T);
			D[164] = new RegularRangeMapping(3771, 3772, JoiningType.T);
			D[165] = new RegularRangeMapping(3784, 3789, JoiningType.T);
			D[166] = new RegularRangeMapping(3864, 3865, JoiningType.T);
			D[167] = new SingleElementRangeMapping(3893, JoiningType.T);
			D[168] = new SingleElementRangeMapping(3895, JoiningType.T);
			D[169] = new SingleElementRangeMapping(3897, JoiningType.T);
			D[170] = new RegularRangeMapping(3953, 3966, JoiningType.T);
			D[171] = new RegularRangeMapping(3968, 3972, JoiningType.T);
			D[172] = new RegularRangeMapping(3974, 3975, JoiningType.T);
			D[173] = new RegularRangeMapping(3981, 3991, JoiningType.T);
			D[174] = new RegularRangeMapping(3993, 4028, JoiningType.T);
			D[175] = new SingleElementRangeMapping(4038, JoiningType.T);
			D[176] = new RegularRangeMapping(4141, 4144, JoiningType.T);
			D[177] = new RegularRangeMapping(4146, 4151, JoiningType.T);
			D[178] = new RegularRangeMapping(4153, 4154, JoiningType.T);
			D[179] = new RegularRangeMapping(4157, 4158, JoiningType.T);
			D[180] = new RegularRangeMapping(4184, 4185, JoiningType.T);
			D[181] = new RegularRangeMapping(4190, 4192, JoiningType.T);
			D[182] = new RegularRangeMapping(4209, 4212, JoiningType.T);
			D[183] = new SingleElementRangeMapping(4226, JoiningType.T);
			D[184] = new RegularRangeMapping(4229, 4230, JoiningType.T);
			D[185] = new SingleElementRangeMapping(4237, JoiningType.T);
			D[186] = new SingleElementRangeMapping(4253, JoiningType.T);
			D[187] = new RegularRangeMapping(4957, 4959, JoiningType.T);
			D[188] = new RegularRangeMapping(5906, 5908, JoiningType.T);
			D[189] = new RegularRangeMapping(5938, 5940, JoiningType.T);
			D[190] = new RegularRangeMapping(5970, 5971, JoiningType.T);
			D[191] = new RegularRangeMapping(6002, 6003, JoiningType.T);
			D[192] = new RegularRangeMapping(6068, 6069, JoiningType.T);
			D[193] = new RegularRangeMapping(6071, 6077, JoiningType.T);
			D[194] = new SingleElementRangeMapping(6086, JoiningType.T);
			D[195] = new RegularRangeMapping(6089, 6099, JoiningType.T);
			D[196] = new SingleElementRangeMapping(6109, JoiningType.T);
			D[197] = new SingleElementRangeMapping(6151, JoiningType.D);
			D[198] = new SingleElementRangeMapping(6154, JoiningType.C);
			D[199] = new RegularRangeMapping(6155, 6157, JoiningType.T);
			D[200] = new RegularRangeMapping(6176, 6210, JoiningType.D);
			D[201] = new SingleElementRangeMapping(6211, JoiningType.D);
			D[202] = new RegularRangeMapping(6212, 6263, JoiningType.D);
			D[203] = new RegularRangeMapping(6277, 6278, JoiningType.T);
			D[204] = new RegularRangeMapping(6279, 6312, JoiningType.D);
			D[205] = new SingleElementRangeMapping(6313, JoiningType.T);
			D[206] = new SingleElementRangeMapping(6314, JoiningType.D);
			D[207] = new RegularRangeMapping(6432, 6434, JoiningType.T);
			D[208] = new RegularRangeMapping(6439, 6440, JoiningType.T);
			D[209] = new SingleElementRangeMapping(6450, JoiningType.T);
			D[210] = new RegularRangeMapping(6457, 6459, JoiningType.T);
			D[211] = new RegularRangeMapping(6679, 6680, JoiningType.T);
			D[212] = new SingleElementRangeMapping(6683, JoiningType.T);
			D[213] = new SingleElementRangeMapping(6742, JoiningType.T);
			D[214] = new RegularRangeMapping(6744, 6750, JoiningType.T);
			D[215] = new SingleElementRangeMapping(6752, JoiningType.T);
			D[216] = new SingleElementRangeMapping(6754, JoiningType.T);
			D[217] = new RegularRangeMapping(6757, 6764, JoiningType.T);
			D[218] = new RegularRangeMapping(6771, 6780, JoiningType.T);
			D[219] = new SingleElementRangeMapping(6783, JoiningType.T);
			D[220] = new RegularRangeMapping(6832, 6845, JoiningType.T);
			D[221] = new SingleElementRangeMapping(6846, JoiningType.T);
			D[222] = new RegularRangeMapping(6912, 6915, JoiningType.T);
			D[223] = new SingleElementRangeMapping(6964, JoiningType.T);
			D[224] = new RegularRangeMapping(6966, 6970, JoiningType.T);
			D[225] = new SingleElementRangeMapping(6972, JoiningType.T);
			D[226] = new SingleElementRangeMapping(6978, JoiningType.T);
			D[227] = new RegularRangeMapping(7019, 7027, JoiningType.T);
			D[228] = new RegularRangeMapping(7040, 7041, JoiningType.T);
			D[229] = new RegularRangeMapping(7074, 7077, JoiningType.T);
			D[230] = new RegularRangeMapping(7080, 7081, JoiningType.T);
			D[231] = new RegularRangeMapping(7083, 7085, JoiningType.T);
			D[232] = new SingleElementRangeMapping(7142, JoiningType.T);
			D[233] = new RegularRangeMapping(7144, 7145, JoiningType.T);
			D[234] = new SingleElementRangeMapping(7149, JoiningType.T);
			D[235] = new RegularRangeMapping(7151, 7153, JoiningType.T);
			D[236] = new RegularRangeMapping(7212, 7219, JoiningType.T);
			D[237] = new RegularRangeMapping(7222, 7223, JoiningType.T);
			D[238] = new RegularRangeMapping(7376, 7378, JoiningType.T);
			D[239] = new RegularRangeMapping(7380, 7392, JoiningType.T);
			D[240] = new RegularRangeMapping(7394, 7400, JoiningType.T);
			D[241] = new SingleElementRangeMapping(7405, JoiningType.T);
			D[242] = new SingleElementRangeMapping(7412, JoiningType.T);
			D[243] = new RegularRangeMapping(7416, 7417, JoiningType.T);
			D[244] = new RegularRangeMapping(7616, 7669, JoiningType.T);
			D[245] = new RegularRangeMapping(7675, 7679, JoiningType.T);
			D[246] = new SingleElementRangeMapping(8203, JoiningType.T);
			D[247] = new SingleElementRangeMapping(8205, JoiningType.C);
			D[248] = new RegularRangeMapping(8206, 8207, JoiningType.T);
			D[249] = new RegularRangeMapping(8234, 8238, JoiningType.T);
			D[250] = new RegularRangeMapping(8288, 8292, JoiningType.T);
			D[251] = new RegularRangeMapping(8298, 8303, JoiningType.T);
			D[252] = new RegularRangeMapping(8400, 8412, JoiningType.T);
			D[253] = new RegularRangeMapping(8413, 8416, JoiningType.T);
			D[254] = new SingleElementRangeMapping(8417, JoiningType.T);
			D[255] = new RegularRangeMapping(8418, 8420, JoiningType.T);
			D[256] = new RegularRangeMapping(8421, 8432, JoiningType.T);
			D[257] = new RegularRangeMapping(11503, 11505, JoiningType.T);
			D[258] = new SingleElementRangeMapping(11647, JoiningType.T);
			D[259] = new RegularRangeMapping(11744, 11775, JoiningType.T);
			D[260] = new RegularRangeMapping(12330, 12333, JoiningType.T);
			D[261] = new RegularRangeMapping(12441, 12442, JoiningType.T);
			D[262] = new SingleElementRangeMapping(42607, JoiningType.T);
			D[263] = new RegularRangeMapping(42608, 42610, JoiningType.T);
			D[264] = new RegularRangeMapping(42612, 42621, JoiningType.T);
			D[265] = new RegularRangeMapping(42654, 42655, JoiningType.T);
			D[266] = new RegularRangeMapping(42736, 42737, JoiningType.T);
			D[267] = new SingleElementRangeMapping(43010, JoiningType.T);
			D[268] = new SingleElementRangeMapping(43014, JoiningType.T);
			D[269] = new SingleElementRangeMapping(43019, JoiningType.T);
			D[270] = new RegularRangeMapping(43045, 43046, JoiningType.T);
			D[271] = new RegularRangeMapping(43072, 43121, JoiningType.D);
			D[272] = new SingleElementRangeMapping(43122, JoiningType.L);
			D[273] = new RegularRangeMapping(43204, 43205, JoiningType.T);
			D[274] = new RegularRangeMapping(43232, 43249, JoiningType.T);
			D[275] = new RegularRangeMapping(43302, 43309, JoiningType.T);
			D[276] = new RegularRangeMapping(43335, 43345, JoiningType.T);
			D[277] = new RegularRangeMapping(43392, 43394, JoiningType.T);
			D[278] = new SingleElementRangeMapping(43443, JoiningType.T);
			D[279] = new RegularRangeMapping(43446, 43449, JoiningType.T);
			D[280] = new SingleElementRangeMapping(43452, JoiningType.T);
			D[281] = new SingleElementRangeMapping(43493, JoiningType.T);
			D[282] = new RegularRangeMapping(43561, 43566, JoiningType.T);
			D[283] = new RegularRangeMapping(43569, 43570, JoiningType.T);
			D[284] = new RegularRangeMapping(43573, 43574, JoiningType.T);
			D[285] = new SingleElementRangeMapping(43587, JoiningType.T);
			D[286] = new SingleElementRangeMapping(43596, JoiningType.T);
			D[287] = new SingleElementRangeMapping(43644, JoiningType.T);
			D[288] = new SingleElementRangeMapping(43696, JoiningType.T);
			D[289] = new RegularRangeMapping(43698, 43700, JoiningType.T);
			D[290] = new RegularRangeMapping(43703, 43704, JoiningType.T);
			D[291] = new RegularRangeMapping(43710, 43711, JoiningType.T);
			D[292] = new SingleElementRangeMapping(43713, JoiningType.T);
			D[293] = new RegularRangeMapping(43756, 43757, JoiningType.T);
			D[294] = new SingleElementRangeMapping(43766, JoiningType.T);
			D[295] = new SingleElementRangeMapping(44005, JoiningType.T);
			D[296] = new SingleElementRangeMapping(44008, JoiningType.T);
			D[297] = new SingleElementRangeMapping(44013, JoiningType.T);
			D[298] = new SingleElementRangeMapping(64286, JoiningType.T);
			D[299] = new RegularRangeMapping(65024, 65039, JoiningType.T);
			D[300] = new RegularRangeMapping(65056, 65071, JoiningType.T);
			D[301] = new SingleElementRangeMapping(65279, JoiningType.T);
			D[302] = new RegularRangeMapping(65529, 65531, JoiningType.T);
			D[303] = new SingleElementRangeMapping(66045, JoiningType.T);
			D[304] = new SingleElementRangeMapping(66272, JoiningType.T);
			D[305] = new RegularRangeMapping(66422, 66426, JoiningType.T);
			D[306] = new RegularRangeMapping(68097, 68099, JoiningType.T);
			D[307] = new RegularRangeMapping(68101, 68102, JoiningType.T);
			D[308] = new RegularRangeMapping(68108, 68111, JoiningType.T);
			D[309] = new RegularRangeMapping(68152, 68154, JoiningType.T);
			D[310] = new SingleElementRangeMapping(68159, JoiningType.T);
			D[311] = new RegularRangeMapping(68288, 68292, JoiningType.D);
			D[312] = new SingleElementRangeMapping(68293, JoiningType.R);
			D[313] = new SingleElementRangeMapping(68295, JoiningType.R);
			D[314] = new RegularRangeMapping(68297, 68298, JoiningType.R);
			D[315] = new SingleElementRangeMapping(68301, JoiningType.L);
			D[316] = new RegularRangeMapping(68302, 68306, JoiningType.R);
			D[317] = new RegularRangeMapping(68307, 68310, JoiningType.D);
			D[318] = new SingleElementRangeMapping(68311, JoiningType.L);
			D[319] = new RegularRangeMapping(68312, 68316, JoiningType.D);
			D[320] = new SingleElementRangeMapping(68317, JoiningType.R);
			D[321] = new RegularRangeMapping(68318, 68320, JoiningType.D);
			D[322] = new SingleElementRangeMapping(68321, JoiningType.R);
			D[323] = new SingleElementRangeMapping(68324, JoiningType.R);
			D[324] = new RegularRangeMapping(68325, 68326, JoiningType.T);
			D[325] = new RegularRangeMapping(68331, 68334, JoiningType.D);
			D[326] = new SingleElementRangeMapping(68335, JoiningType.R);
			D[327] = new SingleElementRangeMapping(68480, JoiningType.D);
			D[328] = new SingleElementRangeMapping(68481, JoiningType.R);
			D[329] = new SingleElementRangeMapping(68482, JoiningType.D);
			D[330] = new RegularRangeMapping(68483, 68485, JoiningType.R);
			D[331] = new RegularRangeMapping(68486, 68488, JoiningType.D);
			D[332] = new SingleElementRangeMapping(68489, JoiningType.R);
			D[333] = new RegularRangeMapping(68490, 68491, JoiningType.D);
			D[334] = new SingleElementRangeMapping(68492, JoiningType.R);
			D[335] = new SingleElementRangeMapping(68493, JoiningType.D);
			D[336] = new RegularRangeMapping(68494, 68495, JoiningType.R);
			D[337] = new SingleElementRangeMapping(68496, JoiningType.D);
			D[338] = new SingleElementRangeMapping(68497, JoiningType.R);
			D[339] = new RegularRangeMapping(68521, 68524, JoiningType.R);
			D[340] = new RegularRangeMapping(68525, 68526, JoiningType.D);
			D[341] = new SingleElementRangeMapping(69633, JoiningType.T);
			D[342] = new RegularRangeMapping(69688, 69702, JoiningType.T);
			D[343] = new RegularRangeMapping(69759, 69761, JoiningType.T);
			D[344] = new RegularRangeMapping(69811, 69814, JoiningType.T);
			D[345] = new RegularRangeMapping(69817, 69818, JoiningType.T);
			D[346] = new SingleElementRangeMapping(69821, JoiningType.T);
			D[347] = new RegularRangeMapping(69888, 69890, JoiningType.T);
			D[348] = new RegularRangeMapping(69927, 69931, JoiningType.T);
			D[349] = new RegularRangeMapping(69933, 69940, JoiningType.T);
			D[350] = new SingleElementRangeMapping(70003, JoiningType.T);
			D[351] = new RegularRangeMapping(70016, 70017, JoiningType.T);
			D[352] = new RegularRangeMapping(70070, 70078, JoiningType.T);
			D[353] = new RegularRangeMapping(70090, 70092, JoiningType.T);
			D[354] = new RegularRangeMapping(70191, 70193, JoiningType.T);
			D[355] = new SingleElementRangeMapping(70196, JoiningType.T);
			D[356] = new RegularRangeMapping(70198, 70199, JoiningType.T);
			D[357] = new SingleElementRangeMapping(70206, JoiningType.T);
			D[358] = new SingleElementRangeMapping(70367, JoiningType.T);
			D[359] = new RegularRangeMapping(70371, 70378, JoiningType.T);
			D[360] = new RegularRangeMapping(70400, 70401, JoiningType.T);
			D[361] = new SingleElementRangeMapping(70460, JoiningType.T);
			D[362] = new SingleElementRangeMapping(70464, JoiningType.T);
			D[363] = new RegularRangeMapping(70502, 70508, JoiningType.T);
			D[364] = new RegularRangeMapping(70512, 70516, JoiningType.T);
			D[365] = new RegularRangeMapping(70712, 70719, JoiningType.T);
			D[366] = new RegularRangeMapping(70722, 70724, JoiningType.T);
			D[367] = new SingleElementRangeMapping(70726, JoiningType.T);
			D[368] = new RegularRangeMapping(70835, 70840, JoiningType.T);
			D[369] = new SingleElementRangeMapping(70842, JoiningType.T);
			D[370] = new RegularRangeMapping(70847, 70848, JoiningType.T);
			D[371] = new RegularRangeMapping(70850, 70851, JoiningType.T);
			D[372] = new RegularRangeMapping(71090, 71093, JoiningType.T);
			D[373] = new RegularRangeMapping(71100, 71101, JoiningType.T);
			D[374] = new RegularRangeMapping(71103, 71104, JoiningType.T);
			D[375] = new RegularRangeMapping(71132, 71133, JoiningType.T);
			D[376] = new RegularRangeMapping(71219, 71226, JoiningType.T);
			D[377] = new SingleElementRangeMapping(71229, JoiningType.T);
			D[378] = new RegularRangeMapping(71231, 71232, JoiningType.T);
			D[379] = new SingleElementRangeMapping(71339, JoiningType.T);
			D[380] = new SingleElementRangeMapping(71341, JoiningType.T);
			D[381] = new RegularRangeMapping(71344, 71349, JoiningType.T);
			D[382] = new SingleElementRangeMapping(71351, JoiningType.T);
			D[383] = new RegularRangeMapping(71453, 71455, JoiningType.T);
			D[384] = new RegularRangeMapping(71458, 71461, JoiningType.T);
			D[385] = new RegularRangeMapping(71463, 71467, JoiningType.T);
			D[386] = new RegularRangeMapping(72752, 72758, JoiningType.T);
			D[387] = new RegularRangeMapping(72760, 72765, JoiningType.T);
			D[388] = new SingleElementRangeMapping(72767, JoiningType.T);
			D[389] = new RegularRangeMapping(72850, 72871, JoiningType.T);
			D[390] = new RegularRangeMapping(72874, 72880, JoiningType.T);
			D[391] = new RegularRangeMapping(72882, 72883, JoiningType.T);
			D[392] = new RegularRangeMapping(72885, 72886, JoiningType.T);
			D[393] = new RegularRangeMapping(92912, 92916, JoiningType.T);
			D[394] = new RegularRangeMapping(92976, 92982, JoiningType.T);
			D[395] = new RegularRangeMapping(94095, 94098, JoiningType.T);
			D[396] = new RegularRangeMapping(113821, 113822, JoiningType.T);
			D[397] = new RegularRangeMapping(113824, 113827, JoiningType.T);
			D[398] = new RegularRangeMapping(119143, 119145, JoiningType.T);
			D[399] = new RegularRangeMapping(119155, 119162, JoiningType.T);
			D[400] = new RegularRangeMapping(119163, 119170, JoiningType.T);
			D[401] = new RegularRangeMapping(119173, 119179, JoiningType.T);
			D[402] = new RegularRangeMapping(119210, 119213, JoiningType.T);
			D[403] = new RegularRangeMapping(119362, 119364, JoiningType.T);
			D[404] = new RegularRangeMapping(121344, 121398, JoiningType.T);
			D[405] = new RegularRangeMapping(121403, 121452, JoiningType.T);
			D[406] = new SingleElementRangeMapping(121461, JoiningType.T);
			D[407] = new SingleElementRangeMapping(121476, JoiningType.T);
			D[408] = new RegularRangeMapping(121499, 121503, JoiningType.T);
			D[409] = new RegularRangeMapping(121505, 121519, JoiningType.T);
			D[410] = new RegularRangeMapping(122880, 122886, JoiningType.T);
			D[411] = new RegularRangeMapping(122888, 122904, JoiningType.T);
			D[412] = new RegularRangeMapping(122907, 122913, JoiningType.T);
			D[413] = new RegularRangeMapping(122915, 122916, JoiningType.T);
			D[414] = new RegularRangeMapping(122918, 122922, JoiningType.T);
			D[415] = new RegularRangeMapping(125136, 125142, JoiningType.T);
			D[416] = new RegularRangeMapping(125184, 125251, JoiningType.D);
			D[417] = new RegularRangeMapping(125252, 125258, JoiningType.T);
			D[418] = new SingleElementRangeMapping(917505, JoiningType.T);
			D[419] = new RegularRangeMapping(917536, 917631, JoiningType.T);
			D[420] = new RegularRangeMapping(917760, 917999, JoiningType.T);
		}
	}
}