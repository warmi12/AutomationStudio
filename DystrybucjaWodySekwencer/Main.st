
PROGRAM _INIT
	(* Insert code here *)
	 Sterowanie:= INITIAL;
END_PROGRAM

PROGRAM _CYCLIC
	(* Maszyna stanu do systemu dystrybucji wody *)
	
	CASE Sterowanie OF
		INITIAL:
			FOR i:=0 TO 9 DO
				ZegarTON[i].IN:=FALSE; (*KAsowanie stanmów zegara*)
				ZegarTON[i]();
			END_FOR;

	
			DystrybucjaCieczy.Operator.doSystemAktywny:=(DystrybucjaCieczy.Operator.diStart OR 
			DystrybucjaCieczy.Operator.doSystemAktywny) AND DystrybucjaCieczy.Operator.diEStop 
			AND DystrybucjaCieczy.Operator.diStop;
			
			IF (DystrybucjaCieczy.Operator.doSystemAktywny AND DystrybucjaCieczy.Pompa.diTermik) THEN
				Sterowanie:=ROZRUCH;
			END_IF;
			
			IF (DystrybucjaCieczy.Operator.doSystemAktywny AND NOT(DystrybucjaCieczy.Pompa.diTermik)) THEN
				(*Wpisujemy indeks do tablicy alarmow i przekazujemy do bazy danych*)
				Sterowanie:=AWARIA;
			END_IF;
			
		ROZRUCH:
			ZegarTON[1].IN:=NOT(DystrybucjaCieczy.Pompa.diTermik);
			ZegarTON[1].PT:=REAL_TO_TIME(DystrybucjaCieczyPar.uiCzasSensor[0]*1000);
			ZegarTON[1]();

			ZegarTON[2].IN:=TRUE;
			ZegarTON[2].PT:=REAL_TO_TIME(DystrybucjaCieczyPar.uiCzasSensor[0]*1000);
			ZegarTON[2]();

			DystrybucjaCieczy.Pompa.doPompa:=TRUE; //akcja
			
			IF (DystrybucjaCieczy.Pompa.diCisnienieMin AND DystrybucjaCieczy.Pompa.diPrzeplywMin) THEN
				Sterowanie:=POMPOWANIE;
			END_IF;
			IF NOT(DystrybucjaCieczy.Operator.diStop) THEN
				Sterowanie:= WYBIEG;
			END_IF;
			IF NOT(DystrybucjaCieczy.Operator.diStop) THEN
				Sterowanie:=AWARIA;
			END_IF;
			IF ZegarTON[1].Q THEN
				(*Wprowadz indeks DO tablicy alarmów*)
				Sterowanie:=AWARIA;
			END_IF;
			IF ZegarTON[2].Q THEN
				(*Wprowadz indeks do tablicy alarmów*)
				Sterowanie:=AWARIA;
			END_IF;

						
		POMPOWANIE:
			ZegarTON[1].IN:=NOT(DystrybucjaCieczy.Pompa.diTermik);
			ZegarTON[1].PT:=REAL_TO_TIME(DystrybucjaCieczyPar.uiCzasSensor[1]*1000);
			ZegarTON[1]();

			ZegarTON[3].IN:=NOT(DystrybucjaCieczy.Pompa.diCisnienieMin);
			ZegarTON[3].PT:=REAL_TO_TIME(DystrybucjaCieczyPar.uiCzasSensor[3]*1000);
			ZegarTON[3]();

			ZegarTON[4].IN:=NOT(DystrybucjaCieczy.Pompa.diPrzeplywMin);
			ZegarTON[4].PT:=REAL_TO_TIME(DystrybucjaCieczyPar.uiCzasSensor[4]*1000);
			ZegarTON[4]();

			IF NOT(DystrybucjaCieczy.Operator.diStop) THEN
				Sterowanie:=WYBIEG;
			END_IF;
			IF NOT(DystrybucjaCieczy.Operator.diStop) THEN
				Sterowanie:=AWARIA;
			END_IF;
			IF ZegarTON[1].Q THEN
				(*Wprowadz indeks DO tablicy alarmów*)
				Sterowanie:=AWARIA;
			END_IF;	
			IF ZegarTON[3].Q THEN
				(*Wprowadz indeks DO tablicy alarmów*)
				Sterowanie:=AWARIA;
			END_IF;	
			IF ZegarTON[4].Q THEN
				(*Wprowadz indeks DO tablicy alarmów*)
				Sterowanie:=AWARIA;
			END_IF;	
		WYBIEG:
			DystrybucjaCieczy.Pompa.doPompa:=FALSE;

			ZegarTON[1].IN:=NOT(DystrybucjaCieczy.Pompa.diTermik);
			ZegarTON[1].PT:=REAL_TO_TIME(DystrybucjaCieczyPar.uiCzasSensor[0]*1000);
			ZegarTON[1]();

			IF (NOT(DystrybucjaCieczy.Pompa.diCisnienieMin) AND NOT(DystrybucjaCieczy.Pompa.diPrzeplywMin)) THEN
				DystrybucjaCieczy.Operator.doSystemAktywny:=FALSE;
				Sterowanie:=INITIAL;
			END_IF;
			IF NOT(DystrybucjaCieczy.Operator.diStop) THEN
				(*Wprowadz indeks DO tablicy alarmów*)
				Sterowanie:=AWARIA;
			END_IF;
			IF ZegarTON[1].Q THEN
				(*Wprowadz indeks DO tablicy alarmów*)
				Sterowanie:=AWARIA;
			END_IF;			
							
			
		AWARIA:
			DystrybucjaCieczy.Operator.doSystemAktywny:=FALSE;
			DystrybucjaCieczy.Pompa.doPompa:=FALSE;
			ZegarTON[0].IN:=NOT(ZegarTON[0].Q);
			ZegarTON[0].PT:=T#300ms;
			ZegarTON[0]();
			DystrybucjaCieczy.Operator.doAwaria:=DystrybucjaCieczy.Operator.doAwaria XOR ZegarTON[0].Q;
			IF (DystrybucjaCieczy.Operator.diKasujAwaria AND DystrybucjaCieczy.Pompa.diTermik AND DystrybucjaCieczy.Operator.diStop) THEN 
				DystrybucjaCieczy.Operator.doAwaria:=FALSE;
				(*Potwierdzamy alarm i przekazujemy do bazy danych*)
				Sterowanie:=INITIAL;
			END_IF

	END_CASE;
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

