%%%%%%%%%%%
%% Fig.2 %%
%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VFM eccentricity (left) & polar angle (middle), best fitting numerosity model (right) meshes Fig.2a %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% NOTE: requires an inflated cortical surface structure (grayLayer1) - not shareable without being identifiable
data_dir = '/home/data/';

paths{1} = strcat(data_dir,'P01');
paths{2} = strcat(data_dir,'P02');
paths{3} = strcat(data_dir,'P03');
paths{4} = strcat(data_dir,'P04');
paths{5} = strcat(data_dir,'P05');
paths{6} = strcat(data_dir,'P06');
paths{7} = strcat(data_dir,'P07');
paths{8} = strcat(data_dir,'P08');
paths{9} = strcat(data_dir,'P09');
paths{10} = strcat(data_dir,'P10');
paths{11} = strcat(data_dir,'P11');

displayMesh = 1;
saveData = 1;

modelFieldNames = {'TunedLog2Lin', 'MonoLog'};
participantNames = {'P01', 'P02', 'P03', 'P04', 'P05', 'P06', 'P07', 'P08', 'P09', 'P10', 'P11'};
ROINames = {'gray-Layer1'}; ROIFieldNames = {'grayLayer1'}; %#ok<NASGU>

% Colormaps for mesh surface, from https://www.fabiocrameri.ch/colourmaps/
vik = ...
   [0.0013,0.0698,0.3795;0.0024,0.0765,0.3835;0.0033,0.0831,0.3875;0.0041,0.0896,0.3915;
    0.0049,0.0959,0.3955;0.0056,0.1023,0.3994;0.0062,0.1085,0.4034;0.0067,0.1147,0.4073;
    0.0071,0.1208,0.4113;0.0075,0.1270,0.4152;0.0079,0.1331,0.4192;0.0081,0.1391,0.4231;
    0.0084,0.1452,0.4270;0.0086,0.1511,0.4309;0.0088,0.1571,0.4348;0.0089,0.1632,0.4387;
    0.0091,0.1691,0.4426;0.0092,0.1751,0.4465;0.0093,0.1811,0.4503;0.0094,0.1871,0.4542;
    0.0094,0.1930,0.4581;0.0095,0.1990,0.4620;0.0096,0.2050,0.4658;0.0096,0.2110,0.4697;
    0.0097,0.2170,0.4736;0.0097,0.2231,0.4775;0.0098,0.2291,0.4814;0.0099,0.2352,0.4852;
    0.0100,0.2413,0.4892;0.0101,0.2474,0.4931;0.0103,0.2535,0.4970;0.0105,0.2597,0.5010;
    0.0108,0.2659,0.5049;0.0112,0.2720,0.5089;0.0117,0.2783,0.5129;0.0123,0.2846,0.5170;
    0.0129,0.2909,0.5210;0.0138,0.2972,0.5251;0.0148,0.3036,0.5292;0.0161,0.3100,0.5333;
    0.0177,0.3165,0.5375;0.0196,0.3230,0.5417;0.0219,0.3296,0.5459;0.0247,0.3361,0.5502;
    0.0280,0.3428,0.5545;0.0320,0.3495,0.5589;0.0368,0.3563,0.5633;0.0422,0.3632,0.5678;
    0.0480,0.3701,0.5723;0.0543,0.3771,0.5769;0.0610,0.3841,0.5816;0.0681,0.3913,0.5863;
    0.0755,0.3985,0.5910;0.0832,0.4057,0.5959;0.0914,0.4131,0.6008;0.0998,0.4205,0.6057;
    0.1086,0.4280,0.6107;0.1177,0.4356,0.6158;0.1270,0.4432,0.6209;0.1367,0.4509,0.6261;
    0.1466,0.4586,0.6313;0.1568,0.4665,0.6366;0.1672,0.4743,0.6419;0.1778,0.4822,0.6472;
    0.1886,0.4902,0.6526;0.1996,0.4982,0.6580;0.2108,0.5062,0.6635;0.2221,0.5143,0.6689;
    0.2336,0.5223,0.6744;0.2452,0.5304,0.6799;0.2570,0.5385,0.6854;0.2689,0.5466,0.6909;
    0.2808,0.5547,0.6964;0.2929,0.5628,0.7019;0.3050,0.5709,0.7074;0.3172,0.5790,0.7129;
    0.3294,0.5871,0.7184;0.3417,0.5951,0.7239;0.3541,0.6032,0.7294;0.3665,0.6112,0.7349;
    0.3789,0.6192,0.7403;0.3913,0.6272,0.7458;0.4038,0.6351,0.7512;0.4162,0.6430,0.7566;
    0.4287,0.6510,0.7620;0.4412,0.6588,0.7673;0.4537,0.6667,0.7727;0.4662,0.6745,0.7780;
    0.4787,0.6823,0.7834;0.4912,0.6901,0.7887;0.5037,0.6979,0.7940;0.5162,0.7057,0.7993;
    0.5287,0.7134,0.8045;0.5411,0.7211,0.8098;0.5536,0.7288,0.8150;0.5661,0.7364,0.8202;
    0.5786,0.7441,0.8254;0.5910,0.7517,0.8306;0.6035,0.7593,0.8358;0.6159,0.7669,0.8409;
    0.6284,0.7745,0.8461;0.6408,0.7820,0.8511;0.6532,0.7895,0.8562;0.6656,0.7969,0.8612;
    0.6781,0.8044,0.8662;0.6905,0.8117,0.8711;0.7029,0.8190,0.8759;0.7153,0.8263,0.8806;
    0.7276,0.8334,0.8851;0.7400,0.8405,0.8896;0.7524,0.8474,0.8938;0.7647,0.8541,0.8978;
    0.7769,0.8607,0.9016;0.7891,0.8670,0.9050;0.8012,0.8730,0.9080;0.8131,0.8787,0.9107;
    0.8249,0.8841,0.9128;0.8364,0.8889,0.9143;0.8476,0.8933,0.9152;0.8585,0.8971,0.9154;
    0.8689,0.9002,0.9148;0.8787,0.9026,0.9134;0.8880,0.9043,0.9112;0.8965,0.9052,0.9080;
    0.9042,0.9052,0.9040;0.9112,0.9044,0.8991;0.9172,0.9028,0.8934;0.9223,0.9004,0.8869;
    0.9265,0.8972,0.8797;0.9298,0.8933,0.8718;0.9322,0.8887,0.8634;0.9339,0.8836,0.8545;
    0.9348,0.8779,0.8452;0.9350,0.8718,0.8355;0.9346,0.8653,0.8256;0.9338,0.8585,0.8154;
    0.9324,0.8515,0.8051;0.9307,0.8442,0.7947;0.9286,0.8368,0.7842;0.9263,0.8292,0.7736;
    0.9238,0.8215,0.7630;0.9210,0.8138,0.7523;0.9181,0.8060,0.7417;0.9152,0.7982,0.7310;
    0.9121,0.7903,0.7204;0.9089,0.7824,0.7098;0.9057,0.7745,0.6991;0.9025,0.7667,0.6886;
    0.8992,0.7588,0.6781;0.8960,0.7510,0.6675;0.8927,0.7431,0.6571;0.8894,0.7353,0.6467;
    0.8861,0.7276,0.6363;0.8828,0.7198,0.6259;0.8796,0.7121,0.6156;0.8763,0.7044,0.6054;
    0.8730,0.6968,0.5951;0.8698,0.6891,0.5850;0.8666,0.6815,0.5748;0.8633,0.6740,0.5647;
    0.8601,0.6665,0.5547;0.8569,0.6590,0.5447;0.8537,0.6515,0.5348;0.8506,0.6441,0.5248;
    0.8474,0.6367,0.5150;0.8443,0.6293,0.5051;0.8411,0.6220,0.4954;0.8380,0.6147,0.4856;
    0.8349,0.6074,0.4759;0.8318,0.6001,0.4663;0.8287,0.5929,0.4567;0.8256,0.5858,0.4471;
    0.8226,0.5786,0.4376;0.8195,0.5715,0.4281;0.8165,0.5644,0.4187;0.8135,0.5573,0.4093;
    0.8104,0.5503,0.3999;0.8074,0.5433,0.3906;0.8044,0.5363,0.3813;0.8015,0.5293,0.3720;
    0.7985,0.5224,0.3628;0.7955,0.5155,0.3537;0.7925,0.5086,0.3445;0.7896,0.5017,0.3354;
    0.7866,0.4948,0.3263;0.7837,0.4880,0.3173;0.7807,0.4811,0.3083;0.7777,0.4743,0.2993;
    0.7748,0.4675,0.2904;0.7718,0.4606,0.2814;0.7688,0.4538,0.2725;0.7658,0.4469,0.2636;
    0.7627,0.4401,0.2548;0.7596,0.4331,0.2459;0.7565,0.4262,0.2370;0.7533,0.4192,0.2282;
    0.7501,0.4122,0.2193;0.7467,0.4050,0.2105;0.7432,0.3978,0.2016;0.7397,0.3905,0.1927;
    0.7359,0.3831,0.1839;0.7320,0.3755,0.1750;0.7279,0.3677,0.1660;0.7235,0.3599,0.1571;
    0.7189,0.3518,0.1482;0.7140,0.3435,0.1393;0.7088,0.3350,0.1305;0.7033,0.3264,0.1215;
    0.6974,0.3175,0.1128;0.6912,0.3085,0.1041;0.6847,0.2993,0.0956;0.6777,0.2899,0.0873;
    0.6705,0.2805,0.0792;0.6629,0.2710,0.0715;0.6550,0.2615,0.0641;0.6470,0.2521,0.0571;
    0.6387,0.2427,0.0506;0.6303,0.2335,0.0447;0.6217,0.2244,0.0394;0.6131,0.2157,0.0348;
    0.6045,0.2071,0.0311;0.5959,0.1987,0.0282;0.5874,0.1907,0.0260;0.5789,0.1829,0.0244;
    0.5705,0.1754,0.0233;0.5623,0.1682,0.0225;0.5541,0.1612,0.0221;0.5460,0.1544,0.0219;
    0.5380,0.1479,0.0217;0.5302,0.1415,0.0217;0.5224,0.1353,0.0218;0.5148,0.1292,0.0220;
    0.5072,0.1233,0.0222;0.4997,0.1175,0.0225;0.4923,0.1118,0.0228;0.4850,0.1062,0.0231;
    0.4778,0.1006,0.0235;0.4706,0.0952,0.0239;0.4635,0.0897,0.0243;0.4565,0.0843,0.0248;
    0.4495,0.0787,0.0252;0.4426,0.0734,0.0256;0.4357,0.0679,0.0261;0.4289,0.0624,0.0265;
    0.4221,0.0568,0.0270;0.4154,0.0511,0.0274;0.4088,0.0454,0.0278;0.4021,0.0394,0.0282;   
    0.3956,0.0334,0.0286;0.3890,0.0278,0.0289;0.3825,0.0226,0.0293;0.3760,0.0176,0.0296;
    0.3696,0.0129,0.0299;0.3632,0.0082,0.0301;0.3568,0.0040,0.0303;0.3504,0.0001,0.0305];

