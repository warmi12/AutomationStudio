
TYPE
	ModeTyp : 
		(
		NONE := 0, (* Nie wybrany algorytm *)
		MANUAL := 1, (*Sterowanie rêczne*)
		ONOFF := 2, (* Algorytm dwustawny *)
		PID := 3, (* ALgorytm PID *)
		FUZZY := 4, (* Algorytm rozmyty *)
		ADRC := 5, (* Algortym adaptacyjny *)
		DEADBEAT :=6 (* Algorytm cyfrowy dead beat *)
		);
	KomoraTyp : 	STRUCT 
		aoHeater : INT; (* Wysterowanie grza³ki *)
		aoFan : INT; (* Wysterowanie wentylatora *)
		aiTemperature : INT; (* Pomiar temperatury -> PT1000 *)
		uiHeater : REAL; (* Wysterowanie grza³ki -> GUI [%]*)
		uiFan : REAL; (* Wysterowanie wentylatora -> GUI [%] *)
		uiTemperature : REAL; (* Pomiar temperatury -> PT1000 -> GUI [oC] *)
		Heater : AnalogActuatorTyp;
		Fan : AnalogActuatorTyp;
		Temperature : AnalogSensorTyp;
		TemperatureOutSide : AnalogSensorTyp;
	END_STRUCT;
	
	sKomoraParTyp : STRUCT
		k : REAL; (* Wzmocnienie czêœci proporcjonalnej - skalowanie strumieñ ciep³a - wartoœæ temperatury*)
		T1 : REAL; (* Sta³a czasowa bezw³adnoœci [s -default, min, h] *)
		T2 : REAL; (* Sta³a czasowa bezw³adnoœci [s -default, min, h] *)
	END_STRUCT;
	
	AnalogActuatorTyp : 	STRUCT 
		aoValue : INT;
		uiStatus : USINT;
		uiValue : REAL;
	END_STRUCT;
	AnalogSensorTyp : 	STRUCT 
		aiValue : INT;
		uiStatus : USINT;
		uiValue : REAL;
	END_STRUCT;
	OperatorTyp : 	STRUCT 
		Heater : AnalogActuatorTyp; (* Do sterowania rêcznego grzaniem -> suwak i pole num *)
		Fan : AnalogActuatorTyp; (* Do sterowania rêcznego wentylowaniem -> suwak i pole num *)
		diStart : BOOL; (* Przycisk Start - inicjowanie pracy systemu *)
		diStop : BOOL; (* Przycisk Stop - zatrzymywanie pracy systemu *)
		diEStop : BOOL:= TRUE; (* Przycisk EStop - zatrzymywanie pracy systemu Emergency Switch*)
		doSystemAktywny : BOOL; (* Lampka system aktywny *)
		uiStart : BOOL; (* Kontrolka Start - inicjowanie pracy systemu - GUI*)
		uiStop : BOOL; (* Kontrolka Stop - zatrzymywanie pracy systemu - GUI*)
		uiSystemAktywny : BOOL; (* Kontrolka system aktywny - GUI*)
		diReset : BOOL; (* Przycisk kasowania awarii *)
		doAlarm : BOOL; (* Lampka awaria *)
		uiReset : BOOL; (* Kontrolka-dotyk kasowania awarii - GUI*)
		uiAlarm : BOOL; (* Kontrolka - Lampka awaria - GUI*)
		GUI : GUITyp; (* Zmienna z³o¿ona do sterowania elementami graficznymi *)
	END_STRUCT;
	
	GUITyp : STRUCT
		uiEnableSimulation : BOOL:= TRUE; (* Aktywacja symulacji komory cieplnej*)
		uiLockWindow : USINT;
		ShowLayer : LayerTyp;
		Units : UnitTyp;
	END_STRUCT;
	
	UnitTyp : STRUCT
		uiHeater : USINT;
		uiTemperature : USINT;
	END_STRUCT;
	
	LayerTyp : STRUCT
		Manual : USINT;
		OnOff : USINT;
		PID : USINT;
	END_STRUCT;
	
END_TYPE
