TYPE
	BathRoomTyp: STRUCT
		Suszarka : DryerTyp;
	END_STRUCT;

	DryerTyp: STRUCT
		diHand : BOOL; (* Sensor wykrywajacy onbecnosc rak *)
		doDmuchawa: BOOL; (* Wysterowanie cewki stycznika -> grza³ka + wentylator 220vac *)
		diTermik : BOOL; (* Termostat wykrywaj¹cy za gor¹ce styki stycznika *)
	END_STRUCT;
	
	BathRoomParTyp: STRUCT
		Suszarka : DryerParTyp;
	END_STRUCT;
	
	DryerParTyp: STRUCT
		uiCzasON : REAL; (*Deklaracja czasu za³¹czenie sek ->GUI *)
		uiCzasOFF: REAL; (*Deklaracja przerw sek ->GUI *)
		uiCzasPracy: WorkTimeTyp; (*£¹czny czas pracy szuszarki w trybie suszenia h,m*)
		uiLiczbaOnOff : DINT; (* Liczba za³¹czeñ suszarki *)
	END_STRUCT;
	
	WorkTimeTyp: STRUCT
		uiGodziny: REAL;
		uiSekundy: REAL;
		uiMinuty: REAL;
	END_STRUCT;

END_TYPE	