cork = ...
   [0.1710,0.1003,0.2998;0.1711,0.1062,0.3053;0.1711,0.1119,0.3108;0.1711,0.1176,0.3163;
	0.1710,0.1233,0.3218;0.1708,0.1290,0.3274;0.1706,0.1346,0.3330;0.1704,0.1402,0.3385;
    0.1701,0.1458,0.3441;0.1698,0.1514,0.3497;0.1694,0.1570,0.3553;0.1690,0.1626,0.3610;
    0.1685,0.1682,0.3666;0.1681,0.1738,0.3723;0.1676,0.1795,0.3780;0.1671,0.1851,0.3837;
    0.1666,0.1908,0.3894;0.1661,0.1965,0.3951;0.1657,0.2022,0.4009;0.1652,0.2079,0.4066;
    0.1648,0.2137,0.4124;0.1644,0.2194,0.4182;0.1641,0.2253,0.4240;0.1638,0.2311,0.4299;
    0.1635,0.2370,0.4357;0.1634,0.2429,0.4415;0.1634,0.2489,0.4474;0.1634,0.2549,0.4533;
    0.1637,0.2609,0.4592;0.1640,0.2670,0.4650;0.1646,0.2731,0.4709;0.1653,0.2793,0.4768;
    0.1662,0.2854,0.4827;0.1674,0.2917,0.4885;0.1689,0.2980,0.4944;0.1705,0.3043,0.5002;
    0.1725,0.3107,0.5060;0.1749,0.3171,0.5118;0.1775,0.3235,0.5176;0.1804,0.3300,0.5233;
    0.1837,0.3365,0.5290;0.1873,0.3430,0.5346;0.1913,0.3496,0.5402;0.1955,0.3562,0.5458;
    0.2002,0.3627,0.5513;0.2051,0.3693,0.5567;0.2104,0.3760,0.5621;0.2159,0.3826,0.5675;
    0.2217,0.3892,0.5727;0.2278,0.3958,0.5779;0.2341,0.4024,0.5831;0.2406,0.4091,0.5882;
    0.2474,0.4157,0.5932;0.2544,0.4223,0.5982;0.2615,0.4289,0.6032;0.2688,0.4355,0.6080;
    0.2762,0.4421,0.6129;0.2837,0.4487,0.6177;0.2914,0.4553,0.6225;0.2992,0.4618,0.6272;
    0.3070,0.4684,0.6319;0.3150,0.4750,0.6366;0.3230,0.4815,0.6412;0.3311,0.4881,0.6458;
    0.3392,0.4947,0.6505;0.3474,0.5012,0.6551;0.3557,0.5078,0.6597;0.3639,0.5144,0.6642;
    0.3722,0.5209,0.6688;0.3806,0.5275,0.6734;0.3890,0.5340,0.6780;0.3974,0.5406,0.6825;
    0.4059,0.5472,0.6871;0.4143,0.5538,0.6916;0.4228,0.5604,0.6962;0.4314,0.5670,0.7008;
    0.4399,0.5736,0.7053;0.4485,0.5802,0.7099;0.4570,0.5868,0.7145;0.4656,0.5934,0.7191;
    0.4743,0.6000,0.7236;0.4829,0.6067,0.7282;0.4916,0.6133,0.7328;0.5002,0.6200,0.7374;
    0.5089,0.6266,0.7420;0.5176,0.6333,0.7466;0.5263,0.6399,0.7512;0.5350,0.6466,0.7558;
    0.5438,0.6533,0.7605;0.5525,0.6600,0.7651;0.5613,0.6667,0.7697;0.5701,0.6734,0.7743;
    0.5789,0.6801,0.7790;0.5877,0.6868,0.7836;0.5965,0.6936,0.7883;0.6054,0.7003,0.7929;
    0.6142,0.7071,0.7976;0.6231,0.7138,0.8023;0.6320,0.7206,0.8069;0.6409,0.7273,0.8116;
    0.6497,0.7341,0.8162;0.6586,0.7409,0.8209;0.6676,0.7477,0.8255;0.6765,0.7544,0.8302;
    0.6854,0.7612,0.8348;0.6943,0.7680,0.8394;0.7032,0.7748,0.8440;0.7121,0.7816,0.8486;
    0.7209,0.7884,0.8531;0.7298,0.7952,0.8576;0.7386,0.8019,0.8620;0.7474,0.8087,0.8664;
    0.7561,0.8154,0.8706;0.7647,0.8221,0.8747;0.7732,0.8288,0.8787;0.7816,0.8354,0.8826;
    0.7899,0.8419,0.8862;0.7980,0.8483,0.8896;0.8058,0.8546,0.8927;0.8133,0.8608,0.8955;
    0.8205,0.8668,0.8979;0.8273,0.8726,0.8998;0.8336,0.8781,0.9013;0.8394,0.8833,0.9023;
    0.8445,0.8881,0.9026;0.8489,0.8924,0.9024;0.8526,0.8963,0.9014;0.8553,0.8997,0.8998;
    0.8572,0.9024,0.8975;0.8582,0.9046,0.8944;0.8583,0.9061,0.8907;0.8574,0.9070,0.8864;
    0.8556,0.9073,0.8815;0.8530,0.9069,0.8761;0.8496,0.9060,0.8702;0.8455,0.9046,0.8639;
    0.8408,0.9026,0.8573;0.8355,0.9003,0.8504;0.8297,0.8975,0.8433;0.8236,0.8944,0.8361;
    0.8170,0.8911,0.8287;0.8102,0.8875,0.8211;0.8031,0.8837,0.8135;0.7959,0.8797,0.8059;
    0.7885,0.8756,0.7982;0.7809,0.8713,0.7905;0.7732,0.8670,0.7828;0.7655,0.8626,0.7750;
    0.7577,0.8581,0.7672;0.7498,0.8536,0.7595;0.7419,0.8490,0.7517;0.7340,0.8444,0.7440;
    0.7261,0.8398,0.7362;0.7181,0.8352,0.7285;0.7101,0.8305,0.7207;0.7021,0.8259,0.7130;
    0.6942,0.8212,0.7053;0.6862,0.8165,0.6976;0.6782,0.8119,0.6899;0.6703,0.8072,0.6822;
    0.6623,0.8025,0.6745;0.6544,0.7979,0.6668;0.6464,0.7932,0.6591;0.6385,0.7886,0.6515;
    0.6306,0.7839,0.6438;0.6226,0.7793,0.6362;0.6147,0.7746,0.6286;0.6069,0.7700,0.6209;
    0.5990,0.7654,0.6133;0.5911,0.7608,0.6057;0.5832,0.7561,0.5981;0.5754,0.7515,0.5905;
    0.5675,0.7469,0.5829;0.5597,0.7423,0.5753;0.5519,0.7377,0.5678;0.5441,0.7331,0.5602;
    0.5362,0.7284,0.5526;0.5284,0.7238,0.5451;0.5206,0.7192,0.5375;0.5129,0.7146,0.5299;
    0.5051,0.7100,0.5224;0.4973,0.7054,0.5148;0.4895,0.7008,0.5072;0.4818,0.6961,0.4997;
    0.4740,0.6915,0.4921;0.4663,0.6868,0.4845;0.4586,0.6822,0.4769;0.4508,0.6775,0.4693;
    0.4431,0.6727,0.4616;0.4354,0.6680,0.4540;0.4277,0.6632,0.4463;0.4201,0.6584,0.4385;
    0.4124,0.6535,0.4308;0.4048,0.6485,0.4229;0.3972,0.6435,0.4151;0.3896,0.6385,0.4072;
    0.3821,0.6333,0.3992;0.3747,0.6281,0.3911;0.3673,0.6227,0.3830;0.3599,0.6173,0.3748;
    0.3527,0.6118,0.3665;0.3456,0.6061,0.3582;0.3386,0.6003,0.3498;0.3318,0.5944,0.3413;
    0.3251,0.5884,0.3327;0.3186,0.5822,0.3241;0.3124,0.5759,0.3155;0.3064,0.5695,0.3068;
    0.3006,0.5631,0.2981;0.2952,0.5565,0.2894;0.2901,0.5499,0.2808;0.2853,0.5432,0.2722;
    0.2809,0.5364,0.2637;0.2769,0.5297,0.2553;0.2732,0.5229,0.2470;0.2698,0.5161,0.2388;
    0.2668,0.5094,0.2308;0.2642,0.5027,0.2230;0.2619,0.4961,0.2153;0.2599,0.4896,0.2078;
    0.2582,0.4831,0.2005;0.2568,0.4767,0.1934;0.2557,0.4704,0.1865;0.2548,0.4642,0.1797;
    0.2541,0.4581,0.1732;0.2535,0.4521,0.1668;0.2531,0.4462,0.1606;0.2529,0.4404,0.1545;
    0.2528,0.4347,0.1485;0.2528,0.4290,0.1427;0.2529,0.4234,0.1371;0.2531,0.4179,0.1315;
    0.2533,0.4125,0.1260;0.2536,0.4071,0.1206;0.2539,0.4018,0.1153;0.2542,0.3966,0.1101;
    0.2546,0.3914,0.1048;0.2550,0.3863,0.0997;0.2554,0.3813,0.0947;0.2558,0.3762,0.0896;
    0.2562,0.3712,0.0846;0.2566,0.3663,0.0795;0.2571,0.3614,0.0745;0.2575,0.3566,0.0695;
    0.2578,0.3517,0.0644;0.2582,0.3469,0.0594;0.2586,0.3422,0.0541;0.2589,0.3375,0.0490;
    0.2592,0.3328,0.0435;0.2595,0.3281,0.0382;0.2598,0.3234,0.0327;0.2600,0.3188,0.0277;
    0.2602,0.3141,0.0230;0.2604,0.3096,0.0184;0.2605,0.3049,0.0142;0.2606,0.3004,0.0099];

