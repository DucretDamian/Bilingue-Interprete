unit analizador_sintactico;

interface
{$codepage UTF8}
uses crt,tipos,pila_simbolos_gramaticales,Archivo,Analizador_lexico,unidad_arbol;
procedure inicializar_TAS(var TAS:tipo_tas);
procedure cargarTAS(var TAS:tipo_tas);
procedure Analizador_Sintactico_DPNR(var Fuente:FileOfChar;var arbol:t_punteroA;var error:boolean);//DEBE ESTAR LA RUTA DEL ARCHIVO, EL ARBOL Y EL ERROR
implementation
procedure inicializar_TAS(var TAS:tipo_tas);
	var i,j: TipoSimboloGramatical; 
		begin
		//Inicializar toda la TAS en nil
		for i:=VPrograma To VDatoEscr do
			for j:= Tid To pesos do
				TAS[i,j]:=nil;
		end;
procedure cargarTAS(var TAS:tipo_tas);
	begin
	
	//La TAS cargada

	// Para <Programa> ::= "biliprograma" "id" ";" <Declaracion> <Cuerpo> "biliend" ";"
	new(TAS[VPrograma, Tbiliprograma]);
	TAS[VPrograma, Tbiliprograma]^.elem[1]:= Tbiliprograma;
	TAS[VPrograma, Tbiliprograma]^.elem[2]:= Tid;
	TAS[VPrograma, Tbiliprograma]^.elem[3]:= TpuntoYcoma;
	TAS[VPrograma, Tbiliprograma]^.elem[4]:= VDeclaracion;
	TAS[VPrograma, Tbiliprograma]^.elem[5]:= VCuerpo;
	TAS[VPrograma, Tbiliprograma]^.elem[6]:= Tbiliend;
	TAS[VPrograma, Tbiliprograma]^.elem[7]:= TpuntoYcoma;
	TAS[VPrograma, Tbiliprograma]^.cant:= 7;
	// Para <Cuerpo> ::= <Sent> ";" <Cuerpo> 
	new(TAS[VCuerpo, Tid]);
	TAS[VCuerpo, Tid]^.elem[1]:= VSent;
	TAS[VCuerpo, Tid]^.elem[2]:= TpuntoYcoma;
	TAS[VCuerpo, Tid]^.elem[3]:= VCuerpo;
	TAS[VCuerpo, Tid]^.cant:= 3;

	new(TAS[VCuerpo, Tidm]);
	TAS[VCuerpo, Tidm]^.elem[1]:= VSent;
	TAS[VCuerpo, Tidm]^.elem[2]:= TpuntoYcoma;
	TAS[VCuerpo, Tidm]^.elem[3]:= VCuerpo;
	TAS[VCuerpo, Tidm]^.cant:= 3;

	new(TAS[VCuerpo, Tif]);
	TAS[VCuerpo, Tif]^.elem[1]:= VSent;
	TAS[VCuerpo, Tif]^.elem[2]:= TpuntoYcoma;
	TAS[VCuerpo, Tif]^.elem[3]:= VCuerpo;
	TAS[VCuerpo, Tif]^.cant:= 3;

	new(TAS[VCuerpo, Twhile]);
	TAS[VCuerpo, Twhile]^.elem[1]:= VSent;
	TAS[VCuerpo, Twhile]^.elem[2]:= TpuntoYcoma;
	TAS[VCuerpo, Twhile]^.elem[3]:= VCuerpo;
	TAS[VCuerpo, Twhile]^.cant:= 3;

	new(TAS[VCuerpo, Tescribir]);
	TAS[VCuerpo, Tescribir]^.elem[1]:= VSent;
	TAS[VCuerpo, Tescribir]^.elem[2]:= TpuntoYcoma;
	TAS[VCuerpo, Tescribir]^.elem[3]:= VCuerpo;
	TAS[VCuerpo, Tescribir]^.cant:= 3;

	new(TAS[VCuerpo, Tleer]);
	TAS[VCuerpo, Tleer]^.elem[1]:= VSent;
	TAS[VCuerpo, Tleer]^.elem[2]:= TpuntoYcoma;
	TAS[VCuerpo, Tleer]^.elem[3]:= VCuerpo;
	TAS[VCuerpo, Tleer]^.cant:= 3;

	// Para <Cuerpo> ::= epsilon --> {"biliend", "end", "else", $}
	new(TAS[VCuerpo, Tbiliend]);
	TAS[VCuerpo, Tbiliend]^.cant:= 0;

	new(TAS[VCuerpo, Tend]);
	TAS[VCuerpo, Tend]^.cant:= 0;

	new(TAS[VCuerpo, Telse]);
	TAS[VCuerpo, Telse]^.cant:= 0;

	// new(TAS[VCuerpo, pesos]);
	// TAS[VCuerpo, pesos]^.cant:= 0;
	// Para <Sent> ::= <Asignacion>
	new(TAS[VSent, Tid]);
	TAS[VSent, Tid]^.elem[1]:= VAsignacion;
	TAS[VSent, Tid]^.cant:= 1;

	new(TAS[VSent, Tidm]);
	TAS[VSent, Tidm]^.elem[1]:= VAsignacion;
	TAS[VSent, Tidm]^.cant:= 1;
	// Para <Sent> ::= <Condicional>
	new(TAS[VSent, Tif]);
	TAS[VSent, Tif]^.elem[1]:= VCondicional;
	TAS[VSent, Tif]^.cant:= 1;
	// Para <Sent> ::= <Ciclo>
	new(TAS[VSent, Twhile]);
	TAS[VSent, Twhile]^.elem[1]:= VCiclo;
	TAS[VSent, Twhile]^.cant:= 1;
	// Para <Sent> ::= <Escritura>
	new(TAS[VSent, Tescribir]);
	TAS[VSent, Tescribir]^.elem[1]:= VEscribir;
	TAS[VSent, Tescribir]^.cant:= 1;
	// Para <Sent> ::= <Lectura>
	new(TAS[VSent, Tleer]);
	TAS[VSent, Tleer]^.elem[1]:= VLectura;
	TAS[VSent, Tleer]^.cant:= 1;
	// Para <Asignacion> ::= "id" "opasig" <EASumRes>
	new(TAS[VAsignacion, Tid]);
	TAS[VAsignacion, Tid]^.elem[1]:= Tid;
	TAS[VAsignacion, Tid]^.elem[2]:= Topasig;
	TAS[VAsignacion, Tid]^.elem[3]:= VEASumRes;
	TAS[VAsignacion, Tid]^.cant:= 3;
	// Para <Asignacion> ::= "idm" <AsignacionT>
	new(TAS[VAsignacion, Tidm]);
	TAS[VAsignacion, Tidm]^.elem[1]:= Tidm;
	TAS[VAsignacion, Tidm]^.elem[2]:= VAsignacionT;
	TAS[VAsignacion, Tidm]^.cant:= 2;
	// Para <AsignacionT> ::= "opasig" <EMSumRes>
	new(TAS[VAsignacionT, TOpaSig]);
	TAS[VAsignacionT, TOpaSig]^.elem[1]:= TOpaSig;
	TAS[VAsignacionT, TOpaSig]^.elem[2]:= VEMSumRes;
	TAS[VAsignacionT, TOpaSig]^.cant:= 2;
	// Para <AsignacionT> ::= "[" <EASumRes> ";" <EASumRes> "]" "opasig" <EASumRes>
	new(TAS[VAsignacionT, TcorcheteA]);
	TAS[VAsignacionT, TcorcheteA]^.elem[1]:= TcorcheteA;
	TAS[VAsignacionT, TcorcheteA]^.elem[2]:= VEASumRes;
	TAS[VAsignacionT, TcorcheteA]^.elem[3]:= TpuntoYcoma;
	TAS[VAsignacionT, TcorcheteA]^.elem[4]:= VEASumRes;
	TAS[VAsignacionT, TcorcheteA]^.elem[5]:= TcorcheteC;
	TAS[VAsignacionT, TcorcheteA]^.elem[6]:= TOpaSig;
	TAS[VAsignacionT, TcorcheteA]^.elem[7]:= VEASumRes;
	TAS[VAsignacionT, TcorcheteA]^.cant:= 7;

	// Para <Condicional> ::= "if" “(“ <CondAnd> “)” "then" <Cuerpo> <CondicionalF>
	new(TAS[VCondicional, Tif]);
	TAS[VCondicional, Tif]^.elem[1]:= Tif;
	TAS[VCondicional, Tif]^.elem[2]:= TparentesisA;
	TAS[VCondicional, Tif]^.elem[3]:= VCondAnd;
	TAS[VCondicional, Tif]^.elem[4]:= TparentesisC;
	TAS[VCondicional, Tif]^.elem[5]:= Tthen;
	TAS[VCondicional, Tif]^.elem[6]:= VCuerpo;
	TAS[VCondicional, Tif]^.elem[7]:= VCondicionalF;
	TAS[VCondicional, Tif]^.cant:= 7;
	// Para <CondicionalF> ::= "end"
	new(TAS[VCondicionalF, Tend]);
	TAS[VCondicionalF, Tend]^.elem[1]:= Tend;
	TAS[VCondicionalF, Tend]^.cant:= 1;
	// Para <CondicionalF> ::= "else" <Cuerpo> "end"
	new(TAS[VCondicionalF, Telse]);
	TAS[VCondicionalF, Telse]^.elem[1]:= Telse;
	TAS[VCondicionalF, Telse]^.elem[2]:= VCuerpo;
	TAS[VCondicionalF, Telse]^.elem[3]:= Tend;
	TAS[VCondicionalF, Telse]^.cant:= 3;
	// Para <Ciclo> ::= "while" “(“ <CondAnd> “)”  "do" <Cuerpo> "end"
	new(TAS[VCiclo, Twhile]);
	TAS[VCiclo, Twhile]^.elem[1]:= Twhile;
	TAS[VCiclo, Twhile]^.elem[2]:= TparentesisA;
	TAS[VCiclo, Twhile]^.elem[3]:= VCondAnd;
	TAS[VCiclo, Twhile]^.elem[4]:= TparentesisC;
	TAS[VCiclo, Twhile]^.elem[5]:= Tdo;
	TAS[VCiclo, Twhile]^.elem[6]:= VCuerpo;
	TAS[VCiclo, Twhile]^.elem[7]:= Tend;
	TAS[VCiclo, Twhile]^.cant:= 7;
	// Para <CondAnd> ::= <CondOr> <CondAndT>
	new(TAS[VCondAnd, Tnot]);
	TAS[VCondAnd, Tnot]^.elem[1]:= VCondOr;
	TAS[VCondAnd, Tnot]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, Tnot]^.cant:= 2;

	new(TAS[VCondAnd, TConstReal]);
	TAS[VCondAnd, TConstReal]^.elem[1]:= VCondOr;
	TAS[VCondAnd, TConstReal]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, TConstReal]^.cant:= 2;

	new(TAS[VCondAnd, Tid]);
	TAS[VCondAnd, Tid]^.elem[1]:= VCondOr;
	TAS[VCondAnd, Tid]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, Tid]^.cant:= 2;

	new(TAS[VCondAnd, Tidm]);
	TAS[VCondAnd, Tidm]^.elem[1]:= VCondOr;
	TAS[VCondAnd, Tidm]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, Tidm]^.cant:= 2;

	new(TAS[VCondAnd, TparentesisA]);
	TAS[VCondAnd, TparentesisA]^.elem[1]:= VCondOr;
	TAS[VCondAnd, TparentesisA]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, TparentesisA]^.cant:= 2;

	new(TAS[VCondAnd, TsizeCol]);
	TAS[VCondAnd, TsizeCol]^.elem[1]:= VCondOr;
	TAS[VCondAnd, TsizeCol]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, TsizeCol]^.cant:= 2;

	new(TAS[VCondAnd, TsizeFila]);
	TAS[VCondAnd, TsizeFila]^.elem[1]:= VCondOr;
	TAS[VCondAnd, TsizeFila]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, TsizeFila]^.cant:= 2;

	new(TAS[VCondAnd, Tmenos]);
	TAS[VCondAnd, Tmenos]^.elem[1]:= VCondOr;
	TAS[VCondAnd, Tmenos]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, Tmenos]^.cant:= 2;

	new(TAS[VCondAnd, TcorcheteA]);
	TAS[VCondAnd, TcorcheteA]^.elem[1]:= VCondOr;
	TAS[VCondAnd, TcorcheteA]^.elem[2]:= VCondAndT;
	TAS[VCondAnd, TcorcheteA]^.cant:= 2;
	// Para <CondAndT> ::= “and” <CondOr> <CondAndT>
	new(TAS[VCondAndT, Tand]);
	TAS[VCondAndT, Tand]^.elem[1]:= Tand;
	TAS[VCondAndT, Tand]^.elem[2]:= VCondOr;
	TAS[VCondAndT, Tand]^.elem[3]:= VCondAndT;
	TAS[VCondAndT, Tand]^.cant:= 3;
	// Para <CondAndT> ::= epsilon
	new(TAS[VCondAndT, TcorcheteC]);
	TAS[VCondAndT, TcorcheteC]^.cant:= 0;

	new(TAS[VCondAndT, TparentesisC]);
	TAS[VCondAndT, TparentesisC]^.cant:= 0;
	// Para <CondOr> ::= <CondNot> <CondOrT>
	new(TAS[VCondOr, Tnot]);
	TAS[VCondOr, Tnot]^.elem[1]:= VCondNot;
	TAS[VCondOr, Tnot]^.elem[2]:= VCondOrT;
	TAS[VCondOr, Tnot]^.cant:= 2;

	new(TAS[VCondOr, TConstReal]);
	TAS[VCondOr, TConstReal]^.elem[1]:= VCondNot;
	TAS[VCondOr, TConstReal]^.elem[2]:= VCondOrT;
	TAS[VCondOr, TConstReal]^.cant:= 2;

	new(TAS[VCondOr, Tid]);
	TAS[VCondOr, Tid]^.elem[1]:= VCondNot;
	TAS[VCondOr, Tid]^.elem[2]:= VCondOrT;
	TAS[VCondOr, Tid]^.cant:= 2;

	new(TAS[VCondOr, Tidm]);
	TAS[VCondOr, Tidm]^.elem[1]:= VCondNot;
	TAS[VCondOr, Tidm]^.elem[2]:= VCondOrT;
	TAS[VCondOr, Tidm]^.cant:= 2;

	new(TAS[VCondOr, TparentesisA]);
	TAS[VCondOr, TparentesisA]^.elem[1]:= VCondNot;
	TAS[VCondOr, TparentesisA]^.elem[2]:= VCondOrT;
	TAS[VCondOr, TparentesisA]^.cant:= 2;

	new(TAS[VCondOr, TsizeCol]);
	TAS[VCondOr, TsizeCol]^.elem[1]:= VCondNot;
	TAS[VCondOr, TsizeCol]^.elem[2]:= VCondOrT;
	TAS[VCondOr, TsizeCol]^.cant:= 2;

	new(TAS[VCondOr, TsizeFila]);
	TAS[VCondOr, TsizeFila]^.elem[1]:= VCondNot;
	TAS[VCondOr, TsizeFila]^.elem[2]:= VCondOrT;
	TAS[VCondOr, TsizeFila]^.cant:= 2;

	new(TAS[VCondOr, Tmenos]);
	TAS[VCondOr, Tmenos]^.elem[1]:= VCondNot;
	TAS[VCondOr, Tmenos]^.elem[2]:= VCondOrT;
	TAS[VCondOr, Tmenos]^.cant:= 2;

	new(TAS[VCondOr, TcorcheteA]);
	TAS[VCondOr, TcorcheteA]^.elem[1]:= VCondNot;
	TAS[VCondOr, TcorcheteA]^.elem[2]:= VCondOrT;
	TAS[VCondOr, TcorcheteA]^.cant:= 2;
	// Para <CondOrT> ::= “or” <CondNot> <CondOrT>
	new(TAS[VCondOrT, Tor]);
	TAS[VCondOrT, Tor]^.elem[1]:= Tor;
	TAS[VCondOrT, Tor]^.elem[2]:= VCondNot;
	TAS[VCondOrT, Tor]^.elem[3]:= VCondOrT;
	TAS[VCondOrT, Tor]^.cant:= 3;
	// Para <CondOrT> ::= epsilon
	new(TAS[VCondOrT, Tand]);
	TAS[VCondOrT, Tand]^.cant:= 0;

	new(TAS[VCondOrT, TparentesisC]);
	TAS[VCondOrT, TparentesisC]^.cant:= 0;

	new(TAS[VCondOrT, TcorcheteC]);
	TAS[VCondOrT, TcorcheteC]^.cant:= 0;
	// Para <CondNot> ::= “not” <CondNot>
	new(TAS[VCondNot, Tnot]);
	TAS[VCondNot, Tnot]^.elem[1]:= Tnot;
	TAS[VCondNot, Tnot]^.elem[2]:= VCondNot;
	TAS[VCondNot, Tnot]^.cant:= 2;
	// Para <CondNot> ::= <EC>

	new(TAS[VCondNot, TConstReal]);
	TAS[VCondNot, TConstReal]^.elem[1]:= VEC;
	TAS[VCondNot, TConstReal]^.cant:= 1;
	
	new(TAS[VCondNot, Tid]);
	TAS[VCondNot, Tid]^.elem[1]:= VEC;
	TAS[VCondNot, Tid]^.cant:= 1;
	
	new(TAS[VCondNot, Tidm]);
	TAS[VCondNot, Tidm]^.elem[1]:= VEC;
	TAS[VCondNot, Tidm]^.cant:= 1;
	
	new(TAS[VCondNot, TparentesisA]);
	TAS[VCondNot, TparentesisA]^.elem[1]:= VEC;
	TAS[VCondNot, TparentesisA]^.cant:= 1;
	
	new(TAS[VCondNot, TsizeCol]);
	TAS[VCondNot, TsizeCol]^.elem[1]:= VEC;
	TAS[VCondNot, TsizeCol]^.cant:= 1;
	
	new(TAS[VCondNot, TsizeFila]);
	TAS[VCondNot, TsizeFila]^.elem[1]:= VEC;
	TAS[VCondNot, TsizeFila]^.cant:= 1;
	
	new(TAS[VCondNot, Tmenos]);
	TAS[VCondNot, Tmenos]^.elem[1]:= VEC;
	TAS[VCondNot, Tmenos]^.cant:= 1;

	new(TAS[VCondNot, TcorcheteA]);
	TAS[VCondNot, TcorcheteA]^.elem[1]:= VEC;
	TAS[VCondNot, TcorcheteA]^.cant:= 1;
	// Para <EC> ::= <EASumRes> “OpRel” <EASumRes>
	new(TAS[VEC, TConstReal]);
	TAS[VEC, TConstReal]^.elem[1]:= VEASumRes;
	TAS[VEC, TConstReal]^.elem[2]:= Toprel;
	TAS[VEC, TConstReal]^.elem[3]:= VEASumRes;
	TAS[VEC, TConstReal]^.cant:= 3;

	new(TAS[VEC, Tid]);
	TAS[VEC, Tid]^.elem[1]:= VEASumRes;
	TAS[VEC, Tid]^.elem[2]:= Toprel;
	TAS[VEC, Tid]^.elem[3]:= VEASumRes;
	TAS[VEC, Tid]^.cant:= 3;
	
	new(TAS[VEC, Tidm]);
	TAS[VEC, Tidm]^.elem[1]:= VEASumRes;
	TAS[VEC, Tidm]^.elem[2]:= Toprel;
	TAS[VEC, Tidm]^.elem[3]:= VEASumRes;
	TAS[VEC, Tidm]^.cant:= 3;
	
	new(TAS[VEC, TparentesisA]);
	TAS[VEC, TparentesisA]^.elem[1]:= VEASumRes;
	TAS[VEC, TparentesisA]^.elem[2]:= Toprel;
	TAS[VEC, TparentesisA]^.elem[3]:= VEASumRes;
	TAS[VEC, TparentesisA]^.cant:= 3;
	
	new(TAS[VEC, TsizeCol]);
	TAS[VEC, TsizeCol]^.elem[1]:= VEASumRes;
	TAS[VEC, TsizeCol]^.elem[2]:= Toprel;
	TAS[VEC, TsizeCol]^.elem[3]:= VEASumRes;
	TAS[VEC, TsizeCol]^.cant:= 3;
	
	new(TAS[VEC, TsizeFila]);
	TAS[VEC, TsizeFila]^.elem[1]:= VEASumRes;
	TAS[VEC, TsizeFila]^.elem[2]:= Toprel;
	TAS[VEC, TsizeFila]^.elem[3]:= VEASumRes;
	TAS[VEC, TsizeFila]^.cant:= 3;

	new(TAS[VEC, Tmenos]);
	TAS[VEC, Tmenos]^.elem[1]:= VEASumRes;
	TAS[VEC, Tmenos]^.elem[2]:= Toprel;
	TAS[VEC, Tmenos]^.elem[3]:= VEASumRes;
	TAS[VEC, Tmenos]^.cant:= 3;

	// Para <EC> ::= “[“ <CondAnd> “]”
	new(TAS[VEC, TcorcheteA]);
	TAS[VEC, TcorcheteA]^.elem[1]:= TcorcheteA;
	TAS[VEC, TcorcheteA]^.elem[2]:= VCondAnd;
	TAS[VEC, TcorcheteA]^.elem[3]:= TcorcheteC;
	TAS[VEC, TcorcheteA]^.cant:= 3;
	// Para <EASumRes> ::= <EAMultDiv> <EASumResT> 
	new(TAS[VEASumRes, TConstReal]);
	TAS[VEASumRes, TConstReal]^.elem[1]:= VEAMultDiv;
	TAS[VEASumRes, TConstReal]^.elem[2]:= VEASumResT;
	TAS[VEASumRes, TConstReal]^.cant:= 2;

	new(TAS[VEASumRes, Tid]);
	TAS[VEASumRes, Tid]^.elem[1]:= VEAMultDiv;
	TAS[VEASumRes, Tid]^.elem[2]:= VEASumResT;
	TAS[VEASumRes, Tid]^.cant:= 2;
	
	new(TAS[VEASumRes, Tidm]);
	TAS[VEASumRes, Tidm]^.elem[1]:= VEAMultDiv;
	TAS[VEASumRes, Tidm]^.elem[2]:= VEASumResT;
	TAS[VEASumRes, Tidm]^.cant:= 2;
	
	new(TAS[VEASumRes, TparentesisA]);
	TAS[VEASumRes, TparentesisA]^.elem[1]:= VEAMultDiv;
	TAS[VEASumRes, TparentesisA]^.elem[2]:= VEASumResT;
	TAS[VEASumRes, TparentesisA]^.cant:= 2;
	
	new(TAS[VEASumRes, TsizeCol]);
	TAS[VEASumRes, TsizeCol]^.elem[1]:= VEAMultDiv;
	TAS[VEASumRes, TsizeCol]^.elem[2]:= VEASumResT;
	TAS[VEASumRes, TsizeCol]^.cant:= 2;
	
	new(TAS[VEASumRes, TsizeFila]);
	TAS[VEASumRes, TsizeFila]^.elem[1]:= VEAMultDiv;
	TAS[VEASumRes, TsizeFila]^.elem[2]:= VEASumResT;
	TAS[VEASumRes, TsizeFila]^.cant:= 2;

	new(TAS[VEASumRes, Tmenos]);
	TAS[VEASumRes, Tmenos]^.elem[1]:= VEAMultDiv;
	TAS[VEASumRes, Tmenos]^.elem[2]:= VEASumResT;
	TAS[VEASumRes, Tmenos]^.cant:= 2;
	// Para <EASumResT> ::= "+"  <EAMultDiv> <EASumResT
	new(TAS[VEASumResT, Tmas]);
	TAS[VEASumResT, Tmas]^.elem[1]:= Tmas;
	TAS[VEASumResT, Tmas]^.elem[2]:= VEAMultDiv;
	TAS[VEASumResT, Tmas]^.elem[3]:= VEASumResT;
	TAS[VEASumResT, Tmas]^.cant:= 3;
	// Para <EASumResT> ::= "-" <EAMultDiv> <EASumResT>
	//MENOS
	new(TAS[VEASumResT, Tmenos]);
	TAS[VEASumResT, Tmenos]^.elem[1]:= Tmenos;
	TAS[VEASumResT, Tmenos]^.elem[2]:= VEAMultDiv;
	TAS[VEASumResT, Tmenos]^.elem[3]:= VEASumResT;
	TAS[VEASumResT, Tmenos]^.cant:= 3;

	// Para <EASumResT> ::= e
	new(TAS[VEASumResT, TpuntoYcoma]);
	TAS[VEASumResT, TpuntoYcoma]^.cant:= 0;	

	new(TAS[VEASumResT, TcorcheteC]);
	TAS[VEASumResT, TcorcheteC]^.cant:= 0;	

	new(TAS[VEASumResT, Toprel]);
	TAS[VEASumResT, Toprel]^.cant:= 0;	

	new(TAS[VEASumResT, Tor]);
	TAS[VEASumResT, Tor]^.cant:= 0;	

	new(TAS[VEASumResT, Tand]);
	TAS[VEASumResT, Tand]^.cant:= 0;	

	new(TAS[VEASumResT, TparentesisC]);
	TAS[VEASumResT, TparentesisC]^.cant:= 0;	

	new(TAS[VEASumResT, Tcoma]);
	TAS[VEASumResT, Tcoma]^.cant:= 0;

	new(TAS[VEASumResT, TLlaveC]);
	TAS[VEASumResT, TLlaveC]^.cant:= 0;

	// Para <EAMultDiv> ::= <EAPotRaiz> <EAMultDivT>
	new(TAS[VEAMultDiv, TConstReal]);
	TAS[VEAMultDiv, TConstReal]^.elem[1]:= VEAPotRaiz;
	TAS[VEAMultDiv, TConstReal]^.elem[2]:= VEAMultDivT;
	TAS[VEAMultDiv, TConstReal]^.cant:= 2;

	new(TAS[VEAMultDiv, Tid]);
	TAS[VEAMultDiv, Tid]^.elem[1]:= VEAPotRaiz;
	TAS[VEAMultDiv, Tid]^.elem[2]:= VEAMultDivT;
	TAS[VEAMultDiv, Tid]^.cant:= 2;

	new(TAS[VEAMultDiv, Tidm]);
	TAS[VEAMultDiv, Tidm]^.elem[1]:= VEAPotRaiz;
	TAS[VEAMultDiv, Tidm]^.elem[2]:= VEAMultDivT;
	TAS[VEAMultDiv, Tidm]^.cant:= 2;

	new(TAS[VEAMultDiv, TparentesisA]);
	TAS[VEAMultDiv, TparentesisA]^.elem[1]:= VEAPotRaiz;
	TAS[VEAMultDiv, TparentesisA]^.elem[2]:= VEAMultDivT;
	TAS[VEAMultDiv, TparentesisA]^.cant:= 2;

	new(TAS[VEAMultDiv, TsizeCol]);
	TAS[VEAMultDiv, TsizeCol]^.elem[1]:= VEAPotRaiz;
	TAS[VEAMultDiv, TsizeCol]^.elem[2]:= VEAMultDivT;
	TAS[VEAMultDiv, TsizeCol]^.cant:= 2;

	new(TAS[VEAMultDiv, TsizeFila]);
	TAS[VEAMultDiv, TsizeFila]^.elem[1]:= VEAPotRaiz;
	TAS[VEAMultDiv, TsizeFila]^.elem[2]:= VEAMultDivT;
	TAS[VEAMultDiv, TsizeFila]^.cant:= 2;

	new(TAS[VEAMultDiv, Tmenos]);
	TAS[VEAMultDiv, Tmenos]^.elem[1]:= VEAPotRaiz;
	TAS[VEAMultDiv, Tmenos]^.elem[2]:= VEAMultDivT;
	TAS[VEAMultDiv, Tmenos]^.cant:= 2;

	// Para <EAMultDivT> ::= "*" <EAPotRaiz> <EAMultDivT>
	new(TAS[VEAMultDivT, Tasterisco]);
	TAS[VEAMultDivT, Tasterisco]^.elem[1]:= Tasterisco;
	TAS[VEAMultDivT, Tasterisco]^.elem[2]:= VEAPotRaiz;
	TAS[VEAMultDivT, Tasterisco]^.elem[3]:= VEAMultDivT;
	TAS[VEAMultDivT, Tasterisco]^.cant:= 3;
	// Para <EAMultDivT> ::= "/" <EAPotRaiz> <EAMultDivT>
	new(TAS[VEAMultDivT, Tdividir]);
	TAS[VEAMultDivT, Tdividir]^.elem[1]:= Tdividir;
	TAS[VEAMultDivT, Tdividir]^.elem[2]:= VEAPotRaiz;
	TAS[VEAMultDivT, Tdividir]^.elem[3]:= VEAMultDivT;
	TAS[VEAMultDivT, Tdividir]^.cant:= 3;
	// Para <EAMultDivT> ::= e
	new(TAS[VEAMultDivT, Tcoma]);
	TAS[VEAMultDivT, Tcoma]^.cant:= 0;	

	new(TAS[VEAMultDivT, TpuntoYcoma]);
	TAS[VEAMultDivT, TpuntoYcoma]^.cant:= 0;	

	new(TAS[VEAMultDivT, Tmas]);
	TAS[VEAMultDivT, Tmas]^.cant:= 0;	

	//MENOS
	new(TAS[VEAMultDivT, Tmenos]);
	TAS[VEAMultDivT, Tmenos]^.cant:= 0;	

	new(TAS[VEAMultDivT, TcorcheteC]);
	TAS[VEAMultDivT, TcorcheteC]^.cant:= 0;	

	new(TAS[VEAMultDivT, Toprel]);
	TAS[VEAMultDivT, Toprel]^.cant:= 0;	

	new(TAS[VEAMultDivT, Tor]);
	TAS[VEAMultDivT, Tor]^.cant:= 0;	

	new(TAS[VEAMultDivT, Tand]);
	TAS[VEAMultDivT, Tand]^.cant:= 0;	

	new(TAS[VEAMultDivT, TparentesisC]);
	TAS[VEAMultDivT, TparentesisC]^.cant:= 0;	

	new(TAS[VEAMultDivT, TLlaveC]);
	TAS[VEAMultDivT, TLlaveC]^.cant:= 0;	
	// Para <EAPotRaiz> ::= <Factor> <EAPotRaizT>
	new(TAS[VEAPotRaiz, TConstReal]);
	TAS[VEAPotRaiz, TConstReal]^.elem[1]:= VFactor;
	TAS[VEAPotRaiz, TConstReal]^.elem[2]:= VEAPotRaizT;
	TAS[VEAPotRaiz, TConstReal]^.cant:= 2;

	new(TAS[VEAPotRaiz, Tid]);
	TAS[VEAPotRaiz, Tid]^.elem[1]:= VFactor;
	TAS[VEAPotRaiz, Tid]^.elem[2]:= VEAPotRaizT;
	TAS[VEAPotRaiz, Tid]^.cant:= 2;

	new(TAS[VEAPotRaiz, Tidm]);
	TAS[VEAPotRaiz, Tidm]^.elem[1]:= VFactor;
	TAS[VEAPotRaiz, Tidm]^.elem[2]:= VEAPotRaizT;
	TAS[VEAPotRaiz, Tidm]^.cant:= 2;

	new(TAS[VEAPotRaiz, TparentesisA]);
	TAS[VEAPotRaiz, TparentesisA]^.elem[1]:= VFactor;
	TAS[VEAPotRaiz, TparentesisA]^.elem[2]:= VEAPotRaizT;
	TAS[VEAPotRaiz, TparentesisA]^.cant:= 2;

	new(TAS[VEAPotRaiz, TsizeCol]);
	TAS[VEAPotRaiz, TsizeCol]^.elem[1]:= VFactor;
	TAS[VEAPotRaiz, TsizeCol]^.elem[2]:= VEAPotRaizT;
	TAS[VEAPotRaiz, TsizeCol]^.cant:= 2;

	new(TAS[VEAPotRaiz, TsizeFila]);
	TAS[VEAPotRaiz, TsizeFila]^.elem[1]:= VFactor;
	TAS[VEAPotRaiz, TsizeFila]^.elem[2]:= VEAPotRaizT;
	TAS[VEAPotRaiz, TsizeFila]^.cant:= 2;

	new(TAS[VEAPotRaiz, Tmenos]);
	TAS[VEAPotRaiz, Tmenos]^.elem[1]:= VFactor;
	TAS[VEAPotRaiz, Tmenos]^.elem[2]:= VEAPotRaizT;
	TAS[VEAPotRaiz, Tmenos]^.cant:= 2;
	// Para <Factor> ::= "constreal"
	new(TAS[VFactor, TConstReal]);
	TAS[VFactor, TConstReal]^.elem[1]:= TConstReal;
	TAS[VFactor, TConstReal]^.cant:= 1;
	// Para <Factor> ::= "id"
	new(TAS[VFactor, Tid]);
	TAS[VFactor, Tid]^.elem[1]:= Tid;
	TAS[VFactor, Tid]^.cant:= 1;
	// Para <Factor> ::= <EMD>
	new(TAS[VFactor, Tidm]);
	TAS[VFactor, Tidm]^.elem[1]:= VEMD;
	TAS[VFactor, Tidm]^.cant:= 1;
	// Para <Factor> ::= "(" <EASumRes> ")"
	new(TAS[VFactor, TparentesisA]);
	TAS[VFactor, TparentesisA]^.elem[1]:= TparentesisA;
	TAS[VFactor, TparentesisA]^.elem[2]:= VEASumRes;
	TAS[VFactor, TparentesisA]^.elem[3]:= TparentesisC;
	TAS[VFactor, TparentesisA]^.cant:= 3;
	// Para <Factor> ::= “sizeCol” “(“ “idm” “)
	new(TAS[VFactor, TsizeCol]);
	TAS[VFactor, TsizeCol]^.elem[1]:= TsizeCol;
	TAS[VFactor, TsizeCol]^.elem[2]:= TparentesisA;
	TAS[VFactor, TsizeCol]^.elem[3]:= Tidm;
	TAS[VFactor, TsizeCol]^.elem[4]:= TparentesisC;
	TAS[VFactor, TsizeCol]^.cant:= 4;
	// Para <Factor> ::= “sizeFila” “(“ “idm” “)”
	new(TAS[VFactor, TsizeFila]);
	TAS[VFactor, TsizeFila]^.elem[1]:= TsizeFila;
	TAS[VFactor, TsizeFila]^.elem[2]:= TparentesisA;
	TAS[VFactor, TsizeFila]^.elem[3]:= Tidm;
	TAS[VFactor, TsizeFila]^.elem[4]:= TparentesisC;
	TAS[VFactor, TsizeFila]^.cant:= 4;
	// Para <Factor> ::= "-" <Factor> 
	new(TAS[VFactor, Tmenos]);
	TAS[VFactor, Tmenos]^.elem[1]:= Tmenos;
	TAS[VFactor, Tmenos]^.elem[2]:= VFactor;
	TAS[VFactor, Tmenos]^.cant:= 2;
	// Para <EAPotRaizT> ::= “**” <Factor> <EAPotRaizT>
	new(TAS[VEAPotRaizT, TDosAsteriscos]);
	TAS[VEAPotRaizT, TDosAsteriscos]^.elem[1]:= TDosAsteriscos;
	TAS[VEAPotRaizT, TDosAsteriscos]^.elem[2]:= VFactor;
	TAS[VEAPotRaizT, TDosAsteriscos]^.elem[3]:= VEAPotRaizT;
	TAS[VEAPotRaizT, TDosAsteriscos]^.cant:= 3;
	// Para <EAPotRaizT> ::= “rqz” <Factor> <EAPotRaizT>
	new(TAS[VEAPotRaizT, Trqz]);
	TAS[VEAPotRaizT, Trqz]^.elem[1]:= Trqz;
	TAS[VEAPotRaizT, Trqz]^.elem[2]:= VFactor;
	TAS[VEAPotRaizT, Trqz]^.elem[3]:= VEAPotRaizT;
	TAS[VEAPotRaizT, Trqz]^.cant:= 3;
	// Para <EAPotRaizT> ::= e
	new(TAS[VEAPotRaizT, Tmas]);
	TAS[VEAPotRaizT, Tmas]^.cant:= 0;

	//MENOS
	new(TAS[VEAPotRaizT, Tmenos]);
	TAS[VEAPotRaizT, Tmenos]^.cant:= 0;

	new(TAS[VEAPotRaizT, Tasterisco]);
	TAS[VEAPotRaizT, Tasterisco]^.cant:= 0;

	new(TAS[VEAPotRaizT, Tdividir]);
	TAS[VEAPotRaizT, Tdividir]^.cant:= 0;

	new(TAS[VEAPotRaizT, TpuntoYcoma]);
	TAS[VEAPotRaizT, TpuntoYcoma]^.cant:= 0;

	new(TAS[VEAPotRaizT, TcorcheteC]);
	TAS[VEAPotRaizT, TcorcheteC]^.cant:= 0;

	new(TAS[VEAPotRaizT, Toprel]);
	TAS[VEAPotRaizT, Toprel]^.cant:= 0;

	new(TAS[VEAPotRaizT, Tor]);
	TAS[VEAPotRaizT, Tor]^.cant:= 0;

	new(TAS[VEAPotRaizT, Tand]);
	TAS[VEAPotRaizT, Tand]^.cant:= 0;

	new(TAS[VEAPotRaizT, TparentesisC]);
	TAS[VEAPotRaizT, TparentesisC]^.cant:= 0;

	new(TAS[VEAPotRaizT, Tcoma]);
	TAS[VEAPotRaizT, Tcoma]^.cant:= 0;

	new(TAS[VEAPotRaizT, TLlaveC]);
	TAS[VEAPotRaizT, TLlaveC]^.cant:= 0;
	// Para <Declaracion> ::=  "dec" <DeclaracionF> "decend" ";"
	new(TAS[VDeclaracion, Tdec]);
	TAS[VDeclaracion, Tdec]^.elem[1]:= Tdec;
	TAS[VDeclaracion, Tdec]^.elem[2]:= VDeclaracionF;
	TAS[VDeclaracion, Tdec]^.elem[3]:= Tdecend;
	TAS[VDeclaracion, Tdec]^.elem[4]:= TpuntoYcoma;
	TAS[VDeclaracion, Tdec]^.cant:= 4;
	// Para <Declaracion> ::=  e
	new(TAS[VDeclaracion, Tid]);
	TAS[VDeclaracion, Tid]^.cant:= 0;

	new(TAS[VDeclaracion, Tidm]);
	TAS[VDeclaracion, Tidm]^.cant:= 0;

	new(TAS[VDeclaracion, Tif]);
	TAS[VDeclaracion, Tif]^.cant:= 0;

	new(TAS[VDeclaracion, Twhile]);
	TAS[VDeclaracion, Twhile]^.cant:= 0;

	new(TAS[VDeclaracion, Tescribir]);
	TAS[VDeclaracion, Tescribir]^.cant:= 0;

	new(TAS[VDeclaracion, Tleer]);
	TAS[VDeclaracion, Tleer]^.cant:= 0;

	new(TAS[VDeclaracion, Tbiliend]);
	TAS[VDeclaracion, Tbiliend]^.cant:= 0;

	new(TAS[VDeclaracion, Tend]);
	TAS[VDeclaracion, Tend]^.cant:= 0;

	new(TAS[VDeclaracion, Telse]);
	TAS[VDeclaracion, Telse]^.cant:= 0;

	// new(TAS[VDeclaracion, pesos]);
	// TAS[VDeclaracion, pesos]^.cant:= 0;
	// Para <DeclaracionF> ::=  "id" ":" "Real" ";" <DeclaracionF> 
	new(TAS[VDeclaracionF, Tid]);
	TAS[VDeclaracionF, Tid]^.elem[1]:= Tid;
	TAS[VDeclaracionF, Tid]^.elem[2]:= Tdospuntos;
	TAS[VDeclaracionF, Tid]^.elem[3]:= Treal;
	TAS[VDeclaracionF, Tid]^.elem[4]:= TpuntoYcoma;
	TAS[VDeclaracionF, Tid]^.elem[5]:= VDeclaracionF;
	TAS[VDeclaracionF, Tid]^.cant:= 5;
	// Para <DeclaracionF> ::=  "idm" ":" "matrix" "[" "constreal" “;” "constreal" “]” ";" <DeclaracionF>
	new(TAS[VDeclaracionF, Tidm]);
	TAS[VDeclaracionF, Tidm]^.elem[1]:= Tidm;
	TAS[VDeclaracionF, Tidm]^.elem[2]:= Tdospuntos;
	TAS[VDeclaracionF, Tidm]^.elem[3]:= Tmatrix;
	TAS[VDeclaracionF, Tidm]^.elem[4]:= TcorcheteA;
	TAS[VDeclaracionF, Tidm]^.elem[5]:= TConstReal;
	TAS[VDeclaracionF, Tidm]^.elem[6]:= TpuntoYcoma;
	TAS[VDeclaracionF, Tidm]^.elem[7]:= TConstReal;
	TAS[VDeclaracionF, Tidm]^.elem[8]:= TcorcheteC;
	TAS[VDeclaracionF, Tidm]^.elem[9]:= TpuntoYcoma;
	TAS[VDeclaracionF, Tidm]^.elem[10]:= VDeclaracionF;
	TAS[VDeclaracionF, Tidm]^.cant:= 10;
	// Para <DeclaracionF> ::=  e
	new(TAS[VDeclaracionF, Tdecend]);
	TAS[VDeclaracionF, Tdecend]^.cant:= 0;
	// Para <EMD> ::= “idm” “[“ <EASumRes> “;” <EASumRes> “]”
	new(TAS[VEMD, Tidm]);
	TAS[VEMD, Tidm]^.elem[1]:= Tidm;
	TAS[VEMD, Tidm]^.elem[2]:= TcorcheteA;
	TAS[VEMD, Tidm]^.elem[3]:= VEASumRes;
	TAS[VEMD, Tidm]^.elem[4]:= TpuntoYcoma;
	TAS[VEMD, Tidm]^.elem[5]:= VEASumRes;
	TAS[VEMD, Tidm]^.elem[6]:= TcorcheteC;
	TAS[VEMD, Tidm]^.cant:= 6;
	// 	Para <EMSumRes> ::= <EMMultTra> <EMSumResT>
	new(TAS[VEMSumRes, Tidm]);
	TAS[VEMSumRes, Tidm]^.elem[1]:= VEMMultTra;
	TAS[VEMSumRes, Tidm]^.elem[2]:= VEMSumResT;
	TAS[VEMSumRes, Tidm]^.cant:= 2;

	new(TAS[VEMSumRes, TparentesisA]);
	TAS[VEMSumRes, TparentesisA]^.elem[1]:= VEMMultTra;
	TAS[VEMSumRes, TparentesisA]^.elem[2]:= VEMSumResT;
	TAS[VEMSumRes, TparentesisA]^.cant:= 2;

	new(TAS[VEMSumRes, Tarroba]);
	TAS[VEMSumRes, Tarroba]^.elem[1]:= VEMMultTra;
	TAS[VEMSumRes, Tarroba]^.elem[2]:= VEMSumResT;
	TAS[VEMSumRes, Tarroba]^.cant:= 2;

	new(TAS[VEMSumRes, TLlaveA]);
	TAS[VEMSumRes, TLlaveA]^.elem[1]:= VEMMultTra;
	TAS[VEMSumRes, TLlaveA]^.elem[2]:= VEMSumResT;
	TAS[VEMSumRes, TLlaveA]^.cant:= 2;
	// Para <EMSumResT> ::= "+" <EMMultTra> <EMSumResT>
	new(TAS[VEMSumResT, Tmas]);
	TAS[VEMSumResT, Tmas]^.elem[1]:= Tmas;
	TAS[VEMSumResT, Tmas]^.elem[2]:= VEMMultTra;
	TAS[VEMSumResT, Tmas]^.elem[3]:= VEMSumResT;
	TAS[VEMSumResT, Tmas]^.cant:= 3;
	// Para <EMSumResT> ::= "-" <EMMultTra> <EMSumResT> 
	new(TAS[VEMSumResT, Tmenos]);
	TAS[VEMSumResT, Tmenos]^.elem[1]:= Tmenos;
	TAS[VEMSumResT, Tmenos]^.elem[2]:= VEMMultTra;
	TAS[VEMSumResT, Tmenos]^.elem[3]:= VEMSumResT;
	TAS[VEMSumResT, Tmenos]^.cant:= 3;
	// Para <EMSumResT> ::= e
	new(TAS[VEMSumResT, TparentesisC]);
	TAS[VEMSumResT, TparentesisC]^.cant:= 0;

	new(TAS[VEMSumResT, TpuntoYcoma]);
	TAS[VEMSumResT, TpuntoYcoma]^.cant:= 0;

	new(TAS[VEMSumResT, Tcoma]);
	TAS[VEMSumResT, Tcoma]^.cant:= 0;

	new(TAS[VEMSumResT, TLlaveC]);
	TAS[VEMSumResT, TLlaveC]^.cant:= 0;
	// Para <EMMultTra> ::= <EMMultiEsc> <EMMultTraT> 
	new(TAS[VEMMultTra, Tidm]);
	TAS[VEMMultTra, Tidm]^.elem[1]:= VEMMultiEsc;
	TAS[VEMMultTra, Tidm]^.elem[2]:= VEMMultTraT;
	TAS[VEMMultTra, Tidm]^.cant:= 2;

	new(TAS[VEMMultTra, TparentesisA]);
	TAS[VEMMultTra, TparentesisA]^.elem[1]:= VEMMultiEsc;
	TAS[VEMMultTra, TparentesisA]^.elem[2]:= VEMMultTraT;
	TAS[VEMMultTra, TparentesisA]^.cant:= 2;

	new(TAS[VEMMultTra, Tarroba]);
	TAS[VEMMultTra, Tarroba]^.elem[1]:= VEMMultiEsc;
	TAS[VEMMultTra, Tarroba]^.elem[2]:= VEMMultTraT;
	TAS[VEMMultTra, Tarroba]^.cant:= 2;

	new(TAS[VEMMultTra, TLlaveA]);
	TAS[VEMMultTra, TLlaveA]^.elem[1]:= VEMMultiEsc;
	TAS[VEMMultTra, TLlaveA]^.elem[2]:= VEMMultTraT;
	TAS[VEMMultTra, TLlaveA]^.cant:= 2;
	// Para <EMMultTraT> ::= "*" <EMMultiEsc> <EMMultTraT>
	new(TAS[VEMMultTraT, Tasterisco]);
	TAS[VEMMultTraT, Tasterisco]^.elem[1]:= Tasterisco;
	TAS[VEMMultTraT, Tasterisco]^.elem[2]:= VEMMultiEsc;
	TAS[VEMMultTraT, Tasterisco]^.elem[3]:= VEMMultTraT;
	TAS[VEMMultTraT, Tasterisco]^.cant:= 3;
	// Para <EMMultTraT> ::= e
	new(TAS[VEMMultTraT, Tmas]);
	TAS[VEMMultTraT, Tmas]^.cant:= 0;

	new(TAS[VEMMultTraT, Tmenos]);
	TAS[VEMMultTraT, Tmenos]^.cant:= 0;

	new(TAS[VEMMultTraT, TparentesisC]);
	TAS[VEMMultTraT, TparentesisC]^.cant:= 0;

	new(TAS[VEMMultTraT, TpuntoYcoma]);
	TAS[VEMMultTraT, TpuntoYcoma]^.cant:= 0;

	new(TAS[VEMMultTraT, Tcoma]);
	TAS[VEMMultTraT, Tcoma]^.cant:= 0;

	new(TAS[VEMMultTraT, TLlaveC]);
	TAS[VEMMultTraT, TLlaveC]^.cant:= 0;
	// Para <EMMultiEsc> ::= “idm” <EMMultiEscT>
	new(TAS[VEMMultiEsc, Tidm]);
	TAS[VEMMultiEsc, Tidm]^.elem[1]:= Tidm;
	TAS[VEMMultiEsc, Tidm]^.elem[2]:= VEMMultiEscT;
	TAS[VEMMultiEsc, Tidm]^.cant:= 2;
	// Para <EMMultiEsc> ::= <ConstMatrix> <EMMultiEscT>
	new(TAS[VEMMultiEsc, TLlaveA]);
	TAS[VEMMultiEsc, TLlaveA]^.elem[1]:= VConstMatrix;
	TAS[VEMMultiEsc, TLlaveA]^.elem[2]:= VEMMultiEscT;
	TAS[VEMMultiEsc, TLlaveA]^.cant:= 2;
	// Para <EMMultiEsc> ::= “(“ <EMSumRes> “)” <EMMultiEscT>
	new(TAS[VEMMultiEsc, TparentesisA]);
	TAS[VEMMultiEsc, TparentesisA]^.elem[1]:= TparentesisA;
	TAS[VEMMultiEsc, TparentesisA]^.elem[2]:= VEMSumRes;
	TAS[VEMMultiEsc, TparentesisA]^.elem[3]:= TparentesisC;
	TAS[VEMMultiEsc, TparentesisA]^.elem[4]:= VEMMultiEscT;
	TAS[VEMMultiEsc, TparentesisA]^.cant:= 4;
	// Para <EMMultiEsc> ::= "@" "(" <EMSumRes> “)”  <EMMultiEscT>
	new(TAS[VEMMultiEsc, Tarroba]);
	TAS[VEMMultiEsc, Tarroba]^.elem[1]:= Tarroba;
	TAS[VEMMultiEsc, Tarroba]^.elem[2]:= TparentesisA;
	TAS[VEMMultiEsc, Tarroba]^.elem[3]:= VEMSumRes;
	TAS[VEMMultiEsc, Tarroba]^.elem[4]:= TparentesisC;
	TAS[VEMMultiEsc, Tarroba]^.elem[5]:= VEMMultiEscT;
	TAS[VEMMultiEsc, Tarroba]^.cant:= 5;
	// Para <EMMultiEscT>::= “^” <Factor> <EMMultiEscT>
	new(TAS[VEMMultiEscT, Tangulito]);
	TAS[VEMMultiEscT, Tangulito]^.elem[1]:= Tangulito;
	TAS[VEMMultiEscT, Tangulito]^.elem[2]:= VFactor;
	TAS[VEMMultiEscT, Tangulito]^.elem[3]:= VEMMultiEscT;
	TAS[VEMMultiEscT, Tangulito]^.cant:= 3;
	// Para <EMMultiEscT>::= e
	new(TAS[VEMMultiEscT, Tasterisco]);
	TAS[VEMMultiEscT, Tasterisco]^.cant:= 0;

	new(TAS[VEMMultiEscT, Tmas]);
	TAS[VEMMultiEscT, Tmas]^.cant:= 0;
	
	new(TAS[VEMMultiEscT, Tmenos]);
	TAS[VEMMultiEscT, Tmenos]^.cant:= 0;
	
	new(TAS[VEMMultiEscT, TparentesisC]);
	TAS[VEMMultiEscT, TparentesisC]^.cant:= 0;
	
	new(TAS[VEMMultiEscT, TpuntoYcoma]);
	TAS[VEMMultiEscT, TpuntoYcoma]^.cant:= 0;
	
	new(TAS[VEMMultiEscT, Tcoma]);
	TAS[VEMMultiEscT, Tcoma]^.cant:= 0;
	
	new(TAS[VEMMultiEscT, TLlaveC]);
	TAS[VEMMultiEscT, TLlaveC]^.cant:= 0;
	// Para <Lectura> ::= “leer" (“ “ConstString” "," "id" “)” ”;”
	new(TAS[VLectura, Tleer]);
	TAS[VLectura, Tleer]^.elem[1]:= Tleer;
	TAS[VLectura, Tleer]^.elem[2]:= TparentesisA;
	TAS[VLectura, Tleer]^.elem[3]:= TconstString;
	TAS[VLectura, Tleer]^.elem[4]:= Tcoma;
	TAS[VLectura, Tleer]^.elem[5]:= Tid;
	TAS[VLectura, Tleer]^.elem[6]:= TparentesisC;
	// TAS[VLectura, Tleer]^.elem[7]:= TpuntoYcoma;
	TAS[VLectura, Tleer]^.cant:= 6;
	// Para <Escritura> ::= “escribir" (“ <ListDatoEscr> “)” ”;”
	new(TAS[VEscribir, Tescribir]);
	TAS[VEscribir, Tescribir]^.elem[1]:= Tescribir;
	TAS[VEscribir, Tescribir]^.elem[2]:= TparentesisA;
	TAS[VEscribir, Tescribir]^.elem[3]:= VListaDatoEscr;
	TAS[VEscribir, Tescribir]^.elem[4]:= TparentesisC;
	// TAS[VEscribir, Tescribir]^.elem[5]:= TpuntoYcoma;
	TAS[VEscribir, Tescribir]^.cant:= 4;
	// Para <ListDatoEscr> ::= <DatoEscr> <ListDatoEscrF>
	new(TAS[VListaDatoEscr, TconstString]);
	TAS[VListaDatoEscr, TconstString]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, TconstString]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, TconstString]^.cant:= 2;

	new(TAS[VListaDatoEscr, TConstReal]);
	TAS[VListaDatoEscr, TConstReal]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, TConstReal]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, TConstReal]^.cant:= 2;

	new(TAS[VListaDatoEscr, Tid]);
	TAS[VListaDatoEscr, Tid]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, Tid]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, Tid]^.cant:= 2;

	new(TAS[VListaDatoEscr, Tidm]);
	TAS[VListaDatoEscr, Tidm]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, Tidm]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, Tidm]^.cant:= 2;

	new(TAS[VListaDatoEscr, Tmatrix]);
	TAS[VListaDatoEscr, Tmatrix]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, Tmatrix]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, Tmatrix]^.cant:= 2;

	new(TAS[VListaDatoEscr, TparentesisA]);
	TAS[VListaDatoEscr, TparentesisA]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, TparentesisA]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, TparentesisA]^.cant:= 2;

	new(TAS[VListaDatoEscr, TsizeCol]);
	TAS[VListaDatoEscr, TsizeCol]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, TsizeCol]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, TsizeCol]^.cant:= 2;

	new(TAS[VListaDatoEscr, TsizeFila]);
	TAS[VListaDatoEscr, TsizeFila]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, TsizeFila]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, TsizeFila]^.cant:= 2;

	new(TAS[VListaDatoEscr, Tmenos]);
	TAS[VListaDatoEscr, Tmenos]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, Tmenos]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, Tmenos]^.cant:= 2;

	new(TAS[VListaDatoEscr, TcorcheteA]);
	TAS[VListaDatoEscr, TcorcheteA]^.elem[1]:= VDatoEscr;
	TAS[VListaDatoEscr, TcorcheteA]^.elem[2]:= VListaDatoEscrF;
	TAS[VListaDatoEscr, TcorcheteA]^.cant:= 2;
	// Para <ListDatoEscrF> ::= “,” <ListDatoEscr>
	new(TAS[VListaDatoEscrF, Tcoma]);
	TAS[VListaDatoEscrF, Tcoma]^.elem[1]:= Tcoma;
	TAS[VListaDatoEscrF, Tcoma]^.elem[2]:= VListaDatoEscr;
	TAS[VListaDatoEscrF, Tcoma]^.cant:= 2;
	// Para <ListDatoEscrF> ::= e
	new(TAS[VListaDatoEscrF, TparentesisC]);
	TAS[VListaDatoEscrF, TparentesisC]^.cant:= 0;
	// Para <DatoEscr> ::= “ConstString”
	new(TAS[VDatoEscr, TconstString]);
	TAS[VDatoEscr, TconstString]^.elem[1]:= TconstString;
	TAS[VDatoEscr, TconstString]^.cant:= 1;
	// Para <DatoEscr> ::= <EASumRes>
	new(TAS[VDatoEscr, TConstReal]);
	TAS[VDatoEscr, TConstReal]^.elem[1]:= VEASumRes;
	TAS[VDatoEscr, TConstReal]^.cant:= 1;

	new(TAS[VDatoEscr, Tid]);
	TAS[VDatoEscr, Tid]^.elem[1]:= VEASumRes;
	TAS[VDatoEscr, Tid]^.cant:= 1;

	new(TAS[VDatoEscr, Tidm]);
	TAS[VDatoEscr, Tidm]^.elem[1]:= VEASumRes;
	TAS[VDatoEscr, Tidm]^.cant:= 1;

	new(TAS[VDatoEscr, TparentesisA]);
	TAS[VDatoEscr, TparentesisA]^.elem[1]:= VEASumRes;
	TAS[VDatoEscr, TparentesisA]^.cant:= 1;

	new(TAS[VDatoEscr, TsizeCol]);
	TAS[VDatoEscr, TsizeCol]^.elem[1]:= VEASumRes;
	TAS[VDatoEscr, TsizeCol]^.cant:= 1;

	new(TAS[VDatoEscr, TsizeFila]);
	TAS[VDatoEscr, TsizeFila]^.elem[1]:= VEASumRes;
	TAS[VDatoEscr, TsizeFila]^.cant:= 1;

	new(TAS[VDatoEscr, Tmenos]);
	TAS[VDatoEscr, Tmenos]^.elem[1]:= VEASumRes;
	TAS[VDatoEscr, Tmenos]^.cant:= 1;
	// Para <DatoEscr> ::= "matrix" "(" <EMSumRes> ")"
	new(TAS[VDatoEscr, Tmatrix]);
	TAS[VDatoEscr, Tmatrix]^.elem[1]:= Tmatrix;
	TAS[VDatoEscr, Tmatrix]^.elem[2]:= TparentesisA;
	TAS[VDatoEscr, Tmatrix]^.elem[3]:= VEMSumRes;
	TAS[VDatoEscr, Tmatrix]^.elem[4]:= TparentesisC;
	TAS[VDatoEscr, Tmatrix]^.cant:= 4;
	// Para <ConstMatrix>::= "{" <Filas> "}"
	new(TAS[VConstMatrix, TLlaveA]);
	TAS[VConstMatrix, TLlaveA]^.elem[1]:= TLlaveA;
	TAS[VConstMatrix, TLlaveA]^.elem[2]:= VFilas;
	TAS[VConstMatrix, TLlaveA]^.elem[3]:= TLlaveC;
	TAS[VConstMatrix, TLlaveA]^.cant:= 3;
	// Para <Filas>::= "{" <Columnas> "}" <Filas>
	new(TAS[VFilas, TLlaveA]);
	TAS[VFilas, TLlaveA]^.elem[1]:= TLlaveA;
	TAS[VFilas, TLlaveA]^.elem[2]:= VColumnas;
	TAS[VFilas, TLlaveA]^.elem[3]:= TLlaveC;
	TAS[VFilas, TLlaveA]^.elem[4]:= VFilas;
	TAS[VFilas, TLlaveA]^.cant:= 4;
	// Para <Filas>::= e
	new(TAS[VFilas, TLlaveC]);
	TAS[VFilas, TLlaveC]^.cant:= 0;
	// Para <Columnas>::= <EASumRes> <ColumnasT>
	new(TAS[VColumnas, TConstReal]);
	TAS[VColumnas, TConstReal]^.elem[1]:= VEASumRes;
	TAS[VColumnas, TConstReal]^.elem[2]:= VColumnasT;
	TAS[VColumnas, TConstReal]^.cant:= 2;

	new(TAS[VColumnas, Tid]);
	TAS[VColumnas, Tid]^.elem[1]:= VEASumRes;
	TAS[VColumnas, Tid]^.elem[2]:= VColumnasT;
	TAS[VColumnas, Tid]^.cant:= 2;

	new(TAS[VColumnas, Tidm]);
	TAS[VColumnas, Tidm]^.elem[1]:= VEASumRes;
	TAS[VColumnas, Tidm]^.elem[2]:= VColumnasT;
	TAS[VColumnas, Tidm]^.cant:= 2;

	new(TAS[VColumnas, TparentesisA]);
	TAS[VColumnas, TparentesisA]^.elem[1]:= VEASumRes;
	TAS[VColumnas, TparentesisA]^.elem[2]:= VColumnasT;
	TAS[VColumnas, TparentesisA]^.cant:= 2;

	new(TAS[VColumnas, TsizeCol]);
	TAS[VColumnas, TsizeCol]^.elem[1]:= VEASumRes;
	TAS[VColumnas, TsizeCol]^.elem[2]:= VColumnasT;
	TAS[VColumnas, TsizeCol]^.cant:= 2;

	new(TAS[VColumnas, TsizeFila]);
	TAS[VColumnas, TsizeFila]^.elem[1]:= VEASumRes;
	TAS[VColumnas, TsizeFila]^.elem[2]:= VColumnasT;
	TAS[VColumnas, TsizeFila]^.cant:= 2;

	new(TAS[VColumnas, Tmenos]);
	TAS[VColumnas, Tmenos]^.elem[1]:= VEASumRes;
	TAS[VColumnas, Tmenos]^.elem[2]:= VColumnasT;
	TAS[VColumnas, Tmenos]^.cant:= 2;
	// Para <ColumnasT>::= "," <Columnas>
	new(TAS[VColumnasT, Tcoma]);
	TAS[VColumnasT, Tcoma]^.elem[1]:= Tcoma;
	TAS[VColumnasT, Tcoma]^.elem[2]:= VColumnas;
	TAS[VColumnasT, Tcoma]^.cant:= 2;
	// Para <ColumnasT>::= e
	new(TAS[VColumnasT, TLlaveC]);
	TAS[VColumnasT, TLlaveC]^.cant:= 0;
	end;
