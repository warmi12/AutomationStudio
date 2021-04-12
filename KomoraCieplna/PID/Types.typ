TYPE
	cPIDParTyp : STRUCT
		Kp : REAL; (* Wzmocnienie proporcjonalne *)
		Ti : REAL; (* Czas ca³kowania *)
		Td : REAL; (* Czas ró¿niczkowania *)
		Tf : REAL; (* Sta³a czasowa filtracji dolnoprzepustowej *)
		CVmax : REAL; (* Amplituda max sygna³u CV *)
		CVmin : REAL; (* Aplituda min sygna³u CV *)  
	END_STRUCT;
		  
END_TYPE