% Find best fitting numerosity model (log(tuned) or monotonic) at each voxel
for participant = 1:length(participantNames)
    cd(paths{participant})
    mrVista 3

    if participant<=5
        stimuli = [9,14:15]; % All,odd,even
    else
        stimuli = [7,10:11]; % All,odd,even
    end
    
    for stim = 1:length(stimuli)
        VOLUME{1}.curDataType = stimuli(stim);
        for models = 1:length(modelFieldNames)
            % Get correct folder for stimulus configuration
            if stim == 1
                if models == 1 % Tuned numerosity
                    model{1}.x0=exp(model{1}.x0);
                    tuneAll = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllL1.ve;
                    tuneAll_xs = exp(data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllL1.x0);
                    tuneAll_rss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllL1.rss;
                    tuneAll_rawrss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllL1.rawrss;
                end
                
                if models == 2 % Monotonic numerosity
                    monoAll = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllL1.ve;
                    monoAll_xs = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllL1.x0;
                    monoAll_rss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllL1.rss;
                    monoAll_rawrss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllL1.rawrss;
                end
                
            else
                if models == 1
                    model{1}.x0=exp(model{1}.x0);
                    if stim == 2
                        tuneOdd = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllOddL1.ve;
                        tuneOdd_xs = exp(data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllOddL1.x0);
                        tuneOdd_rss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllOddL1.rss;
                        tuneOdd_rawrss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllOddL1.rawrss;
                    elseif stim == 3 
                        tuneEven = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllEvenL1.ve;
                        tuneEven_xs = exp(data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllEvenL1.x0);
                        tuneEven_rss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllEvenL1.rss;
                        tuneEven_rawrss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{1}).NumerosityAllEvenL1.rawrss;
                    end
                else
                    if stim == 2
                        monoOdd = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllOddL1.ve;
                        monoOdd_xs = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllOddL1.x0;
                        monoOdd_rss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllOddL1.rss;
                        monoOdd_rawrss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllOddL1.rawrss;
                    elseif stim == 3
                        monoEven = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllEvenL1.ve;
                        monoEven_xs = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllEvenL1.x0;
                        monoEven_rss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllEvenL1.rss;
                        monoEven_rawrss = data_numerosity.mesh.(participantNames{participant}).(modelFieldNames{2}).NumerosityAllEvenL1.rawrss;
                    end
                end
            end 
        end
    end
    
    cd(paths{participant})
    
    % Check for change in slope
    flipFlop = ~(monoOdd_xs == monoEven_xs);
    mono_xs = monoOdd_xs;
    mono_xs(flipFlop) = 0; % Set changed xs to 0
    mono = (monoOdd + monoEven)./2;
    mono(flipFlop) = 0; % Set changed VE to 0
    mono_rss = (monoOdd_rss + monoEven_rss)./2;
    mono_rss(flipFlop) = 0; % Set changed VE to 0
    mono_rawrss = (monoOdd_rawrss + monoEven_rawrss)./2;
    mono_rawrss(flipFlop) = 0; % Set changed VE to 0
    
    tune_xs = (tuneOdd_xs + tuneEven_xs)./2;
    tune = (tuneOdd + tuneEven)./2;
    tune_rss = (tuneOdd_rss + tuneEven_rss)./2;
    tune_rawrss = (tuneOdd_rawrss + tuneEven_rawrss)./2;
    tune(tune_xs<1.01 | tune_xs>6.99) = 0; % Restrict mapWin to number range 1-7
    
    meshNames = {'meshBothInflated','meshLeftInflated','meshRightInflated'};
    savePath = {'/home/data/NatComms/'};
    saveNames = {'monoTuned_back(cv)','monoTuned_left(cv)','monoTuned_right(cv)'};
    
    meshSettings = load('MeshSettings.mat');
    subjSettings = length(meshSettings.settings);
    currentSettings = [subjSettings-2,subjSettings-1,subjSettings]; % Back,left,right
    
    close all
    mrvCleanWorkspace
    
    for meshes=1:3
        
        mrVista 3
        H = open3DWindow;
        
        meshPath = strcat([pwd,'/',meshNames{meshes}]);
        VOLUME{1} = meshLoad(VOLUME{1},meshPath,1);
        msh = viewGet(VOLUME{1}, 'currentmesh');
        
        if ~isempty(msh)
            VOLUME{1} = viewSet(VOLUME{1},'currentmesh',msh);
        end
        mrmSet(msh, 'cursoroff');
        
        MSH = viewGet(VOLUME{1}, 'Mesh');
        vertexGrayMap = mrmMapVerticesToGray( meshGet(MSH, 'initialvertices'), viewGet(VOLUME{1}, 'nodes'),...
            viewGet(VOLUME{1}, 'mmPerVox'), viewGet(VOLUME{1}, 'edges') );
        MSH = meshSet(MSH, 'vertexgraymap', vertexGrayMap); VOLUME{1} = viewSet(VOLUME{1}, 'Mesh', MSH);
        clear MSH vertexGrayMap
        
        meshRetrieveSettings(viewGet(VOLUME{1}, 'CurMesh'), currentSettings(meshes));
        
        %% Tuned numerosity
        model{1}.x0 = [];model{1}.rss = [];model{1}.rawrss = [];
        
        tuneIdx = [];
        monotunedT = zeros(size(mono)).*-1;veLimit = 0.00;
        for idx = 1:size(mono,2)
            if (tune(idx) > mono(idx) && (tune(idx) >= veLimit)) % Tuned response fits better than monotonic
                monotunedT(idx) = tune(idx);
                model{1}.x0(idx) = monotunedT(idx);
                model{1}.rss(idx) = tune_rss(idx);
                model{1}.rawrss(idx) = tune_rawrss(idx);
                tuneIdx=[tuneIdx,idx]; %#ok<AGROW>
            elseif (tune(idx) < mono(idx) && (mono(idx) >= veLimit)) % Monotonic response fits better than tuned
                if mono_xs(idx) == 1 % Monotonic increasing
                    monotunedT(idx) = -1;
                    model{1}.x0(idx) = monotunedT(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;
                elseif mono_xs(idx) == 2 % Monotonic decreasing
                    monotunedT(idx) = -1;
                    model{1}.x0(idx) = monotunedT(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;
                end
            elseif (tune(idx) && mono(idx)) == 0 % Neither model fits well
                monotunedT(idx) = -1;
                model{1}.x0(idx) = monotunedT(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
                continue
            elseif (tune(idx) == mono(idx) && (tune(idx) >= veLimit)) % Tuned & monotonic response fits equally well, coin-flip
                monotuneFlip = randi(2);
                if monotuneFlip == 1 % Choose monotonic
                    if mono_xs(idx) == 1 % Monotonic increasing
                        monotunedT(idx) = -1;
                        model{1}.x0(idx) = monotunedT(idx);
                        model{1}.rss(idx) = -1;
                        model{1}.rawrss(idx) = -1;
                    elseif mono_xs(idx) == 2 % Monotonic decreasing
                        monotunedT(idx) = -1;
                        model{1}.x0(idx) = monotunedT(idx);
                        model{1}.rss(idx) = -1;
                        model{1}.rawrss(idx) = -1;
                    end
                elseif monotuneFlip == 2 % Choose tuned
                    monotunedT(idx) = tune(idx);
                    model{1}.x0(idx) = monotunedT(idx);
                    model{1}.rss(idx) = tune_rss(idx);
                    model{1}.rawrss(idx) = tune_rawrss(idx);
                    tuneIdx=[tuneIdx,idx]; %#ok<AGROW>
                end 
            end
        end
        
        if saveData
            save('monotonicTuned_tuned(cv).mat','model','params');
        end
        
        if displayMesh
            rmName = fullfile([paths{participant},'/monotonicTuned_tuned(cv).mat']);
            VOLUME{1} = rmSelect(VOLUME{1}, 1, rmName); VOLUME{1} = rmLoadDefault(VOLUME{1});
            VOLUME{1} = setDisplayMode(VOLUME{1},'co'); VOLUME{1} = refreshScreen(VOLUME{1});
            modeInfo = VOLUME{1}.ui.(['co' 'Mode']);
            VOLUME{1} = setClipMode(VOLUME{1}, 'co', [0 1]);
            
            VOLUME{1}.ui.mapMode.numGrays = 128;
            VOLUME{1}.ui.mapMode.numColors = 128;
            VOLUME{1}.ui.mapMode.clipMode = [0 1];
            cmap_tuned = zeros(256,3);
            cmap_tuned(1:128,:) = [linspace(0,1,128)',linspace(0,1,128)',linspace(0,1,128)'];
            
            vik128 = vik(round(linspace(129,256,128)),:);
            cmap_tuned(129:256,:) = vik128;
            
            modeInfo.cmap = cmap_tuned;
            modeInfo.name = 'cmap_tuned';
            VOLUME{1}.ui.(['co' 'Mode']) = modeInfo;
            VOLUME{1} = setCothresh(VOLUME{1}, 0.3);VOLUME{1} = refreshScreen(VOLUME{1}, 1);
            VOLUME{1} = setClipMode(VOLUME{1}, 'co', [0 1]);
            [~, ~, ~, tunedColors] = meshColorOverlay(VOLUME{1},0);
            VOLUME{1} = meshColorOverlay(VOLUME{1});
            
            getColormap = 0;
            if getColormap == 1
                figure(99);ax = axes;ax.Visible = 'off';
                colormap(ax,cmap_tuned(129:256,:));c = colorbar;
                c.Ticks=[];colorbarPos = get(c,'position');c.Box = 'off';c.Color = [0.9400 0.9400 0.9400];
                export_fig(ax, 'colorbar_tuned.png', '-r600');
                close 99
            end
        end
        
        %% Monotonic numerosity increase
        model{1}.x0 = [];model{1}.rss = [];model{1}.rawrss = [];
        
        monoInIdx = [];
        monotunedI = zeros(size(mono)).*-1;veLimit = 0.00;
        for idx = 1:size(mono,2)
            if (tune(idx) > mono(idx) && (tune(idx) >= veLimit)) % Tuned response fits better than monotonic
                monotunedI(idx) = -1;
                model{1}.x0(idx) = monotunedI(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
            elseif (tune(idx) < mono(idx) && (mono(idx) >= veLimit)) % Monotonic response fits better than tuned
                if mono_xs(idx) == 1 % Monotonic increasing
                    monotunedI(idx) = mono(idx);
                    model{1}.x0(idx) = monotunedI(idx);
                    model{1}.rss(idx) = mono_rss(idx);
                    model{1}.rawrss(idx) = mono_rawrss(idx);
                    monoInIdx=[monoInIdx,idx]; %#ok<AGROW>
                elseif mono_xs(idx) == 2 % Monotonic decreasing
                    monotunedI(idx) = -1;
                    model{1}.x0(idx) = monotunedI(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;
                end
            elseif (tune(idx) && mono(idx)) == 0 % Neither model fits well
                monotunedI(idx) = -1;
                model{1}.x0(idx) = monotunedI(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
                continue
            elseif (tune(idx) == mono(idx) && (tune(idx) >= veLimit)) % Tuned & monotonic response fits equally well, coin-flip
                monotuneFlip = randi(2);
                if monotuneFlip == 1 % Choose monotonic
                    if mono_xs(idx) == 1 % Monotonic increasing
                        monotunedI(idx) = mono(idx);
                        model{1}.x0(idx) = monotunedI(idx);
                        model{1}.rss(idx) = mono_rss(idx);
                        model{1}.rawrss(idx) = mono_rawrss(idx);
                        monoInIdx=[monoInIdx,idx]; %#ok<AGROW>
                    elseif mono_xs(idx) == 2 % Monotonic decreasing
                        monotunedI(idx) = -1;
                        model{1}.x0(idx) = monotunedI(idx);
                        model{1}.rss(idx) = -1;
                        model{1}.rawrss(idx) = -1;
                    end
                elseif monotuneFlip == 2 % Choose tuned
                    monotunedI(idx) = -1;
                    model{1}.x0(idx) = monotunedI(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;
                end
            end
        end
        
        if saveData
            save('monotonicTuned_increase(cv).mat','model','params');
        end
        
        if displayMesh
            rmName = fullfile([paths{participant},'/monotonicTuned_increase(cv).mat']);
            VOLUME{1} = rmSelect(VOLUME{1}, 1, rmName); VOLUME{1} = rmLoadDefault(VOLUME{1});
            VOLUME{1} = setDisplayMode(VOLUME{1},'co'); VOLUME{1} = refreshScreen(VOLUME{1});
            modeInfo = VOLUME{1}.ui.(['co' 'Mode']);
            VOLUME{1} = setClipMode(VOLUME{1}, 'co', [0 1]);
            
            VOLUME{1}.ui.mapMode.numGrays = 128;
            VOLUME{1}.ui.mapMode.numColors = 128;
            VOLUME{1}.ui.mapMode.clipMode = [0 1];
            cmap_monoIncrease = zeros(256,3);
            cmap_monoincrease(1:128,:) = [linspace(0,1,128)',linspace(0,1,128)',linspace(0,1,128)'];
            
            vik128 = vik(round(linspace(1,128,128)),:);
            cmap_monoIncrease(256:-1:129,:) = vik128;
            
            modeInfo.cmap = cmap_monoIncrease;
            modeInfo.name = 'cmap_monoIncrease';
            VOLUME{1}.ui.(['co' 'Mode']) = modeInfo;
            VOLUME{1} = setCothresh(VOLUME{1}, 0.3);VOLUME{1} = refreshScreen(VOLUME{1}, 1);
            VOLUME{1} = setClipMode(VOLUME{1}, 'co', [0 1]);
            [~, ~, ~, increaseColors] = meshColorOverlay(VOLUME{1},0);
            VOLUME{1} = meshColorOverlay(VOLUME{1});
            
            getColormap = 0;
            if getColormap == 1
                figure(99);ax = axes;ax.Visible = 'off';
                colormap(ax,cmap_monoIncrease(129:256,:));c = colorbar;
                c.Ticks = [];colorbarPos = get(c,'position');c.Box = 'off';c.Color = [0.9400 0.9400 0.9400];
                export_fig(ax, 'colorbar_increase.png', '-r600');
                close 99
            end
        end
        
        %% Monotonic numerosity decrease
        model{1}.x0 = [];model{1}.rss = [];model{1}.rawrss = [];
        
        monoDeIdx = [];
        monotunedD = zeros(size(mono)).*-1;veLimit = 0.00;
        for idx = 1:size(mono,2)
            if (tune(idx) > mono(idx) && (tune(idx) >= veLimit)) % Tuned response fits better than monotonic
                monotunedD(idx) = -1;
                model{1}.x0(idx) = monotunedD(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;                
            elseif (tune(idx) < mono(idx) && (mono(idx) >= veLimit)) % Monotonic response fits better than tuned
                if mono_xs(idx) == 1 % Monotonic oncreasing
                    monotunedD(idx) = -1;
                    model{1}.x0(idx) = monotunedD(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;
                elseif mono_xs(idx) == 2 % Monotonic decreasing
                    monotunedD(idx) = mono(idx);
                    model{1}.x0(idx) = monotunedD(idx);
                    model{1}.rss(idx) = mono_rss(idx);
                    model{1}.rawrss(idx) = mono_rawrss(idx);
                    monoDeIdx=[monoDeIdx,idx]; %#ok<AGROW>
                end
            elseif (tune(idx) && mono(idx)) == 0 % Neither model fits well
                monotunedD(idx) = -1;
                model{1}.x0(idx) = monotunedD(idx);
                model{1}.rss(idx) = -1;
                model{1}.rawrss(idx) = -1;
                continue
            elseif (tune(idx) == mono(idx) && (tune(idx) >= veLimit)) % Tuned & monotonic response fits equally well, coin-flip
                monotuneFlip = randi(2);
                if monotuneFlip == 1 % Choose monotonic
                    if mono_xs(idx) == 1 % Increasing monotonic
                        monotunedD(idx) = -1;
                        model{1}.x0(idx) = monotunedD(idx);
                        model{1}.rss(idx) = -1;
                    elseif mono_xs(idx) == 2 % Decreasing monotonic
                        monotunedD(idx) = mono(idx);
                        model{1}.x0(idx) = monotunedD(idx);
                        model{1}.rss(idx) = mono_rss(idx);
                        model{1}.rawrss(idx) = mono_rawrss(idx);
                        monoDeIdx=[monoDeIdx,idx]; %#ok<AGROW>
                    end
                elseif monotuneFlip == 2 % Choose tuned
                    monotunedD(idx) = -1;
                    model{1}.x0(idx) = monotunedD(idx);
                    model{1}.rss(idx) = -1;
                    model{1}.rawrss(idx) = -1;
                end
                
            end
        end
        
        if saveData
            save('monotonicTuned_decrease(cv).mat','model','params');
        end
        
        if displayMesh
            rmName = fullfile([paths{participant},'/monotonicTuned_decrease(cv).mat']);
            VOLUME{1} = rmSelect(VOLUME{1}, 1, rmName); VOLUME{1} = rmLoadDefault(VOLUME{1});
            VOLUME{1} = setDisplayMode(VOLUME{1},'co'); VOLUME{1} = refreshScreen(VOLUME{1});
            modeInfo = VOLUME{1}.ui.(['co' 'Mode']);
            VOLUME{1} = setClipMode(VOLUME{1}, 'co', [0 1]);
            
            VOLUME{1}.ui.mapMode.numGrays = 128;
            VOLUME{1}.ui.mapMode.numColors = 128;
            VOLUME{1}.ui.mapMode.clipMode = [0 1];
            cmap_monoDecrease = zeros(256,3);
            cmap_monoDecrease(1:128,:) = [linspace(0,1,128)',linspace(0,1,128)',linspace(0,1,128)'];
            
            cork128 = cork(round(linspace(129,256,128)),:);
            cmap_monoDecrease(129:256,:) = cork128;
            
            modeInfo.cmap = cmap_monoDecrease;
            modeInfo.name = 'cmap_monoDecrease';
            VOLUME{1}.ui.(['co' 'Mode']) = modeInfo;
            VOLUME{1} = setCothresh(VOLUME{1}, 0.3);VOLUME{1} = refreshScreen(VOLUME{1}, 1);
            VOLUME{1} = setClipMode(VOLUME{1}, 'co', [0 1]);
            [~, ~, ~, decreaseColors] = meshColorOverlay(VOLUME{1},0);
            VOLUME{1} = meshColorOverlay(VOLUME{1});
            
            getColormap = 0;
            if getColormap == 1
                figure(99);ax = axes;ax.Visible = 'off';
                colormap(ax,cmap_monoDecrease(129:256,:));c = colorbar;
                c.Ticks = [];colorbarPos = get(c,'position');c.Box = 'off';c.Color = [0.9400 0.9400 0.9400];
                export_fig(ax, 'colorbar_decrease.png', '-r600');
                close 99
            end
        end
        
        %% Overlay mesh colors - slow loop, not vectorised but works
        sulciColor=[160;160;160;153];gyriColor=[96;96;96;153];
        tunedIncrease_colors = nan(4,size(tunedColors,2));
        increaseCoords=[];tuneCoords=[]; % Get coords for time-series plotting
        
        % Add monotonic increase map to tuned map
        for colorIndx = 1:size(tunedColors,2)
            if (sum(tunedColors(:,colorIndx)==sulciColor)==4 && sum(increaseColors(:,colorIndx)==sulciColor)==4) %match sulci
                tunedIncrease_colors(:,colorIndx) = sulciColor;
            elseif (sum(tunedColors(:,colorIndx)==gyriColor)==4 && sum(increaseColors(:,colorIndx)==gyriColor)==4) %match gyri
                tunedIncrease_colors(:,colorIndx) = gyriColor;
            elseif (sum(tunedColors(:,colorIndx)==sulciColor)==4 || sum(tunedColors(:,colorIndx)==gyriColor)==4) ...
                    && (sum(increaseColors(:,colorIndx)==sulciColor)~=4 || sum(increaseColors(:,colorIndx)==gyriColor)~=4) %select increase color
                tunedIncrease_colors(:,colorIndx) = increaseColors(:,colorIndx);increaseCoords=[increaseCoords,colorIndx]; %#ok<AGROW>
            elseif (sum(increaseColors(:,colorIndx)==sulciColor)==4 || sum(increaseColors(:,colorIndx)==gyriColor)==4) ...
                    && (sum(tunedColors(:,colorIndx)==sulciColor)~=4 || sum(tunedColors(:,colorIndx)==gyriColor)~=4) %select tuned color
                tunedIncrease_colors(:,colorIndx) = tunedColors(:,colorIndx);tuneCoords=[tuneCoords,colorIndx]; %#ok<AGROW>
            elseif (sum(increaseColors(:,colorIndx)==sulciColor)~=4 || sum(increaseColors(:,colorIndx)==gyriColor)~=4) ...
                    && (sum(tunedColors(:,colorIndx)==sulciColor)~=4 || sum(tunedColors(:,colorIndx)==gyriColor)~=4) %overlap, coin flip either color
                colorFlip = randi(2);
                if colorFlip==1
                    tunedIncrease_colors(:,colorIndx) = tunedColors(:,colorIndx);tuneCoords=[tuneCoords,colorIndx]; %#ok<AGROW>
                elseif colorFlip==2
                    tunedIncrease_colors(:,colorIndx) = increaseColors(:,colorIndx);increaseCoords=[increaseCoords,colorIndx]; %#ok<AGROW>
                end
            end
        end
        
        % Add monotonic decrease map to tunedIncrease map
        tunedIncreaseDecrease_colors = nan(4,size(tunedColors,2));
        decreaseCoords=[]; % Get coords for time-series plotting
        for colorIndx = 1:size(tunedColors,2)
            if (sum(tunedIncrease_colors(:,colorIndx)==sulciColor)==4 && sum(decreaseColors(:,colorIndx)==sulciColor)==4) %match sulci
                tunedIncreaseDecrease_colors(:,colorIndx) = sulciColor;
            elseif (sum(tunedIncrease_colors(:,colorIndx)==gyriColor)==4 && sum(decreaseColors(:,colorIndx)==gyriColor)==4) %match gyri
                tunedIncreaseDecrease_colors (:,colorIndx) = gyriColor;
            elseif (sum(tunedIncrease_colors(:,colorIndx)==sulciColor)==4 || sum(tunedIncrease_colors(:,colorIndx)==gyriColor)==4) ...
                    && (sum(decreaseColors(:,colorIndx)==sulciColor)~=4 || sum(decreaseColors(:,colorIndx)==gyriColor)~=4) %select decrease color
                tunedIncreaseDecrease_colors(:,colorIndx) = decreaseColors(:,colorIndx);decreaseCoords=[decreaseCoords,colorIndx]; %#ok<AGROW>
            elseif (sum(decreaseColors(:,colorIndx)==sulciColor)==4 || sum(decreaseColors(:,colorIndx)==gyriColor)==4) ...
                    && (sum(tunedIncrease_colors(:,colorIndx)==sulciColor)~=4 || sum(tunedIncrease_colors(:,colorIndx)==gyriColor)~=4) %select tunedIncrease color
                tunedIncreaseDecrease_colors(:,colorIndx) = tunedIncrease_colors(:,colorIndx);
            elseif (sum(decreaseColors(:,colorIndx)==sulciColor)~=4 || sum(decreaseColors(:,colorIndx)==gyriColor)~=4) ...
                    && (sum(tunedIncrease_colors(:,colorIndx)==sulciColor)~=4 || sum(tunedIncrease_colors(:,colorIndx)==gyriColor)~=4) %overlap, coin flip either color
                colorFlip = randi(2);
                if colorFlip==1
                    tunedIncreaseDecrease_colors(:,colorIndx) = tunedIncrease_colors(:,colorIndx);
                elseif colorFlip==2
                    tunedIncreaseDecrease_colors(:,colorIndx) = decreaseColors(:,colorIndx);decreaseCoords=[decreaseCoords,colorIndx]; %#ok<AGROW>
                end
            end
        end
        
        VOLUME{1}.mesh{1}.colors = tunedIncreaseDecrease_colors;
        mrmSet(VOLUME{1}.mesh{1},'colors',tunedIncreaseDecrease_colors');
        
        save('tunedIncreaseDecrease_colors(cv).mat','tunedIncreaseDecrease_colors');
        
        % Store back, left and right mesh views
        % Make sure to hide cursor
        % meshStoreSettings( viewGet(VOLUME{1}, 'Mesh') );
        
        msh = viewGet(VOLUME{1},'currentmesh');
        lights = meshGet(msh,'lights');
        lights{1}.diffuse = [0 0 0];
        lights{1}.ambient = [0.5 0.5 0.5];
        host = meshGet(msh, 'host');
        windowID = meshGet(msh, 'windowID');
        distance=10;
        for n = 1:length(lights)
            L.actor = lights{n}.actor;
            L.origin = distance .* lights{n}.origin;
            lights{n} = mergeStructures(lights{n}, L);
            mrMesh(host, windowID, 'set', L);
        end
        msh = meshSet(msh, 'lights', lights);
        VOLUME{1} = viewSet(VOLUME{1}, 'mesh', msh);
        meshRetrieveSettings(viewGet(VOLUME{1}, 'CurMesh'), currentSettings(meshes));
        wSize = [1056,1855]; %@1920x1080
        mrmSet(msh,'windowSize',wSize(1),wSize(2));
        
        % Save screenshot
        fname = fullfile(savePath{1},participantNames{participant},[saveNames{meshes},'.png']);
        udata.rgb = mrmGet(msh,'screenshot')/255;
        imwrite(udata.rgb, fname);
        set(gcf,'userdata',udata);
        
        allMeshes = viewGet(VOLUME{1}, 'allmeshes');
        mrmSet(allMeshes, 'closeall');
        h = findobj('Name', '3DWindow (mrMesh)');
        close(h);
        VOLUME{1} = rmfield(VOLUME{1},'mesh');
        
        close all
        mrvCleanWorkspace
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Response model fit (R^2) vs. preferred visual field eccentricity Fig.2b %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load data_numerosity
load data_vfm
participantNames = {'P01', 'P02', 'P03', 'P04', 'P05'};
whichParticipants=1:5;
group.bins = []; fitData = []; bins = [];
mapNames=["bothIPS0","bothIPS1","bothIPS2","bothIPS3","bothIPS4","bothIPS5","bothsPCS1","bothsPCS2","bothiPCS",...
    "bothLO1","bothLO2","bothTO1","bothTO2","bothV1","bothV2","bothV3","bothV3AB"];
allNames = ["All","AllOdd","AllEven"];
binsize = 0.20;thresh.ecc = [0 5.5];voxelSize = 1.77;
bins.MonoLogIncrease.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.MonoLogDecrease.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.TunedLog2Lin.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.AggFourierPower.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
minNumerosity=log(1.01);maxNumerosity=log(6.99);
coloursTuned = [205,0,0]./255;coloursMono = [0,205,205]./255;coloursIncrease = [0,0,205]./255;coloursDecrease = [0,205,0]./255;
coloursFourierPower = [0 255 255]./255;
colourROI=1;yrange=0.5;

saveData = 1;savePlots = 1;

for thisParticipant=whichParticipants
    for DTs=1:length(allNames)
        for maps = 1:length(mapNames)
            eval(['AggFourierPower.',allNames{DTs},'.',mapNames{maps},...
                '=data_numerosity.ve.',participantNames{thisParticipant},'.aggFourierPower.',allNames{DTs},...
                '.',mapNames{maps},'.Both;']);
            eval(['MonoLog.',allNames{DTs},'.',mapNames{maps},...
                '=data_numerosity.ve.',participantNames{thisParticipant},'.monoNumber.',allNames{DTs},...
                '.',mapNames{maps},'.Both;']);
            eval(['Tuned.',allNames{DTs},'.',mapNames{maps},...
                '=data_numerosity.ve.',participantNames{thisParticipant},'.tunedNumber.',allNames{DTs},...
                '.',mapNames{maps},'.Both;']);
        end
    end
end

for thisParticipant=whichParticipants
    for DTs=2:length(allNames)
        for maps = 1:length(mapNames)
            % Fourier power
            x0s_current = data_numerosity.ve.(participantNames{thisParticipant}).aggFourierPower.(allNames{DTs}).(mapNames{maps}).Both.x0sAll;
            x0s_current_mean = mean(x0s_current);
            ves_current = data_numerosity.ve.(participantNames{thisParticipant}).aggFourierPower.(allNames{DTs}).(mapNames{maps}).Both.vesXvalAll;
            ves_current_mean = mean(ves_current);
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).xs = x0s_current_mean;
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).varianceExplained = ves_current_mean;
            
            % Monotonic numerosity
            x0s_current = data_numerosity.ve.(participantNames{thisParticipant}).monoNumber.(allNames{DTs}).(mapNames{maps}).Both.x0sAll;
            x0s_current_mean = mean(x0s_current);
            ves_current = data_numerosity.ve.(participantNames{thisParticipant}).monoNumber.(allNames{DTs}).(mapNames{maps}).Both.vesXvalAll;
            ves_current_mean = mean(ves_current);
            cv_data.MonoLog.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).xs = x0s_current_mean;
            cv_data.MonoLog.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).varianceExplained = ves_current_mean;
            
            % Tuned numerosity
            x0s_current = data_numerosity.ve.(participantNames{thisParticipant}).tunedNumber.(allNames{DTs}).(mapNames{maps}).Both.x0sAll;
            x0s_current_mean = mean(x0s_current);
            ves_current = data_numerosity.ve.(participantNames{thisParticipant}).tunedNumber.(allNames{DTs}).(mapNames{maps}).Both.vesXvalAll;
            ves_current_mean = mean(ves_current);
            cv_data.Tuned.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).xs = x0s_current_mean;
            cv_data.Tuned.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).varianceExplained = ves_current_mean;
        end
    end
end

condNames = fieldnames(cv_data.AggFourierPower.(participantNames{1}));
condNames(3) = {'AllOddEven'};
% Average odd/even scans
for thisParticipant=whichParticipants
    % Check for change in slope
    for ROIs = 1:length(mapNames)
        % Fourier power
        flipFlop = ~(cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).xs == ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs);

        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs = ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs;
        
        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs(flipFlop) = 0; % Set changed xs to 0

        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = ...
            (cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).varianceExplained + ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained(flipFlop) = 0; % Set changed VE to 0 
        
        % Monotonic numerosity
        flipFlop = ~(cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).xs == ...
            cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs);

        cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs = ...
            cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs;
        
        cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs(flipFlop) = 0; % Set changed xs to 0

        cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = ...
            (cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).varianceExplained + ...
            cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.MonoLog.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained(flipFlop) = 0; % Set changed VE to 0         

        % Tuned numerosity
        varianceExplained = (cv_data.Tuned.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).varianceExplained + ...
            cv_data.Tuned.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = varianceExplained;
        
        xs = (cv_data.Tuned.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).xs + ...
            cv_data.Tuned.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs)./2;
                
        xs = exp(xs); %Log2Lin
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs = xs;
            
        varianceExplained(xs<=minNumerosity)=0;varianceExplained(xs>=maxNumerosity)=0;
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = varianceExplained;        
    end
end

ve_data.AggFourierPower=cv_data.AggFourierPower;
ve_data.MonoLog=cv_data.MonoLog;
ve_data.TunedLog2Lin=cv_data.Tuned;

% Seperate out increasing & decreasing
ve_data.AggFourierPowerIncrease = ve_data.AggFourierPower;
ve_data.MonoLogIncrease = ve_data.MonoLog;
ve_data.MonoLogDecrease = ve_data.MonoLog;

for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        % Fourier power
        ve_data.AggFourierPowerIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained...
            (ve_data.AggFourierPowerIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).xs==2) = 0;
        
        % Monotonic numerosity
        ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained...
            (ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).xs==2) = 0;
        ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained...
            (ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).xs==1) = 0;
    end
end

%% eccentricity
for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        ecc.(participantNames{participant}).(char(mapNames{roi})).ecc = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).ecc;
        ecc.(participantNames{participant}).(char(mapNames{roi})).sigma = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).sigma;        
    end
