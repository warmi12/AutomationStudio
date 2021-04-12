
TYPE
	SterowanieTyp : 
		(
		AWARIA := 5, (*oBSLUGA AWARII -> gor�ce styki stycznika pompy, suchobieg - przep�yw poni�ej minimum*)
		WYBIEG := 4, (*Procedura zatrzymywania -> spdek ci�nienia poni�ej minimum i przep�ywu poni�ej min*)
		POMPOWANIE := 3, (*Normalnia praca, utrzymywanie ci�nienia powy�ej wiekszgo ni� min i przep�ywu wiekszego ni� min*)
		INITIAL := 1, (*Czekanie na rozruch*)
		ROZRUCH := 2 (*Porcedura rozruchowa *)
	);
	
	PumpTyp : STRUCT
		doPompa : BOOL; (*Wysterowanie stycznika pompy*)
		diTermik : BOOL := TRUE; (*TERMOSTAT wykrywaj�cy gor�ce styki stycznika*)
		diCisnienieMin : BOOL; (*presostat wykrywaj�cy ci�nienie minimalne*)
		diCisnienieMax : BOOL :=TRUE;
		diPrzeplywMin : BOOL; (*Czujnik wykrywajacy przeplyw minimalny*)
		diPrzeplywMax : BOOL :=TRUE; (*Czujnik wykrywajacy przeplyw maksymalny*)
	END_STRUCT;
	
	OperatorTyp : STRUCT
		diStart : BOOL; (*Przycisk start NO*)
		diStop : BOOL := TRUE; (*Przycisk STOP NC*)
		diEStop : BOOL := TRUE; (*Wy��cznik bezpieczenstaw nc*)
		doSystemAktywny : BOOL; (*Lampka system aktywny*)
		doAwaria : BOOL; (*Lampka awaria*)
		diKasujAwaria : BOOL; (*Przycisk kasowania awarii*)
	END_STRUCT;
	
	DystrybucjaCieczyTyp : STRUCT
		Pompa : PumpTyp;
		Operator : OperatorTyp;
	END_STRUCT;

	SystemParTyp : STRUCT
		uiCzasSensor : ARRAY[0..9] OF REAL;(*Czas aktywno�ci sensora wykrywaj�cego usterk� np. termik [sekundy]*)
		uiCzasWybieg : ARRAY[0..9] OF REAL;(*Czas aktywno�ci sensora wykrywaj�cego usterk� np. termik [sekundy]*)
		uiCzasRozruch : ARRAY[0..9] OF REAL;
	END_STRUCT;
	
END_TYPE
