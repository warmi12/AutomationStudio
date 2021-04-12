
PROGRAM _INIT
	(* Insert code here *)
	Operator[0].GUI.Units.uiHeater:=1; (* Jednostki wydajnoœci grza³ki : 0=int, 1=%,2-volt *)
	Operator[0].GUI.Units.uiTemperature:=1	;(* Jednostki temp : 0=int, 1=oC,2-oF *)
END_PROGRAM

PROGRAM _CYCLIC
	(* Kooperacja z Matlab/Simulink *)
	gTemperaturePV:= Komora[0].Temperature.uiValue;
	gTemperatureSP:= gKomoraPar[0].TemperatureSP;
	gError:= gKomoraPar[0].TemperatureSP - Komora[0].Temperature.uiValue;
	(* Procedura Uruchamiania i zatrzymywania procesu *)

	Operator[0].uiSystemAktywny:= (Operator[0].uiStart OR Operator[0].uiSystemAktywny)	AND
	NOT(Operator[0].uiStop) AND Operator[0].diEStop; (* Aktywacja systemu z priorytetem na Stop *)
	
	gOperator.Enable:= Operator[0].uiSystemAktywny;//Przekazanie flagi do zmiennej globalnej -> aktywacja OnOff, PID itd
	
	Komora[0].TemperatureOutSide.uiValue:= INT_TO_REAL(Komora[0].TemperatureOutSide.aiValue); //Temperatura otoczenia 


	
	IF Operator[0].GUI.uiEnableSimulation THEN
		(* Komora symulowana - model PT2 *)
		sKomora[0].Enable:= gOperator.Enable; //System aktywny
		sKomora[0].Gain:= sKomoraPar[0].k; //Wzmocnienie proporcjonalne
		sKomora[0].TimeConstant1:= sKomoraPar[0].T1; //Sta³a czasowa T1 
		sKomora[0].TimeConstant2:= sKomoraPar[0].T2; //Sta³a czasowa T2
		sKomora[0](); //FUB - function update block
		Komora[0].Temperature.uiValue:= sKomora[0].Out; (* Komora symulowana *)
		sKomora[0].Update:= EDGEPOS(gOperator.Enable); //Wczytanie k, T1, T2 do rejestrów modelu
		gHeaterCV:= sKomora[0].In;
	ELSE
		Komora[0].Temperature.uiValue:= INT_TO_REAL(Komora[0].Temperature.aiValue);(* Komora rzeczywista *)
		gHeaterCV:= INT_TO_REAL(Komora[0].Heater.aoValue);
	END_IF;


	
	
	CASE Tryb[0] OF
		
		NONE:
			Komora[0].Heater.aoValue:= 0; //uiValue -> GUI
			Komora[0].Fan.aoValue:= 0;	//Rêczne sterowanie obiektem
		MANUAL:
			IF Operator[0].GUI.uiEnableSimulation THEN
					sKomora[0].In:= Operator[0].Heater.uiValue; //uiValue -> GUI
					//Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue);	//Rêczne sterowanie obiektem
				ELSE
					Komora[0].Heater.aoValue:= 	REAL_TO_INT(Operator[0].Heater.uiValue); //uiValue -> GUI
					Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue);	//Rêczne sterowanie obiektem
				END_IF; 	
		
		ONOFF:
				gOnOff.Enable:=Operator[0].uiSystemAktywny;
				IF Operator[0].GUI.uiEnableSimulation THEN
					//Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue); (* Sterowanie rêczne *)
					sKomora[0].In:= gOnOff.HeaterCV; //Pobieranie sygna³u steruj¹cego z OnOff
					gOnOff.TemperaturePV:= Komora[0].Temperature.uiValue;//Wysy³anie sygna³u pomiarowego do OnOff
				ELSE
					Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue); (* Sterowanie rêczne *)
					Komora[0].Heater.aoValue:= 	REAL_TO_INT(gOnOff.HeaterCV); //Pobieranie sygna³u steruj¹cego z OnOff
					gOnOff.TemperaturePV:= INT_TO_REAL(Komora[0].Temperature.aiValue);//Wysy³anie sygna³u pomiarowego do OnOff
				END_IF;	
		
		PID:
				gPID.Enable:=Operator[0].uiSystemAktywny;
				IF Operator[0].GUI.uiEnableSimulation THEN
					//Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue); (* Sterowanie rêczne *)
					sKomora[0].In:= gPID.HeaterCV; //Pobieranie sygna³u steruj¹cego z PID
					gPID.TemperaturePV:= Komora[0].Temperature.uiValue;//Wysy³anie sygna³u pomiarowego do PID
				ELSE
					Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue); (* Sterowanie rêczne *)
					Komora[0].Heater.aoValue:= 	REAL_TO_INT(gPID.HeaterCV); //Pobieranie sygna³u steruj¹cego z PID
					gPID.TemperaturePV:= INT_TO_REAL(Komora[0].Temperature.aiValue);//Wysy³anie sygna³u pomiarowego do PID
				END_IF;	
		FUZZY:
			Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue);
			
		ADRC:
			Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue);
			
		DEADBEAT:
			Komora[0].Fan.aoValue:= REAL_TO_INT(Operator[0].Fan.uiValue);
		

	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