end

%% Group data
for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        eccCurrent = data_vfm.ve.(participantNames{participant}).VFML1.(mapNames{roi}).ecc;
        veCurrent_monoIncrease = ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        veCurrent_monoDecrease = ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        veCurrent_tuned = ve_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        veCurrent_AggFourierPower = ve_data.AggFourierPower.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        
        if participant==1
            group.ecc.(mapNames{roi}).ecc = eccCurrent;
            group.ve_data.MonoLogIncrease.(mapNames{roi}) = veCurrent_monoIncrease;
            group.ve_data.MonoLogDecrease.(mapNames{roi}) = veCurrent_monoDecrease;            
            group.ve_data.TunedLog2Lin.(mapNames{roi}) = veCurrent_tuned;
            group.ve_data.AggFourierPower.(mapNames{roi}) = veCurrent_AggFourierPower;            
        else
            group.ecc.(mapNames{roi}).ecc = [group.ecc.(mapNames{roi}).ecc, eccCurrent];
            group.ve_data.MonoLogIncrease.(mapNames{roi}) = [group.ve_data.MonoLogIncrease.(mapNames{roi}), veCurrent_monoIncrease];
            group.ve_data.MonoLogDecrease.(mapNames{roi}) = [group.ve_data.MonoLogDecrease.(mapNames{roi}), veCurrent_monoDecrease];            
            group.ve_data.TunedLog2Lin.(mapNames{roi}) = [group.ve_data.TunedLog2Lin.(mapNames{roi}), veCurrent_tuned];
            group.ve_data.AggFourierPower.(mapNames{roi}) = [group.ve_data.AggFourierPower.(mapNames{roi}), veCurrent_AggFourierPower];
        end
    end
