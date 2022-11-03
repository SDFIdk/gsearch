SELECT '005_create_fonetik.sql ' || now();


CREATE SCHEMA IF NOT EXISTS fonetik;

ALTER SCHEMA fonetik OWNER TO postgres;

COMMENT ON SCHEMA fonetik IS 'Phonetic rules and functions';

SET default_tablespace = '';

SET default_table_access_method = heap;

DROP TABLE IF EXISTS fonetik.fonetiskregel;

CREATE TABLE fonetik.fonetiskregel (
    regelnr integer,
    type integer,
    s1 character varying(50),
    s2 character varying(50),
    s3 character varying(50),
    vejfonetik integer,
    normalisering integer
);

ALTER TABLE fonetik.fonetiskregel OWNER TO postgres;

INSERT INTO fonetik.fonetiskregel
    VALUES (1, 1, '.', ' ', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (2, 1, '''', ' ', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (3, 1, '-', ' ', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (4, 1, ',', ' ', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (5, 1, '  ', ' ', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (6, 1, '  ', ' ', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (7, 1, '  ', ' ', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (8, 1, 'È', 'E', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (9, 1, 'É', 'E', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (10, 1, ' V ', ' VEJ ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (11, 1, 'VEJ ', ' VEJ ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (12, 1, 'VEJEN ', ' VEJ ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (13, 1, ' LDV ', ' LANDEVEJ ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (14, 1, 'ALLE ', ' ALLE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (15, 1, 'ALLEEN ', ' ALLE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (16, 1, 'KLOSTERET', 'KLOSTRET', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (17, 1, 'GADE ', ' GADE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (18, 1, 'GADEN ', ' GADE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (19, 1, 'PLADS ', ' PLADS ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (20, 1, 'PLADSEN ', ' PLADS ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (21, 1, 'VÆNGE ', ' VÆNGE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (22, 1, 'VÆNGET ', ' VÆNGE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (23, 1, 'FALDET', 'FALD', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (24, 1, 'VANG', ' VANG', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (25, 1, 'VANGEN', ' VANG', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (26, 1, 'MARK ', ' MARK ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (27, 1, 'MARKEN ', ' MARK ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (28, 1, 'KVARTER ', ' KVARTER ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (29, 1, 'KVARTERET ', ' KVARTER ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (30, 1, ' KV ', ' KVARTER ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (31, 1, 'HAVEFORENING ', ' HAVEFORENING ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (32, 1, 'HAVEFORENINGEN ', ' HAVEFORENING ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (33, 1, 'TORV ', ' TORV ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (34, 1, 'TORVET ', ' TORV ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (35, 1, 'AGER ', ' AGER ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (36, 1, 'AGEREN ', ' AGER ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (37, 1, 'STRÆDE ', ' STRÆDE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (38, 1, 'STRÆDET ', ' STRÆDE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (39, 1, 'STR ', ' STRÆDE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (40, 1, 'BOULEVARD ', ' BOULEVARD ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (41, 1, 'BOULEVARDEN ', ' BOULEVARD ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (42, 1, 'BOULEV ', ' BOULEVARD ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (43, 1, 'ÅSEN ', ' ÅSEN ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (44, 1, 'PARK ', ' PARK ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (45, 1, 'PARKEN ', ' PARK ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (46, 1, 'HAVE ', ' HAVE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (47, 1, 'HAVEN ', ' HAVE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (48, 1, 'STRAND ', ' STRAND ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (49, 1, 'STRANDEN ', ' STRAND ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (50, 1, 'BAKKE ', ' BAKKE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (51, 1, 'BAKKEN ', ' BAKKE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (52, 1, 'MØLLE ', ' MØLLE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (53, 1, 'MØLLEN ', ' MØLLE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (54, 1, 'MOSE ', ' MOSE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (55, 1, 'MOSEN ', ' MOSE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (56, 1, 'HUSE ', ' HUSE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (57, 1, 'HUSENE ', ' HUSE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (58, 1, 'HAVN ', ' HAVN ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (59, 1, 'HAVNEN ', ' HAVN ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (60, 1, 'SKOV ', ' SKOV ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (61, 1, 'SKOVEN ', ' SKOV ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (62, 1, 'BY ', ' BY ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (63, 1, 'BYEN ', ' BY ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (64, 1, 'STADION ', ' STADION ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (65, 1, 'KIRKE ', ' KIRKE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (66, 1, 'KIRKEN ', ' KIRKE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (67, 1, 'KÆR ', ' KÆR ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (68, 1, 'KÆRET ', ' KÆR ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (69, 1, 'HAVEF ', ' HAVEFORENING ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (70, 1, 'GYDE ', ' GYDE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (71, 1, 'GYDEN ', ' GYDE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (72, 1, 'TOFT ', ' TOFT ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (73, 1, 'TOFTEN ', ' TOFT ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (74, 1, 'ELME ', ' ELME ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (75, 1, 'ELMENE ', ' ELME ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (76, 1, 'STI ', ' STI ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (77, 1, 'STIEN ', ' STI ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (78, 1, 'OVERDREV ', ' OVERDREV ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (82, 1, ' (NORD) ', ' N ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (83, 1, ' (SYD) ', ' S ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (84, 1, ' NORDRE', ' NORDRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (85, 1, ' NØRRE', ' NORDRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (86, 1, ' NR ', ' NORDRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (87, 1, ' NDR ', ' NORDRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (88, 1, ' SØNDER', ' SØNDRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (89, 1, ' SØNDRE', ' SØNDRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (90, 1, ' SDR ', ' SØNDRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (91, 1, ' ØSTRE', ' ØSTRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (92, 1, ' ØSTER', ' ØSTRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (93, 3, ' Ø ', ' ØSTRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (94, 1, ' VESTRE', ' VESTRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (95, 1, ' VESTER', ' VESTRE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (96, 1, ' LILLE ', ' LILLE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (97, 1, ' LL ', ' LILLE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (98, 1, ' GL ', ' GAMMEL ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (99, 1, ' GAMMEL', ' GAMMEL ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (100, 1, ' GAMLE', ' GAMMEL ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (101, 1, ' VED ', ' VED ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (102, 1, ' NY ', ' NY ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (103, 1, ' SKT ', ' SANKT ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (104, 1, ' SANKT ', ' SANKT ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (105, 1, ' SCT ', ' SANKT ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (106, 1, ' STORE ', ' STORE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (107, 1, 'ST ST ', 'STEN STENSEN ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (108, 1, 'ST BLICH', 'STEN BLICH', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (109, 3, ' ST ', ' STORE ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (110, 1, ' ST ', ' STATIONS ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (111, 1, ' CHR ', ' CHRISTIAN ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (112, 1, ' ERH ', ' ERHARD ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (113, 1, 'EJNAR ', ' EJNER ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (114, 1, ' FRITS ', ' FRITZ ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (115, 1, 'KR BJERR', 'KRESTEN BJERR', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (116, 1, 'KR BERT', 'KRESTEN BERT', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (117, 1, 'PIBE ', 'PIBER ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (118, 1, ' DR ALEXANDRINE', ' DRONNING ALEXANDRINE', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (119, 1, ' DR CHRISTINE', ' DRONNING CHRISTINE', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (120, 1, ' DR LOUISE', ' DRONNING LOUISE', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (121, 1, ' DR THYRA', ' DRONNING THYRA', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (122, 1, ' DR DAGMAR', ' DRONNING DAGMAR', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (123, 1, ' DR INGRID', ' DRONNING INGRID', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (124, 1, ' DR MARGRETHE', ' DRONNING MARGRETHE', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (125, 1, ' DR ', ' DOKTOR ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (126, 1, 'BORGM ', 'BORGMESTER ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (127, 1, ' HC ', ' H C ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (128, 1, ' TH ', ' T ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (129, 1, ' JOHS ', ' JOHANNES ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (130, 1, ' KR ', ' K ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (131, 1, ' FR ', ' FREDERIK ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (132, 1, ' H/F ', ' HAVEFORENING ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (133, 1, ' HVF ', ' HAVEFORENING ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (134, 1, ' FRBERG ', ' FREDERIKSBERG ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (135, 1, ' FRBORG ', ' FREDERIKSBORG ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (136, 1, ' THS ', ' THOMAS ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (137, 1, ' HAVEKOLN ', ' HAVEKOLONI ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (138, 1, ' SV ', ' SVEND ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (139, 1, ' RS ', ' RASMUS ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (140, 1, ' H/F ', ' HAVEFORENING ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (141, 1, ' FJERRITSL ', ' FJERRITSLEV ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (142, 1, ' HF ', ' HAVEFORENING ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (143, 1, ' VALD ', ' VALDEMAR ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (144, 1, ' HAVEK ', ' HAVEKOLONI ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (145, 1, 'ALAHARMA', 'ALAHÄRMÄ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (146, 2, '*S ', '* ', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (147, 2, 'KJ*', 'K*', 'EÆØ', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (148, 2, 'KI*', 'K*', 'EÆØ', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (149, 1, 'OEHL', 'Ø', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (150, 1, 'SCHL', 'SL', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (151, 1, 'HUI', 'VI', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (152, 1, 'BOUL', 'BUL', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (153, 1, '&', ' OG ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (154, 1, 'Ü', 'Y', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (155, 1, 'Y', 'Y', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (156, 1, 'AA', 'Å', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (157, 1, 'Å', 'O', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (158, 1, 'Æ', 'E', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (159, 1, 'Ä', 'E', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (160, 1, 'Ö', 'Ø', NULL, 1, 1);

INSERT INTO fonetik.fonetiskregel
    VALUES (161, 1, 'AU', 'AV', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (162, 1, 'QUI', 'KVI', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (163, 1, ' X', ' S', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (164, 1, ' CZ', ' SJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (165, 1, ' CS', ' SJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (166, 1, ' TCH', ' SJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (167, 1, 'Q', 'K', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (168, 1, 'X', 'KS', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (169, 1, 'Z', 'S', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (170, 1, 'IC ', 'IS ', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (171, 1, 'TCH ', 'SJ ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (172, 2, 'C*', 'S*', 'EIYØ', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (173, 1, 'W', 'V', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (174, 2, ' H*', ' *', 'BCDFGHJKLMNPRSTV', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (175, 1, 'GG', 'K', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (176, 1, 'NN', 'ND', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (177, 4, '', '', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (178, 1, ' PH', ' F', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (179, 2, 'PH*', 'P*', 'OØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (180, 1, 'PH', 'F', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (181, 2, '*B', '*P', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (182, 1, 'PF', 'F', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (183, 1, ' CHO', ' KO', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (184, 2, ' CH*', ' SJ*', 'AEIOUYØ', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (185, 2, 'SCHO*', 'SKOV', 'UV', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (186, 1, 'SCH', 'SJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (187, 1, 'C', 'K', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (188, 1, 'SH', 'SJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (189, 2, '*H', '*', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (190, 1, 'AR ', 'A ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (191, 2, 'AR*', 'A*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (192, 1, 'ARE', 'A', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (193, 4, '', '', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (194, 1, ' BIE', ' BI', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (195, 1, ' PIE', ' PI', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (196, 1, ' SIE', ' SI', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (197, 1, ' GIE', ' GI', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (198, 1, ' KIE', ' KI', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (199, 1, ' SKIE', ' SKE', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (200, 1, ' HIE', ' JE', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (201, 2, '*E', '*', 'AEIOUYØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (202, 2, '*I', '*J', 'AEIOUYØ', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (203, 2, '*Y', '*J', 'AEIOUYØ', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (204, 2, 'I*', 'J*', 'AEIOUYØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (205, 2, 'Y*', 'J*', 'AEIOUYØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (206, 1, ' HJ', ' J', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (207, 2, ' GJ*', ' G*', 'EØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (208, 2, 'KJ*', 'K*', 'EØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (209, 1, 'EU', 'ØJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (210, 1, 'ØV ', 'EV ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (211, 2, 'ØV*', 'EV*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (212, 2, '*U', 'OV', 'AO', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (213, 1, 'Y', 'Y', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (214, 2, '*D ', '* ', 'AEIOUYØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (215, 2, 'AD*', 'A*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (216, 2, 'ED*', 'E*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (217, 2, 'ID*', 'I*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (218, 2, 'OD*', 'O*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (219, 2, 'UD*', 'U*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (220, 2, 'YD*', 'Y*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (221, 2, 'ØD*', 'Ø*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (222, 2, '*DE', '*', 'AEIOUYØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (223, 2, 'EG*', 'EJ*', 'LN', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (224, 2, 'AG*', 'OV*', 'LN', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (225, 2, 'OG*', 'OV*', 'LN', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (226, 2, '*G ', '* ', 'AEIOUYØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (227, 2, 'AG*', 'A*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (228, 2, 'EG*', 'E*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (229, 2, 'IG*', 'I*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (230, 2, 'OG*', 'O*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (231, 2, 'UG*', 'U*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (232, 2, 'YG*', 'Y*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (233, 2, 'ØG*', 'Ø*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (234, 2, '*GE', '*', 'AEIOUYØ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (235, 1, 'AV', 'OV', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (236, 1, 'OVG ', 'OV ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (237, 2, 'OVG*', 'OV*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (238, 1, 'OVGE', 'OV', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (239, 2, '*H', '*', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (240, 1, 'AJ', 'EJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (241, 1, 'OJ', 'ØJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (242, 2, '*D', '*', 'LN', 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (243, 1, 'LG ', 'L ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (244, 1, 'LV ', 'L ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (245, 1, 'RG ', 'R ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (246, 1, 'RV ', 'R ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (247, 2, 'LG*', 'L*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (248, 2, 'LV*', 'L*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (249, 2, 'RG*', 'R*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (250, 2, 'RV*', 'R*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (251, 1, 'LGE', 'LE', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (252, 1, 'LVE', 'LE', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (253, 1, 'RGE', 'RE', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (254, 1, 'RVE', 'RE', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (255, 2, '*G', '*K', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (256, 2, '*D', '*T', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (257, 4, '', '', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (258, 1, 'TS', 'S', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (259, 2, '*ST', '*S', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (260, 1, 'SS', 'S', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (261, 1, ' TJ', ' SJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (262, 2, '*SJ', '*S', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (263, 1, ' STJ', ' SJ', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (264, 2, '*ST', '*S', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (265, 2, ' SJ*', ' S*', 'BCDFGHJKLMNPRSTV', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (266, 1, 'SS', 'S', NULL, 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (267, 2, '*M', '*N', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (268, 2, '*NK ', '*N ', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (269, 2, '*NKB', '*NB', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (270, 2, '*NKC', '*NC', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (271, 2, '*NKD', '*ND', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (272, 2, '*NKF', '*NF', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (273, 2, '*NKG', '*NG', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (274, 2, '*NKH', '*NH', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (275, 2, '*NKJ', '*NJ', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (276, 2, '*NKK', '*NK', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (277, 2, '*NKL', '*NL', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (278, 2, '*NKM', '*NM', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (279, 2, '*NKN', '*NN', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (280, 2, '*NKP', '*NP', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (281, 2, '*NKR', '*NR', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (282, 2, '*NKS', '*NS', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (283, 2, '*NKT', '*NT', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (284, 2, '*NKV', '*NV', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 0, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (285, 1, 'NN', 'N', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (286, 4, '', '', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (287, 4, '', '', NULL, 1, 0);

INSERT INTO fonetik.fonetiskregel
    VALUES (288, 1, ' ', '', NULL, 1, 1);