procedure Analizador_Sintactico_DPNR(var Fuente:FileOfChar;var arbol:t_punteroA;var error:boolean);//DEBE ESTAR LA RUTA DEL ARCHIVO, EL ARBOL Y EL ERROR
var pila:t_pila;
	exito:boolean;
	auxiliar:TipoSimboloGramatical;
	dato_pila: t_dato_pila;
	TS: TablaDeSimbolos;
	TAS: tipo_tas;
	Hijo:t_punteroA;
	Complex: TipoSimboloGramatical;
	i: 0..MaxProduc;
	Control:LongInt;
	Lexema:string;
	begin
	exito:= false;
	error:= false;
	//Al inicio, apilar $ y luego el simbolo inicial de la gramatica
	crear_pila(pila);
	crear_arbol(arbol,'',VPrograma);

	dato_pila.Simbolo:= pesos;
	dato_pila.arbol:= nil;
	apilar(pila,dato_pila);	

	dato_pila.Simbolo:= VPrograma;
	dato_pila.arbol:= arbol;
	apilar(pila,dato_pila);	

	CargarTS(TS);

	inicializar_TAS(TAS);
	cargarTAS(TAS);
	crear_y_abrir_Fuente(Fuente);
	Control:=0;
	ObtenerSiguienteCompLex(Fuente, Control, CompLex, Lexema, TS);
	//-----------------------
	//Repetir hasta exito o Error
		repeat
		//Sea dato_pila el simbolo al tope de la pila y a el simbolo en la entrada
		//Desapilar dato_pila
		desapilar(pila,dato_pila);

		{writeln(dato_pila,'  ',Complex);
				readkey;
				readkey;}
		//Si dato_pila es terminal
			if(dato_pila.Simbolo >= Tbiliprograma) and (dato_pila.Simbolo <= Treal) then
				begin
				//Si dato_pila es igual a a, avanzar el control al siguiente simbolo de entrada
				if dato_pila.Simbolo = Complex then
					begin
					// writeln('AVANZAR EL CONTROL AL SIGUIENTE SIMBOLO',' ',Complex,' ',Lexema);
					dato_pila.arbol^.Lexema:= Lexema;
					ObtenerSiguienteCompLex(Fuente, Control, CompLex, Lexema, TS);
					end
				//Si no error
				else begin
					// writeln('Error sintactico: Se esperaba ',Complex,' ',Lexema, ' y se encontro ', dato_pila.Simbolo);
					writeln('Error sintactico en: Se esperaba ',dato_pila.Simbolo, ' y se encontro ',Complex,' ',Lexema);
					error:=true;	//Error sintactico
					end;
				end
		//Si dato_pila es variable
			else if (dato_pila.Simbolo >= VPrograma) and (dato_pila.Simbolo <= VColumnasT) then
				begin
				//Si TAS[dato_pila,a] = vacia, entonces error

					if(TAS[dato_pila.Simbolo,Complex] = nil ) then //or (Complex = error_lexico)
						begin
						writeln('Error lexico: Se esperaba ',dato_pila.Simbolo, ' y se encontro ',Complex,' ',Lexema);
						error:=true;	//El Error es lexico
						readkey;
						end
					else begin
							//Sino, sea TAS[dato_pila,a] = A_1,A_2,...A_n
							//Apilar A_n,A_n-1,...A_1 (A_1 queda al tope)
							//Agregar los hijos A_1,A_2,...A_n al nodo dato_pila en el arbol de derivacion
							for i:=1 to TAS[dato_pila.Simbolo,Complex]^.cant Do
								begin
								auxiliar:= TAS[dato_pila.Simbolo,Complex]^.elem[i];
								//CREAR NODO PARA EL ARBOL Y AGREGARLO AL ARBOL
								crear_nodo(hijo,auxiliar);
								agregar_hijo(dato_pila.arbol,hijo);
								end;
								
							//Y APILAR TODO
							apilarTodo(pila,dato_pila.arbol)
						end;
				end
		//Si dato_pila = a = $, entonces Exito
			else if (dato_pila.Simbolo = Complex) and (Complex = pesos) then
				begin
				writeln('EXITO!!!');
				
				exito:=true;
				end;
		until (exito or error);
		close(Fuente);
	//-----------------------
	end;
end.