end

for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        eccIndices_AggFourierPower(roi) = sum([length(ecc.(participantNames{1}).(mapNames{roi}).ecc),length(ecc.(participantNames{2}).(mapNames{roi}).ecc),...
            length(ecc.(participantNames{3}).(mapNames{roi}).ecc),length(ecc.(participantNames{4}).(mapNames{roi}).ecc),length(ecc.(participantNames{5}).(mapNames{roi}).ecc)]); %#ok<SAGROW>
        
        for b = round(thresh.ecc(1):binsize:thresh.ecc(2),1)
            % Determine which voxels are in each bin
            bii = ecc.(participantNames{participant}).(mapNames{roi}).ecc >  b-binsize./2 & ...
                ecc.(participantNames{participant}).(mapNames{roi}).ecc <= b+binsize./2;
            group_bii = group.ecc.(mapNames{roi}).ecc >  b-binsize./2 & ...
                group.ecc.(mapNames{roi}).ecc <= b+binsize./2;
            group_bii_FP = group.ecc.(mapNames{roi}).ecc(1:eccIndices_AggFourierPower(roi)) >  b-binsize./2 & ...
                group.ecc.(mapNames{roi}).ecc(1:eccIndices_AggFourierPower(roi)) <= b+binsize./2;
            if any(bii)
                % Fit which eccentricity bin this corresponds to
                ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                s_monoIncrease = wstat(ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_monoIncrease.sterr;
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_monoIncrease.stdev;
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_monoIncrease.mean;
                
                s_monoDecrease = wstat(ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_monoDecrease.sterr;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_monoDecrease.stdev;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_monoDecrease.mean;
                
                s_tuned = wstat(ve_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_tuned.sterr;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_tuned.stdev;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_tuned.mean;
                
                s_AggFourierPower = wstat(ve_data.AggFourierPower.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.AggFourierPower.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_AggFourierPower.sterr;
                bins.AggFourierPower.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_AggFourierPower.stdev;
                bins.AggFourierPower.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_AggFourierPower.mean;
                
            else
                ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.AggFourierPower.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                
            end
            if any(group_bii)
                group_ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                s_monoIncrease = wstat(group.ve_data.MonoLogIncrease.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.MonoLogIncrease.(mapNames{roi}).sterr(:,group_ii2 ) = s_monoIncrease.sterr;
                group.bins.MonoLogIncrease.(mapNames{roi}).sdev(:,group_ii2 ) = s_monoIncrease.stdev;
                group.bins.MonoLogIncrease.(mapNames{roi}).mean(:,group_ii2 ) = s_monoIncrease.mean;
                
                s_monoDecrease = wstat(group.ve_data.MonoLogDecrease.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.MonoLogDecrease.(mapNames{roi}).sterr(:,group_ii2 ) = s_monoDecrease.sterr;
                group.bins.MonoLogDecrease.(mapNames{roi}).sdev(:,group_ii2 ) = s_monoDecrease.stdev;
                group.bins.MonoLogDecrease.(mapNames{roi}).mean(:,group_ii2 ) = s_monoDecrease.mean;
                
                s_tuned = wstat(group.ve_data.TunedLog2Lin.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.TunedLog2Lin.(mapNames{roi}).sterr(:,group_ii2 ) = s_tuned.sterr;
                group.bins.TunedLog2Lin.(mapNames{roi}).sdev(:,group_ii2 ) = s_tuned.stdev;
                group.bins.TunedLog2Lin.(mapNames{roi}).mean(:,group_ii2 ) = s_tuned.mean;
            else
                group_ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                group.bins.MonoLogIncrease.(mapNames{roi}).mean(:,group_ii2) = 0;
                group.bins.MonoLogDecrease.(mapNames{roi}).mean(:,group_ii2) = 0;
                group.bins.TunedLog2Lin.(mapNames{roi}).mean(:,group_ii2) = 0;
            end
            
            if any(group_bii_FP)
                group_ii2 = find(round(bins.AggFourierPower.x,1) == b);
                s_AggFourierPower = wstat(group.ve_data.AggFourierPower.(mapNames{roi})(group_bii_FP),[], voxelSize^2);
                group.bins.AggFourierPower.(mapNames{roi}).sterr(:,group_ii2 ) = s_AggFourierPower.sterr;
                group.bins.AggFourierPower.(mapNames{roi}).sdev(:,group_ii2 ) = s_AggFourierPower.stdev;
                group.bins.AggFourierPower.(mapNames{roi}).mean(:,group_ii2 ) = s_AggFourierPower.mean;
            else
                group_ii2 = find(round(bins.AggFourierPower.x,1) == b);
                group.bins.AggFourierPower.(mapNames{roi}).mean(:,group_ii2) = 0;
            end
            
        end
        
        % Fitting data
        if participant==1
            fitData.ecc.(mapNames{roi}) = ecc.(participantNames{participant}).(mapNames{roi}).ecc;
            fitData.ve.MonoLogIncrease.(mapNames{roi}) = ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
            fitData.ve.MonoLogDecrease.(mapNames{roi}) = ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
            fitData.ve.TunedLog2Lin.(mapNames{roi}) = ve_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
            fitData.ve.AggFourierPower.(mapNames{roi}) = ve_data.AggFourierPower.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained;
        else
            fitData.ecc.(mapNames{roi}) = [fitData.ecc.(mapNames{roi}),ecc.(participantNames{participant}).(mapNames{roi}).ecc];
            fitData.ve.MonoLogIncrease.(mapNames{roi}) = [fitData.ve.MonoLogIncrease.(mapNames{roi}),ve_data.MonoLogIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained];
            fitData.ve.MonoLogDecrease.(mapNames{roi}) = [fitData.ve.MonoLogDecrease.(mapNames{roi}),ve_data.MonoLogDecrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained];
            fitData.ve.TunedLog2Lin.(mapNames{roi}) = [fitData.ve.TunedLog2Lin.(mapNames{roi}),ve_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained];
            fitData.ve.AggFourierPower.(mapNames{roi}) = [fitData.ve.AggFourierPower.(mapNames{roi}),ve_data.AggFourierPower.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained];
        end
    end
end

%% V1 & V3
for roi = [14,16]
    %% Eccentricity data
    eccBoot = fitData.ecc.(mapNames{roi});
    eccBoot_FP = fitData.ecc.(mapNames{roi})(1:eccIndices_AggFourierPower(roi));
    minEcc = min(thresh.ecc); maxEcc = max(thresh.ecc);

    %% Sigmoid fit
    %% Aggregate Fourier power    
    veBoot_FourierPower = fitData.ve.AggFourierPower.(mapNames{roi});
    x_AggFourierPower = bins.AggFourierPower.x;
    y_AggFourierPower = group.bins.AggFourierPower.(mapNames{roi}).mean';
    sterr_AggFourierPower = group.bins.AggFourierPower.(mapNames{roi}).sterr';
    x_AggFourierPower(y_AggFourierPower==0) = [];
    sterr_AggFourierPower(y_AggFourierPower==0) = [];
    y_AggFourierPower(y_AggFourierPower==0) = [];
    
    % Bootstrapping
    [sigmoidData.group.AggFourierPower.(mapNames{roi}),fitParams.group.AggFourierPower.(mapNames{roi})] = fitSigmoid3(eccBoot_FP,veBoot_FourierPower, 0, 5.5, 0.2, ones(size(veBoot_FourierPower)), 0);
    % For more robust estimates, consider using monoTuned_make_sigmoid_CIs
    
    figure; 
    scatter(sigmoidData.group.AggFourierPower.(mapNames{roi}).x, sigmoidData.group.AggFourierPower.(mapNames{roi}).y,[],'filled', 'MarkerFaceColor',coloursFourierPower)
    hold on; errorbar(sigmoidData.group.AggFourierPower.(mapNames{roi}).x,sigmoidData.group.AggFourierPower.(mapNames{roi}).y,...
        sigmoidData.group.AggFourierPower.(mapNames{roi}).ysterr(1,:),sigmoidData.group.AggFourierPower.(mapNames{roi}).ysterr(2,:),'.','Color',coloursFourierPower,...
        'MarkerFaceColor',coloursMono,'LineWidth',1);
    hold on; plot(sigmoidData.group.AggFourierPower.(mapNames{roi}).xfit, sigmoidData.group.AggFourierPower.(mapNames{roi}).yfit, '-', 'Color',coloursFourierPower,'LineWidth',3);
    hold on; plot(sigmoidData.group.AggFourierPower.(mapNames{roi}).xfit, sigmoidData.group.AggFourierPower.(mapNames{roi}).b_upper, '--','Color',coloursFourierPower,'LineWidth',2);
    hold on; plot(sigmoidData.group.AggFourierPower.(mapNames{roi}).xfit, sigmoidData.group.AggFourierPower.(mapNames{roi}).b_lower,  '--','Color',coloursFourierPower,'LineWidth',2);

    %% Monotonic numerosity (increasing)
    veBoot_monoIncrease = fitData.ve.MonoLogIncrease.(mapNames{roi});
    x_monoIncrease = bins.MonoLogIncrease.x;
    y_monoIncrease = group.bins.MonoLogIncrease.(mapNames{roi}).mean';
    sterr_monoIncrease = group.bins.MonoLogIncrease.(mapNames{roi}).sterr';
    x_monoIncrease(y_monoIncrease==0) = [];
    sterr_monoIncrease(y_monoIncrease==0) = [];
    y_monoIncrease(y_monoIncrease==0) = [];
    
    % Bootstrapping
    [sigmoidData.group.MonoLogIncrease.(mapNames{roi}),fitParams.group.MonoLogIncrease.(mapNames{roi})] = fitSigmoid3(eccBoot,veBoot_monoIncrease, 0, 5.5, 0.2, ones(size(veBoot_monoIncrease)), 0);
    % For more robust estimates, consider using monoTuned_make_sigmoid_CIs

    scatter(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).x, sigmoidData.group.MonoLogIncrease.(mapNames{roi}).y,[],'filled', 'MarkerFaceColor',coloursIncrease)
    hold on; errorbar(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).x,sigmoidData.group.MonoLogIncrease.(mapNames{roi}).y,...
        sigmoidData.group.MonoLogIncrease.(mapNames{roi}).ysterr(1,:),sigmoidData.group.MonoLogIncrease.(mapNames{roi}).ysterr(2,:),'.','Color',coloursIncrease,...
        'MarkerFaceColor',coloursMono,'LineWidth',1);
    hold on; plot(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogIncrease.(mapNames{roi}).yfit, '-', 'Color',coloursIncrease,'LineWidth',3);
    hold on; plot(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogIncrease.(mapNames{roi}).b_upper, '--','Color',coloursIncrease,'LineWidth',2);
    hold on; plot(sigmoidData.group.MonoLogIncrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogIncrease.(mapNames{roi}).b_lower,  '--','Color',coloursIncrease,'LineWidth',2);    

    %% Monotonic numerosity (decreasing)
    veBoot_monoDecrease = fitData.ve.MonoLogDecrease.(mapNames{roi});
    x_monoDecrease = bins.MonoLogDecrease.x;
    y_monoDecrease = group.bins.MonoLogDecrease.(mapNames{roi}).mean';
    sterr_monoDecrease = group.bins.MonoLogDecrease.(mapNames{roi}).sterr';
    x_monoDecrease(y_monoDecrease==0) = [];
    sterr_monoDecrease(y_monoDecrease==0) = [];
    y_monoDecrease(y_monoDecrease==0) = [];
    
    % Bootstrapping
    [sigmoidData.group.MonoLogDecrease.(mapNames{roi}),fitParams.group.MonoLogDecrease.(mapNames{roi})] = fitSigmoid3(eccBoot,veBoot_monoDecrease, 0, 5.5, 0.2, ones(size(veBoot_monoDecrease)), 0);
    % For more robust estimates, consider using monoTuned_make_sigmoid_CIs
    
    scatter(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).x, sigmoidData.group.MonoLogDecrease.(mapNames{roi}).y,[],'filled', 'MarkerFaceColor',coloursDecrease)
    hold on; errorbar(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).x,sigmoidData.group.MonoLogDecrease.(mapNames{roi}).y,...
        sigmoidData.group.MonoLogDecrease.(mapNames{roi}).ysterr(1,:),sigmoidData.group.MonoLogDecrease.(mapNames{roi}).ysterr(2,:),'.','Color',coloursDecrease,...
        'MarkerFaceColor',coloursMono,'LineWidth',1);
    hold on; plot(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogDecrease.(mapNames{roi}).yfit, '-', 'Color',coloursDecrease,'LineWidth',3);
    hold on; plot(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogDecrease.(mapNames{roi}).b_upper, '--','Color',coloursDecrease,'LineWidth',2);
    hold on; plot(sigmoidData.group.MonoLogDecrease.(mapNames{roi}).xfit, sigmoidData.group.MonoLogDecrease.(mapNames{roi}).b_lower,  '--','Color',coloursDecrease,'LineWidth',2);
    
    %% Tuned numerosity
    veBoot_tuned = fitData.ve.TunedLog2Lin.(mapNames{roi});
    x_tuned = bins.TunedLog2Lin.x;
    y_tuned = group.bins.TunedLog2Lin.(mapNames{roi}).mean';
    sterr_tuned = group.bins.TunedLog2Lin.(mapNames{roi}).sterr';
    x_tuned(y_tuned==0) = [];
    sterr_tuned(y_tuned==0) = [];
    y_tuned(y_tuned==0) = [];
    
    % Bootstrapping
    [sigmoidData.group.TunedLog2Lin.(mapNames{roi}),fitParams.group.TunedLog2Lin.(mapNames{roi})] = fitSigmoid3(eccBoot,veBoot_tuned, 0, 5.5, 0.2, ones(size(veBoot_tuned)), 0);
    % For more robust estimates, consider using monoTuned_make_sigmoid_CIs
              
    scatter(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).x, sigmoidData.group.TunedLog2Lin.(mapNames{roi}).y,[],'filled', 'MarkerFaceColor',coloursTuned)
    hold on; errorbar(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).x,sigmoidData.group.TunedLog2Lin.(mapNames{roi}).y,...
        sigmoidData.group.TunedLog2Lin.(mapNames{roi}).ysterr(1,:),sigmoidData.group.TunedLog2Lin.(mapNames{roi}).ysterr(2,:),'.','Color',coloursTuned,...
        'MarkerFaceColor',coloursTuned,'LineWidth',1);
    hold on; plot(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).xfit, sigmoidData.group.TunedLog2Lin.(mapNames{roi}).yfit, '-', 'Color',coloursTuned,'LineWidth',3);
    hold on; plot(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).xfit, sigmoidData.group.TunedLog2Lin.(mapNames{roi}).b_upper, '--','Color',coloursTuned,'LineWidth',2);
    hold on; plot(sigmoidData.group.TunedLog2Lin.(mapNames{roi}).xfit, sigmoidData.group.TunedLog2Lin.(mapNames{roi}).b_lower,  '--','Color',coloursTuned,'LineWidth',2);

    axis([0 5.5 0 yrange])
    yticks(0:.1:.5);yticklabels({'0','0.1','0.2','0.3','0.4','0.5'});
    ylabel({'Response model fit (R^2)'},'FontWeight','bold');
    xticks(0:1:5);xticklabels({'0','1','2','3','4','5'});
    xlabel('Preferred eccentricity (^o)','FontWeight','bold');
    set(gca,'FontSize',15);
    axis square
    set(gcf,'color','w');
    box off
    
    if savePlots,export_fig(['Fig2b_',mapNames{roi}],'-png','-r600','-painters');close all;end
    if saveData,save(['sigmoidData_',mapNames{roi},'.mat'],'sigmoidData','fitParams');end
