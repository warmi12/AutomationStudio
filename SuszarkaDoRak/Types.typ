TYPE
	BathRoomTyp: STRUCT
		Suszarka : DryerTyp;
	END_STRUCT;

	DryerTyp: STRUCT
		diHand : BOOL; (* Sensor wykrywajacy onbecnosc rak *)
		doDmuchawa: BOOL; (* Wysterowanie cewki stycznika -> grza�ka + wentylator 220vac *)
		diTermik : BOOL; (* Termostat wykrywaj�cy za gor�ce styki stycznika *)
	END_STRUCT;
	
	BathRoomParTyp: STRUCT
		Suszarka : DryerParTyp;
	END_STRUCT;
	
	DryerParTyp: STRUCT
		uiCzasON : REAL; (*Deklaracja czasu za��czenie sek ->GUI *)
		uiCzasOFF: REAL; (*Deklaracja przerw sek ->GUI *)
		uiCzasPracy: WorkTimeTyp; (*��czny czas pracy szuszarki w trybie suszenia h,m*)
		uiLiczbaOnOff : DINT; (* Liczba za��cze� suszarki *)
	END_STRUCT;
	
	WorkTimeTyp: STRUCT
		uiGodziny: REAL;
		uiSekundy: REAL;
		uiMinuty: REAL;
	END_STRUCT;

END_TYPE	