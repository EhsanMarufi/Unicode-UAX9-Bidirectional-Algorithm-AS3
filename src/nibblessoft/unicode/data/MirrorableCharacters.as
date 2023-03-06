package nibblessoft.unicode.data {
	
	public class MirrorableCharacters {
		
		private static const ENTRIES_COUNT:uint = 545;
		private static var D:Vector.<MirrorableCharacter>;
		
		
		/**
		 * Returns a <code>MirrorableCharacter</code> object in which the corresponding mirrored-glyph codepoint is stroed;
		 * using an efficient binary search algorithm.
		 * @param codepoint The Unicode<sup>&reg;</sup> codepoint to retrieve a <code>MirrorableCharacter</code>
		 *                  object, in which the corresponding mirrored glyph codepoint is stroed. 
		 * @return a <code>MirrorableCharacter</code> object in which the corresponding mirrored glyph codepoint is stroed,
		 *         or <code>null</code> if the specified codepoint doesn't reflect a mirrored codepoint.
		 * 
		 */
		public static function getMirroredCharacter(codepoint:uint):MirrorableCharacter {
			// Uses the Binary Search Algorithm
			var L:int = 0, R:int = ENTRIES_COUNT-1;
			var m:int;
			var mirrorableCharacter:MirrorableCharacter;
			
			while (true) {
				if (L > R)
					// Search should be terminated as unsuccessful
					break;
				
				m = Math.floor((L+R)/2);
				
				mirrorableCharacter = MirrorableCharacter(D[m]);
				if (mirrorableCharacter.glyphCodepoint < codepoint)
					L = m + 1;
				else if (mirrorableCharacter.glyphCodepoint > codepoint)
					R = m - 1;
				else
					// Found it!
					return mirrorableCharacter;
			}
			
			// Search terminates as unsuccessful
			return null;
		}
		
		
		// Static initializer
		{
			D = new Vector.<MirrorableCharacter>(ENTRIES_COUNT, true);
			
			// Because of the frequent need of the data to be present in memory, the reference
			// array is implemented "static".
			// It is prefered to have the data hard-coded as it provides some preformance gains 
			// compared to other methods of loading the data into the array (like through an 
			// external binary file), while the file size of the source-code increases!
			// The following enteries are sorted based on the first codepoint; the missed
			// codepoints are not mirrorable characters.
			D[0] = new MirrorableCharacter(40, 41);
			D[1] = new MirrorableCharacter(41, 40);
			D[2] = new MirrorableCharacter(60, 62);
			D[3] = new MirrorableCharacter(62, 60);
			D[4] = new MirrorableCharacter(91, 93);
			D[5] = new MirrorableCharacter(93, 91);
			D[6] = new MirrorableCharacter(123, 125);
			D[7] = new MirrorableCharacter(125, 123);
			D[8] = new MirrorableCharacter(171, 187);
			D[9] = new MirrorableCharacter(187, 171);
			D[10] = new MirrorableCharacter(3898, 3899);
			D[11] = new MirrorableCharacter(3899, 3898);
			D[12] = new MirrorableCharacter(3900, 3901);
			D[13] = new MirrorableCharacter(3901, 3900);
			D[14] = new MirrorableCharacter(5787, 5788);
			D[15] = new MirrorableCharacter(5788, 5787);
			D[16] = new MirrorableCharacter(8249, 8250);
			D[17] = new MirrorableCharacter(8250, 8249);
			D[18] = new MirrorableCharacter(8261, 8262);
			D[19] = new MirrorableCharacter(8262, 8261);
			D[20] = new MirrorableCharacter(8317, 8318);
			D[21] = new MirrorableCharacter(8318, 8317);
			D[22] = new MirrorableCharacter(8333, 8334);
			D[23] = new MirrorableCharacter(8334, 8333);
			D[24] = new MirrorableCharacter(8512, NaN);
			D[25] = new MirrorableCharacter(8705, NaN);
			D[26] = new MirrorableCharacter(8706, NaN);
			D[27] = new MirrorableCharacter(8707, NaN);
			D[28] = new MirrorableCharacter(8708, NaN);
			D[29] = new MirrorableCharacter(8712, 8715);
			D[30] = new MirrorableCharacter(8713, 8716);
			D[31] = new MirrorableCharacter(8714, 8717);
			D[32] = new MirrorableCharacter(8715, 8712);
			D[33] = new MirrorableCharacter(8716, 8713);
			D[34] = new MirrorableCharacter(8717, 8714);
			D[35] = new MirrorableCharacter(8721, NaN);
			D[36] = new MirrorableCharacter(8725, 10741);
			D[37] = new MirrorableCharacter(8726, NaN);
			D[38] = new MirrorableCharacter(8730, NaN);
			D[39] = new MirrorableCharacter(8731, NaN);
			D[40] = new MirrorableCharacter(8732, NaN);
			D[41] = new MirrorableCharacter(8733, NaN);
			D[42] = new MirrorableCharacter(8735, NaN);
			D[43] = new MirrorableCharacter(8736, NaN);
			D[44] = new MirrorableCharacter(8737, NaN);
			D[45] = new MirrorableCharacter(8738, NaN);
			D[46] = new MirrorableCharacter(8740, NaN);
			D[47] = new MirrorableCharacter(8742, NaN);
			D[48] = new MirrorableCharacter(8747, NaN);
			D[49] = new MirrorableCharacter(8748, NaN);
			D[50] = new MirrorableCharacter(8749, NaN);
			D[51] = new MirrorableCharacter(8750, NaN);
			D[52] = new MirrorableCharacter(8751, NaN);
			D[53] = new MirrorableCharacter(8752, NaN);
			D[54] = new MirrorableCharacter(8753, NaN);
			D[55] = new MirrorableCharacter(8754, NaN);
			D[56] = new MirrorableCharacter(8755, NaN);
			D[57] = new MirrorableCharacter(8761, NaN);
			D[58] = new MirrorableCharacter(8763, NaN);
			D[59] = new MirrorableCharacter(8764, 8765);
			D[60] = new MirrorableCharacter(8765, 8764);
			D[61] = new MirrorableCharacter(8766, NaN);
			D[62] = new MirrorableCharacter(8767, NaN);
			D[63] = new MirrorableCharacter(8768, NaN);
			D[64] = new MirrorableCharacter(8769, NaN);
			D[65] = new MirrorableCharacter(8770, NaN);
			D[66] = new MirrorableCharacter(8771, 8909);
			D[67] = new MirrorableCharacter(8772, NaN);
			D[68] = new MirrorableCharacter(8773, NaN);
			D[69] = new MirrorableCharacter(8774, NaN);
			D[70] = new MirrorableCharacter(8775, NaN);
			D[71] = new MirrorableCharacter(8776, NaN);
			D[72] = new MirrorableCharacter(8777, NaN);
			D[73] = new MirrorableCharacter(8778, NaN);
			D[74] = new MirrorableCharacter(8779, NaN);
			D[75] = new MirrorableCharacter(8780, NaN);
			D[76] = new MirrorableCharacter(8786, 8787);
			D[77] = new MirrorableCharacter(8787, 8786);
			D[78] = new MirrorableCharacter(8788, 8789);
			D[79] = new MirrorableCharacter(8789, 8788);
			D[80] = new MirrorableCharacter(8799, NaN);
			D[81] = new MirrorableCharacter(8800, NaN);
			D[82] = new MirrorableCharacter(8802, NaN);
			D[83] = new MirrorableCharacter(8804, 8805);
			D[84] = new MirrorableCharacter(8805, 8804);
			D[85] = new MirrorableCharacter(8806, 8807);
			D[86] = new MirrorableCharacter(8807, 8806);
			D[87] = new MirrorableCharacter(8808, 8809);
			D[88] = new MirrorableCharacter(8809, 8808);
			D[89] = new MirrorableCharacter(8810, 8811);
			D[90] = new MirrorableCharacter(8811, 8810);
			D[91] = new MirrorableCharacter(8814, 8815);
			D[92] = new MirrorableCharacter(8815, 8814);
			D[93] = new MirrorableCharacter(8816, 8817);
			D[94] = new MirrorableCharacter(8817, 8816);
			D[95] = new MirrorableCharacter(8818, 8819);
			D[96] = new MirrorableCharacter(8819, 8818);
			D[97] = new MirrorableCharacter(8820, 8821);
			D[98] = new MirrorableCharacter(8821, 8820);
			D[99] = new MirrorableCharacter(8822, 8823);
			D[100] = new MirrorableCharacter(8823, 8822);
			D[101] = new MirrorableCharacter(8824, 8825);
			D[102] = new MirrorableCharacter(8825, 8824);
			D[103] = new MirrorableCharacter(8826, 8827);
			D[104] = new MirrorableCharacter(8827, 8826);
			D[105] = new MirrorableCharacter(8828, 8829);
			D[106] = new MirrorableCharacter(8829, 8828);
			D[107] = new MirrorableCharacter(8830, 8831);
			D[108] = new MirrorableCharacter(8831, 8830);
			D[109] = new MirrorableCharacter(8832, 8833);
			D[110] = new MirrorableCharacter(8833, 8832);
			D[111] = new MirrorableCharacter(8834, 8835);
			D[112] = new MirrorableCharacter(8835, 8834);
			D[113] = new MirrorableCharacter(8836, 8837);
			D[114] = new MirrorableCharacter(8837, 8836);
			D[115] = new MirrorableCharacter(8838, 8839);
			D[116] = new MirrorableCharacter(8839, 8838);
			D[117] = new MirrorableCharacter(8840, 8841);
			D[118] = new MirrorableCharacter(8841, 8840);
			D[119] = new MirrorableCharacter(8842, 8843);
			D[120] = new MirrorableCharacter(8843, 8842);
			D[121] = new MirrorableCharacter(8844, NaN);
			D[122] = new MirrorableCharacter(8847, 8848);
			D[123] = new MirrorableCharacter(8848, 8847);
			D[124] = new MirrorableCharacter(8849, 8850);
			D[125] = new MirrorableCharacter(8850, 8849);
			D[126] = new MirrorableCharacter(8856, 10680);
			D[127] = new MirrorableCharacter(8866, 8867);
			D[128] = new MirrorableCharacter(8867, 8866);
			D[129] = new MirrorableCharacter(8870, 10974);
			D[130] = new MirrorableCharacter(8871, NaN);
			D[131] = new MirrorableCharacter(8872, 10980);
			D[132] = new MirrorableCharacter(8873, 10979);
			D[133] = new MirrorableCharacter(8874, NaN);
			D[134] = new MirrorableCharacter(8875, 10981);
			D[135] = new MirrorableCharacter(8876, NaN);
			D[136] = new MirrorableCharacter(8877, NaN);
			D[137] = new MirrorableCharacter(8878, NaN);
			D[138] = new MirrorableCharacter(8879, NaN);
			D[139] = new MirrorableCharacter(8880, 8881);
			D[140] = new MirrorableCharacter(8881, 8880);
			D[141] = new MirrorableCharacter(8882, 8883);
			D[142] = new MirrorableCharacter(8883, 8882);
			D[143] = new MirrorableCharacter(8884, 8885);
			D[144] = new MirrorableCharacter(8885, 8884);
			D[145] = new MirrorableCharacter(8886, 8887);
			D[146] = new MirrorableCharacter(8887, 8886);
			D[147] = new MirrorableCharacter(8888, NaN);
			D[148] = new MirrorableCharacter(8894, NaN);
			D[149] = new MirrorableCharacter(8895, NaN);
			D[150] = new MirrorableCharacter(8905, 8906);
			D[151] = new MirrorableCharacter(8906, 8905);
			D[152] = new MirrorableCharacter(8907, 8908);
			D[153] = new MirrorableCharacter(8908, 8907);
			D[154] = new MirrorableCharacter(8909, 8771);
			D[155] = new MirrorableCharacter(8912, 8913);
			D[156] = new MirrorableCharacter(8913, 8912);
			D[157] = new MirrorableCharacter(8918, 8919);
			D[158] = new MirrorableCharacter(8919, 8918);
			D[159] = new MirrorableCharacter(8920, 8921);
			D[160] = new MirrorableCharacter(8921, 8920);
			D[161] = new MirrorableCharacter(8922, 8923);
			D[162] = new MirrorableCharacter(8923, 8922);
			D[163] = new MirrorableCharacter(8924, 8925);
			D[164] = new MirrorableCharacter(8925, 8924);
			D[165] = new MirrorableCharacter(8926, 8927);
			D[166] = new MirrorableCharacter(8927, 8926);
			D[167] = new MirrorableCharacter(8928, 8929);
			D[168] = new MirrorableCharacter(8929, 8928);
			D[169] = new MirrorableCharacter(8930, 8931);
			D[170] = new MirrorableCharacter(8931, 8930);
			D[171] = new MirrorableCharacter(8932, 8933);
			D[172] = new MirrorableCharacter(8933, 8932);
			D[173] = new MirrorableCharacter(8934, 8935);
			D[174] = new MirrorableCharacter(8935, 8934);
			D[175] = new MirrorableCharacter(8936, 8937);
			D[176] = new MirrorableCharacter(8937, 8936);
			D[177] = new MirrorableCharacter(8938, 8939);
			D[178] = new MirrorableCharacter(8939, 8938);
			D[179] = new MirrorableCharacter(8940, 8941);
			D[180] = new MirrorableCharacter(8941, 8940);
			D[181] = new MirrorableCharacter(8944, 8945);
			D[182] = new MirrorableCharacter(8945, 8944);
			D[183] = new MirrorableCharacter(8946, 8954);
			D[184] = new MirrorableCharacter(8947, 8955);
			D[185] = new MirrorableCharacter(8948, 8956);
			D[186] = new MirrorableCharacter(8949, NaN);
			D[187] = new MirrorableCharacter(8950, 8957);
			D[188] = new MirrorableCharacter(8951, 8958);
			D[189] = new MirrorableCharacter(8952, NaN);
			D[190] = new MirrorableCharacter(8953, NaN);
			D[191] = new MirrorableCharacter(8954, 8946);
			D[192] = new MirrorableCharacter(8955, 8947);
			D[193] = new MirrorableCharacter(8956, 8948);
			D[194] = new MirrorableCharacter(8957, 8950);
			D[195] = new MirrorableCharacter(8958, 8951);
			D[196] = new MirrorableCharacter(8959, NaN);
			D[197] = new MirrorableCharacter(8968, 8969);
			D[198] = new MirrorableCharacter(8969, 8968);
			D[199] = new MirrorableCharacter(8970, 8971);
			D[200] = new MirrorableCharacter(8971, 8970);
			D[201] = new MirrorableCharacter(8992, NaN);
			D[202] = new MirrorableCharacter(8993, NaN);
			D[203] = new MirrorableCharacter(9001, 9002);
			D[204] = new MirrorableCharacter(9002, 9001);
			D[205] = new MirrorableCharacter(10088, 10089);
			D[206] = new MirrorableCharacter(10089, 10088);
			D[207] = new MirrorableCharacter(10090, 10091);
			D[208] = new MirrorableCharacter(10091, 10090);
			D[209] = new MirrorableCharacter(10092, 10093);
			D[210] = new MirrorableCharacter(10093, 10092);
			D[211] = new MirrorableCharacter(10094, 10095);
			D[212] = new MirrorableCharacter(10095, 10094);
			D[213] = new MirrorableCharacter(10096, 10097);
			D[214] = new MirrorableCharacter(10097, 10096);
			D[215] = new MirrorableCharacter(10098, 10099);
			D[216] = new MirrorableCharacter(10099, 10098);
			D[217] = new MirrorableCharacter(10100, 10101);
			D[218] = new MirrorableCharacter(10101, 10100);
			D[219] = new MirrorableCharacter(10176, NaN);
			D[220] = new MirrorableCharacter(10179, 10180);
			D[221] = new MirrorableCharacter(10180, 10179);
			D[222] = new MirrorableCharacter(10181, 10182);
			D[223] = new MirrorableCharacter(10182, 10181);
			D[224] = new MirrorableCharacter(10184, 10185);
			D[225] = new MirrorableCharacter(10185, 10184);
			D[226] = new MirrorableCharacter(10187, 10189);
			D[227] = new MirrorableCharacter(10188, NaN);
			D[228] = new MirrorableCharacter(10189, 10187);
			D[229] = new MirrorableCharacter(10195, NaN);
			D[230] = new MirrorableCharacter(10196, NaN);
			D[231] = new MirrorableCharacter(10197, 10198);
			D[232] = new MirrorableCharacter(10198, 10197);
			D[233] = new MirrorableCharacter(10204, NaN);
			D[234] = new MirrorableCharacter(10205, 10206);
			D[235] = new MirrorableCharacter(10206, 10205);
			D[236] = new MirrorableCharacter(10210, 10211);
			D[237] = new MirrorableCharacter(10211, 10210);
			D[238] = new MirrorableCharacter(10212, 10213);
			D[239] = new MirrorableCharacter(10213, 10212);
			D[240] = new MirrorableCharacter(10214, 10215);
			D[241] = new MirrorableCharacter(10215, 10214);
			D[242] = new MirrorableCharacter(10216, 10217);
			D[243] = new MirrorableCharacter(10217, 10216);
			D[244] = new MirrorableCharacter(10218, 10219);
			D[245] = new MirrorableCharacter(10219, 10218);
			D[246] = new MirrorableCharacter(10220, 10221);
			D[247] = new MirrorableCharacter(10221, 10220);
			D[248] = new MirrorableCharacter(10222, 10223);
			D[249] = new MirrorableCharacter(10223, 10222);
			D[250] = new MirrorableCharacter(10627, 10628);
			D[251] = new MirrorableCharacter(10628, 10627);
			D[252] = new MirrorableCharacter(10629, 10630);
			D[253] = new MirrorableCharacter(10630, 10629);
			D[254] = new MirrorableCharacter(10631, 10632);
			D[255] = new MirrorableCharacter(10632, 10631);
			D[256] = new MirrorableCharacter(10633, 10634);
			D[257] = new MirrorableCharacter(10634, 10633);
			D[258] = new MirrorableCharacter(10635, 10636);
			D[259] = new MirrorableCharacter(10636, 10635);
			D[260] = new MirrorableCharacter(10637, 10640);
			D[261] = new MirrorableCharacter(10638, 10639);
			D[262] = new MirrorableCharacter(10639, 10638);
			D[263] = new MirrorableCharacter(10640, 10637);
			D[264] = new MirrorableCharacter(10641, 10642);
			D[265] = new MirrorableCharacter(10642, 10641);
			D[266] = new MirrorableCharacter(10643, 10644);
			D[267] = new MirrorableCharacter(10644, 10643);
			D[268] = new MirrorableCharacter(10645, 10646);
			D[269] = new MirrorableCharacter(10646, 10645);
			D[270] = new MirrorableCharacter(10647, 10648);
			D[271] = new MirrorableCharacter(10648, 10647);
			D[272] = new MirrorableCharacter(10651, NaN);
			D[273] = new MirrorableCharacter(10652, NaN);
			D[274] = new MirrorableCharacter(10653, NaN);
			D[275] = new MirrorableCharacter(10654, NaN);
			D[276] = new MirrorableCharacter(10655, NaN);
			D[277] = new MirrorableCharacter(10656, NaN);
			D[278] = new MirrorableCharacter(10657, NaN);
			D[279] = new MirrorableCharacter(10658, NaN);
			D[280] = new MirrorableCharacter(10659, NaN);
			D[281] = new MirrorableCharacter(10660, NaN);
			D[282] = new MirrorableCharacter(10661, NaN);
			D[283] = new MirrorableCharacter(10662, NaN);
			D[284] = new MirrorableCharacter(10663, NaN);
			D[285] = new MirrorableCharacter(10664, NaN);
			D[286] = new MirrorableCharacter(10665, NaN);
			D[287] = new MirrorableCharacter(10666, NaN);
			D[288] = new MirrorableCharacter(10667, NaN);
			D[289] = new MirrorableCharacter(10668, NaN);
			D[290] = new MirrorableCharacter(10669, NaN);
			D[291] = new MirrorableCharacter(10670, NaN);
			D[292] = new MirrorableCharacter(10671, NaN);
			D[293] = new MirrorableCharacter(10680, 8856);
			D[294] = new MirrorableCharacter(10688, 10689);
			D[295] = new MirrorableCharacter(10689, 10688);
			D[296] = new MirrorableCharacter(10690, NaN);
			D[297] = new MirrorableCharacter(10691, NaN);
			D[298] = new MirrorableCharacter(10692, 10693);
			D[299] = new MirrorableCharacter(10693, 10692);
			D[300] = new MirrorableCharacter(10697, NaN);
			D[301] = new MirrorableCharacter(10702, NaN);
			D[302] = new MirrorableCharacter(10703, 10704);
			D[303] = new MirrorableCharacter(10704, 10703);
			D[304] = new MirrorableCharacter(10705, 10706);
			D[305] = new MirrorableCharacter(10706, 10705);
			D[306] = new MirrorableCharacter(10708, 10709);
			D[307] = new MirrorableCharacter(10709, 10708);
			D[308] = new MirrorableCharacter(10712, 10713);
			D[309] = new MirrorableCharacter(10713, 10712);
			D[310] = new MirrorableCharacter(10714, 10715);
			D[311] = new MirrorableCharacter(10715, 10714);
			D[312] = new MirrorableCharacter(10716, NaN);
			D[313] = new MirrorableCharacter(10721, NaN);
			D[314] = new MirrorableCharacter(10723, NaN);
			D[315] = new MirrorableCharacter(10724, NaN);
			D[316] = new MirrorableCharacter(10725, NaN);
			D[317] = new MirrorableCharacter(10728, NaN);
			D[318] = new MirrorableCharacter(10729, NaN);
			D[319] = new MirrorableCharacter(10740, NaN);
			D[320] = new MirrorableCharacter(10741, 8725);
			D[321] = new MirrorableCharacter(10742, NaN);
			D[322] = new MirrorableCharacter(10743, NaN);
			D[323] = new MirrorableCharacter(10744, 10745);
			D[324] = new MirrorableCharacter(10745, 10744);
			D[325] = new MirrorableCharacter(10748, 10749);
			D[326] = new MirrorableCharacter(10749, 10748);
			D[327] = new MirrorableCharacter(10762, NaN);
			D[328] = new MirrorableCharacter(10763, NaN);
			D[329] = new MirrorableCharacter(10764, NaN);
			D[330] = new MirrorableCharacter(10765, NaN);
			D[331] = new MirrorableCharacter(10766, NaN);
			D[332] = new MirrorableCharacter(10767, NaN);
			D[333] = new MirrorableCharacter(10768, NaN);
			D[334] = new MirrorableCharacter(10769, NaN);
			D[335] = new MirrorableCharacter(10770, NaN);
			D[336] = new MirrorableCharacter(10771, NaN);
			D[337] = new MirrorableCharacter(10772, NaN);
			D[338] = new MirrorableCharacter(10773, NaN);
			D[339] = new MirrorableCharacter(10774, NaN);
			D[340] = new MirrorableCharacter(10775, NaN);
			D[341] = new MirrorableCharacter(10776, NaN);
			D[342] = new MirrorableCharacter(10777, NaN);
			D[343] = new MirrorableCharacter(10778, NaN);
			D[344] = new MirrorableCharacter(10779, NaN);
			D[345] = new MirrorableCharacter(10780, NaN);
			D[346] = new MirrorableCharacter(10782, NaN);
			D[347] = new MirrorableCharacter(10783, NaN);
			D[348] = new MirrorableCharacter(10784, NaN);
			D[349] = new MirrorableCharacter(10785, NaN);
			D[350] = new MirrorableCharacter(10788, NaN);
			D[351] = new MirrorableCharacter(10790, NaN);
			D[352] = new MirrorableCharacter(10793, NaN);
			D[353] = new MirrorableCharacter(10795, 10796);
			D[354] = new MirrorableCharacter(10796, 10795);
			D[355] = new MirrorableCharacter(10797, 10798);
			D[356] = new MirrorableCharacter(10798, 10797);
			D[357] = new MirrorableCharacter(10804, 10805);
			D[358] = new MirrorableCharacter(10805, 10804);
			D[359] = new MirrorableCharacter(10812, 10813);
			D[360] = new MirrorableCharacter(10813, 10812);
			D[361] = new MirrorableCharacter(10814, NaN);
			D[362] = new MirrorableCharacter(10839, NaN);
			D[363] = new MirrorableCharacter(10840, NaN);
			D[364] = new MirrorableCharacter(10852, 10853);
			D[365] = new MirrorableCharacter(10853, 10852);
			D[366] = new MirrorableCharacter(10858, NaN);
			D[367] = new MirrorableCharacter(10859, NaN);
			D[368] = new MirrorableCharacter(10860, NaN);
			D[369] = new MirrorableCharacter(10861, NaN);
			D[370] = new MirrorableCharacter(10863, NaN);
			D[371] = new MirrorableCharacter(10864, NaN);
			D[372] = new MirrorableCharacter(10867, NaN);
			D[373] = new MirrorableCharacter(10868, NaN);
			D[374] = new MirrorableCharacter(10873, 10874);
			D[375] = new MirrorableCharacter(10874, 10873);
			D[376] = new MirrorableCharacter(10875, NaN);
			D[377] = new MirrorableCharacter(10876, NaN);
			D[378] = new MirrorableCharacter(10877, 10878);
			D[379] = new MirrorableCharacter(10878, 10877);
			D[380] = new MirrorableCharacter(10879, 10880);
			D[381] = new MirrorableCharacter(10880, 10879);
			D[382] = new MirrorableCharacter(10881, 10882);
			D[383] = new MirrorableCharacter(10882, 10881);
			D[384] = new MirrorableCharacter(10883, 10884);
			D[385] = new MirrorableCharacter(10884, 10883);
			D[386] = new MirrorableCharacter(10885, NaN);
			D[387] = new MirrorableCharacter(10886, NaN);
			D[388] = new MirrorableCharacter(10887, NaN);
			D[389] = new MirrorableCharacter(10888, NaN);
			D[390] = new MirrorableCharacter(10889, NaN);
			D[391] = new MirrorableCharacter(10890, NaN);
			D[392] = new MirrorableCharacter(10891, 10892);
			D[393] = new MirrorableCharacter(10892, 10891);
			D[394] = new MirrorableCharacter(10893, NaN);
			D[395] = new MirrorableCharacter(10894, NaN);
			D[396] = new MirrorableCharacter(10895, NaN);
			D[397] = new MirrorableCharacter(10896, NaN);
			D[398] = new MirrorableCharacter(10897, 10898);
			D[399] = new MirrorableCharacter(10898, 10897);
			D[400] = new MirrorableCharacter(10899, 10900);
			D[401] = new MirrorableCharacter(10900, 10899);
			D[402] = new MirrorableCharacter(10901, 10902);
			D[403] = new MirrorableCharacter(10902, 10901);
			D[404] = new MirrorableCharacter(10903, 10904);
			D[405] = new MirrorableCharacter(10904, 10903);
			D[406] = new MirrorableCharacter(10905, 10906);
			D[407] = new MirrorableCharacter(10906, 10905);
			D[408] = new MirrorableCharacter(10907, 10908);
			D[409] = new MirrorableCharacter(10908, 10907);
			D[410] = new MirrorableCharacter(10909, NaN);
			D[411] = new MirrorableCharacter(10910, NaN);
			D[412] = new MirrorableCharacter(10911, NaN);
			D[413] = new MirrorableCharacter(10912, NaN);
			D[414] = new MirrorableCharacter(10913, 10914);
			D[415] = new MirrorableCharacter(10914, 10913);
			D[416] = new MirrorableCharacter(10915, NaN);
			D[417] = new MirrorableCharacter(10918, 10919);
			D[418] = new MirrorableCharacter(10919, 10918);
			D[419] = new MirrorableCharacter(10920, 10921);
			D[420] = new MirrorableCharacter(10921, 10920);
			D[421] = new MirrorableCharacter(10922, 10923);
			D[422] = new MirrorableCharacter(10923, 10922);
			D[423] = new MirrorableCharacter(10924, 10925);
			D[424] = new MirrorableCharacter(10925, 10924);
			D[425] = new MirrorableCharacter(10927, 10928);
			D[426] = new MirrorableCharacter(10928, 10927);
			D[427] = new MirrorableCharacter(10929, NaN);
			D[428] = new MirrorableCharacter(10930, NaN);
			D[429] = new MirrorableCharacter(10931, 10932);
			D[430] = new MirrorableCharacter(10932, 10931);
			D[431] = new MirrorableCharacter(10933, NaN);
			D[432] = new MirrorableCharacter(10934, NaN);
			D[433] = new MirrorableCharacter(10935, NaN);
			D[434] = new MirrorableCharacter(10936, NaN);
			D[435] = new MirrorableCharacter(10937, NaN);
			D[436] = new MirrorableCharacter(10938, NaN);
			D[437] = new MirrorableCharacter(10939, 10940);
			D[438] = new MirrorableCharacter(10940, 10939);
			D[439] = new MirrorableCharacter(10941, 10942);
			D[440] = new MirrorableCharacter(10942, 10941);
			D[441] = new MirrorableCharacter(10943, 10944);
			D[442] = new MirrorableCharacter(10944, 10943);
			D[443] = new MirrorableCharacter(10945, 10946);
			D[444] = new MirrorableCharacter(10946, 10945);
			D[445] = new MirrorableCharacter(10947, 10948);
			D[446] = new MirrorableCharacter(10948, 10947);
			D[447] = new MirrorableCharacter(10949, 10950);
			D[448] = new MirrorableCharacter(10950, 10949);
			D[449] = new MirrorableCharacter(10951, NaN);
			D[450] = new MirrorableCharacter(10952, NaN);
			D[451] = new MirrorableCharacter(10953, NaN);
			D[452] = new MirrorableCharacter(10954, NaN);
			D[453] = new MirrorableCharacter(10955, NaN);
			D[454] = new MirrorableCharacter(10956, NaN);
			D[455] = new MirrorableCharacter(10957, 10958);
			D[456] = new MirrorableCharacter(10958, 10957);
			D[457] = new MirrorableCharacter(10959, 10960);
			D[458] = new MirrorableCharacter(10960, 10959);
			D[459] = new MirrorableCharacter(10961, 10962);
			D[460] = new MirrorableCharacter(10962, 10961);
			D[461] = new MirrorableCharacter(10963, 10964);
			D[462] = new MirrorableCharacter(10964, 10963);
			D[463] = new MirrorableCharacter(10965, 10966);
			D[464] = new MirrorableCharacter(10966, 10965);
			D[465] = new MirrorableCharacter(10972, NaN);
			D[466] = new MirrorableCharacter(10974, 8870);
			D[467] = new MirrorableCharacter(10978, NaN);
			D[468] = new MirrorableCharacter(10979, 8873);
			D[469] = new MirrorableCharacter(10980, 8872);
			D[470] = new MirrorableCharacter(10981, 8875);
			D[471] = new MirrorableCharacter(10982, NaN);
			D[472] = new MirrorableCharacter(10988, 10989);
			D[473] = new MirrorableCharacter(10989, 10988);
			D[474] = new MirrorableCharacter(10990, NaN);
			D[475] = new MirrorableCharacter(10995, NaN);
			D[476] = new MirrorableCharacter(10999, 11000);
			D[477] = new MirrorableCharacter(11000, 10999);
			D[478] = new MirrorableCharacter(11001, 11002);
			D[479] = new MirrorableCharacter(11002, 11001);
			D[480] = new MirrorableCharacter(11003, NaN);
			D[481] = new MirrorableCharacter(11005, NaN);
			D[482] = new MirrorableCharacter(11778, 11779);
			D[483] = new MirrorableCharacter(11779, 11778);
			D[484] = new MirrorableCharacter(11780, 11781);
			D[485] = new MirrorableCharacter(11781, 11780);
			D[486] = new MirrorableCharacter(11785, 11786);
			D[487] = new MirrorableCharacter(11786, 11785);
			D[488] = new MirrorableCharacter(11788, 11789);
			D[489] = new MirrorableCharacter(11789, 11788);
			D[490] = new MirrorableCharacter(11804, 11805);
			D[491] = new MirrorableCharacter(11805, 11804);
			D[492] = new MirrorableCharacter(11808, 11809);
			D[493] = new MirrorableCharacter(11809, 11808);
			D[494] = new MirrorableCharacter(11810, 11811);
			D[495] = new MirrorableCharacter(11811, 11810);
			D[496] = new MirrorableCharacter(11812, 11813);
			D[497] = new MirrorableCharacter(11813, 11812);
			D[498] = new MirrorableCharacter(11814, 11815);
			D[499] = new MirrorableCharacter(11815, 11814);
			D[500] = new MirrorableCharacter(11816, 11817);
			D[501] = new MirrorableCharacter(11817, 11816);
			D[502] = new MirrorableCharacter(12296, 12297);
			D[503] = new MirrorableCharacter(12297, 12296);
			D[504] = new MirrorableCharacter(12298, 12299);
			D[505] = new MirrorableCharacter(12299, 12298);
			D[506] = new MirrorableCharacter(12300, 12301);
			D[507] = new MirrorableCharacter(12301, 12300);
			D[508] = new MirrorableCharacter(12302, 12303);
			D[509] = new MirrorableCharacter(12303, 12302);
			D[510] = new MirrorableCharacter(12304, 12305);
			D[511] = new MirrorableCharacter(12305, 12304);
			D[512] = new MirrorableCharacter(12308, 12309);
			D[513] = new MirrorableCharacter(12309, 12308);
			D[514] = new MirrorableCharacter(12310, 12311);
			D[515] = new MirrorableCharacter(12311, 12310);
			D[516] = new MirrorableCharacter(12312, 12313);
			D[517] = new MirrorableCharacter(12313, 12312);
			D[518] = new MirrorableCharacter(12314, 12315);
			D[519] = new MirrorableCharacter(12315, 12314);
			D[520] = new MirrorableCharacter(65113, 65114);
			D[521] = new MirrorableCharacter(65114, 65113);
			D[522] = new MirrorableCharacter(65115, 65116);
			D[523] = new MirrorableCharacter(65116, 65115);
			D[524] = new MirrorableCharacter(65117, 65118);
			D[525] = new MirrorableCharacter(65118, 65117);
			D[526] = new MirrorableCharacter(65124, 65125);
			D[527] = new MirrorableCharacter(65125, 65124);
			D[528] = new MirrorableCharacter(65288, 65289);
			D[529] = new MirrorableCharacter(65289, 65288);
			D[530] = new MirrorableCharacter(65308, 65310);
			D[531] = new MirrorableCharacter(65310, 65308);
			D[532] = new MirrorableCharacter(65339, 65341);
			D[533] = new MirrorableCharacter(65341, 65339);
			D[534] = new MirrorableCharacter(65371, 65373);
			D[535] = new MirrorableCharacter(65373, 65371);
			D[536] = new MirrorableCharacter(65375, 65376);
			D[537] = new MirrorableCharacter(65376, 65375);
			D[538] = new MirrorableCharacter(65378, 65379);
			D[539] = new MirrorableCharacter(65379, 65378);
			D[540] = new MirrorableCharacter(120539, NaN);
			D[541] = new MirrorableCharacter(120597, NaN);
			D[542] = new MirrorableCharacter(120655, NaN);
			D[543] = new MirrorableCharacter(120713, NaN);
			D[544] = new MirrorableCharacter(120771, NaN);
		}
	}
}