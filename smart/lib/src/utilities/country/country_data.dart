import 'country.dart';

/// {@template country_data}
/// A class that provides access to country data.
/// 
/// This class is **not meant to be instantiated** and should be accessed statically.
/// 
/// {@endtemplate}
class CountryData {
  CountryData._();

  /// The singleton instance of [CountryData].
  /// 
  /// {@macro country_data}
  static CountryData instance = CountryData._();

  String _image(String code) {
    return "https://chxpalpeslofqzeulcjr.supabase.co/storage/v1/object/public/flags/${code.toLowerCase()}.png";
  }

  /// List of all available countries
  /// 
  /// {@macro country_data}
  List<Country> get countries => [
        afghanistan,
        alandIslands,
        albania,
        algeria,
        americanSamoa,
        andorra,
        angola,
        anguilla,
        antarctica,
        antiguaAndBarbuda,
        argentina,
        armenia,
        aruba,
        australia,
        austria,
        azerbaijan,
        bahamas,
        bahrain,
        bangladesh,
        barbados,
        belarus,
        belgium,
        belize,
        benin,
        bermuda,
        bhutan,
        bolivia,
        bosniaAndHerzegovina,
        botswana,
        bouvetIsland,
        brazil,
        britishIndianOceanTerritory,
        bruneiDarussalam,
        bulgaria,
        burkinaFaso,
        burundi,
        cambodia,
        cameroon,
        canada,
        capeVerde,
        caymanIslands,
        centralAfricanRepublic,
        chad,
        chile,
        china,
        christmasIsland,
        cocosIslands,
        colombia,
        comoros,
        congo,
        democraticRepublicOfCongo,
        cookIslands,
        costaRica,
        coteDivoire,
        croatia,
        cuba,
        cyprus,
        czechRepublic,
        denmark,
        djibouti,
        dominica,
        dominicanRepublic,
        ecuador,
        egypt,
        elSalvador,
        equatorialGuinea,
        eritrea,
        estonia,
        ethiopia,
        falklandIslands,
        faroeIslands,
        fiji,
        finland,
        france,
        frenchGuiana,
        frenchPolynesia,
        frenchSouthernTerritories,
        gabon,
        gambia,
        georgia,
        germany,
        ghana,
        gibraltar,
        greece,
        greenland,
        grenada,
        guadeloupe,
        guam,
        guatemala,
        guernsey,
        guinea,
        guineaBissau,
        guyana,
        haiti,
        heardIsland,
        holySeeCityVatican,
        honduras,
        hongKong,
        hungary,
        iceland,
        india,
        indonesia,
        iran,
        iraq,
        ireland,
        isleOfMan,
        israel,
        italy,
        jamaica,
        japan,
        jersey,
        jordan,
        kazakhstan,
        kenya,
        kiribati,
        northKorea,
        southKorea,
        kuwait,
        kyrgyzstan,
        laos,
        latvia,
        lebanon,
        lesotho,
        liberia,
        libya,
        liechtenstein,
        lithuania,
        luxembourg,
        macao,
        macedonia,
        madagascar,
        malawi,
        malaysia,
        maldives,
        mali,
        malta,
        marshallIslands,
        martinique,
        mauritania,
        mauritius,
        mayotte,
        mexico,
        micronesia,
        moldova,
        monaco,
        mongolia,
        montenegro,
        montserrat,
        morocco,
        mozambique,
        myanmar,
        namibia,
        nauru,
        nepal,
        netherlands,
        newCaledonia,
        newZealand,
        nicaragua,
        niger,
        nigeria,
        niue,
        norfolkIsland,
        northernMarianaIslands,
        norway,
        oman,
        pakistan,
        palau,
        palestine,
        panama,
        papuaNewGuinea,
        paraguay,
        peru,
        philippines,
        pitcairn,
        poland,
        portugal,
        puertoRico,
        qatar,
        reunion,
        romania,
        russia,
        rwanda,
        saintBarthelemy,
        saintHelena,
        saintKittsAndNevis,
        saintLucia,
        saintMartin,
        saintPierreAndMiquelon,
        saintVincentAndGrenadines,
        samoa,
        sanMarino,
        saoTomeAndPrincipe,
        saudiArabia,
        senegal,
        serbia,
        seychelles,
        sierraLeone,
        singapore,
        sintMaarten,
        slovakia,
        slovenia,
        solomonIslands,
        somalia,
        southAfrica,
        southGeorgia,
        southSudan,
        spain,
        sriLanka,
        sudan,
        suriname,
        svalbardAndJanMayen,
        swaziland,
        sweden,
        switzerland,
        syria,
        taiwan,
        tajikistan,
        tanzania,
        thailand,
        timorLeste,
        togo,
        tokelau,
        tonga,
        trinidadAndTobago,
        tunisia,
        turkey,
        turkmenistan,
        turksAndCaicosIslands,
        tuvalu,
        uganda,
        ukraine,
        unitedArabEmirates,
        unitedKingdom,
        unitedStates,
        uruguay,
        uzbekistan,
        vanuatu,
        venezuela,
        vietnam,
        wallisAndFutuna,
        westernSahara,
        yemen,
        zambia,
        zimbabwe,
  ];