end

%% TO1, IPS0 & IPS5
clear ve_data cv_data ecc

participantNames = {'P01', 'P02', 'P03', 'P04', 'P05', 'P06', 'P07', 'P08', 'P09', 'P10', 'P11'};
whichParticipants=1:5;
group = [];group.bins = []; fitData = []; bins = [];
ROINames = {'IPS0', 'IPS1', 'IPS2', 'IPS3', 'IPS4', 'IPS5', ...
    'sPCS1', 'sPCS2', 'iPCS', 'LO1','LO2', 'TO1', 'TO2', ...
    'V1', 'V2', 'V3', 'V3AB'};
mapNames=["bothIPS0","bothIPS1","bothIPS2","bothIPS3","bothIPS4","bothIPS5","bothsPCS1","bothsPCS2","bothiPCS",...
    "bothLO1","bothLO2","bothTO1","bothTO2","bothV1","bothV2","bothV3","bothV3AB"];
modelFieldNames = {'MonoLog','TunedLog2Lin'};
binsize = 0.20;thresh.ecc = [0 5.5];voxelSize = 1.77;
bins.MonoLogIncrease.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.MonoLogDecrease.x = (thresh.ecc(1):binsize:thresh.ecc(2))';
bins.TunedLog2Lin.x = (thresh.ecc(1):binsize:thresh.ecc(2))';

for participant = 1:length(participantNames)
    ve_data.MonoLog.(participantNames{participant}) = data_numerosity.ve.(participantNames{participant}).MonoLog;
    ve_data.TunedLog2Lin.(participantNames{participant}) = data_numerosity.ve.(participantNames{participant}).TunedLog2Lin;
end

condNames = fieldnames(ve_data.MonoLog.(participantNames{participant}));
% Combine cross-validated model results
for participant = 1:length(participantNames)
    
    % Monotonic
    for ROIs = 1:length(mapNames)
        
        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).iCoords = ...
            ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).iCoords;
        
        % Check for change in slope
        flipFlop = ~(ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).xs == ...
            ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{3}).(mapNames{ROIs}).xs);

        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).xs = ...
            ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).xs;
        
        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).xs(flipFlop) = 0; %set changed xs to 0

        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).varianceExplained = ...
            (ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).varianceExplained + ...
            ve_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{3}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.(modelFieldNames{1}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).varianceExplained(flipFlop) = 0; %set changed VE to 0
        
    end
    % Tuned
    for ROIs = 1:length(mapNames)
        
        cv_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).iCoords = ...
            ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).iCoords;
        
        cv_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).xs = ...
            (ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).xs + ...
            ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{3}).(mapNames{ROIs}).xs)./2;

        cv_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{1}).(mapNames{ROIs}).varianceExplained = ...
            (ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{2}).(mapNames{ROIs}).varianceExplained + ...
            ve_data.(modelFieldNames{2}).(participantNames{participant}).(condNames{3}).(mapNames{ROIs}).varianceExplained)./2;
    end
end

clear ve_data
ve_data = cv_data;

% Seperate out increase and decrease
ve_data.MonoLogIncrease = ve_data.MonoLog;
ve_data.MonoLogDecrease = ve_data.MonoLog;
condition=1;
for participant = 1:length(participantNames)
    condNames = fieldnames(ve_data.MonoLog.(participantNames{participant}));
    for roi = 1:length(mapNames)
        ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained...
            (ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).xs==2) = 0;
        ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained...
            (ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).xs==1) = 0;
    end
end

%% eccentricity
for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        ecc.(participantNames{participant}).(char(mapNames{roi})).ecc = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).ecc;
        ecc.(participantNames{participant}).(char(mapNames{roi})).sigma = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).sigma;        
    end
end

%% Group data
for participant = 1:length(participantNames)
    condNames = fieldnames(ve_data.MonoLog.(participantNames{participant}));
    for roi = 1:length(mapNames)
        eccCurrent = ecc.(participantNames{participant}).(mapNames{roi}).ecc;
        veCurrent_monoIncrease = ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
        veCurrent_monoDecrease = ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
        veCurrent_tuned = ve_data.TunedLog2Lin.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
        
        if participant==1
            group.ecc.(mapNames{roi}).ecc = eccCurrent;
            group.ve_data.MonoLogIncrease.(mapNames{roi}) = veCurrent_monoIncrease;
            group.ve_data.MonoLogDecrease.(mapNames{roi}) = veCurrent_monoDecrease;            
            group.ve_data.TunedLog2Lin.(mapNames{roi}) = veCurrent_tuned;
        else
            group.ecc.(mapNames{roi}).ecc = [group.ecc.(mapNames{roi}).ecc, eccCurrent];
            group.ve_data.MonoLogIncrease.(mapNames{roi}) = [group.ve_data.MonoLogIncrease.(mapNames{roi}), veCurrent_monoIncrease];
            group.ve_data.MonoLogDecrease.(mapNames{roi}) = [group.ve_data.MonoLogDecrease.(mapNames{roi}), veCurrent_monoDecrease];            
            group.ve_data.TunedLog2Lin.(mapNames{roi}) = [group.ve_data.TunedLog2Lin.(mapNames{roi}), veCurrent_tuned];
        end
    end
end

