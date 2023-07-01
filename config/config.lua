Config = {};

-- Configuration --

Config.Tattoostudios = {
    Type = 'Tattoostudio',
    Blip = {
        sprite = 75,
        color = 1,
        scale = 0.5,
        label = 'Tattoo Studio'
    },

    Locations = {
        [1] = { coords = vec4(1321.6733, -1655.234, 52.277172, 220.0) },
        [2] = { coords = vec4(-1155.334, -1428.770, 4.9559621, 35.00) },
        [3] = { coords = vec4(325.86343, 181.25825, 103.58799, 340.0) },
        [4] = { coords = vec4(-3170.430, 1078.7686, 20.830646, 64.00) },
        [5] = { coords = vec4(1865.8266, 3746.7917, 33.029373, 300.0) },
        [6] = { coords = vec4(-295.7279, 6200.4238, 31.488298, 315.0) }
    }
};

Config.Barbershops = {
    Type = 'Barbershop',
    Blip = {
        sprite = 71,
        color = 17,
        scale = 0.5,
        label = 'Barbershop'
    },

    Locations = {
        [1] = { coords = vec4(1212.6284, -473.3526, 66.208244, 255.0)},
        [2] = { coords = vec4(138.10140, -1707.472, 29.291860, 140.0)},
        [3] = { coords = vec4(-1281.616, -1117.704, 6.9903578, 90.00)},
        [4] = { coords = vec4(1931.4611, 3731.4755, 32.844650, 210.0)},
        [5] = { coords = vec4(-33.71763, -153.3233, 57.076793, 340.0)},
        [6] = { coords = vec4(-277.7628, 6227.2456, 31.695775, 45.00)},
        [7] = { coords = vec4(-814.3340, -183.7920, 37.568881, 120.0), size = vec3(8, 10, 3) }
    }
};

Config.Clotheshops = {
    Type = 'Clotheshop',
    Blip = {
        sprite = 366,
        color = 2,
        scale = 0.5,
        label = 'Clotheshop'
    },

    Locations = {
        [1] = { coords = vec4(-163.8151, -303.1322, 39.733325, 250.0), type = 'Ponsonbys' },
        [2] = { coords = vec4(-709.8834, -152.5524, 37.415187, 125.0), type = 'Ponsonbys' },
        [3] = { coords = vec4(-1450.074, -237.5210, 49.811084, 45.00), type = 'Ponsonbys' },

        [4] = { coords = vec4(617.14080, 2758.8730, 42.088264, 185.0), type = 'Suburban' },
        [5] = { coords = vec4(-3171.431, 1048.8194, 20.863365, 335.0), type = 'Suburban' },
        [6] = { coords = vec4(-1194.987, -773.0936, 17.324033, 127.0), type = 'Suburban' },
        [7] = { coords = vec4(124.51161, -219.4961, 54.557712, 340.0), type = 'Suburban' },

        [8] = { coords = vec4(423.31961, -804.1683, 29.493425, 180.0), type = 'Binco' },
        [9] = { coords = vec4(77.618392, -1394.952, 29.378429, 360.0), type = 'Binco' },
        [10] = { coords = vec4(-1101.496, 2707.5083, 19.110174, 310.0), type = 'Binco' },
        [11] = { coords = vec4(1194.5809, 2708.0078, 38.224948, 270.0), type = 'Binco' },
        [12] = { coords = vec4(-823.0214, -1076.487, 11.330414, 300.0), type = 'Binco' },
        [13] = { coords = vec4(4.8262758, 6515.4531, 31.880130, 130.0), type = 'Binco' },
        [14] = { coords = vec4(1691.3988, 4824.5742, 42.065441, 185.0), type = 'Binco' }
    }
};