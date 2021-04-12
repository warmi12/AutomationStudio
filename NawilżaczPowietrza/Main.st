
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(*Rozruch*)
	Operator.doSystemAktywny:=(Operator.diStart OR Operator.doSystemAktywny) 
	AND Operator.diStop AND Operator.diEStop AND NOT (Operator.doAwaria);
	

	
	(*Utrzymywanie wilgotnosci i temperatury*)
	Hala.doNawilzacz:= (NOT(Hala.diTemperatura[1])OR Hala.diWilgotnosc) AND Operator.doSystemAktywny;

	Hala.doGrzalka[0]:= ((NOT(Hala.diTemperatura[0]) AND Hala.diTemperatura[1] AND NOT(Hala.doNawilzacz)) 
	OR (NOT(Hala.diTemperatura[0]) AND NOT(Hala.diTemperatura[1]) AND Hala.doNawilzacz))
	AND (Hala.diTemperatura[0] OR Hala.diTemperatura[1]  OR Hala.diWilgotnosc)
	AND Operator.doSystemAktywny; // 2 KW
	
	Hala.doGrzalka[1]:= ( (Hala.diTemperatura[0] AND Hala.diTemperatura[1] AND NOT(Hala.doNawilzacz))
	OR (NOT(Hala.diTemperatura[0]) AND Hala.diTemperatura[1] AND Hala.doNawilzacz)
	)
	AND Operator.doSystemAktywny; //8 KW
	
	Hala.doGrzalka[2]:= ((Hala.diTemperatura[0] AND Hala.diTemperatura[1] AND Hala.doNawilzacz) 
	)
	AND Operator.doSystemAktywny; //10 KW
	
	//Diagnostyka
	Operator.doAwaria:=(Hala.diTemperatura[0] AND NOT(Hala.diTemperatura[1])) 
	OR (Operator.doAwaria AND NOT(Operator.diKasujAwaria));
	 
END_PROGRAM

PROGRAM _EXIT

	 
END_PROGRAM