for participant = 1:length(participantNames)
    condNames = fieldnames(ve_data.MonoLog.(participantNames{participant}));
    for roi = 1:length(mapNames)
        for b = round(thresh.ecc(1):binsize:thresh.ecc(2),1)
            % Determine which voxels are in each bin
            bii = ecc.(participantNames{participant}).(mapNames{roi}).ecc >  b-binsize./2 & ...
                ecc.(participantNames{participant}).(mapNames{roi}).ecc <= b+binsize./2;
            group_bii = group.ecc.(mapNames{roi}).ecc >  b-binsize./2 & ...
                group.ecc.(mapNames{roi}).ecc <= b+binsize./2;
            if any(bii)
                % Fit which eccentricity bin this corresponds to
                ii2 = find(bins.MonoLogIncrease.x == b);
                s_monoIncrease = wstat(ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_monoIncrease.sterr;
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_monoIncrease.stdev;
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_monoIncrease.mean;

                s_monoDecrease = wstat(ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_monoDecrease.sterr;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_monoDecrease.stdev;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_monoDecrease.mean;
                
                s_tuned = wstat(ve_data.TunedLog2Lin.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained(bii),[], voxelSize^2);
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).sterr(:,ii2) = s_tuned.sterr;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).sdev(:,ii2) = s_tuned.stdev;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = s_tuned.mean;

            else
                ii2 = find(bins.MonoLogIncrease.x == b);
                bins.MonoLogIncrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.MonoLogDecrease.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                bins.TunedLog2Lin.(participantNames{participant}).(mapNames{roi}).mean(:,ii2) = 0;
                
            end
            if any(group_bii)                
                group_ii2 = find(round(bins.MonoLogIncrease.x,1) == b);
                s_monoIncrease = wstat(group.ve_data.MonoLogIncrease.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.MonoLogIncrease.(mapNames{roi}).sterr(:,group_ii2 ) = s_monoIncrease.sterr;
                group.bins.MonoLogIncrease.(mapNames{roi}).sdev(:,group_ii2 ) = s_monoIncrease.stdev;
                group.bins.MonoLogIncrease.(mapNames{roi}).mean(:,group_ii2 ) = s_monoIncrease.mean;
                
                s_monoDecrease = wstat(group.ve_data.MonoLogDecrease.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.MonoLogDecrease.(mapNames{roi}).sterr(:,group_ii2 ) = s_monoDecrease.sterr;
                group.bins.MonoLogDecrease.(mapNames{roi}).sdev(:,group_ii2 ) = s_monoDecrease.stdev;
                group.bins.MonoLogDecrease.(mapNames{roi}).mean(:,group_ii2 ) = s_monoDecrease.mean;                
                
                s_tuned = wstat(group.ve_data.TunedLog2Lin.(mapNames{roi})(group_bii),[], voxelSize^2);
                group.bins.TunedLog2Lin.(mapNames{roi}).sterr(:,group_ii2 ) = s_tuned.sterr;
                group.bins.TunedLog2Lin.(mapNames{roi}).sdev(:,group_ii2 ) = s_tuned.stdev;
                group.bins.TunedLog2Lin.(mapNames{roi}).mean(:,group_ii2 ) = s_tuned.mean;
            else
                group_ii2 = find(bins.MonoLogIncrease.x == b);
                group.bins.MonoLogIncrease.(mapNames{roi}).mean(:,group_ii2) = 0;
                group.bins.MonoLogDecrease.(mapNames{roi}).mean(:,group_ii2) = 0;                
                group.bins.TunedLog2Lin.(mapNames{roi}).mean(:,group_ii2) = 0;
            end                
        end
        
        %fitting data
        if participant==1
            fitData.ecc.(mapNames{roi}) = ecc.(participantNames{participant}).(mapNames{roi}).ecc;
            fitData.ve.MonoLogIncrease.(mapNames{roi}) = ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
            fitData.ve.MonoLogDecrease.(mapNames{roi}) = ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;            
            fitData.ve.TunedLog2Lin.(mapNames{roi}) = ve_data.TunedLog2Lin.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained;
        else
            fitData.ecc.(mapNames{roi}) = [fitData.ecc.(mapNames{roi}),ecc.(participantNames{participant}).(mapNames{roi}).ecc];
            fitData.ve.MonoLogIncrease.(mapNames{roi}) = [fitData.ve.MonoLogIncrease.(mapNames{roi}),ve_data.MonoLogIncrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained];
            fitData.ve.MonoLogDecrease.(mapNames{roi}) = [fitData.ve.MonoLogDecrease.(mapNames{roi}),ve_data.MonoLogDecrease.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained];            
            fitData.ve.TunedLog2Lin.(mapNames{roi}) = [fitData.ve.TunedLog2Lin.(mapNames{roi}),ve_data.TunedLog2Lin.(participantNames{participant}).(char(condNames{condition})).(mapNames{roi}).varianceExplained];
        end
    end

end

for roi = [12,1,6]
    %% Eccentricity data
    eccBoot = fitData.ecc.(mapNames{roi});
    minEcc = min(thresh.ecc); maxEcc = max(thresh.ecc);

    %% Quadratic fit
    nboot = 1000; % Number of bootstrap samples
    poly_order = 2; % Quadratic
        
    %% Monotonic numerosity (increasing)
    x_monoIncrease = bins.MonoLogIncrease.x;
    y_monoIncrease = group.bins.MonoLogIncrease.(mapNames{roi}).mean';
    sterr_monoIncrease = group.bins.MonoLogIncrease.(mapNames{roi}).sterr';
    x_monoIncrease(y_monoIncrease==0) = [];
    sterr_monoIncrease(y_monoIncrease==0) = [];
    y_monoIncrease(y_monoIncrease==0) = [];
    
    [pQuad_monoIncrease,SQuad_monoIncrease] = polyfit(x_monoIncrease,y_monoIncrease,poly_order);
    xvQuad_monoIncrease = linspace(min(x_monoIncrease), max(x_monoIncrease), 1000);
    [yQuad_ci_monoIncrease,deltaQuad_monoIncrease] = polyconf(pQuad_monoIncrease,xvQuad_monoIncrease,SQuad_monoIncrease,'predopt','curve');
    
    xfit = linspace(min(x_monoIncrease(~isnan(y_monoIncrease))),max(x_monoIncrease(~isnan(y_monoIncrease))),1000)';
    yfit = polyval(pQuad_monoIncrease,xfit,SQuad_monoIncrease);
     
    figure
    errorbar(x_monoIncrease, y_monoIncrease, sterr_monoIncrease, '.','Color',coloursIncrease(colourROI,:),'LineWidth',1); % Original data
    hold on
    scatter(x_monoIncrease, y_monoIncrease, [], coloursIncrease(colourROI,:),'filled'); % Original data
    hold on
    plot(xfit,yfit,'Color',coloursIncrease(colourROI,:),'LineWidth',3); % Fit
    plot(xfit,yQuad_ci_monoIncrease-deltaQuad_monoIncrease, '--','Color',coloursIncrease(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    plot(xfit,yQuad_ci_monoIncrease+deltaQuad_monoIncrease, '--','Color',coloursIncrease(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    
    %% Monotonic numerosity (decreasing)
    x_monoDecrease = bins.MonoLogDecrease.x;
    y_monoDecrease = group.bins.MonoLogDecrease.(mapNames{roi}).mean';
    sterr_monoDecrease = group.bins.MonoLogDecrease.(mapNames{roi}).sterr';
    x_monoDecrease(y_monoDecrease==0) = [];
    sterr_monoDecrease(y_monoDecrease==0) = [];
    y_monoDecrease(y_monoDecrease==0) = [];
    
    [pQuad_monoDecrease,SQuad_monoDecrease] = polyfit(x_monoDecrease,y_monoDecrease,poly_order);
    xvQuad_monoDecrease = linspace(min(x_monoDecrease), max(x_monoDecrease), 1000);
    [yQuad_ci_monoDecrease,deltaQuad_monoDecrease] = polyconf(pQuad_monoDecrease,xvQuad_monoDecrease,SQuad_monoDecrease,'predopt','curve');
    
    xfit = linspace(min(x_monoDecrease(~isnan(y_monoDecrease))),max(x_monoDecrease(~isnan(y_monoDecrease))),1000)';
    yfit = polyval(pQuad_monoDecrease,xfit,SQuad_monoDecrease);
           
    errorbar(x_monoDecrease, y_monoDecrease, sterr_monoDecrease, '.','Color',coloursDecrease(colourROI,:),'LineWidth',1); % Original data
    hold on
    scatter(x_monoDecrease, y_monoDecrease, [], coloursDecrease(colourROI,:),'filled'); % Original data
    hold on
    plot(xfit,yfit,'Color',coloursDecrease(colourROI,:),'LineWidth',3); % Fit
    plot(xfit,yQuad_ci_monoDecrease-deltaQuad_monoDecrease, '--','Color',coloursDecrease(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    plot(xfit,yQuad_ci_monoDecrease+deltaQuad_monoDecrease, '--','Color',coloursDecrease(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    
    %% Tuned numerosity
    x_tuned = bins.TunedLog2Lin.x;
    y_tuned = group.bins.TunedLog2Lin.(mapNames{roi}).mean';
    sterr_tuned = group.bins.TunedLog2Lin.(mapNames{roi}).sterr';
    x_tuned(y_tuned==0) = [];
    sterr_tuned(y_tuned==0) = [];
    y_tuned(y_tuned==0) = [];
    
    [pQuad_tuned,SQuad_tuned] = polyfit(x_tuned,y_tuned,poly_order);
    xvQuad_tuned = linspace(min(x_tuned), max(x_tuned), 1000);
    [yQuad_ci_tuned,deltaQuad_tuned] = polyconf(pQuad_tuned,xvQuad_tuned,SQuad_tuned,'predopt','curve');
    
    xfit = linspace(min(x_tuned(~isnan(y_tuned))),max(x_tuned(~isnan(y_tuned))),1000)';
    yfit = polyval(pQuad_tuned,xfit,SQuad_tuned);
           
    errorbar(x_tuned, y_tuned, sterr_tuned, '.','Color',coloursTuned(colourROI,:),'LineWidth',1); % Original data
    hold on
    scatter(x_tuned, y_tuned, [], coloursTuned(colourROI,:),'filled'); % Original data
    hold on
    plot(xfit,yfit,'Color',coloursTuned(colourROI,:),'LineWidth',3); % Fit
    plot(xfit,yQuad_ci_tuned-deltaQuad_tuned, '--','Color',coloursTuned(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    plot(xfit,yQuad_ci_tuned+deltaQuad_tuned, '--','Color',coloursTuned(colourROI,:),'LineWidth',2); % 95% confidence interval of fit line
    
    axis([0 5.5 0 yrange])
    yticks(0:.1:.5);yticklabels({'0','0.1','0.2','0.3','0.4','0.5'});
    ylabel({'Response model fit (R^2)'},'FontWeight','bold');
    xticks(0:1:5);xticklabels({'0','1','2','3','4','5'});
    xlabel('Preferred eccentricity (^o)','FontWeight','bold');
    set(gca,'FontSize',15);
    axis square
    set(gcf,'color','w');
    box off

    if savePlots,export_fig(['Fig2b_',mapNames{roi}],'-png','-r600','-painters');close all;end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Model fit (R^2) ANOVA (numerosity vs. aggregate Fourier power, eccentricity, VFM ROIs) Fig.2b %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load data_numerosity
load data_vfm

participantNames = {'P01', 'P02', 'P03', 'P04', 'P05'}; % Only have Fourier Power models for P01-P05
mapNames=["bothIPS0", "bothIPS1", "bothIPS2", "bothIPS3", "bothIPS4", "bothIPS5", "bothsPCS1", "bothsPCS2",...
    "bothiPCS", "bothLO1", "bothLO2", "bothTO1", "bothTO2", "bothV1", "bothV2", "bothV3", "bothV3AB",...
    "leftIPS0", "leftIPS1", "leftIPS2", "leftIPS3", "leftIPS4", "leftIPS5", "leftsPCS1", "leftsPCS2",...
    "leftiPCS", "leftLO1", "leftLO2", "leftTO1", "leftTO2", "leftV1", "leftV2", "leftV3", "leftV3AB",...
    "rightIPS0", "rightIPS1", "rightIPS2", "rightIPS3", "rightIPS4", "rightIPS5", "rightsPCS1", "rightsPCS2",...
    "rightiPCS", "rightLO1", "rightLO2", "rightTO1", "rightTO2", "rightV1", "rightV2", "rightV3", "rightV3AB"];
allNames = ["All","AllOdd","AllEven"];
minNumerosity=log(1.01);maxNumerosity=log(6.99);

saveData = 1;savePlots = 1;

for thisParticipant = 1:length(participantNames)
    for DTs=1:length(allNames)
        for maps = 1:length(mapNames)
            eval(['AggFourierPower.',participantNames{thisParticipant},'.',allNames{DTs},'.',mapNames{maps},...
                '=data_numerosity.ve.',participantNames{thisParticipant},'.aggFourierPower.',allNames{DTs},...
                '.',mapNames{maps},'.Both;']);
            eval(['Tuned.',participantNames{thisParticipant},'.',allNames{DTs},'.',mapNames{maps},...
                '=data_numerosity.ve.',participantNames{thisParticipant},'.tunedNumber.',allNames{DTs},...
                '.',mapNames{maps},'.Both;']);
        end
    end
end

for thisParticipant = 1:length(participantNames)
    for DTs=2:length(allNames)
        for maps = 1:length(mapNames)
            % Fourier power
            x0s_current = data_numerosity.ve.(participantNames{thisParticipant}).aggFourierPower.(allNames{DTs}).(mapNames{maps}).Both.x0sAll;
            x0s_current_mean = mean(x0s_current);
            ves_current = data_numerosity.ve.(participantNames{thisParticipant}).aggFourierPower.(allNames{DTs}).(mapNames{maps}).Both.vesXvalAll;
            ves_current_mean = mean(ves_current);
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).xs = x0s_current_mean;
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).varianceExplained = ves_current_mean;
                        
            % Tuned numerosity
            x0s_current = data_numerosity.ve.(participantNames{thisParticipant}).tunedNumber.(allNames{DTs}).(mapNames{maps}).Both.x0sAll;
            x0s_current_mean = mean(x0s_current);
            ves_current = data_numerosity.ve.(participantNames{thisParticipant}).tunedNumber.(allNames{DTs}).(mapNames{maps}).Both.vesXvalAll;
            ves_current_mean = mean(ves_current);
            cv_data.Tuned.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).xs = x0s_current_mean;
            cv_data.Tuned.(participantNames{thisParticipant}).(allNames{DTs}).(mapNames{maps}).varianceExplained = ves_current_mean;
        end
    end
end

condNames = fieldnames(cv_data.AggFourierPower.(participantNames{1}));
condNames(3) = {'AllOddEven'};
% Average odd/even scans
for thisParticipant = 1:length(participantNames)
    % Check for change in slope
    for ROIs = 1:length(mapNames)
        % Fourier power
        flipFlop = ~(cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).xs == ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs);

        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs = ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs;
        
        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs(flipFlop) = 0; % Set changed xs to 0

        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = ...
            (cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).varianceExplained + ...
            cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.AggFourierPower.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained(flipFlop) = 0; % Set changed VE to 0 
        
        % Tuned numerosity
        varianceExplained = (cv_data.Tuned.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).varianceExplained + ...
            cv_data.Tuned.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).varianceExplained)./2;
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = varianceExplained;
        
        xs = (cv_data.Tuned.(participantNames{thisParticipant}).(condNames{1}).(mapNames{ROIs}).xs + ...
            cv_data.Tuned.(participantNames{thisParticipant}).(condNames{2}).(mapNames{ROIs}).xs)./2;
                
        xs = exp(xs); %Log2Lin
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).xs = xs;
            
        varianceExplained(xs<=minNumerosity)=0;varianceExplained(xs>=maxNumerosity)=0;
        
        cv_data.Tuned.(participantNames{thisParticipant}).(condNames{3}).(mapNames{ROIs}).varianceExplained = varianceExplained;        
    end
end

ve_data.AggFourierPower = cv_data.AggFourierPower;
ve_data.TunedLog2Lin = cv_data.Tuned;

% Seperate out increasing & decreasing
ve_data.AggFourierPowerIncrease = ve_data.AggFourierPower;

for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        % Fourier power
        ve_data.AggFourierPowerIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained...
            (ve_data.AggFourierPowerIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).xs==2) = 0;
    end
end

%% eccentricity
for participant = 1:length(participantNames)
    for roi = 1:length(mapNames)
        ecc.(participantNames{participant}).(char(mapNames{roi})).ecc = data_vfm.ve.(participantNames{participant}).VFML1.(char(mapNames{roi})).ecc;
    end
end

anova_data = ve_data;
anova_ecc = ecc;

anova_thisParticipant = participantNames;
anova_rois = {'IPS0','IPS1','IPS2','IPS3','IPS4','IPS5',...
    'sPCS1','sPCS2','iPCS','LO1','LO2','TO1','TO2',...
    'V1','V2','V3','V3AB'};
anova_eccentricity = {'Near','Far'};
anova_hemispheres={'Left', 'Right'}; % not used

anovaOn=1;  % calculate ANOVA (0=off/1=on)
plotOn=1;   % save ANOVA plot (0=off/1=on)

yrange = 0.5;       % VE maximum y-axis
removeVE = 0;       % Minimum VE value
removeEcc = 5.5;    % Maximum eccentricity value

%% ANOVA - Aggregate Fourier power
veANOVA=[];eccANOVA=[];thisParticipantANOVA=[];roiANOVA=[];hemiANOVA=[];
for roi = 1:17 % both ROIs only
    for participant = 1:length(participantNames)
        veCurrent = anova_data.AggFourierPowerIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained';
        eccClose = anova_ecc.(participantNames{participant}).(mapNames{roi}).ecc';
        removeVE_Ecc = find(sum([veCurrent<=removeVE,eccClose>removeEcc],2)>0);
        eccClose(removeVE_Ecc)=[];
        eccClose(eccClose<=1) = 0;eccClose(eccClose>=2) = 1; % 0=less than 1.5deg, 1=greater than 1.5deg
        veCurrent(removeVE_Ecc)=[];
        eccANOVA=[eccANOVA;[0;1]]; %#ok<AGROW>
        veANOVA = [veANOVA;[mean(veCurrent(eccClose==0));mean(veCurrent(eccClose==1))]]; %#ok<AGROW>
        thisParticipantANOVA = [thisParticipantANOVA;[participant;participant]]; %#ok<AGROW>
        roiANOVA = [roiANOVA;[(mod(roi-18,17)+1);(mod(roi-18,17)+1)]]; %#ok<AGROW>    
    end
end

models_anova.ve=veANOVA;
models_anova.thisParticipant=nominal(thisParticipantANOVA);
models_anova.map=nominal(roiANOVA);
models_anova.eccentricity=nominal(eccANOVA+1);
models_anova_lme=table(veANOVA,nominal(thisParticipantANOVA),nominal(roiANOVA),nominal(eccANOVA+1),'VariableNames',{'ve', 'thisParticipant' ,'map', 'eccentricity'});

thisParticipantANOVA=anova_thisParticipant(thisParticipantANOVA);
hemiANOVA=anova_hemispheres(hemiANOVA+1); %#ok<NASGU>
roiANOVA=anova_rois(roiANOVA);
eccANOVA=anova_eccentricity(eccANOVA+1);

% ANOVA without hemisphere
if anovaOn==1
    randomANOVA=1;
    if randomANOVA==0
        % Fixed
        [p_both_fourier,tbl_both_fourier,stats_both_fourier,terms_both_fourier] = anovan(veANOVA,{thisParticipantANOVA,roiANOVA,eccANOVA},...
            'varnames', {'thisParticipant', 'map', 'eccentricity'});
        figure;results_both_fourier=multcompare(stats_both_fourier, 'Dimension', [2 3]); close all
    else
        % Random
        [p_both_fourier,tbl_both_fourier,stats_both_fourier,terms_both_fourier] = anovan(veANOVA,{thisParticipantANOVA,roiANOVA,eccANOVA},...
            'model',1,'random',1,'varnames', {'thisParticipant', 'map', 'eccentricity'});
        figure;results_both_fourier=multcompare(stats_both_fourier, 'Dimension', [2 3]); close all
        
        lme= fitlme(models_anova_lme,'ve~map+eccentricity+(1|thisParticipant)','DummyVarCoding','eff','FitMethod','reml');
        disp(lme);
        anova(lme,'dfmethod','satterthwaite')
    end
end

% For plotting
for roi = 18:length(mapNames) % L&R ROIs
    for participant = 1:length(participantNames)
        veCurrent = anova_data.AggFourierPowerIncrease.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained';
        eccClose = anova_ecc.(participantNames{participant}).(mapNames{roi}).ecc';
        removeVE_Ecc = find(sum([veCurrent<=removeVE,eccClose>removeEcc],2)>0);
        eccClose(removeVE_Ecc)=[];
        eccClose(eccClose<=1) = 0;eccClose(eccClose>=2) = 1; % 0=less than 1.5deg, 1=greater than 1.5deg
        veCurrent(removeVE_Ecc)=[];
        meanSub_ve_near(participant,roi-17)=nanmean(veCurrent(eccClose==0)); %#ok<SAGROW>
        meanSub_ve_far(participant,roi-17)=nanmean(veCurrent(eccClose==1));  %#ok<SAGROW>
    end
end
fourier_mean_ve_near=nanmean(meanSub_ve_near);
fourier_mean_ve_far=nanmean(meanSub_ve_far);

fourier_std_ve_near=nanstd(meanSub_ve_near);
fourier_std_ve_far=nanstd(meanSub_ve_far);

fourier_se2x_ve_near=2*(fourier_std_ve_near/sqrt(length(participantNames)));
fourier_se2x_ve_far=2*(fourier_std_ve_far/sqrt(length(participantNames)));

%% ANOVA - Tuned numerosity
veANOVA=[];eccANOVA=[];thisParticipantANOVA=[];roiANOVA=[];hemiANOVA=[];
for roi = 1:17 % both ROIs only
    for participant = 1:length(participantNames)
        veCurrent = anova_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained';
        eccClose = anova_ecc.(participantNames{participant}).(mapNames{roi}).ecc';
        removeVE_Ecc = find(sum([veCurrent<=removeVE,eccClose>removeEcc],2)>0);
        eccClose(removeVE_Ecc)=[];
        eccClose(eccClose<=1) = 0;eccClose(eccClose>=2) = 1; % 0=less than 1.5deg, 1=greater than 1.5deg
        veCurrent(removeVE_Ecc)=[];
        eccANOVA=[eccANOVA;[0;1]]; %#ok<AGROW>
        veANOVA = [veANOVA;[mean(veCurrent(eccClose==0));mean(veCurrent(eccClose==1))]]; %#ok<AGROW>
        thisParticipantANOVA = [thisParticipantANOVA;[participant;participant]]; %#ok<AGROW>
        roiANOVA = [roiANOVA;[(mod(roi-18,17)+1);(mod(roi-18,17)+1)]]; %#ok<AGROW>
    end
end

models_anova.ve=veANOVA;
models_anova.thisParticipant=nominal(thisParticipantANOVA);
models_anova.map=nominal(roiANOVA);
models_anova.eccentricity=nominal(eccANOVA+1);
models_anova_lme=table(veANOVA,nominal(thisParticipantANOVA),nominal(roiANOVA),nominal(eccANOVA+1),'VariableNames',{'ve', 'thisParticipant' ,'map', 'eccentricity'});

thisParticipantANOVA=anova_thisParticipant(thisParticipantANOVA);
hemiANOVA=anova_hemispheres(hemiANOVA+1);
roiANOVA=anova_rois(roiANOVA);
eccANOVA=anova_eccentricity(eccANOVA+1);

% ANOVA without hemisphere
if anovaOn==1
    randomANOVA=1;
    if randomANOVA==0
        % Fixed
        [p_both_tuned,tbl_both_tuned,stats_both_tuned,terms_both_tuned] = anovan(veANOVA,{thisParticipantANOVA,roiANOVA,eccANOVA},...
            'varnames', {'thisParticipant', 'map', 'eccentricity'});
        figure;results_both_tuned=multcompare(stats_both_tuned, 'Dimension', [2 3]); close all
    else
        % Random
        [p_both_tuned,tbl_both_tuned,stats_both_tuned,terms_both_tuned] = anovan(veANOVA,{thisParticipantANOVA,roiANOVA,eccANOVA},...
            'model',1,'random',1,'varnames', {'thisParticipant', 'map', 'eccentricity'});
        figure;results_both_tuned=multcompare(stats_both_tuned, 'Dimension', [2 3]); close all
        
        lme= fitlme(models_anova_lme,'ve~map+eccentricity+(1|thisParticipant)','DummyVarCoding','eff','FitMethod','reml');
        disp(lme);
        anova(lme,'dfmethod','satterthwaite')
    end
end

% For plotting
for roi = 18:length(mapNames) % L&R ROIs only
    for participant = 1:length(participantNames)
        veCurrent = anova_data.TunedLog2Lin.(participantNames{participant}).AllOddEven.(mapNames{roi}).varianceExplained';
        eccClose = anova_ecc.(participantNames{participant}).(mapNames{roi}).ecc';
        removeVE_Ecc = find(sum([veCurrent<=removeVE,eccClose>removeEcc],2)>0);
        eccClose(removeVE_Ecc)=[];
        eccClose(eccClose<=1) = 0;eccClose(eccClose>=2) = 1; % 0=less than 1.5deg, 1=greater than 1.5deg
        veCurrent(removeVE_Ecc)=[];
        meanSub_ve_near(participant,roi-17)=nanmean(veCurrent(eccClose==0));
        meanSub_ve_far(participant,roi-17)=nanmean(veCurrent(eccClose==1));
    end
end
tuned_mean_ve_near=nanmean(meanSub_ve_near);
tuned_mean_ve_far=nanmean(meanSub_ve_far);

tuned_std_ve_near=nanstd(meanSub_ve_near);
tuned_std_ve_far=nanstd(meanSub_ve_far);

tuned_se2x_ve_near=2*(tuned_std_ve_near/sqrt(length(participantNames)));
tuned_se2x_ve_far=2*(tuned_std_ve_far/sqrt(length(participantNames)));

%% ANOVA plot: Marginal means & 95%CI
figure;
scatter_roiLabels = {'IPS0','IPS1','IPS2','IPS3','IPS4','IPS5',...
    'sPCS1','sPCS2','iPCS','LO1 ','LO2 ','TO1 ','TO2 ',...
    ' V1 ',' V2 ',' V3 ','V3AB'};
scatter_order=[14:16,10:13,17,1:9];x_LR=1:17;
% Dorsal(1:9,17) is IPS0-IPS5, iPCS, sPCS1-sPCS2, V3AB
% Ventral(10:13) is LO1-LO2, TO1-TO2
% EVC(14:16) is V1-V3
fourier_barLeft=[0,0.8078,0.8196];fourier_barRight=[0.6863,0.9333,0.9333];
tuned_barLeft=[1,.56,.56];tuned_barRight=[1,.8,.8];

% Error bars
%left, %less than 1.5deg
plot([x_LR;x_LR]-.2,[fourier_mean_ve_near(1,(scatter_order))-fourier_se2x_ve_near(1,(scatter_order));fourier_mean_ve_near(1,(scatter_order))+fourier_se2x_ve_near(1,(scatter_order))],'Color',fourier_barLeft,'LineWidth',3);
hold on
%right, %less than 1.5deg
fourierPower_rightBars=plot([x_LR;x_LR]+.2,[fourier_mean_ve_near(1,(scatter_order+17))-fourier_se2x_ve_near(1,(scatter_order+17));fourier_mean_ve_near(1,(scatter_order+17))+fourier_se2x_ve_near(1,(scatter_order+17))],'Color',fourier_barRight,'LineWidth',3);
%left, %greater than 1.5deg
fourierPower_leftBars=plot([x_LR+18;x_LR+18]-.2,[fourier_mean_ve_far(1,(scatter_order))-fourier_se2x_ve_far(1,(scatter_order));fourier_mean_ve_far(1,(scatter_order))+fourier_se2x_ve_far(1,(scatter_order))],'Color',fourier_barLeft,'LineWidth',3);
%right, %greater than 1.5deg
plot([x_LR+18;x_LR+18]+.2,[fourier_mean_ve_far(1,(scatter_order+17))-fourier_se2x_ve_far(1,(scatter_order+17));fourier_mean_ve_far(1,(scatter_order+17))+fourier_se2x_ve_far(1,(scatter_order+17))],'Color',fourier_barRight,'LineWidth',3);

%left, %less than 1.5deg
plot([x_LR;x_LR]-.2,[tuned_mean_ve_near(1,(scatter_order))-tuned_se2x_ve_near(1,(scatter_order));tuned_mean_ve_near(1,(scatter_order))+tuned_se2x_ve_near(1,(scatter_order))],'Color',tuned_barLeft,'LineWidth',3);
hold on
%right, %less than 1.5deg
tuned_rightBars=plot([x_LR;x_LR]+.2,[tuned_mean_ve_near(1,(scatter_order+17))-tuned_se2x_ve_near(1,(scatter_order+17));tuned_mean_ve_near(1,(scatter_order+17))+tuned_se2x_ve_near(1,(scatter_order+17))],'Color',tuned_barRight,'LineWidth',3);
%left, %greater than 1.5deg
tuned_leftBars=plot([x_LR+18;x_LR+18]-.2,[tuned_mean_ve_far(1,(scatter_order))-tuned_se2x_ve_far(1,(scatter_order));tuned_mean_ve_far(1,(scatter_order))+tuned_se2x_ve_far(1,(scatter_order))],'Color',tuned_barLeft,'LineWidth',3);
%right, %greater than 1.5deg
plot([x_LR+18;x_LR+18]+.2,[tuned_mean_ve_far(1,(scatter_order+17))-tuned_se2x_ve_far(1,(scatter_order+17));tuned_mean_ve_far(1,(scatter_order+17))+tuned_se2x_ve_far(1,(scatter_order+17))],'Color',tuned_barRight,'LineWidth',3);

% Point estimates
%left, %less than 1.5deg
fourierPower_15deg=scatter(x_LR-.2,fourier_mean_ve_near(1,scatter_order),24,'o','MarkerFaceColor',fourier_barLeft,'MarkerEdgeColor','k');
%right, %less than 1.5deg
scatter(x_LR+.2,fourier_mean_ve_near(1,scatter_order+17),24,'o','MarkerFaceColor',fourier_barRight,'MarkerEdgeColor','k');
%left, %greater than 1.5deg
fourierPower_55deg=scatter(x_LR+18-.2,fourier_mean_ve_far(1,scatter_order),28,'s','MarkerFaceColor',fourier_barLeft,'MarkerEdgeColor','k');
%right, %greater than 1.5deg
scatter(x_LR+18+.2,fourier_mean_ve_far(1,scatter_order+17),28,'s','MarkerFaceColor',fourier_barRight,'MarkerEdgeColor','k');

%left, %less than 1.5deg
tuned_15deg=scatter(x_LR-.2,tuned_mean_ve_near(1,scatter_order),24,'o','MarkerFaceColor',tuned_barLeft,'MarkerEdgeColor','k');
%right, %less than 1.5deg
scatter(x_LR+.2,tuned_mean_ve_near(1,scatter_order+17),24,'o','MarkerFaceColor',tuned_barRight,'MarkerEdgeColor','k');
%left, %greater than 1.5deg
tuned_55deg=scatter(x_LR+18-.2,tuned_mean_ve_far(1,scatter_order),28,'s','MarkerFaceColor',tuned_barLeft,'MarkerEdgeColor','k');
%right, %greater than 1.5deg
scatter(x_LR+18+.2,tuned_mean_ve_far(1,scatter_order+17),28,'s','MarkerFaceColor',tuned_barRight,'MarkerEdgeColor','k');

xticks(1:1:(roi*2)+1);xticklabels([scatter_roiLabels(scatter_order(1:end)),' ',scatter_roiLabels(scatter_order(1:end))]);
xtickangle(90);box off
axis([0,36,0,yrange])
yticks(0:.1:yrange);yticklabels({'0','0.1','0.2','0.3','0.4','0.5'})
plot([18;18],[0,1],'k--','LineWidth',1);

set(gcf,'Color','w');
xlabel('Visual field maps','FontWeight','bold');
ylabel({'Response model fit (R^2)'},'FontWeight','bold');
set(gcf,'units','centimeters','position',[0.1 0.1 24 8]);
if plotOn;export_fig(['Fig2c','.png'],'-png','-r600','-painters');end
