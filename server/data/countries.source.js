/**
 * Curated source data for Classic (country) levels.
 *
 * This is the ONLY file you edit to add/remove countries. `scripts/build-seed.js`
 * expands each entry into a full level object (image URLs, credits, multiple-
 * choice options) and writes data/levels.seed.json.
 *
 * Images:
 *   - landmark[0] & landmark[1]  -> Wikimedia Commons (free media, credited to
 *     the Commons file page which carries the author + exact licence).
 *   - the flag                   -> flagcdn.com (public-domain flag imagery).
 *
 * If a Commons filename ever stops resolving, the app falls back to the country
 * flag automatically, and fixing it is a one-line change here (swap the `file`).
 */

/** @typedef {{ title: string, file: string }} Landmark */
/**
 * @typedef {Object} CountrySource
 * @property {string} name        Display name & correct answer
 * @property {string} iso2        ISO 3166-1 alpha-2 (lowercase) for the flag
 * @property {string} continent
 * @property {string} description Shown under the images
 * @property {string} funfact     Shown on the result screen
 * @property {[Landmark, Landmark]} landmarks  Two Wikimedia Commons images
 */

/** @type {CountrySource[]} */
export const countries = [
  // ----------------------------- EUROPE -----------------------------
  {
    name: 'France', iso2: 'fr', continent: 'Europe',
    description: 'A Western European nation famed for its art, cuisine, fashion and wine.',
    funfact: 'France is the most visited country in the world, drawing around 90 million tourists a year.',
    landmarks: [
      { title: 'Eiffel Tower, Paris', file: 'Eiffel_Tower_Paris.jpg' },
      { title: 'Louvre Museum, Paris', file: 'Louvre_Museum_Wikimedia_Commons.jpg' },
    ],
  },
  {
    name: 'Italy', iso2: 'it', continent: 'Europe',
    description: 'A Mediterranean country shaped like a boot, rich in history, art and food.',
    funfact: 'Italy is home to the most UNESCO World Heritage Sites of any country on Earth.',
    landmarks: [
      { title: 'Colosseum, Rome', file: 'Colosseum_in_Rome,_Italy_-_April_2007.jpg' },
      { title: 'Grand Canal, Venice', file: 'Canal_Grande_Chiesa_della_Salute_e_Punta_della_Dogana_Venezia.jpg' },
    ],
  },
  {
    name: 'Spain', iso2: 'es', continent: 'Europe',
    description: 'An Iberian country known for flamenco, beaches and bold architecture.',
    funfact: 'Spain has the second-highest number of UNESCO World Heritage Sites in the world.',
    landmarks: [
      { title: 'Sagrada Família, Barcelona', file: 'Sagrada_Familia_01.jpg' },
      { title: 'Alhambra, Granada', file: 'Vista_de_la_Alhambra.jpg' },
    ],
  },
  {
    name: 'Germany', iso2: 'de', continent: 'Europe',
    description: 'A Central European economic powerhouse of castles, forests and festivals.',
    funfact: 'Germany has over 1,500 varieties of beer and 20,000 castles.',
    landmarks: [
      { title: 'Brandenburg Gate, Berlin', file: 'Brandenburger_Tor_abends.jpg' },
      { title: 'Neuschwanstein Castle', file: 'Schloss_Neuschwanstein_2013.jpg' },
    ],
  },
  {
    name: 'United Kingdom', iso2: 'gb', continent: 'Europe',
    description: 'An island nation of rolling hills, historic cities and royal tradition.',
    funfact: 'The UK has no single written constitution — it relies on laws and conventions.',
    landmarks: [
      { title: 'Big Ben & Palace of Westminster, London', file: 'Palace_of_Westminster,_London_-_Feb_2007.jpg' },
      { title: 'Tower Bridge, London', file: 'Tower_Bridge_from_Shad_Thames.jpg' },
    ],
  },
  {
    name: 'Greece', iso2: 'gr', continent: 'Europe',
    description: 'The cradle of Western civilisation, with ancient ruins and whitewashed isles.',
    funfact: 'Greece has around 6,000 islands and islets, though only about 230 are inhabited.',
    landmarks: [
      { title: 'Acropolis, Athens', file: 'The_Parthenon_in_Athens.jpg' },
      { title: 'Santorini', file: 'Santorini_-_Oia_03.jpg' },
    ],
  },
  {
    name: 'Netherlands', iso2: 'nl', continent: 'Europe',
    description: 'A low-lying country of canals, windmills, tulips and bicycles.',
    funfact: 'About a quarter of the Netherlands lies below sea level.',
    landmarks: [
      { title: 'Amsterdam canals', file: 'KeizersgrachtReguliersgrachtAmsterdam.jpg' },
      { title: 'Dutch windmills, Kinderdijk', file: 'Kinderdijk_molens.jpg' },
    ],
  },
  {
    name: 'Portugal', iso2: 'pt', continent: 'Europe',
    description: 'Europe\'s westernmost country, known for seafaring history and azulejo tiles.',
    funfact: 'Portugal is one of the oldest nation-states in Europe, with borders largely unchanged since 1139.',
    landmarks: [
      { title: 'Belém Tower, Lisbon', file: 'Torre_de_Belém_Lisboa-1.jpg' },
      { title: 'Pena Palace, Sintra', file: 'Palacio_da_Pena.jpg' },
    ],
  },
  {
    name: 'Switzerland', iso2: 'ch', continent: 'Europe',
    description: 'An Alpine nation of snow-capped peaks, lakes, chocolate and watchmaking.',
    funfact: 'Switzerland has enough nuclear shelters to house its entire population.',
    landmarks: [
      { title: 'Matterhorn', file: 'Matterhorn_from_Domhütte_-_2.jpg' },
      { title: 'Chapel Bridge, Lucerne', file: 'Kapellbrücke_Luzern.jpg' },
    ],
  },
  {
    name: 'Norway', iso2: 'no', continent: 'Europe',
    description: 'A Scandinavian land of dramatic fjords, midnight sun and northern lights.',
    funfact: 'Norway introduced salmon sushi to Japan in the 1980s.',
    landmarks: [
      { title: 'Geirangerfjord', file: 'Geirangerfjord_(6-2007).jpg' },
      { title: 'Bryggen, Bergen', file: 'Bryggen_i_Bergen.jpg' },
    ],
  },
  {
    name: 'Sweden', iso2: 'se', continent: 'Europe',
    description: 'A Nordic country of forests, lakes, design and long summer days.',
    funfact: 'Sweden recycles so efficiently it imports rubbish from other countries to fuel power plants.',
    landmarks: [
      { title: 'Gamla Stan, Stockholm', file: 'Stockholm_Gamla_Stan.jpg' },
      { title: 'Stockholm City Hall', file: 'Stockholm_City_Hall_June_2012.jpg' },
    ],
  },
  {
    name: 'Austria', iso2: 'at', continent: 'Europe',
    description: 'An Alpine country of imperial palaces, classical music and ski slopes.',
    funfact: 'The world\'s oldest zoo still in operation is in Vienna, founded in 1752.',
    landmarks: [
      { title: 'Schönbrunn Palace, Vienna', file: 'Schloss_Schönbrunn_Wien_2014_(Zuschnitt_2).jpg' },
      { title: 'Hallstatt', file: 'Hallstatt_-_Zentrum_.JPG' },
    ],
  },
  {
    name: 'Ireland', iso2: 'ie', continent: 'Europe',
    description: 'The Emerald Isle, famed for green landscapes, cliffs and literary heritage.',
    funfact: 'Halloween originates from the ancient Irish festival of Samhain.',
    landmarks: [
      { title: 'Cliffs of Moher', file: 'Cliffs_of_Moher_2006.jpg' },
      { title: 'Rock of Cashel', file: 'Rock_of_Cashel.jpg' },
    ],
  },
  {
    name: 'Russia', iso2: 'ru', continent: 'Europe',
    description: 'The world\'s largest country, spanning Europe and Asia across 11 time zones.',
    funfact: 'Russia is so large it borders 14 countries and spans 11 time zones.',
    landmarks: [
      { title: "Saint Basil's Cathedral, Moscow", file: 'Saint_Basil\'s_Cathedral_in_Moscow.jpg' },
      { title: 'Winter Palace, Saint Petersburg', file: 'Panorámica_del_Palacio_de_Invierno,_San_Petersburgo,_Rusia,_2016-01-08,_DD_09.JPG' },
    ],
  },
  {
    name: 'Iceland', iso2: 'is', continent: 'Europe',
    description: 'A volcanic island of geysers, glaciers, waterfalls and hot springs.',
    funfact: 'Iceland runs almost entirely on renewable geothermal and hydro energy.',
    landmarks: [
      { title: 'Gullfoss waterfall', file: 'Gullfoss,_an_iconic_waterfall_of_Iceland.jpg' },
      { title: 'Hallgrímskirkja, Reykjavík', file: 'Hallgrímskirkja_20051001.jpg' },
    ],
  },

  // ------------------------------ ASIA ------------------------------
  {
    name: 'Japan', iso2: 'jp', continent: 'Asia',
    description: 'An East Asian archipelago blending ancient temples with neon megacities.',
    funfact: 'Japan has more than 5 million vending machines — roughly one for every 23 people.',
    landmarks: [
      { title: 'Mount Fuji', file: 'Mount_Fuji_from_Hotel_Mt_Fuji_1994-2-7.jpg' },
      { title: 'Fushimi Inari Shrine, Kyoto', file: 'Fushimi_Inari-taisha,_senbontorii.jpg' },
    ],
  },
  {
    name: 'China', iso2: 'cn', continent: 'Asia',
    description: 'A vast East Asian civilisation with millennia of history and dynamic cities.',
    funfact: 'The Great Wall of China is over 21,000 km long in total.',
    landmarks: [
      { title: 'Great Wall of China', file: 'The_Great_Wall_of_China_at_Jinshanling-edit.jpg' },
      { title: 'Forbidden City, Beijing', file: 'Forbidden_City_Beijing_Shenwumen_Gate.JPG' },
    ],
  },
  {
    name: 'India', iso2: 'in', continent: 'Asia',
    description: 'A South Asian subcontinent of extraordinary diversity, colour and spice.',
    funfact: 'India is home to the wettest inhabited place on Earth — Mawsynram.',
    landmarks: [
      { title: 'Taj Mahal, Agra', file: 'Taj_Mahal_(Edited).jpeg' },
      { title: 'Amber Fort, Jaipur', file: 'Amber_Fort_Jaipur.jpg' },
    ],
  },
  {
    name: 'Thailand', iso2: 'th', continent: 'Asia',
    description: 'A Southeast Asian kingdom of gilded temples, beaches and street food.',
    funfact: 'Bangkok\'s full ceremonial name is the longest city name in the world.',
    landmarks: [
      { title: 'Wat Arun, Bangkok', file: 'Wat_Arun_(Bangkok).jpg' },
      { title: 'Phi Phi Islands', file: 'Ko_Phi_Phi_Le.jpg' },
    ],
  },
  {
    name: 'Vietnam', iso2: 'vn', continent: 'Asia',
    description: 'A Southeast Asian country of limestone karsts, rice terraces and pho.',
    funfact: 'Vietnam is the world\'s second-largest exporter of coffee.',
    landmarks: [
      { title: 'Ha Long Bay', file: 'Halong_Bay,_Vietnam.jpg' },
      { title: 'Golden Bridge, Da Nang', file: 'Cầu_Vàng_-_Golden_Bridge.jpg' },
    ],
  },
  {
    name: 'South Korea', iso2: 'kr', continent: 'Asia',
    description: 'An East Asian nation fusing palaces and hanok villages with K-pop and tech.',
    funfact: 'South Korea has the fastest average internet speeds in the world.',
    landmarks: [
      { title: 'Gyeongbokgung Palace, Seoul', file: 'Korea-Seoul-Gyeongbokgung-Geunjeongjeon-01.jpg' },
      { title: 'Bukchon Hanok Village', file: 'Bukchon_Hanok_Village.jpg' },
    ],
  },
  {
    name: 'Indonesia', iso2: 'id', continent: 'Asia',
    description: 'The world\'s largest archipelago, with over 17,000 islands and active volcanoes.',
    funfact: 'Indonesia is made up of more than 17,000 islands.',
    landmarks: [
      { title: 'Borobudur Temple', file: 'Borobudur-Nothwest-view.jpg' },
      { title: 'Rice terraces, Bali', file: 'Tegallalang,_Bali.jpg' },
    ],
  },
  {
    name: 'Turkey', iso2: 'tr', continent: 'Asia',
    description: 'A transcontinental country bridging Europe and Asia across the Bosphorus.',
    funfact: 'Istanbul is the only major city in the world that straddles two continents.',
    landmarks: [
      { title: 'Hagia Sophia, Istanbul', file: 'Hagia_Sophia_Mars_2013.jpg' },
      { title: 'Cappadocia', file: 'Cappadocia_balloon_trip,_Göreme,_Nevşehir,_Turkey.jpg' },
    ],
  },
  {
    name: 'United Arab Emirates', iso2: 'ae', continent: 'Asia',
    description: 'A Gulf federation of futuristic skylines rising from the desert.',
    funfact: 'The Burj Khalifa in Dubai is the tallest building in the world at 828 metres.',
    landmarks: [
      { title: 'Burj Khalifa, Dubai', file: 'Burj_Khalifa.jpg' },
      { title: 'Sheikh Zayed Mosque, Abu Dhabi', file: 'Sheikh_Zayed_Mosque.jpg' },
    ],
  },
  {
    name: 'Nepal', iso2: 'np', continent: 'Asia',
    description: 'A Himalayan nation home to eight of the world\'s ten highest peaks.',
    funfact: 'Nepal\'s flag is the only national flag that is not rectangular.',
    landmarks: [
      { title: 'Mount Everest', file: 'Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg' },
      { title: 'Boudhanath Stupa, Kathmandu', file: 'Bodnath_Stupa.jpg' },
    ],
  },
  {
    name: 'Cambodia', iso2: 'kh', continent: 'Asia',
    description: 'A Southeast Asian kingdom defined by the vast temples of Angkor.',
    funfact: 'Angkor Wat is the largest religious monument in the world.',
    landmarks: [
      { title: 'Angkor Wat', file: 'Angkor_Wat.jpg' },
      { title: 'Bayon Temple faces', file: 'Bayon_Angkor_Relief1.jpg' },
    ],
  },
  {
    name: 'Malaysia', iso2: 'my', continent: 'Asia',
    description: 'A Southeast Asian country of rainforests, beaches and modern skylines.',
    funfact: 'The Petronas Towers were the tallest buildings in the world from 1998 to 2004.',
    landmarks: [
      { title: 'Petronas Towers, Kuala Lumpur', file: 'Petronas_Panorama_II.jpg' },
      { title: 'Batu Caves', file: 'Batu_Caves,_KL,_Malaysia.jpg' },
    ],
  },
  {
    name: 'Singapore', iso2: 'sg', continent: 'Asia',
    description: 'A city-state and global hub famed for gardens, food and skyline.',
    funfact: 'Singapore is one of only three surviving city-states in the world.',
    landmarks: [
      { title: 'Marina Bay Sands', file: 'Marina_Bay_Sands_in_the_evening_-_20101120.jpg' },
      { title: 'Gardens by the Bay Supertrees', file: 'Supertree_Grove,_Gardens_by_the_Bay,_Singapore_-_20120617.jpg' },
    ],
  },
  {
    name: 'Jordan', iso2: 'jo', continent: 'Asia',
    description: 'A Middle Eastern kingdom of desert canyons and ancient rock-cut cities.',
    funfact: 'Petra was carved into rose-red rock over 2,000 years ago by the Nabataeans.',
    landmarks: [
      { title: 'Petra Treasury', file: 'The_Treasury,_Petra_(5340588594).jpg' },
      { title: 'Wadi Rum desert', file: 'Wadi_Rum_1.jpg' },
    ],
  },
  {
    name: 'Israel', iso2: 'il', continent: 'Asia',
    description: 'A Middle Eastern country at the crossroads of major world religions.',
    funfact: 'The Dead Sea, on Israel\'s border, is the lowest point on Earth\'s land surface.',
    landmarks: [
      { title: 'Western Wall & Dome of the Rock, Jerusalem', file: 'Jerusalem_Dome_of_the_rock_BW_14.JPG' },
      { title: 'Masada', file: 'Israel-2013-Aerial_21-Masada.jpg' },
    ],
  },

  // ----------------------------- AFRICA -----------------------------
  {
    name: 'Egypt', iso2: 'eg', continent: 'Africa',
    description: 'A North African cradle of civilisation along the life-giving Nile.',
    funfact: 'The Great Pyramid of Giza is the only surviving wonder of the ancient world.',
    landmarks: [
      { title: 'Pyramids of Giza', file: 'Kheops-Pyramid.jpg' },
      { title: 'Great Sphinx of Giza', file: 'Great_Sphinx_of_Giza_-_20080716a.jpg' },
    ],
  },
  {
    name: 'South Africa', iso2: 'za', continent: 'Africa',
    description: 'A diverse nation at Africa\'s southern tip, the "Rainbow Nation".',
    funfact: 'South Africa has three capital cities: Pretoria, Cape Town and Bloemfontein.',
    landmarks: [
      { title: 'Table Mountain, Cape Town', file: 'Table_Mountain_DownUnder.jpg' },
      { title: 'Cape of Good Hope', file: 'Cape_of_Good_Hope.jpg' },
    ],
  },
  {
    name: 'Morocco', iso2: 'ma', continent: 'Africa',
    description: 'A North African country of medinas, deserts and the Atlas Mountains.',
    funfact: 'The University of al-Qarawiyyin in Fez is the oldest existing university in the world.',
    landmarks: [
      { title: 'Jemaa el-Fnaa, Marrakesh', file: 'Marrakech_-_Place_Jemaa_El_Fna.jpg' },
      { title: 'Chefchaouen blue city', file: 'Chefchaouen,_the_Blue_City.jpg' },
    ],
  },
  {
    name: 'Kenya', iso2: 'ke', continent: 'Africa',
    description: 'An East African country famed for safaris and the Great Rift Valley.',
    funfact: 'The Maasai Mara hosts the Great Migration of over a million wildebeest each year.',
    landmarks: [
      { title: 'Maasai Mara safari', file: 'Masai_Mara_at_Sunrise.jpg' },
      { title: 'Mount Kenya', file: 'Mount_Kenya.jpg' },
    ],
  },
  {
    name: 'Tanzania', iso2: 'tz', continent: 'Africa',
    description: 'An East African nation of Kilimanjaro, Serengeti plains and Zanzibar.',
    funfact: 'Mount Kilimanjaro is the highest free-standing mountain in the world.',
    landmarks: [
      { title: 'Mount Kilimanjaro', file: 'Mount_Kilimanjaro_Dec_2009_edit1.jpg' },
      { title: 'Serengeti plains', file: 'Serengeti_Lion_running_saturated.jpg' },
    ],
  },
  {
    name: 'Nigeria', iso2: 'ng', continent: 'Africa',
    description: 'West Africa\'s most populous nation and a cultural and economic giant.',
    funfact: 'Nigeria is the most populous country in Africa, with over 200 million people.',
    landmarks: [
      { title: 'Zuma Rock', file: 'Zuma_Rock.jpg' },
      { title: 'Lagos skyline', file: 'Lagos_Island_2.jpg' },
    ],
  },
  {
    name: 'Ethiopia', iso2: 'et', continent: 'Africa',
    description: 'An ancient highland nation, one of the oldest in the world.',
    funfact: 'Ethiopia follows a unique calendar that is about seven to eight years behind the Gregorian one.',
    landmarks: [
      { title: 'Rock-hewn churches of Lalibela', file: 'Bete_Giyorgis_01.jpg' },
      { title: 'Simien Mountains', file: 'Simien_Mountains_National_Park.jpg' },
    ],
  },
  {
    name: 'Ghana', iso2: 'gh', continent: 'Africa',
    description: 'A West African country known for gold, cocoa and warm hospitality.',
    funfact: 'Ghana was the first sub-Saharan African country to gain independence, in 1957.',
    landmarks: [
      { title: 'Cape Coast Castle', file: 'Cape_Coast_Castle.jpg' },
      { title: 'Kakum canopy walk', file: 'Kakum_National_Park_canopy_walkway.jpg' },
    ],
  },
  {
    name: 'Namibia', iso2: 'na', continent: 'Africa',
    description: 'A southern African land of towering red dunes and desert wildlife.',
    funfact: 'Namibia\'s Sossusvlei is home to some of the tallest sand dunes on Earth.',
    landmarks: [
      { title: 'Sossusvlei dunes', file: 'Dune_in_Sossusvlei,_Namibia.jpg' },
      { title: 'Deadvlei', file: 'Deadvlei,_Namib-Naukluft_National_Park,_Namibia.jpg' },
    ],
  },
  {
    name: 'Madagascar', iso2: 'mg', continent: 'Africa',
    description: 'A vast Indian Ocean island with wildlife found nowhere else on Earth.',
    funfact: 'Around 90% of Madagascar\'s wildlife is found nowhere else on Earth.',
    landmarks: [
      { title: 'Avenue of the Baobabs', file: 'Baobab_Avenue,_Madagascar.jpg' },
      { title: 'Tsingy de Bemaraha', file: 'Tsingy_de_Bemaraha.jpg' },
    ],
  },

  // ------------------------- NORTH AMERICA --------------------------
  {
    name: 'United States', iso2: 'us', continent: 'North America',
    description: 'A continent-spanning nation of varied landscapes and global cities.',
    funfact: 'The US has no official national language at the federal level.',
    landmarks: [
      { title: 'Statue of Liberty, New York', file: 'Statue_of_Liberty_7.jpg' },
      { title: 'Grand Canyon', file: 'Grand_Canyon_view_from_Pima_Point_2010.jpg' },
    ],
  },
  {
    name: 'Canada', iso2: 'ca', continent: 'North America',
    description: 'The world\'s second-largest country, of vast wilderness and friendly cities.',
    funfact: 'Canada has more lakes than the rest of the world\'s lakes combined.',
    landmarks: [
      { title: 'Moraine Lake, Banff', file: 'Moraine_Lake_17092005.jpg' },
      { title: 'CN Tower, Toronto', file: 'Toronto_-_ON_-_Toronto_Harbourfront7.jpg' },
    ],
  },
  {
    name: 'Mexico', iso2: 'mx', continent: 'North America',
    description: 'A vibrant country of ancient pyramids, beaches and rich cuisine.',
    funfact: 'Mexico introduced chocolate, chillies and corn to the rest of the world.',
    landmarks: [
      { title: 'Chichén Itzá', file: 'Chichen_Itza_3.jpg' },
      { title: 'Teotihuacan Pyramids', file: 'Teotihuacan-Sun-Pyramid.jpg' },
    ],
  },
  {
    name: 'Cuba', iso2: 'cu', continent: 'North America',
    description: 'A Caribbean island of colourful old towns, vintage cars and music.',
    funfact: 'Classic 1950s American cars still fill the streets of Havana.',
    landmarks: [
      { title: 'Old Havana', file: 'La_Habana_Vieja,_Cuba.jpg' },
      { title: 'El Capitolio, Havana', file: 'Capitolio_de_La_Habana.jpg' },
    ],
  },
  {
    name: 'Jamaica', iso2: 'jm', continent: 'North America',
    description: 'A Caribbean island, birthplace of reggae and lush tropical scenery.',
    funfact: 'Jamaica was the first Caribbean country to gain independence, in 1962.',
    landmarks: [
      { title: 'Dunn\'s River Falls', file: 'Dunns_River_Falls.jpg' },
      { title: 'Blue Mountains', file: 'Blue_Mountains_Jamaica.jpg' },
    ],
  },
  {
    name: 'Guatemala', iso2: 'gt', continent: 'North America',
    description: 'A Central American country of Mayan ruins, volcanoes and colonial towns.',
    funfact: 'The quetzal, Guatemala\'s national bird, also lends its name to the currency.',
    landmarks: [
      { title: 'Tikal Mayan ruins', file: 'Tikal_Temple1_2006_08_11.JPG' },
      { title: 'Antigua Guatemala', file: 'Antigua_Guatemala_1.JPG' },
    ],
  },

  // ------------------------- SOUTH AMERICA --------------------------
  {
    name: 'Brazil', iso2: 'br', continent: 'South America',
    description: 'South America\'s largest country, home to the Amazon and Carnival.',
    funfact: 'The Amazon rainforest produces about 20% of the world\'s oxygen.',
    landmarks: [
      { title: 'Christ the Redeemer, Rio de Janeiro', file: 'Cristo_Redentor_-_Rio_de_Janeiro,_Brasil.jpg' },
      { title: 'Sugarloaf Mountain, Rio', file: 'Pão_de_Açúcar_visto_do_Corcovado.jpg' },
    ],
  },
  {
    name: 'Argentina', iso2: 'ar', continent: 'South America',
    description: 'A land of tango, beef, the pampas and the peaks of Patagonia.',
    funfact: 'Argentina is home to both the highest and lowest points in the Southern Hemisphere.',
    landmarks: [
      { title: 'Perito Moreno Glacier', file: 'Perito_Moreno_Glacier_Patagonia_Argentina_Luca_Galuzzi_2005.JPG' },
      { title: 'Iguazú Falls', file: 'Iguazu_Falls.jpg' },
    ],
  },
  {
    name: 'Peru', iso2: 'pe', continent: 'South America',
    description: 'An Andean country of Incan heritage, high peaks and ancient trails.',
    funfact: 'Peru has more than 3,000 varieties of potato.',
    landmarks: [
      { title: 'Machu Picchu', file: 'Machu_Picchu,_Peru.jpg' },
      { title: 'Rainbow Mountain (Vinicunca)', file: 'Vinicunca_-_Rainbow_Mountain.jpg' },
    ],
  },
  {
    name: 'Chile', iso2: 'cl', continent: 'South America',
    description: 'A long, narrow country stretching from desert to Antarctic fjords.',
    funfact: 'The Atacama Desert in Chile is the driest non-polar desert on Earth.',
    landmarks: [
      { title: 'Torres del Paine', file: 'Cuernos_del_Paine_from_Lake_Pehoé.jpg' },
      { title: 'Moai of Easter Island', file: 'Moai_Rano_raraku.jpg' },
    ],
  },
  {
    name: 'Colombia', iso2: 'co', continent: 'South America',
    description: 'A country of Caribbean coasts, coffee highlands and colourful cities.',
    funfact: 'Colombia is the only South American country with coastlines on both the Pacific and the Caribbean.',
    landmarks: [
      { title: 'Cartagena old city', file: 'Cartagena_de_Indias_-_Ciudad_amurallada.jpg' },
      { title: 'Caño Cristales river', file: 'Caño_Cristales.jpg' },
    ],
  },
  {
    name: 'Bolivia', iso2: 'bo', continent: 'South America',
    description: 'A high-altitude country of salt flats, altiplano and Andean culture.',
    funfact: 'The Salar de Uyuni is the largest salt flat in the world, mirroring the sky when wet.',
    landmarks: [
      { title: 'Salar de Uyuni salt flat', file: 'Salar_de_Uyuni,_Bolivia.jpg' },
      { title: 'Lake Titicaca', file: 'Lake_Titicaca_on_the_Andes_from_Bolivia.jpg' },
    ],
  },
  {
    name: 'Ecuador', iso2: 'ec', continent: 'South America',
    description: 'An equatorial country spanning Andes, Amazon and the Galápagos.',
    funfact: 'Ecuador is named after the equator, which runs right through it.',
    landmarks: [
      { title: 'Quito historic centre', file: 'Centro_Histórico_de_Quito_pichincha_ecuador.jpg' },
      { title: 'Galápagos wildlife', file: 'Galápagos_giant_tortoise.jpg' },
    ],
  },
  {
    name: 'Venezuela', iso2: 've', continent: 'South America',
    description: 'A country of Caribbean coast, vast plains and the world\'s tallest waterfall.',
    funfact: 'Angel Falls in Venezuela is the world\'s tallest uninterrupted waterfall at 979 m.',
    landmarks: [
      { title: 'Angel Falls', file: 'Angel_Falls.jpg' },
      { title: 'Roraima tepui', file: 'Mount_Roraima.jpg' },
    ],
  },

  // ----------------------------- OCEANIA ----------------------------
  {
    name: 'Australia', iso2: 'au', continent: 'Oceania',
    description: 'An island continent of outback, reefs and laid-back coastal cities.',
    funfact: 'Australia is home to the Great Barrier Reef, the largest living structure on Earth.',
    landmarks: [
      { title: 'Sydney Opera House', file: 'Sydney_Opera_House_-_Dec_2008.jpg' },
      { title: 'Uluru (Ayers Rock)', file: 'Uluru,_helicopter_view,_cropped.jpg' },
    ],
  },
  {
    name: 'New Zealand', iso2: 'nz', continent: 'Oceania',
    description: 'A Pacific nation of fjords, volcanoes, glaciers and rolling green hills.',
    funfact: 'New Zealand has around six times as many sheep as people.',
    landmarks: [
      { title: 'Milford Sound', file: 'Milford_Sound_(Piopiotahi).jpg' },
      { title: 'Lake Tekapo & Mount Cook', file: 'Church_of_the_Good_Shepherd,_Lake_Tekapo.jpg' },
    ],
  },
  {
    name: 'Fiji', iso2: 'fj', continent: 'Oceania',
    description: 'A South Pacific archipelago of coral reefs, palm beaches and lagoons.',
    funfact: 'Fiji is made up of more than 330 islands, about a third of them inhabited.',
    landmarks: [
      { title: 'Fiji islands and lagoon', file: 'Fiji_beach.jpg' },
      { title: 'Mamanuca Islands', file: 'Mamanuca_Islands,_Fiji.jpg' },
    ],
  },
  {
    name: 'Papua New Guinea', iso2: 'pg', continent: 'Oceania',
    description: 'A rugged Pacific nation of rainforests and extraordinary cultural diversity.',
    funfact: 'Papua New Guinea has over 800 languages — the most of any country.',
    landmarks: [
      { title: 'Highlands cultural dress', file: 'Huli_Wigman_PNG.jpg' },
      { title: 'Kokoda rainforest', file: 'Kokoda_Track.jpg' },
    ],
  },
  {
    name: 'Samoa', iso2: 'ws', continent: 'Oceania',
    description: 'A Polynesian island nation of waterfalls, lava fields and ocean trenches.',
    funfact: 'Samoa skipped December 30, 2011 entirely to switch sides of the international date line.',
    landmarks: [
      { title: 'To Sua Ocean Trench', file: 'To_Sua_Ocean_Trench.jpg' },
      { title: 'Lalomanu Beach', file: 'Lalomanu_Beach,_Samoa.jpg' },
    ],
  },
  {
    name: 'Vanuatu', iso2: 'vu', continent: 'Oceania',
    description: 'A South Pacific archipelago of active volcanoes and blue holes.',
    funfact: 'Vanuatu\'s Mount Yasur is one of the world\'s most accessible active volcanoes.',
    landmarks: [
      { title: 'Mount Yasur volcano', file: 'Mt_Yasur_Volcano.jpg' },
      { title: 'Vanuatu blue hole', file: 'Nanda_Blue_Hole,_Espiritu_Santo,_Vanuatu.jpg' },
    ],
  },
];