  /// Country details for `AFGHANISTAN`
  Country get afghanistan {
    String code = "AF";
    return Country(
        name: "Afghanistan",
        flag: "🇦🇫",
        code: code,
        dialCode: "93",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `ÅLAND ISLANDS`
  Country get alandIslands {
    String code = "AX";
    return Country(
        name: "Åland Islands",
        flag: "🇦🇽",
        code: code,
        dialCode: "358",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `ALBANIA`
  Country get albania {
    String code = "AL";
    return Country(
        name: "Albania",
        flag: "🇦🇱",
        code: code,
        dialCode: "355",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `ALGERIA`
  Country get algeria {
    String code = "DZ";
    return Country(
        name: "Algeria",
        flag: "🇩🇿",
        code: code,
        dialCode: "213",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `AMERICAN SAMOA`
  Country get americanSamoa {
    String code = "AS";
    return Country(
        name: "American Samoa",
        flag: "🇦🇸",
        code: code,
        dialCode: "1684",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `ANDORRA`
  Country get andorra {
    String code = "AD";
    return Country(
        name: "Andorra",
        flag: "🇦🇩",
        code: code,
        dialCode: "376",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `ANGOLA`
  Country get angola {
    String code = "AO";
    return Country(
        name: "Angola",
        flag: "🇦🇴",
        code: code,
        dialCode: "244",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `ANGUILLA`
  Country get anguilla {
    String code = "AI";
    return Country(
        name: "Anguilla",
        flag: "🇦🇮",
        code: code,
        dialCode: "1264",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `ANTARCTICA`
  Country get antarctica {
    String code = "AQ";
    return Country(
        name: "Antarctica",
        flag: "🇦🇶",
        code: code,
        dialCode: "672",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `ANTIGUA AND BARBUDA`
  Country get antiguaAndBarbuda {
    String code = "AG";
    return Country(
        name: "Antigua and Barbuda",
        flag: "🇦🇬",
        code: code,
        dialCode: "1268",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `ARGENTINA`
  Country get argentina {
    String code = "AR";
    return Country(
        name: "Argentina",
        flag: "🇦🇷",
        code: code,
        dialCode: "54",
        min: 12,
        max: 12,
        image: _image(code)
    );
  }

  /// Country details for `ARMENIA`
  Country get armenia {
    String code = "AM";
    return Country(
        name: "Armenia",
        flag: "🇦🇲",
        code: code,
        dialCode: "374",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `ARUBA`
  Country get aruba {
    String code = "AW";
    return Country(
        name: "Aruba",
        flag: "🇦🇼",
        code: code,
        dialCode: "297",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `AUSTRALIA`
  Country get australia {
    String code = "AU";
    return Country(
        name: "Australia",
        flag: "🇦🇺",
        code: code,
        dialCode: "61",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `AUSTRIA`
  Country get austria {
    String code = "AT";
    return Country(
        name: "Austria",
        flag: "🇦🇹",
        code: code,
        dialCode: "43",
        min: 13,
        max: 13,
        image: _image(code)
    );
  }

  /// Country details for `AZERBAIJAN`
  Country get azerbaijan {
    String code = "AZ";
    return Country(
        name: "Azerbaijan",
        flag: "🇦🇿",
        code: code,
        dialCode: "994",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `BAHAMAS`
  Country get bahamas {
    String code = "BS";
    return Country(
        name: "Bahamas",
        flag: "🇧🇸",
        code: code,
        dialCode: "1242",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `BAHRAIN`
  Country get bahrain {
    String code = "BH";
    return Country(
        name: "Bahrain",
        flag: "🇧🇭",
        code: code,
        dialCode: "973",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `BANGLADESH`
  Country get bangladesh {
    String code = "BD";
    return Country(
        name: "Bangladesh",
        flag: "🇧🇩",
        code: code,
        dialCode: "880",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `BARBADOS`
  Country get barbados {
    String code = "BB";
    return Country(
        name: "Barbados",
        flag: "🇧🇧",
        code: code,
        dialCode: "1246",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `BELARUS`
  Country get belarus {
    String code = "BY";
    return Country(
        name: "Belarus",
        flag: "🇧🇾",
        code: code,
        dialCode: "375",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `BELGIUM`
  Country get belgium {
    String code = "BE";
    return Country(
        name: "Belgium",
        flag: "🇧🇪",
        code: code,
        dialCode: "32",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `BELIZE`
  Country get belize {
    String code = "BZ";
    return Country(
        name: "Belize",
        flag: "🇧🇿",
        code: code,
        dialCode: "501",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `BENIN`
  Country get benin {
    String code = "BJ";
    return Country(
        name: "Benin",
        flag: "🇧🇯",
        code: code,
        dialCode: "229",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `BERMUDA`
  Country get bermuda {
    String code = "BM";
    return Country(
        name: "Bermuda",
        flag: "🇧🇲",
        code: code,
        dialCode: "1441",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `BHUTAN`
  Country get bhutan {
    String code = "BT";
    return Country(
        name: "Bhutan",
        flag: "🇧🇹",
        code: code,
        dialCode: "975",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `BOLIVIA`
  Country get bolivia {
    String code = "BO";
    return Country(
        name: "Bolivia (Plurinational State of Bolivia)",
        flag: "🇧🇴",
        code: code,
        dialCode: "591",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `BOSNIA AND HERZEGOVINA`
  Country get bosniaAndHerzegovina {
    String code = "BA";
    return Country(
        name: "Bosnia and Herzegovina",
        flag: "🇧🇦",
        code: code,
        dialCode: "387",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `BOTSWANA`
  Country get botswana {
    String code = "BW";
    return Country(
        name: "Botswana",
        flag: "🇧🇼",
        code: code,
        dialCode: "267",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `BOUVET ISLAND`
  Country get bouvetIsland {
    String code = "BV";
    return Country(
        name: "Bouvet Island",
        flag: "🇧🇻",
        code: code,
        dialCode: "47",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `BRAZIL`
  Country get brazil {
    String code = "BR";
    return Country(
        name: "Brazil",
        flag: "🇧🇷",
        code: code,
        dialCode: "55",
        min: 11,
        max: 11,
        image: _image(code)
    );
  }

  /// Country details for `BRITISH INDIAN OCEAN TERRITORY`
  Country get britishIndianOceanTerritory {
    String code = "IO";
    return Country(
        name: "British Indian Ocean Territory",
        flag: "🇮🇴",
        code: code,
        dialCode: "246",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `BRUNEI DARUSSALAM`
  Country get bruneiDarussalam {
    String code = "BN";
    return Country(
        name: "Brunei Darussalam",
        flag: "🇧🇳",
        code: code,
        dialCode: "673",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `BULGARIA`
  Country get bulgaria {
    String code = "BG";
    return Country(
        name: "Bulgaria",
        flag: "🇧🇬",
        code: code,
        dialCode: "359",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `BURKINA FASO`
  Country get burkinaFaso {
    String code = "BF";
    return Country(
        name: "Burkina Faso",
        flag: "🇧🇫",
        code: code,
        dialCode: "226",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `BURUNDI`
  Country get burundi {
    String code = "BI";
    return Country(
        name: "Burundi",
        flag: "🇧🇮",
        code: code,
        dialCode: "257",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `CAMBODIA`
  Country get cambodia {
    String code = "KH";
    return Country(
        name: "Cambodia",
        flag: "🇰🇭",
        code: code,
        dialCode: "855",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `CAMEROON`
  Country get cameroon {
    String code = "CM";
    return Country(
        name: "Cameroon",
        flag: "🇨🇲",
        code: code,
        dialCode: "237",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `CANADA`
  Country get canada {
    String code = "CA";
    return Country(
        name: "Canada",
        flag: "🇨🇦",
        code: code,
        dialCode: "1",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `CAPE VERDE`
  Country get capeVerde {
    String code = "CV";
    return Country(
        name: "Cape Verde",
        flag: "🇨🇻",
        code: code,
        dialCode: "238",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `CAYMAN ISLANDS`
  Country get caymanIslands {
    String code = "KY";
    return Country(
        name: "Cayman Islands",
        flag: "🇰🇾",
        code: code,
        dialCode: "345",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `CENTRAL AFRICAN REPUBLIC`
  Country get centralAfricanRepublic {
    String code = "CF";
    return Country(
        name: "Central African Republic",
        flag: "🇨🇫",
        code: code,
        dialCode: "236",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `CHAD`
  Country get chad {
    String code = "TD";
    return Country(
        name: "Chad",
        flag: "🇹🇩",
        code: code,
        dialCode: "235",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `CHILE`
  Country get chile {
    String code = "CL";
    return Country(
        name: "Chile",
        flag: "🇨🇱",
        code: code,
        dialCode: "56",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `CHINA`
  Country get china {
    String code = "CN";
    return Country(
        name: "China",
        flag: "🇨🇳",
        code: code,
        dialCode: "86",
        min: 12,
        max: 12,
        image: _image(code)
    );
  }

  /// Country details for `CHRISTMAS ISLAND`
  Country get christmasIsland {
    String code = "CX";
    return Country(
        name: "Christmas Island",
        flag: "🇨🇽",
        code: code,
        dialCode: "61",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `COCOS (KEELING) ISLANDS`
  Country get cocosIslands {
    String code = "CC";
    return Country(
        name: "Cocos (Keeling) Islands",
        flag: "🇨🇨",
        code: code,
        dialCode: "61",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `COLOMBIA`
  Country get colombia {
    String code = "CO";
    return Country(
        name: "Colombia",
        flag: "🇨🇴",
        code: code,
        dialCode: "57",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `COMOROS`
  Country get comoros {
    String code = "KM";
    return Country(
        name: "Comoros",
        flag: "🇰🇲",
        code: code,
        dialCode: "269",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `CONGO`
  Country get congo {
    String code = "CG";
    return Country(
        name: "Congo",
        flag: "🇨🇬",
        code: code,
        dialCode: "242",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `DEMOCRATIC REPUBLIC OF THE CONGO`
  Country get democraticRepublicOfCongo {
    String code = "CD";
    return Country(
        name: "Congo (The Democratic Republic of the Congo)",
        flag: "🇨🇩",
        code: code,
        dialCode: "243",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `COOK ISLANDS`
  Country get cookIslands {
    String code = "CK";
    return Country(
        name: "Cook Islands",
        flag: "🇨🇰",
        code: code,
        dialCode: "682",
        min: 5,
        max: 5,
        image: _image(code)
    );
  }

  /// Country details for `COSTA RICA`
  Country get costaRica {
    String code = "CR";
    return Country(
        name: "Costa Rica",
        flag: "🇨🇷",
        code: code,
        dialCode: "506",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `CÔTE D'IVOIRE`
  Country get coteDivoire {
    String code = "CI";
    return Country(
        name: "Côte d'Ivoire",
        flag: "🇨🇮",
        code: code,
        dialCode: "225",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `CROATIA`
  Country get croatia {
    String code = "HR";
    return Country(
        name: "Croatia",
        flag: "🇭🇷",
        code: code,
        dialCode: "385",
        min: 12,
        max: 12,
        image: _image(code)
    );
  }

  /// Country details for `CUBA`
  Country get cuba {
    String code = "CU";
    return Country(
        name: "Cuba",
        flag: "🇨🇺",
        code: code,
        dialCode: "53",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `CYPRUS`
  Country get cyprus {
    String code = "CY";
    return Country(
        name: "Cyprus",
        flag: "🇨🇾",
        code: code,
        dialCode: "357",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `CZECH REPUBLIC`
  Country get czechRepublic {
    String code = "CZ";
    return Country(
        name: "Czech Republic",
        flag: "🇨🇿",
        code: code,
        dialCode: "420",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `DENMARK`
  Country get denmark {
    String code = "DK";
    return Country(
        name: "Denmark",
        flag: "🇩🇰",
        code: code,
        dialCode: "45",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `DJIBOUTI`
  Country get djibouti {
    String code = "DJ";
    return Country(
        name: "Djibouti",
        flag: "🇩🇯",
        code: code,
        dialCode: "253",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `DOMINICA`
  Country get dominica {
    String code = "DM";
    return Country(
        name: "Dominica",
        flag: "🇩🇲",
        code: code,
        dialCode: "1767",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `DOMINICAN REPUBLIC`
  Country get dominicanRepublic {
    String code = "DO";
    return Country(
        name: "Dominican Republic",
        flag: "🇩🇴",
        code: code,
        dialCode: "1849",
        min: 12,
        max: 12,
        image: _image(code)
    );
  }

  /// Country details for `ECUADOR`
  Country get ecuador {
    String code = "EC";
    return Country(
        name: "Ecuador",
        flag: "🇪🇨",
        code: code,
        dialCode: "593",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `EGYPT`
  Country get egypt {
    String code = "EG";
    return Country(
        name: "Egypt",
        flag: "🇪🇬",
        code: code,
        dialCode: "20",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `EL SALVADOR`
  Country get elSalvador {
    String code = "SV";
    return Country(
        name: "El Salvador",
        flag: "🇸🇻",
        code: code,
        dialCode: "503",
        min: 11,
        max: 11,
        image: _image(code)
    );
  }

  /// Country details for `EQUATORIAL GUINEA`
  Country get equatorialGuinea {
    String code = "GQ";
    return Country(
        name: "Equatorial Guinea",
        flag: "🇬🇶",
        code: code,
        dialCode: "240",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `ERITREA`
  Country get eritrea {
    String code = "ER";
    return Country(
        name: "Eritrea",
        flag: "🇪🇷",
        code: code,
        dialCode: "291",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `ESTONIA`
  Country get estonia {
    String code = "EE";
    return Country(
        name: "Estonia",
        flag: "🇪🇪",
        code: code,
        dialCode: "372",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `ETHIOPIA`
  Country get ethiopia {
    String code = "ET";
    return Country(
        name: "Ethiopia",
        flag: "🇪🇹",
        code: code,
        dialCode: "251",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `FALK LAND ISLANDS`
  Country get falklandIslands {
    String code = "FK";
    return Country(
        name: "Falkland Islands (Malvinas)",
        flag: "🇫🇰",
        code: code,
        dialCode: "500",
        min: 5,
        max: 5,
        image: _image(code)
    );
  }

  /// Country details for `FAROE ISLANDS`
  Country get faroeIslands {
    String code = "FO";
    return Country(
        name: "Faroe Islands",
        flag: "🇫🇴",
        code: code,
        dialCode: "298",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `FIJI`
  Country get fiji {
    String code = "FJ";
    return Country(
        name: "Fiji",
        flag: "🇫🇯",
        code: code,
        dialCode: "679",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `FINLAND`
  Country get finland {
    String code = "FI";
    return Country(
        name: "Finland",
        flag: "🇫🇮",
        code: code,
        dialCode: "358",
        min: 12,
        max: 12,
        image: _image(code)
    );
  }

  /// Country details for `FRANCE`
  Country get france {
    String code = "FR";
    return Country(
        name: "France",
        flag: "🇫🇷",
        code: code,
        dialCode: "33",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `FRENCH GUIANA`
  Country get frenchGuiana {
    String code = "GF";
    return Country(
        name: "French Guiana",
        flag: "🇬🇫",
        code: code,
        dialCode: "594",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `FRENCH POLYNESIA`
  Country get frenchPolynesia {
    String code = "PF";
    return Country(
        name: "French Polynesia",
        flag: "🇵🇫",
        code: code,
        dialCode: "689",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `FRENCH SOUTHERN TERRITORIES`
  Country get frenchSouthernTerritories {
    String code = "TF";
    return Country(
        name: "French Southern Territories",
        flag: "🇹🇫",
        code: code,
        dialCode: "262",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `GABON`
  Country get gabon {
    String code = "GA";
    return Country(
        name: "Gabon",
        flag: "🇬🇦",
        code: code,
        dialCode: "241",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `GAMBIA`
  Country get gambia {
    String code = "GM";
    return Country(
        name: "Gambia",
        flag: "🇬🇲",
        code: code,
        dialCode: "220",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `GEORGIA`
  Country get georgia {
    String code = "GE";
    return Country(
        name: "Georgia",
        flag: "🇬🇪",
        code: code,
        dialCode: "995",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `GERMANY`
  Country get germany {
    String code = "DE";
    return Country(
        name: "Germany",
        flag: "🇩🇪",
        code: code,
        dialCode: "49",
        min: 9,
        max: 13,
        image: _image(code)
    );
  }

  /// Country details for `GHANA`
  Country get ghana {
    String code = "GH";
    return Country(
        name: "Ghana",
        flag: "🇬🇭",
        code: code,
        dialCode: "233",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `GIBRALTAR`
  Country get gibraltar {
    String code = "GI";
    return Country(
        name: "Gibraltar",
        flag: "🇬🇮",
        code: code,
        dialCode: "350",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `GREECE`
  Country get greece {
    String code = "GR";
    return Country(
        name: "Greece",
        flag: "🇬🇷",
        code: code,
        dialCode: "30",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `GREENLAND`
  Country get greenland {
    String code = "GL";
    return Country(
        name: "Greenland",
        flag: "🇬🇱",
        code: code,
        dialCode: "299",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `GRENADA`
  Country get grenada {
    String code = "GD";
    return Country(
        name: "Grenada",
        flag: "🇬🇩",
        code: code,
        dialCode: "1473",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `GUADELOUPE`
  Country get guadeloupe {
    String code = "GP";
    return Country(
        name: "Guadeloupe",
        flag: "🇬🇵",
        code: code,
        dialCode: "590",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `GUAM`
  Country get guam {
    String code = "GU";
    return Country(
        name: "Guam",
        flag: "🇬🇺",
        code: code,
        dialCode: "1671",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `GUATEMALA`
  Country get guatemala {
    String code = "GT";
    return Country(
        name: "Guatemala",
        flag: "🇬🇹",
        code: code,
        dialCode: "502",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `GUERNSEY`
  Country get guernsey {
    String code = "GG";
    return Country(
        name: "Guernsey",
        flag: "🇬🇬",
        code: code,
        dialCode: "44",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `GUINEA`
  Country get guinea {
    String code = "GN";
    return Country(
        name: "Guinea",
        flag: "🇬🇳",
        code: code,
        dialCode: "224",
        min: 8,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `GUINEA-BISSAU`
  Country get guineaBissau {
    String code = "GW";
    return Country(
        name: "Guinea-Bissau",
        flag: "🇬🇼",
        code: code,
        dialCode: "245",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `GUYANA`
  Country get guyana {
    String code = "GY";
    return Country(
        name: "Guyana",
        flag: "🇬🇾",
        code: code,
        dialCode: "592",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `HAITI`
  Country get haiti {
    String code = "HT";
    return Country(
        name: "Haiti",
        flag: "🇭🇹",
        code: code,
        dialCode: "509",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `HEARD ISLAND AND MCDONALD ISLANDS`
  Country get heardIsland {
    String code = "HM";
    return Country(
        name: "Heard Island and McDonald Islands",
        flag: "🇭🇲",
        code: code,
        dialCode: "672",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `HOLY SEE (VATICAN CITY STATE)`
  Country get holySeeCityVatican {
    String code = "VA";
    return Country(
        name: "Holy See (Vatican City State)",
        flag: "🇻🇦",
        code: code,
        dialCode: "379",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `HONDURAS`
  Country get honduras {
    String code = "HN";
    return Country(
        name: "Honduras",
        flag: "🇭🇳",
        code: code,
        dialCode: "504",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `HONG KONG`
  Country get hongKong {
    String code = "HK";
    return Country(
        name: "Hong Kong",
        flag: "🇭🇰",
        code: code,
        dialCode: "852",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `HUNGARY`
  Country get hungary {
    String code = "HU";
    return Country(
        name: "Hungary",
        flag: "🇭🇺",
        code: code,
        dialCode: "36",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `ICELAND`
  Country get iceland {
    String code = "IS";
    return Country(
        name: "Iceland",
        flag: "🇮🇸",
        code: code,
        dialCode: "354",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `INDIA`
  Country get india {
    String code = "IN";
    return Country(
        name: "India",
        flag: "🇮🇳",
        code: code,
        dialCode: "91",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `INDONESIA`
  Country get indonesia {
    String code = "ID";
    return Country(
        name: "Indonesia",
        flag: "🇮🇩",
        code: code,
        dialCode: "62",
        min: 10,
        max: 12,
        image: _image(code)
    );
  }

  /// Country details for `IRAN`
  Country get iran {
    String code = "IR";
    return Country(
        name: "Iran (Islamic Republic of Iran)",
        flag: "🇮🇷",
        code: code,
        dialCode: "98",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `IRAQ`
  Country get iraq {
    String code = "IQ";
    return Country(
        name: "Iraq",
        flag: "🇮🇶",
        code: code,
        dialCode: "964",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `IRELAND`
  Country get ireland {
    String code = "IE";
    return Country(
        name: "Ireland",
        flag: "🇮🇪",
        code: code,
        dialCode: "353",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `ISLE OF MAN`
  Country get isleOfMan {
    String code = "IM";
    return Country(
        name: "Isle of Man",
        flag: "🇮🇲",
        code: code,
        dialCode: "44",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `ISRAEL`
  Country get israel {
    String code = "IL";
    return Country(
        name: "Israel",
        flag: "🇮🇱",
        code: code,
        dialCode: "972",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `ITALY`
  Country get italy {
    String code = "IT";
    return Country(
        name: "Italy",
        flag: "🇮🇹",
        code: code,
        dialCode: "39",
        min: 10,
        max: 12,
        image: _image(code)
    );
  }

  /// Country details for `JAMAICA`
  Country get jamaica {
    String code = "JM";
    return Country(
        name: "Jamaica",
        flag: "🇯🇲",
        code: code,
        dialCode: "1876",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `JAPAN`
  Country get japan {
    String code = "JP";
    return Country(
        name: "Japan",
        flag: "🇯🇵",
        code: code,
        dialCode: "81",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `JERSEY`
  Country get jersey {
    String code = "JE";
    return Country(
        name: "Jersey",
        flag: "🇯🇪",
        code: code,
        dialCode: "44",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `JORDAN`
  Country get jordan {
    String code = "JO";
    return Country(
        name: "Jordan",
        flag: "🇯🇴",
        code: code,
        dialCode: "962",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `KAZAKHSTAN`
  Country get kazakhstan {
    String code = "KZ";
    return Country(
        name: "Kazakhstan",
        flag: "🇰🇿",
        code: code,
        dialCode: "7",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `KENYA`
  Country get kenya {
    String code = "KE";
    return Country(
        name: "Kenya",
        flag: "🇰🇪",
        code: code,
        dialCode: "254",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `KIRIBATI`
  Country get kiribati {
    String code = "KI";
    return Country(
        name: "Kiribati",
        flag: "🇰🇮",
        code: code,
        dialCode: "686",
        min: 5,
        max: 5,
        image: _image(code)
    );
  }

  /// Country details for `NORTH KOREA`
  Country get northKorea {
    String code = "KP";
    return Country(
        name: "North Korea",
        flag: "🇰🇵",
        code: code,
        dialCode: "850",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SOUTH KOREA`
  Country get southKorea {
    String code = "KR";
    return Country(
        name: "South Korea",
        flag: "🇰🇷",
        code: code,
        dialCode: "82",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `KUWAIT`
  Country get kuwait {
    String code = "KW";
    return Country(
        name: "Kuwait",
        flag: "🇰🇼",
        code: code,
        dialCode: "965",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `KYRGYZSTAN`
  Country get kyrgyzstan {
    String code = "KG";
    return Country(
        name: "Kyrgyzstan",
        flag: "🇰🇬",
        code: code,
        dialCode: "996",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `LAO PEOPLE'S DEMOCRATIC REPUBLIC`
  Country get laos {
    String code = "LA";
    return Country(
        name: "Lao People's Democratic Republic",
        flag: "🇱🇦",
        code: code,
        dialCode: "856",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `LATVIA`
  Country get latvia {
    String code = "LV";
    return Country(
        name: "Latvia",
        flag: "🇱🇻",
        code: code,
        dialCode: "371",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `LEBANON`
  Country get lebanon {
    String code = "LB";
    return Country(
        name: "Lebanon",
        flag: "🇱🇧",
        code: code,
        dialCode: "961",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `LESOTHO`
  Country get lesotho {
    String code = "LS";
    return Country(
        name: "Lesotho",
        flag: "🇱🇸",
        code: code,
        dialCode: "266",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `LIBERIA`
  Country get liberia {
    String code = "LR";
    return Country(
        name: "Liberia",
        flag: "🇱🇷",
        code: code,
        dialCode: "231",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `LIBYA`
  Country get libya {
    String code = "LY";
    return Country(
        name: "Libya",
        flag: "🇱🇾",
        code: code,
        dialCode: "218",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `LIECHTENSTEIN`
  Country get liechtenstein {
    String code = "LI";
    return Country(
        name: "Liechtenstein",
        flag: "🇱🇮",
        code: code,
        dialCode: "423",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `LITHUANIA`
  Country get lithuania {
    String code = "LT";
    return Country(
        name: "Lithuania",
        flag: "🇱🇹",
        code: code,
        dialCode: "370",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `LUXEMBOURG`
  Country get luxembourg {
    String code = "LU";
    return Country(
        name: "Luxembourg",
        flag: "🇱🇺",
        code: code,
        dialCode: "352",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MACAO`
  Country get macao {
    String code = "MO";
    return Country(
        name: "Macao",
        flag: "🇲🇴",
        code: code,
        dialCode: "853",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `MACEDONIA`
  Country get macedonia {
    String code = "MK";
    return Country(
        name: "Macedonia",
        flag: "🇲🇰",
        code: code,
        dialCode: "389",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MADAGASCAR`
  Country get madagascar {
    String code = "MG";
    return Country(
        name: "Madagascar",
        flag: "🇲🇬",
        code: code,
        dialCode: "261",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `MALAWI`
  Country get malawi {
    String code = "MW";
    return Country(
        name: "Malawi",
        flag: "🇲🇼",
        code: code,
        dialCode: "265",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `MALAYSIA`
  Country get malaysia {
    String code = "MY";
    return Country(
        name: "Malaysia",
        flag: "🇲🇾",
        code: code,
        dialCode: "60",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `MALDIVES`
  Country get maldives {
    String code = "MV";
    return Country(
        name: "Maldives",
        flag: "🇲🇻",
        code: code,
        dialCode: "960",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MALI`
  Country get mali {
    String code = "ML";
    return Country(
        name: "Mali",
        flag: "🇲🇱",
        code: code,
        dialCode: "223",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MALTA`
  Country get malta {
    String code = "MT";
    return Country(
        name: "Malta",
        flag: "🇲🇹",
        code: code,
        dialCode: "356",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MARSHALL ISLANDS`
  Country get marshallIslands {
    String code = "MH";
    return Country(
        name: "Marshall Islands",
        flag: "🇲🇭",
        code: code,
        dialCode: "692",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `MARTINIQUE`
  Country get martinique {
    String code = "MQ";
    return Country(
        name: "Martinique",
        flag: "🇲🇶",
        code: code,
        dialCode: "596",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `MAURITANIA`
  Country get mauritania {
    String code = "MR";
    return Country(
        name: "Mauritania",
        flag: "🇲🇷",
        code: code,
        dialCode: "222",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MAURITIUS`
  Country get mauritius {
    String code = "MU";
    return Country(
        name: "Mauritius",
        flag: "🇲🇺",
        code: code,
        dialCode: "230",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MAYOTTE`
  Country get mayotte {
    String code = "YT";
    return Country(
        name: "Mayotte",
        flag: "🇾🇹",
        code: code,
        dialCode: "262",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `MEXICO`
  Country get mexico {
    String code = "MX";
    return Country(
        name: "Mexico",
        flag: "🇲🇽",
        code: code,
        dialCode: "52",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `MICRONESIA`
  Country get micronesia {
    String code = "FM";
    return Country(
        name: "Micronesia (Federated States of Micronesia)",
        flag: "🇫🇲",
        code: code,
        dialCode: "691",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `MOLDOVA`
  Country get moldova {
    String code = "MD";
    return Country(
        name: "Moldova",
        flag: "🇲🇩",
        code: code,
        dialCode: "373",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MONACO`
  Country get monaco {
    String code = "MC";
    return Country(
        name: "Monaco",
        flag: "🇲🇨",
        code: code,
        dialCode: "377",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `MONGOLIA`
  Country get mongolia {
    String code = "MN";
    return Country(
        name: "Mongolia",
        flag: "🇲🇳",
        code: code,
        dialCode: "976",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MONTENEGRO`
  Country get montenegro {
    String code = "ME";
    return Country(
        name: "Montenegro",
        flag: "🇲🇪",
        code: code,
        dialCode: "382",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MONTSERRAT`
  Country get montserrat {
    String code = "MS";
    return Country(
        name: "Montserrat",
        flag: "🇲🇸",
        code: code,
        dialCode: "1664",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `MOROCCO`
  Country get morocco {
    String code = "MA";
    return Country(
        name: "Morocco",
        flag: "🇲🇦",
        code: code,
        dialCode: "212",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `MOZAMBIQUE`
  Country get mozambique {
    String code = "MZ";
    return Country(
        name: "Mozambique",
        flag: "🇲🇿",
        code: code,
        dialCode: "258",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `MYANMAR`
  Country get myanmar {
    String code = "MM";
    return Country(
        name: "Myanmar",
        flag: "🇲🇲",
        code: code,
        dialCode: "95",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `NAMIBIA`
  Country get namibia {
    String code = "NA";
    return Country(
        name: "Namibia",
        flag: "🇳🇦",
        code: code,
        dialCode: "264",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `NAURU`
  Country get nauru {
    String code = "NR";
    return Country(
        name: "Nauru",
        flag: "🇳🇷",
        code: code,
        dialCode: "674",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `NEPAL`
  Country get nepal {
    String code = "NP";
    return Country(
        name: "Nepal",
        flag: "🇳🇵",
        code: code,
        dialCode: "977",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `NETHERLANDS`
  Country get netherlands {
    String code = "NL";
    return Country(
        name: "Netherlands",
        flag: "🇳🇱",
        code: code,
        dialCode: "31",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `NEW CALEDONIA`
  Country get newCaledonia {
    String code = "NC";
    return Country(
        name: "New Caledonia",
        flag: "🇳🇨",
        code: code,
        dialCode: "687",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `NEW ZEALAND`
  Country get newZealand {
    String code = "NZ";
    return Country(
        name: "New Zealand",
        flag: "🇳🇿",
        code: code,
        dialCode: "64",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `NICARAGUA`
  Country get nicaragua {
    String code = "NI";
    return Country(
        name: "Nicaragua",
        flag: "🇳🇮",
        code: code,
        dialCode: "505",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `NIGER`
  Country get niger {
    String code = "NE";
    return Country(
        name: "Niger",
        flag: "🇳🇪",
        code: code,
        dialCode: "227",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `NIGERIA`
  Country get nigeria {
    String code = "NG";
    return Country(
        name: "Nigeria",
        flag: "🇳🇬",
        code: code,
        dialCode: "234",
        min: 10,
        max: 11,
        image: _image(code)
    );
  }

  /// Country details for `NIUE`
  Country get niue {
    String code = "NU";
    return Country(
        name: "Niue",
        flag: "🇳🇺",
        code: code,
        dialCode: "683",
        min: 4,
        max: 4,
        image: _image(code)
    );
  }

  /// Country details for `NORFOLK ISLAND`
  Country get norfolkIsland {
    String code = "NF";
    return Country(
        name: "Norfolk Island",
        flag: "🇳🇫",
        code: code,
        dialCode: "672",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `NORTHERN MARIANA ISLANDS`
  Country get northernMarianaIslands {
    String code = "MP";
    return Country(
        name: "Northern Mariana Islands",
        flag: "🇲🇵",
        code: code,
        dialCode: "1670",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `NORWAY`
  Country get norway {
    String code = "NO";
    return Country(
        name: "Norway",
        flag: "🇳🇴",
        code: code,
        dialCode: "47",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `OMAN`
  Country get oman {
    String code = "OM";
    return Country(
        name: "Oman",
        flag: "🇴🇲",
        code: code,
        dialCode: "968",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `PAKISTAN`
  Country get pakistan {
    String code = "PK";
    return Country(
        name: "Pakistan",
        flag: "🇵🇰",
        code: code,
        dialCode: "92",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `PALAU`
  Country get palau {
    String code = "PW";
    return Country(
        name: "Palau",
        flag: "🇵🇼",
        code: code,
        dialCode: "680",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `PALESTINE`
  Country get palestine {
    String code = "PS";
    return Country(
        name: "Palestine",
        flag: "🇵🇸",
        code: code,
        dialCode: "970",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `PANAMA`
  Country get panama {
    String code = "PA";
    return Country(
        name: "Panama",
        flag: "🇵🇦",
        code: code,
        dialCode: "507",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `PAPUA NEW GUINEA`
  Country get papuaNewGuinea {
    String code = "PG";
    return Country(
        name: "Papua New Guinea",
        flag: "🇵🇬",
        code: code,
        dialCode: "675",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `PARAGUAY`
  Country get paraguay {
    String code = "PY";
    return Country(
        name: "Paraguay",
        flag: "🇵🇾",
        code: code,
        dialCode: "595",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `PERU`
  Country get peru {
    String code = "PE";
    return Country(
        name: "Peru",
        flag: "🇵🇪",
        code: code,
        dialCode: "51",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `PHILIPPINES`
  Country get philippines {
    String code = "PH";
    return Country(
        name: "Philippines",
        flag: "🇵🇭",
        code: code,
        dialCode: "63",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `PITCAIRN`
  Country get pitcairn {
    String code = "PN";
    return Country(
        name: "Pitcairn",
        flag: "🇵🇳",
        code: code,
        dialCode: "64",
        min: 4,
        max: 4,
        image: _image(code)
    );
  }

  /// Country details for `POLAND`
  Country get poland {
    String code = "PL";
    return Country(
        name: "Poland",
        flag: "🇵🇱",
        code: code,
        dialCode: "48",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `PORTUGAL`
  Country get portugal {
    String code = "PT";
    return Country(
        name: "Portugal",
        flag: "🇵🇹",
        code: code,
        dialCode: "351",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `PUERTO RICO`
  Country get puertoRico {
    String code = "PR";
    return Country(
        name: "Puerto Rico",
        flag: "🇵🇷",
        code: code,
        dialCode: "1787",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `QATAR`
  Country get qatar {
    String code = "QA";
    return Country(
        name: "Qatar",
        flag: "🇶🇦",
        code: code,
        dialCode: "974",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `REUNION`
  Country get reunion {
    String code = "RE";
    return Country(
        name: "Réunion",
        flag: "🇷🇪",
        code: code,
        dialCode: "262",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `ROMANIA`
  Country get romania {
    String code = "RO";
    return Country(
        name: "Romania",
        flag: "🇷🇴",
        code: code,
        dialCode: "40",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `RUSSIA`
  Country get russia {
    String code = "RU";
    return Country(
        name: "Russia",
        flag: "🇷🇺",
        code: code,
        dialCode: "7",
        min: 9,
        max: 11,
        image: _image(code)
    );
  }

  /// Country details for `RWANDA`
  Country get rwanda {
    String code = "RW";
    return Country(
        name: "Rwanda",
        flag: "🇷🇼",
        code: code,
        dialCode: "250",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SAINT BARTHELEMY`
  Country get saintBarthelemy {
    String code = "BL";
    return Country(
        name: "Saint Barthélemy",
        flag: "🇧🇱",
        code: code,
        dialCode: "590",
        min: 12,
        max: 12,
        image: _image(code)
    );
  }

  /// Country details for `SAINT HELENA`
  Country get saintHelena {
    String code = "SH";
    return Country(
        name: "Saint Helena (Ascension and Tristan da Cunha)",
        flag: "🇸🇭",
        code: code,
        dialCode: "290",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SAINT KITTS AND NEVIS`
  Country get saintKittsAndNevis {
    String code = "KN";
    return Country(
        name: "Saint Kitts and Nevis",
        flag: "🇰🇳",
        code: code,
        dialCode: "1869",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `SAINT LUCIA`
  Country get saintLucia {
    String code = "LC";
    return Country(
        name: "Saint Lucia",
        flag: "🇱🇨",
        code: code,
        dialCode: "1758",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `SAINT MARTIN`
  Country get saintMartin {
    String code = "MF";
    return Country(
        name: "Saint Martin (French part)",
        flag: "🇲🇫",
        code: code,
        dialCode: "590",
        min: 15,
        max: 15,
        image: _image(code)
    );
  }

  /// Country details for `SAINT PIERRE AND MIQUELON`
  Country get saintPierreAndMiquelon {
    String code = "PM";
    return Country(
        name: "Saint Pierre and Miquelon",
        flag: "🇵🇲",
        code: code,
        dialCode: "508",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SAINT VINCENT AND GRENADINES`
  Country get saintVincentAndGrenadines {
    String code = "VC";
    return Country(
        name: "Saint Vincent and the Grenadines",
        flag: "🇻🇨",
        code: code,
        dialCode: "1784",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `SAMOA`
  Country get samoa {
    String code = "WS";
    return Country(
        name: "Samoa",
        flag: "🇼🇸",
        code: code,
        dialCode: "685",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `SAN MARINO`
  Country get sanMarino {
    String code = "SM";
    return Country(
        name: "San Marino",
        flag: "🇸🇲",
        code: code,
        dialCode: "378",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `SAO TOME AND PRINCIPE`
  Country get saoTomeAndPrincipe {
    String code = "ST";
    return Country(
        name: "Sao Tome and Principe",
        flag: "🇸🇹",
        code: code,
        dialCode: "239",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SAUDI ARABIA`
  Country get saudiArabia {
    String code = "SA";
    return Country(
        name: "Saudi Arabia",
        flag: "🇸🇦",
        code: code,
        dialCode: "966",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SENEGAL`
  Country get senegal {
    String code = "SN";
    return Country(
        name: "Senegal",
        flag: "🇸🇳",
        code: code,
        dialCode: "221",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `SERBIA`
  Country get serbia {
    String code = "RS";
    return Country(
        name: "Serbia",
        flag: "🇷🇸",
        code: code,
        dialCode: "381",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SEYCHELLES`
  Country get seychelles {
    String code = "SC";
    return Country(
        name: "Seychelles",
        flag: "🇸🇨",
        code: code,
        dialCode: "248",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SIERRA LEONE`
  Country get sierraLeone {
    String code = "SL";
    return Country(
        name: "Sierra Leone",
        flag: "🇸🇱",
        code: code,
        dialCode: "232",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SINGAPORE`
  Country get singapore {
    String code = "SG";
    return Country(
        name: "Singapore",
        flag: "🇸🇬",
        code: code,
        dialCode: "65",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SINT MAARTEN`
  Country get sintMaarten {
    String code = "SX";
    return Country(
        name: "Sint Maarten (Dutch part)",
        flag: "🇸🇽",
        code: code,
        dialCode: "1721",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `SLOVAKIA`
  Country get slovakia {
    String code = "SK";
    return Country(
        name: "Slovakia",
        flag: "🇸🇰",
        code: code,
        dialCode: "421",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SLOVENIA`
  Country get slovenia {
    String code = "SI";
    return Country(
        name: "Slovenia",
        flag: "🇸🇮",
        code: code,
        dialCode: "386",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SOLOMON ISLANDS`
  Country get solomonIslands {
    String code = "SB";
    return Country(
        name: "Solomon Islands",
        flag: "🇸🇧",
        code: code,
        dialCode: "677",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SOMALIA`
  Country get somalia {
    String code = "SO";
    return Country(
        name: "Somalia",
        flag: "🇸🇴",
        code: code,
        dialCode: "252",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SOUTH AFRICA`
  Country get southAfrica {
    String code = "ZA";
    return Country(
        name: "South Africa",
        flag: "🇿🇦",
        code: code,
        dialCode: "27",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `SOUTH GEORGIA`
  Country get southGeorgia {
    String code = "GS";
    return Country(
        name: "South Georgia and the South Sandwich Islands",
        flag: "🇬🇸",
        code: code,
        dialCode: "500",
        min: 17,
        max: 17,
        image: _image(code)
    );
  }

  /// Country details for `SOUTH SUDAN`
  Country get southSudan {
    String code = "SS";
    return Country(
        name: "South Sudan",
        flag: "🇸🇸",
        code: code,
        dialCode: "211",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SPAIN`
  Country get spain {
    String code = "ES";
    return Country(
        name: "Spain",
        flag: "🇪🇸",
        code: code,
        dialCode: "34",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SRI LANKA`
  Country get sriLanka {
    String code = "LK";
    return Country(
        name: "Sri Lanka",
        flag: "🇱🇰",
        code: code,
        dialCode: "94",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SUDAN`
  Country get sudan {
    String code = "SD";
    return Country(
        name: "Sudan",
        flag: "🇸🇩",
        code: code,
        dialCode: "249",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SURINAME`
  Country get suriname {
    String code = "SR";
    return Country(
        name: "Suriname",
        flag: "🇸🇷",
        code: code,
        dialCode: "597",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SVALBARD AND JAN MAYEN`
  Country get svalbardAndJanMayen {
    String code = "SJ";
    return Country(
        name: "Svalbard and Jan Mayen",
        flag: "🇸🇯",
        code: code,
        dialCode: "47",
        min: 17,
        max: 17,
        image: _image(code)
    );
  }

  /// Country details for `SWAZILAND`
  Country get swaziland {
    String code = "SZ";
    return Country(
        name: "Swaziland",
        flag: "🇸🇿",
        code: code,
        dialCode: "268",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `SWEDEN`
  Country get sweden {
    String code = "SE";
    return Country(
        name: "Sweden",
        flag: "🇸🇪",
        code: code,
        dialCode: "46",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SWITZERLAND`
  Country get switzerland {
    String code = "CH";
    return Country(
        name: "Switzerland",
        flag: "🇨🇭",
        code: code,
        dialCode: "41",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `SYRIA`
  Country get syria {
    String code = "SY";
    return Country(
        name: "Syria",
        flag: "🇸🇾",
        code: code,
        dialCode: "963",
        min: 7,
        max: 7,
        image: _image(code)
    );
  }

  /// Country details for `TAIWAN`
  Country get taiwan {
    String code = "TW";
    return Country(
        name: "Taiwan",
        flag: "🇹🇼",
        code: code,
        dialCode: "886",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `TAJIKISTAN`
  Country get tajikistan {
    String code = "TJ";
    return Country(
        name: "Tajikistan",
        flag: "🇹🇯",
        code: code,
        dialCode: "992",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `TANZANIA`
  Country get tanzania {
    String code = "TZ";
    return Country(
        name: "Tanzania",
        flag: "🇹🇿",
        code: code,
        dialCode: "255",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `THAILAND`
  Country get thailand {
    String code = "TH";
    return Country(
        name: "Thailand",
        flag: "🇹🇭",
        code: code,
        dialCode: "66",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `TIMOR LESTE`
  Country get timorLeste {
    String code = "TL";
    return Country(
        name: "Timor-Leste",
        flag: "🇹🇱",
        code: code,
        dialCode: "670",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `TOGO`
  Country get togo {
    String code = "TG";
    return Country(
        name: "Togo",
        flag: "🇹🇬",
        code: code,
        dialCode: "228",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `TOKELAU`
  Country get tokelau {
    String code = "TK";
    return Country(
        name: "Tokelau",
        flag: "🇹🇰",
        code: code,
        dialCode: "690",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `TONGA`
  Country get tonga {
    String code = "TO";
    return Country(
        name: "Tonga",
        flag: "🇹🇴",
        code: code,
        dialCode: "676",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `TRINIDAD AND TOBAGO`
  Country get trinidadAndTobago {
    String code = "TT";
    return Country(
        name: "Trinidad and Tobago",
        flag: "🇹🇹",
        code: code,
        dialCode: "1868",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `TUNISIA`
  Country get tunisia {
    String code = "TN";
    return Country(
        name: "Tunisia",
        flag: "🇹🇳",
        code: code,
        dialCode: "216",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `TURKEY`
  Country get turkey {
    String code = "TR";
    return Country(
        name: "Turkey",
        flag: "🇹🇷",
        code: code,
        dialCode: "90",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `TURKMENISTAN`
  Country get turkmenistan {
    String code = "TM";
    return Country(
        name: "Turkmenistan",
        flag: "🇹🇲",
        code: code,
        dialCode: "993",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `TURKS AND CAICOS ISLANDS`
  Country get turksAndCaicosIslands {
    String code = "TC";
    return Country(
        name: "Turks and Caicos Islands",
        flag: "🇹🇨",
        code: code,
        dialCode: "1649",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `TUVALU`
  Country get tuvalu {
    String code = "TV";
    return Country(
        name: "Tuvalu",
        flag: "🇹🇻",
        code: code,
        dialCode: "688",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `UGANDA`
  Country get uganda {
    String code = "UG";
    return Country(
        name: "Uganda",
        flag: "🇺🇬",
        code: code,
        dialCode: "256",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `UKRAINE`
  Country get ukraine {
    String code = "UA";
    return Country(
        name: "Ukraine",
        flag: "🇺🇦",
        code: code,
        dialCode: "380",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `UNITED ARAB EMIRATES`
  Country get unitedArabEmirates {
    String code = "AE";
    return Country(
        name: "United Arab Emirates",
        flag: "🇦🇪",
        code: code,
        dialCode: "971",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `UNITED KINGDOM`
  Country get unitedKingdom {
    String code = "GB";
    return Country(
        name: "United Kingdom of Great Britain and Northern Ireland",
        flag: "🇬🇧",
        code: code,
        dialCode: "44",
        min: 14,
        max: 14,
        image: _image(code)
    );
  }

  /// Country details for `UNITED STATES`
  Country get unitedStates {
    String code = "US";
    return Country(
        name: "United States of America",
        flag: "🇺🇸",
        code: code,
        dialCode: "1",
        min: 14,
        max: 14,
        image: _image(code)
    );
  }

  /// Country details for `URUGUAY`
  Country get uruguay {
    String code = "UY";
    return Country(
        name: "Uruguay",
        flag: "🇺🇾",
        code: code,
        dialCode: "598",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `UZBEKISTAN`
  Country get uzbekistan {
    String code = "UZ";
    return Country(
        name: "Uzbekistan",
        flag: "🇺🇿",
        code: code,
        dialCode: "998",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `VANUATU`
  Country get vanuatu {
    String code = "VU";
    return Country(
        name: "Vanuatu",
        flag: "🇻🇺",
        code: code,
        dialCode: "678",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `VENEZUELA`
  Country get venezuela {
    String code = "VE";
    return Country(
        name: "Venezuela",
        flag: "🇻🇪",
        code: code,
        dialCode: "58",
        min: 9,
        max: 9,
        image: _image(code)
    );
  }

  /// Country details for `VIETNAM`
  Country get vietnam {
    String code = "VN";
    return Country(
        name: "Vietnam",
        flag: "🇻🇳", code: code,
        dialCode: "84",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `WALLIS AND FUTUNA`
  Country get wallisAndFutuna {
    String code = "WF";
    return Country(
        name: "Wallis and Futuna",
        flag: "🇼🇫",
        code: code,
        dialCode: "681",
        min: 6,
        max: 6,
        image: _image(code)
    );
  }

  /// Country details for `WESTERN SAHARA`
  Country get westernSahara {
    String code = "EH";
    return Country(
        name: "Western Sahara",
        flag: "🇪🇭",
        code: code,
        dialCode: "212",
        min: 10,
        max: 10,
        image: _image(code)
    );
  }

  /// Country details for `YEMEN`
  Country get yemen {
    String code = "YE";
    return Country(
        name: "Yemen",
        flag: "🇾🇪",
        code: code,
        dialCode: "967",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `ZAMBIA`
  Country get zambia {
    String code = "ZM";
    return Country(
        name: "Zambia",
        flag: "🇿🇲",
        code: code,
        dialCode: "260",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }

  /// Country details for `ZIMBABWE`
  Country get zimbabwe {
    String code = "ZW";
    return Country(
        name: "Zimbabwe",
        flag: "🇿🇼",
        code: code,
        dialCode: "263",
        min: 8,
        max: 8,
        image: _image(code)
    );
  }
}