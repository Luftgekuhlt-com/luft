window.ZoneMapProvider = {};

    window.ZoneMapProvider.zoneMaps = {};

    window.ZoneMapProvider.zoneMaps["265"] = {
        name: "San Diego Civic Theatre",
        screens: {
            "1": "Orchestra",
            "2": "Dress Circle",
            "5": "Mezzanine",
            "8": "Lower Loge",
            "7": "Upper Loge",
            "4": "Balcony"
        },
        sections: [
        {
            id: 29,
            name: "Premier Orchestra",
            slug: "orchestra-1",
			screenId: 1,
			vfas: "OR1.jpg",
            zones: [1105]
        },
        {
            id: 30,
            name: "Preferred Orchestra",
            slug: "orchestra-2",
			screenId: 1,
			vfas: "OR2.jpg",
            zones: [1106]
		},
        {
            id: 40,
            name: "Premier Dress Circle",
            screenId: 2,
			slug: "dress-circle-1",
			vfas: "DC1.jpg",
            zones: [1108]
        },
        {
            id: 41,
            name: "Premier Mezzanine",
            slug: "mezzanine-1",
			screenId: 5,
			vfas: "MZ1.jpg",
            zones: [1112]
        },
        {
            id: 11,
            name: "Lower Loge",
            slug: "lower-loge",
			screenId: 8,
			vfas: "LLL.jpg",
            zones: [1111]
        },
        {
            id: 31,
            name: "Preferred Dress Circle",
            slug: "dress-circle-2",
			screenId: 2,
			vfas: "DC2.jpg",
            zones: [1109]
        },
        {
            id: 34,
            name: "Preferred Mezzanine",
            slug: "mezzanine-2",
			screenId: 5,
			vfas: "MZ2.jpg",
			zones: [1113]
		},
		{
			id: 39,
			name: "Select Orchestra",
			slug: "orchestra-3",
			screenId: 1,
			vfas: "OR3L.jpg",
			zones: [1107]
		},
		{
			id: 138,
			name: "Orchestra",
			slug: "orchestra-4",
			screenId: 1,
			vfas: "OR2.jpg",
			zones: [1205],
			optional: true
		},
        {
            id: 15,
            name: "Upper Loge",
            slug: "upper-loge",
			screenId: 7,
			vfas: "ULL.jpg",
            zones: [1115]
        },
        {
            id: 33,
            name: "Dress Circle",
            slug: "dress-circle-3",
			screenId: 2,
			vfas: "DC3L.jpg",
            zones: [1110]
        },
        {
            id: 36,
            name: "Mezzanine",
            slug: "mezzanine-3",
			screenId: 5,
			vfas: "MZ3L.jpg",
            zones: [1114]
        },
        {
            id: 42,
            name: "Premier Balcony",
            slug: "balcony-1",
			screenId: 4,
			vfas: "B1.jpg",
            zones: [1116]
        },
        {
            id: 43,
            name: "Preferred Balcony",
            slug: "balcony-2",
			screenId: 4,
			vfas: "B2.jpg",
            zones: [1117,1124]
        },
        {
            id: 44,
            name: "Balcony",
            slug: "balcony-3",
			screenId: 4,
			vfas: "B3L.jpg",
            zones: [1118]
        }
        ]
    };



    window.ZoneMapProvider.zoneMaps["234"] = {
        name: "Balboa Theatre",
        screens: {
            "6": "Orchestra",
            "8": "Rear Orchestra",
            "7": "Loge",
            "9": "Balcony"
        },
        sections: [
        {
            id: 104,
            name: "Orchestra 1",
            slug: "orchestra-1",
            screenId: 6,
            zones: [1003]
        },
        {
            id: 105,
            name: "Orchestra 2",
            slug: "orchestra-2",
            screenId: 6,
            zones: [1007]
        },
        {
            id: 106,
            name: "Orchestra 3",
            slug: "orchestra-3",
            screenId: 6,
            zones: [1000]
        },
        {
            id: 107,
            name: "Orchestra 4",
            slug: "orchestra-4",
            screenId: 8,
            zones: [1089]
        },
        {
            id: 108,
            name: "Orchestra 5",
            slug: "orchestra-5",
            screenId: 8,
            zones: [1001]
        },
        {
            id: 110,
            name: "Loge 1",
            slug: "loge-1",
            screenId: 7,
            zones: [1008]
        },
        {
            id: 109,
            name: "Loge 2",
            slug: "loge-2",
            screenId: 7,
            zones: [1002]
        },
        {
            id: 112,
            name: "Balcony 1",
            slug: "balcony-1",
            screenId: 9,
            zones: [1004]
        },
        {
            id: 111,
            name: "Balcony 2",
            slug: "balcony-2",
            screenId: 9,
            zones: [1005]
        }
        ]
	};

	window.ZoneMapProvider.zoneMaps["280"] = {
		name: "Balboa Theatre",
		screens: {
			"6": "Orchestra",
			"8": "Rear Orchestra",
			"7": "Loge",
			"9": "Balcony"
		},
		sections: [
			{
				id: 104,
				name: "Zone 1: OR1",
				slug: "orchestra-1",
				screenId: 6,
				vfas: "OR1.jpg",
				zones: [1187]
			},
			{
				id: 105,
				name: "Zone 2: OR2",
				slug: "orchestra-2",
				screenId: 6,
				vfas: "OR2.jpg",
				zones: [1187, 1188]
			},
			{
				id: 106,
				name: "Zone 3: OR3",
				slug: "orchestra-3",
				screenId: 6,
				vfas: "OR3.jpg",
				zones: [1189]
			},
			/*{
				id: 106,
				name: "Zone 4: BAL",
				slug: "orchestra-4",
				screenId: 8,
				vfas: "OR3.jpg",
				zones: [1104],
				optional: true
			},*/
			{
				id: 110,
				name: "Zone 1: L1",
				slug: "loge-1",
				screenId: 7,
				vfas: "L1.jpg",
				zones: [1191]
			},
			{
				id: 109,
				name: "Zone 2: L2",
				slug: "loge-2",
				screenId: 7,
				vfas: "L2_L.jpg",
				zones: [1187, 1192]
			},
			{
				id: 112,
				name: "Zone 4: B1",
				slug: "balcony-1",
				screenId: 9,
				vfas: "B1.jpg",
				zones: [1193]
			}
		]
	};

    window.ZoneMapProvider.zoneMaps["205"] = {
        name: "Copley Symphony Hall",
        sections: [
        {
            id: 76,
            name: "Main 1",
            screenId: 1,
            zones: [881]
        },
        {
            id: 79,
            name: "Grand Tier 1",
            screenId: 4,
            zones: [884]
        },
        {
            id: 77,
            name: "Main 2",
            screenId: 2,
            zones: [882]
        },
        {
            id: 102,
            name: "Grand Tier 2",
            screenId: 4,
            zones: [888]
        },
        {
            id: 78,
            name: "Main 3",
            screenId: 2,
            zones: [883]
        },
        {
            id: 103,
            name: "Grand Tier 3",
            screenId: 4,
            zones: [889]
        },
        {
            id: 101,
            name: "Main 4",
            screenId: 2,
            zones: [887]
        },
        {
            id: 80,
            name: "Mezzanine",
            screenId: 4,
            zones: [885]
        },
        {
            id: 81,
            name: "Balcony",
            screenId: 6,
            zones: [886]
        }
        ]
	};

	window.ZoneMapProvider.zoneMaps["245"] = {
		name: "Joan B Kroc Theatre",
		screens: {
			"1": "Orchestra"
		},
		sections: [
			{
				id: 7,
				name: "Zone 1: OR1",
				slug: "orchestra-1",
				screenId: 1,
				vfas: "OR1_L.jpg",
				zones: [1027]
			},
			{
				id: 105,
				name: "Zone 2: OR2",
				slug: "orchestra-2",
				screenId: 1,
				vfas: "OR2_L.jpg",
				zones: [1028]
			},
			{
				id: 39,
				name: "Zone 3: OR3",
				slug: "orchestra-3",
				screenId: 1,
				vfas: "OR3_L.jpg",
				zones: [1029]
			},
			{
				id: 107,
				name: "Zone 4: OR4",
				slug: "orchestra-4",
				screenId: 1,
				vfas: "OR4_C.jpg",
				zones: [1030]
			}
		]
	};

	window.ZoneMapProvider.zoneMaps["244"] = {
		name: "Lyceum Theater",
		screens: {
			"1": "Level 1"
		},
		sections: [
			{
				id: 29,
				name: "Zone 1: OR1",
				slug: "orchestra-1",
				screenId: 1,
				vfas: "OR1.jpg",
				zones: [1020]
			},
			{
				id: 30,
				name: "Zone 2: OR2",
				slug: "orchestra-2",
				screenId: 1,
				vfas: "OR2_L.jpg",
				zones: [1021]
			},
			{
				id: 41,
				name: "Zone 2: MZ1",
				slug: "mezzanine-1",
				screenId: 1,
				vfas: "MZ1_C.jpg",
				zones: [1022]
			},
			{
				id: 34,
				name: "Zone 3: MZ2",
				slug: "mezzanine-2",
				screenId: 1,
				vfas: "MZ2_L.jpg",
				zones: [1023]
			},
			{
				id: 36,
				name: "Zone 4: MZ3",
				slug: "mezzanine-3",
				screenId: 1,
				vfas: "MZ3_L.jpg",
				zones: [1024]
			}
		]
	};

    window.ZoneMapProvider.GetSections = function (zoneMap) {
        var zmap = window.ZoneMapProvider.zoneMaps[zoneMap + ""];
        return zmap != undefined ? zmap.sections : [];
    };

    window.ZoneMapProvider.GetScreenName = function (zoneMap, screenId) {
        var zmap = window.ZoneMapProvider.zoneMaps[zoneMap + ""];
        return zmap != undefined ? zmap.screens[screenId + ''] : "";
    };