
TYPE
	SterowanieTyp : 
		(
		AWARIA := 5, (*oBSLUGA AWARII -> gor¹ce styki stycznika pompy, suchobieg - przep³yw poni¿ej minimum*)
		WYBIEG := 4, (*Procedura zatrzymywania -> spdek ciœnienia poni¿ej minimum i przep³ywu poni¿ej min*)
		POMPOWANIE := 3, (*Normalnia praca, utrzymywanie ciœnienia powy¿ej wiekszgo ni¿ min i przep³ywu wiekszego ni¿ min*)
		INITIAL := 1, (*Czekanie na rozruch*)
		ROZRUCH := 2 (*Porcedura rozruchowa *)
	);
	
	PumpTyp : STRUCT
		doPompa : BOOL; (*Wysterowanie stycznika pompy*)
		diTermik : BOOL := TRUE; (*TERMOSTAT wykrywaj¹cy gor¹ce styki stycznika*)
		diCisnienieMin : BOOL; (*presostat wykrywaj¹cy ciœnienie minimalne*)
		diCisnienieMax : BOOL :=TRUE;
		diPrzeplywMin : BOOL; (*Czujnik wykrywajacy przeplyw minimalny*)
		diPrzeplywMax : BOOL :=TRUE; (*Czujnik wykrywajacy przeplyw maksymalny*)
	END_STRUCT;
	
	OperatorTyp : STRUCT
		diStart : BOOL; (*Przycisk start NO*)
		diStop : BOOL := TRUE; (*Przycisk STOP NC*)
		diEStop : BOOL := TRUE; (*Wy³¹cznik bezpieczenstaw nc*)
		doSystemAktywny : BOOL; (*Lampka system aktywny*)
		doAwaria : BOOL; (*Lampka awaria*)
		diKasujAwaria : BOOL; (*Przycisk kasowania awarii*)
	END_STRUCT;
	
	DystrybucjaCieczyTyp : STRUCT
		Pompa : PumpTyp;
		Operator : OperatorTyp;
	END_STRUCT;

	SystemParTyp : STRUCT
		uiCzasSensor : ARRAY[0..9] OF REAL;(*Czas aktywnoœci sensora wykrywaj¹cego usterkê np. termik [sekundy]*)
		uiCzasWybieg : ARRAY[0..9] OF REAL;(*Czas aktywnoœci sensora wykrywaj¹cego usterkê np. termik [sekundy]*)
		uiCzasRozruch : ARRAY[0..9] OF REAL;
	END_STRUCT;
	
END_TYPE
