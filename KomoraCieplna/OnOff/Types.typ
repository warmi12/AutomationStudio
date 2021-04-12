TYPE
	cOnOffTyp : STRUCT 
		Out : REAL; (* Zmienna steruj¹ca CV - Output *)
		ActValue : REAL; (* Zmienna pomierzona PV - Input*)
		SetValue : REAL; (* Zmienna zadana SP - Input*)
		uiError : REAL; (* B³¹d regulacji SP-PV - Calc*)
		Enable : BOOL; (* Aktywacja algorytmu - wysterowanie z poziomu KomCont*)
	END_STRUCT;
	cOnOffParTyp : STRUCT
		uiCVmax : REAL; (* Amplituda max sygna³u CV *)
		uiCVmin : REAL; (* Ampliuda min sygna³u CV *)
		uiEmax : REAL; (* Maksymalne odchylenie PV od SP *)
		uiEmin : REAL; (* Minimalne ochylenie PV od SP *)
		uiPVmax : REAL; (* Maksymalna wartoœæ PV *)
		uiPVmin : REAL; (* Minimalna wartoœæ PV *)
		uiLicznik : INT; (* Zmienna decyduj¹ca po ilu przejsciach proces mo¿e byæ w stanie ustalonym *)
		uiAutoTuningOnOff : BOOL:=TRUE; (* Zmienna w³¹czaj¹ca lub wy³¹czaj¹ca auto strojenie *)
	END_STRUCT;
	
	AutoTuningTyp : STRUCT
		fTempOnOff : BOOL; (* flaga do wyznaczenia wykresuy PU *)
		flag : BOOL:=FALSE; (* flaga do sprawdzenia czy przy edgepos wystartowaæ, czy zakoñczyc zegar *)
		P : REAL; (* zmienna mierz¹ca okres *)
		Amplituda : REAL; (* Zmienna przechowuj¹ca Amax-Amin *)
		Amax : REAL; (* Zmienna przechowuj¹ca maksymalne odchylenie aplitudy  *)
		Amin : REAL; (* Zmienna przechowuj¹ca minimalne odchylenie aplitudy  *)
		K : REAL; (* Zmienna K wyliczona ze wzoru *)
		fLicznik : INT; (* Licznik, który kontroluje przejscie procesu w stan ustalony *)
		H : REAL;
	END_STRUCT;
	
	
END_TYPE