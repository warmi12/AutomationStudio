TYPE
	cPIDParTyp : STRUCT
		Kp : REAL; (* Wzmocnienie proporcjonalne *)
		Ti : REAL; (* Czas ca�kowania *)
		Td : REAL; (* Czas r�niczkowania *)
		Tf : REAL; (* Sta�a czasowa filtracji dolnoprzepustowej *)
		CVmax : REAL; (* Amplituda max sygna�u CV *)
		CVmin : REAL; (* Aplituda min sygna�u CV *)  
	END_STRUCT;
		  
END_TYPE