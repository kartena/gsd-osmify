CREATE TABLE "lmv_bright"."terrang_coverage_simple" (gid serial PRIMARY KEY,
"name" varchar(80));
SELECT AddGeometryColumn('lmv_bright','terrang_coverage_simple','the_geom','-1','MULTIPOLYGON',2);

/* Note: this is the coverage of Terrängkartan as it is now (2013-01-14),
   the actual code to generate it is a bit complex and time consuming to run.
   Also occurs in 20130111_000.sql */
INSERT INTO "lmv_bright"."terrang_coverage_simple" ("name",the_geom) VALUES (NULL,ST_SetSRID(geometry('01060000000300000001030000000200000038010000F296187874F412413A81800F09F858414B2BFD9130FF1241A3D38AADF8FA5841C14C092817101341B2E314EF0DFC5841B7F7BDB6821913414889DFC8EDFC58417ECF877A4C251341B2D5A7049EFE5841ADBF67821A3E1341D39027C59400594117EB6AB4D33F134171F934CABD0159416D26B110D1431341B70871DAF1015941EF770CE579391341434ABB597C035941A2CCA1FF9A351341933097A89C035941D6D12CDFC23B13419CDD5A8FEB04594148E83E7947441341935B4FEEE80559419030CF923744134180D5935CAE095941ECFCEF2B864E13410B5ACC5C520C5941F319D9E0A64E13411367A254910D5941C07A23078E5F13411064549D840F594163310DDA8078134108735C64E2105941D8F3F338537B1341A8410B4A4F115941339607FEC7771341AA53D0377C1C5941255AA626886213417542A4846A1F5941222BE3DAC464134149F4D39DB01F594190A2A328FC5A1341ECBA9E951D2159411A4C68773A581341218196BC2724594155229569C64D13410228ABFBBE255941421043B0624F1341C54B5E99F62859418EB48E6D3B4B1341B71D8190482B5941700F5199A7461341D97CD858972C5941A30A93F238381341CCC26C5CCE2E594169DAB1CADE1D134186ACB0CA6C37594143069EAF8F251341A6D571037F395941477B17BEE73A134134533114403B59415F532C6EC26F13415034F4C2FE3C594176370DB7CFB313410CDEDF535E3D5941063B30F019BA13416AF0236FD53D594119821E9DD1C1134184BDC5E3E03E5941BD56F6044BCA1341D3B7D45A1041594125A216ADF6D41341CDC5219129425941494998B6A80114418964048E2E425941CB099BD68507144102EEBB7BCE4259416CE7AFF1DD0014411D74ECF2BA42594187FB6531B3FF13418DB1786DD542594126786184C70014415C10DF84A543594121107D4B67FD1341401D0B3EEE435941AC91623602001441555498F939445941B3ED93E17A02144178CA8F10DC45594104CAB04210FE1341C3061364114659410BE026EA8EFF13415803905100475941682709F34AF71341E647152D3F485941D78947537A0114410881C74B3E4959419B757AA389FD1341BB83F1B291495941AA95CF8B7600144154C3A334A8495941CA5582DE4901144129D97FD91F4A594153E2AA06F9FC134158FD95C0044C5941D19311117CFD134154927191044D5941379AD000E4EF13410EAEADA2E24D5941C8CA92CDAAEB1341DDA3AB09FE4E5941ED9133DAB1E3134154A97CC47A4F5941D95013AE82DB1341E43EC3E77C5059410F181C3ACAD3134162C0900AF0505941F0118AD7BFC01341B35DA5B3255159413E96D175C5B5134128DC63696052594100F214DE7ACB134198250DBD065359410DADF0706CDE13410D6B8DC8DE5359415731B8F1D2E1134118A93F9433545941068901854CDC134105B26ADA13555941856AED21B0DF134116808C2C945559410BF1B5586EE513411B191A51A055594105B3954B0FEA1341B8B00D1F78555941B7ED1385B8FC1341338F78B9A355594167A9FC20BE00144115ECB56ADB555941877CD7456D001441890DB38179565941A4BDA33D9B0514419DF7DEE5E2565941B0287355EA121441C0259D2E6A575941F8193894C63914411B5ACBDF78585941363EFBE2CB3A1441310DDEEB4A585941D96C3319F6621441E49573781157594196EF8B2E3E7414419727C667B2565941EE95286A58B4144142AB596F64575941A460354E4BCD14418FCA288D8A565941E6C6223921DE144118458966D4565941092D6A6479121541A5330B2ECE5A59415BF6D5053E7515416C7E7AADB25E594165DE5EF334A8154129ED2ACB01645941CB0E544C5BC215419F1D1383226559416FDCE3FAD7D71541D350632375665941F4179BB2E4F51541C3C38D03126A5941699F668319091641CB01B163DC6C59417C34D7820B331641520E473B07775941447D904C642616413BF6B9EE597A5941371537E95C181641A9CACCFEA680594123921ED14D161641BE85562847855941199DE75CF13F16419D49598CC2875941D269315E06781641FEE880F1018E5941E854AE717E7F1641C6F5D6609E995941184581237A6C1641FB2435F3D09D5941536082B41B371641537360664DA3594189292480D235164102429231E9A7594160B66F5E060E1641BAF81B5BA9AC59412C6EF55D5AD915413A5A36F016B2594198CD952F23B8154135B6B4F851BB5941855B8012DFAD1541B895FD5619BF5941DAF5FBF71BAF1541AB55BF8B36C35941E43E2DAFF65B15418E674227D0D0594140E147EA0F6C1541F277903A85D15941B69C25E2501B1641758C0E4B6DD4594168945987183D1641CAB9FB7471D4594117665AB848A416411BF2CFA9A5D359416B5BCC8791CC16410E993C283AD459419F23BF2005E11641D625F8F1ECD45941B7BE158BBBFB1641B132DC4BFBDD5941671A912BF6441741CE26F6B2ADE3594140128937016D1741B6D3DCC647EA594162248347969117414D42F349E0F45941000000008E5817410E2DB2ADAFFA59411143F9268E58174157F13E0CC03E5A41000000007EA2194100000020C03E5A41CEEA103C7FA21941D36B901DD0655A41000000006EEC1B4100000020D0655A41000000006EEC1B41000000E0EFB35A419119F6957EA219419A615FE9EFB35A41729D49567EA219413D3BC71100DB5A41000000006EEC1B410000002000DB5A419119F6956EEC1B41669EA01610025B4100000000BE201F410000002010025B410E1F1D9CBF201F41D097621F98155B41998AF76158B52041D36B901D98155B410000000059B520410000002010025B4100000000A7E923410000002010025B41C90CFB4AA7E92341669EA01620295B41000000009F0E25410000002020295B41000000009F0E25410000000040775B4100000000BF5C25410000002040775B4100000000BF5C2541000000E0D7B15B4189A17C1307D42441A90EC1F3D7B15B41B9CE242B07D424413D3BC711E8D85B4100000000BF5C254100000020E8D85B416775089EBF5C2541D36B901D70EC5B4100000000B78126410000002070EC5B416775089EB7812641D36B901D80135C41553C00005F5429410000002080135C413726C6715F5429412D669B1AA0615C41C9D9398E40772B412D669B1AA0615C410000000041772B4100000020903A5C4100000000519E2B4100000000903A5C4100000000519E2B410000002080135C417EBE14FB903A2C410E2E3E0680135C41775E83EC903A2C41A90EC1F329CE5B4100000000691D2B41000000E029CE5B417970F131681D2B4130689DE065C45B410000000071F82941000000E065C45B4137F304B570F829419A615FE9559D5B4100000000F9112941000000E0559D5B41998AF761F81129412D946FE26D995B410000000079D32841000000E06D995B417EBE14FB78D32841F2D1C1F945765B410000000059852841000000E045765B4100000000598528410000002023675B41775E83EC100E294157F13E0C23675B417EBE14FB100E2941F2D1C1F91E3E5B410000000059852841000000E01E3E5B417EBE14FB58852841F2D1C1F925285B4100000000D1712841000000E025285B4100000000D17128410000000016015B4100000000C14A2841000000E015015B4100000000C14A2841B29DEFFF87EE5A41EEA4116629492841B29DEFDF87EE5A4118DCCF794249284161A96EEE8DED5A4100000000C9252741000000E08DED5A41C9D9398EC8252741D39964E505DA5A4100000000094B2641000000E005DA5A413D0AD2EC084B2641C9C6287902D95A41000000002147264105FAA3D200D95A417970F1312047264130689DE094D75A4100000000D1002641000000E094D75A414731DBD4D0002641C3C438EEF5B25A4100000000A18B2541000000E0F5B25A41998AF761A08B25412D946FE24FA45A4100000000D9DB2441000000E04FA45A414731DBD4D8DB2441C3C438EEE58B5A410000000021532441000000E0E58B5A414731DBD420532441C3C438EED5645A4100000000E1B62341000000E0D5645A417EBE14FBE0B62341F2D1C1F9B5165A4100000000C1682341000000E0B5165A4100000000C1682341000000208ACA5941775E83ECE0B6234157F13E0C8ACA594100000000E1B62341000000203EAD59417970F131D8DB2441D097621F3EAD594100000000D9DB24410000002009A1594137F304B5C0D92541669EA01609A1594100000000C1D92541000000202E86594100000000D1002641000000002E86594100000000D1002641000000201E5F59414731DBD4C82527413D3BC7111E5F594100000000C925274100000020964B59417EBE14FB708727410E2E3E06964B5941775E83EC70872741A90EC1F3912259410000000021C42641000000E09122594137F304B520C426419A615FE9090F59410000000059142641000000E0090F5941C9D9398E58142641D39964E5F9E758410000000061EF2441000000E0F9E75841C9D9398E60EF2441D39964E571D458410000000079F12341000000E071D45841C9D9398E78F12341D39964E55AC3584100000000B1412341000000E05AC358417EBE14FBB0412341F2D1C1F9159058410000000091F32241000000E0159058410000000091F32241000000205B465841775E83EC487C234157F13E0C5B4658417EBE14FB487C2341F2D1C1F9561D58410000000091F32241000000E0561D58417EBE14FB90F32241F2D1C1F946F657410000000071A52241000000E046F657417EBE14FB70A52241F2D1C1F96BDB574100000000D96A2241000000E06BDB5741775E83ECD86A2241A90EC1F31FBE574100000000E1452141000000E01FBE57417970F131E045214130689DE0B5A557410000000042711C41000000E0B5A557413215EFC340711C412D946FE2596157411143F9262E741541A90EC1F359615741000000002E741541000000E097AA574100000000DEB014414E62100098AA574100000000DEB01441AE47E1322AB95741B531252DF6B21441B0DD030857B9574100000000DEB01441B6F3FDA467B957410483D609DEB014410E2E3E069CD35741000000000E261541000000209CD35741000000000E261541000000E0D5F357411143F926BE621441A90EC1F3D5F3574100000000BE621441000000E0E51A58411143F9262E031341A90EC1F3E51A5841000000002E031341000000E0F54158411143F926BEF11141A90EC1F3F541584100000000BEF11141000000E005695841000000008E7C11410000000006695841000000008E7C1141000000E0159058411143F9262E921041A90EC1F315905841000000002E921041000000E025B75841000000000E4410410000000026B75841000000000E441041000000E035DE584100000000DCEB0F410000000036DE58415FB33146DCEB0F41E65090DD8AF258410530E9A0A02E10418458C72F83F35841BBD80AA1F96B1041F84767FE3EF5584199C6363AE0B710417F431371CCF65841E9973C1378D010413722F3CF44F85841B5EB6E8C9BE91041CB394843BDFA584100BBE4E3221011410F9BE5B2910159414909F4B17251114109CA841F47025941F1959982F06F1141C171FA2417035941536AA3E0C38B1141C3D3105E5E03594189D1BA101998114182F3D4E404045941896F51ABC3BA114119BEEC70E104594121CE0FAED1D2114126E3F71CF7025941C0FB10AF9EE311411B415135980059412E1F6FE2C1F51141DF7A24DC7EFC5841D59649F5B1041241ECD7A17120FB58414A60019FCC1E1241BD1FD6980BF758410AD99514CB141241F428490878F65841B3845C2D3B1B1241A7CC0D8F18F558417CC7F388F61612419E5B6E6EDEF258416D238726C4181241DCAB45B6C4F058413A46C62D95101241AA1F23C5FBEE5841DA1B2695960D12416F89567602EC584137817FD00B0F1241A175A0DEEAEB584113A9753A3D261241363A8C862BEC584164235CE7ED2D124166ACAACBE3EB584109FA01C186351241F18B43C2E4EB58415BD5A127C943124124162B1DFAEA58410D563E8BEA4312412339326DCBEA584146A03ED3054C12411BB972B475EA58410960053B20521241A405C199AFEA58414A36893900561241873E2D007CEA5841CCB73EE2955712410ED961710DEB5841B46C433B725312418FED0C6B6FEB5841FE3282F5AB55124112E458CC5CEB5841E36CDFC0785B124190253F98A3EB5841A71C388A9F5E1241994036D443EC58419132FB1752661241DA08C08CC6EC5841D474D3E2C16C12413EBC7CCD79EC584134A67E5D82761241F174B88083EB5841DD99A1B4297C12415A617E6E8CEC5841F9B9BDCE1687124132231995C6EB5841DDEFC77C7AA8124189E2DFFC46ED5841C8DB980C76AC12417D9771599BED5841CB0EA05AA8BF1241BC4ED38549ED5841C6F1FA5CB3C512411C5BF4FE6EEF5841767BC26C2ACA12418439EE368FEF5841E83A222F6CC71241729792050BF05841A8732962BBCD1241A3D6CBFE5CF05841DC0FEA7F9BD712412205473B5AF058414EC6AABDF9D5124133C55ACA1BF1584172B95C1FE9DD1241E79F07E0A4F1584194C6F3D337DE1241E2A1DC1C1DF258414373CD7F5DE5124144A8AFA2AEF2584153721E1F4EE41241DC2BD4531BF45841CEAB23A5E4E6124145174CC85EF45841A29D54EDB3E21241C60E91D399F458412D00EB59F8E612417CD1C190E3F4584132C610A342EB1241A0A3DB8BF1F45841D79E87E6D9E81241D242BA3F69F55841003936346FEA1241EAF6A7F5BEF55841234303B7BAE31241F4E1B65701F65841F2684DC795E31241CB947F7F4CF65841D75F0201EDEA1241B95D1E4899F65841CEC1964B96EB1241918EBCDAE9F658415C19D843C1ED124117D2A73DF4F658419F299C94F8EB1241480B02C926F75841DCA495792DF112414B6FA6845CF75841F296187874F412413A81800F09F8584105000000DB25D2B9108C20418456967219C05941DC9F0787AD8C20413CD8078B09C05941289ABBA6ED8C20415FB532890BC0594196CB41113D8C204121D6519C1CC05941DB25D2B9108C20418456967219C059410103000000010000000F00000000000000B0B82441000000E03F0C584100000000AFB82441000000E08B295841000000009F912441000000008C2958418241EB049F9124410E2E3E069052584100000000AFB824410000002090525841B9CE242BAFB824413D3BC711BE745841000000006741254100000020BE745841B9CE242B674125413D3BC7110A925841C9D9398ED84C27412D669B1A0A925841775E83ECD84C2741A90EC1F3056958410000000021C42641000000E0056958414731DBD420C42641C3C438EE8B2958410000000049ED2541000000E08B295841998AF76148ED25412D946FE23F0C584100000000B0B82441000000E03F0C584101030000000100000005000000000000004112274100000000D3AF5841C90CFB4ADFA426419A615FE9D2AF5841C90CFB4ADFA42641669EA0160EBB584137F304B540122741669EA0160EBB5841000000004112274100000000D3AF5841'), 3006));

create table lmv_bright.inre_norrland_roads (
    gid int primary key,
    kkod integer,
    kategori varchar(50),
    vagnr1 varchar(8),
    vagnr2 varchar(8),
    vagnr3 varchar(8),
    vagnr4 varchar(8),
    bklass smallint,
    hmark smallint,
    the_geom geometry
);

insert into lmv_bright.inre_norrland_roads
    select
        vagk_vl.gid,
        kkod,
        kategori,
        vagnr1,
        vagnr2,
        vagnr3,
        vagnr4,
        bklass,
        hmark,
        st_difference(ST_SetSRID(vagk_vl.the_geom, 3006), ST_SetSRID(c.the_geom, 3006)) AS d
    from vagk_vl, lmv_bright.terrang_coverage_simple as c;
