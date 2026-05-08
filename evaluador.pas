unit evaluador;

interface
{$codepage UTF8}
uses tipos,crt,math;
const 
	MaxVar = 200;
	MaxReal = 100;
	MaxFila = 100;
	MaxColumna = 100;

type 
	Ttipo = (Treal,Tmatriz);

	TipoMatrix = array[1..MaxFila,1..MaxColumna] of real;

	TElemento = record
		LexemaId:string;
		ValReal: real;
		tipo: Ttipo;
		ValMatrix: TipoMatrix;
		CantFila, CantColumna:byte;
		end;

	TEstado = record
		elemento: array[1..MaxVar] of TElemento;
		cant:word;
		end;



procedure inicializarEstado(var Estado:TEstado); // Inicializamos el estado
function ValorDe(var Estado:TEstado; LexemaId:string; fila,columna:byte):real; // Obtenemos el valor real de un numero o el numero que esta guardado en una posicion de una matriz
function ValoMatrixDe(var Estado:TEstado; LexemaId:string):TipoMatrix; // Obtenemos la matriz gracias al LexemaId que se pasa como parametro
function filaDe(var Estado:TEstado; LexemaId:string):byte; // Obtenemos la cantidad de filas de una matriz gracias al LexemaId que se pasa como parametro
function columnaDe(var Estado:TEstado; LexemaId:string):byte; // Obtenemos la cantidad de columnas de una matriz gracias al LexemaId que se pasa como parametro
procedure agregarVar(var Estado:TEstado; Var LexemaId:string; var tipo:Ttipo;var TamFil,TamCol:ShortInt); // Agregamos una matriz o un valor real al estado
procedure AsignarReal(var Estado:TEstado;var LexemaId:string; valor:real); // Asignamos un valor real a una variable que esta en el estado, pasandole el LexemaId correspondiente 
procedure AsignarMatriz(var Estado:TEstado;var LexemaId:string; valor:TipoMatrix; TamFil,TamCol:ShortInt); // Asignamos una matriz a una variable que esta en el estado, pasandole el LexemaId correspondiente 
procedure AsignarCeldaMat(var Estado:TEstado;var LexemaId:string;valor:real; TamFil,TamCol:ShortInt); // Asignamos un valor real a una celda de una matriz, correspondiente al LexemaId que se pasa como parametro
procedure SumaEntreMatrices(var MResultado:TipoMatrix; Matrix1:TipoMatrix;fila,columna:ShortInt);
procedure RestaEntreMatrices(var MResultado:TipoMatrix; Matrix1:TipoMatrix;fila,columna:ShortInt);
procedure MultiEntreMatrices(var MResultado:TipoMatrix; Matrix1:TipoMatrix;fila,columna,columnaM1:ShortInt);
procedure EscalarPorMatrix(var MResultado:TipoMatrix;resultado:real;fila,columna:ShortInt);
procedure TransponerMatrix(var MResultado:TipoMatrix;fila,columna:ShortInt);

procedure EvalPrograma(var arbol:t_punteroA; var estado:TEstado); // Evaluamos las producciones de <Programa>
procedure EvalCuerpo(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <Cuerpo>
procedure EvalSent(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <Sent>
procedure EvalAsignacion(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <Asignacion>
procedure EvalAsignacionT(var arbol:t_punteroA;var estado:TEstado;LexemaId:string); // Evaluamos las producciones de <AsignacionT>
procedure EvalCondicional(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <Condicional>
procedure EvalCondicionalF(var arbol:t_punteroA;var estado:TEstado;condicion:boolean); // Evaluamos las producciones de <CondicionalF>
procedure EvalCiclo(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <Ciclo>
procedure EvalCondAnd(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean); // Evaluamos las producciones de <CondAnd>
procedure EvalCondAndT(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean); // Evaluamos las producciones de <CondAndT>
procedure EvalCondOr(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean); // Evaluamos las producciones de <CondOr>
procedure EvalCondOrT(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean); // Evaluamos las producciones de <CondOrT>
procedure EvalCondNot(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean); // Evaluamos las producciones de <CondNot>
procedure EvalEC(var arbol:t_punteroA;var estado:TEstado;var resultado:boolean); // Evaluamos las producciones de <EC>
procedure EvalEASumRes(var arbol:t_punteroA;var estado:TEstado;var resultado:real); // Evaluamos las producciones de <EASumRes>
procedure EvalEASumResT(var arbol:t_punteroA;var estado:TEstado;var resultado:real); // Evaluamos las producciones de <EASumResT>
procedure EvalEAMultDiv(var arbol:t_punteroA;var estado:TEstado;var resultado:real); // Evaluamos las producciones de <EAMultDiv>
procedure EvalEAMultDivT(var arbol:t_punteroA;var estado:TEstado;var resultado:real); // Evaluamos las producciones de <EAMultDivT>
procedure EvalEAPotRaiz(var arbol:t_punteroA;var estado:TEstado;var resultado:real); // Evaluamos las producciones de <EAPotRaiz>
procedure EvalFactor(var arbol:t_punteroA;var estado:TEstado;var resultado:real); // Evaluamos las producciones de <Factor>
procedure EvalEAPotRaizT(var arbol:t_punteroA;var estado:TEstado;var resultado:real); // Evaluamos las producciones de <EAPotRaizT>

procedure EvalDeclaracion(var arbol:t_punteroA; var estado:TEstado); // Evaluamos las producciones de <Declaracion>
procedure EvalDeclaracionF(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <DeclaracionT>

procedure EvalEMD(var arbol:t_punteroA;var estado:TEstado;var resultado:real); // Evaluamos las producciones de <EMD>
procedure EvalEMSumRes(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt); // Evaluamos las producciones de <EMSumRes>
procedure EvalEMSumResT(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt); // Evaluamos las producciones de <EMSumResT>
procedure EvalEMMultTra(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt); // Evaluamos las producciones de <EMMultTra>
procedure EvalEMMultTraT(var arbol:t_punteroA;var estado:TEstado;Var MResultado:TipoMatrix;var fila,columna:ShortInt); // Evaluamos las producciones de <EMMultTraT>
procedure EvalEMMultiEsc(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt); // Evaluamos las producciones de <EMMultiEsc>
procedure EvalEMMultiEscT(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt); // Evaluamos las producciones de <EMMultiEscT>
procedure EvalLectura(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <Lectura>


procedure EvalEscritura(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <Escritura>
procedure EvalListDatoEscr(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <ListDatoEscr>
procedure EvalListDatoEscrF(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <ListDatoEscrF>
procedure EvalDatoEscr(var arbol:t_punteroA;var estado:TEstado); // Evaluamos las producciones de <DatoEscr>
procedure EvalConstMatrix(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt); // Evaluamos las producciones de <ConstMatrix>
procedure EvalFilas(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var i,j,fila,columna:ShortInt); // Evaluamos las producciones de <Filas>
procedure EvalColumnas(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var i,j,fila,columna:ShortInt); // Evaluamos las producciones de <Columnas>
procedure EvalColumnasT(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var i,j,fila,columna:ShortInt); // Evaluamos las producciones de <ColumnasT>
implementation

procedure inicializarEstado(var Estado:TEstado);
var k:1..MaxVar;
	i:1..MaxFila;
	j:1..MaxColumna;
	unElemento:TElemento;
begin	
	unElemento.LexemaId:= '';
	unElemento.ValReal:=0;
	unElemento.tipo:=Treal;
	for i:=1 to MaxFila do
		for j:=1 to MaxColumna do
			begin
			unElemento.ValMatrix[i,j]:=0;
			unElemento.CantFila:=0;
			unElemento.CantColumna:=0;
			end;
	
	Estado.cant:=0;
	for k:=1 to MaxVar do
	begin
	Estado.elemento[k]:= unElemento;
	end;
end;

function ValorDe(var Estado:TEstado; LexemaId:string; fila,columna:byte):real;
var i:1..MaxVar;
begin
	for i:=1 to Estado.cant do
	begin
		if (Estado.elemento[i].LexemaId = LexemaId) then
			if((fila = 0) and (columna = 0)) then
				begin				
				ValorDe:= Estado.elemento[i].ValReal;
				end
			else 
				begin
				ValorDe:= Estado.elemento[i].ValMatrix[fila,columna];
				end;
	end;
end;

function ValoMatrixDe(var Estado:TEstado; LexemaId:string):TipoMatrix;
var i:1..MaxVar;
begin
	for i:=1 to Estado.cant do
	begin
		if (Estado.elemento[i].LexemaId = LexemaId) then
			begin
			ValoMatrixDe:= Estado.elemento[i].ValMatrix;
			end;
	end;
end;

function filaDe(var Estado:TEstado; LexemaId:string):byte;
var i:1..MaxVar;
begin
	for i:=1 to Estado.cant do
		begin
			if (Estado.elemento[i].LexemaId = LexemaId) then
			begin
			filaDe:= Estado.elemento[i].CantFila;
			end;
		end;
end;
function columnaDe(var Estado:TEstado; LexemaId:string):byte;
var i:1..MaxVar;
begin
	for i:=1 to Estado.cant do
		begin
			if (Estado.elemento[i].LexemaId = LexemaId) then
			begin
			columnaDe:= Estado.elemento[i].CantColumna;
			end;
		end;
end;
procedure agregarVar(var Estado:TEstado; Var LexemaId:string; var tipo:Ttipo;var TamFil,TamCol:ShortInt);
var unEstado:TElemento;
begin
	Inc(Estado.cant);
	unEstado:= Estado.elemento[Estado.cant];

	unEstado.CantFila:= TamFil;
	unEstado.CantColumna:= TamCol;
	unEstado.LexemaId:= LexemaId;
	unEstado.tipo:= tipo;

	Estado.elemento[Estado.cant]:=unEstado;
end;

procedure AsignarReal(var Estado:TEstado;var LexemaId:string; valor:real);
var i:1..MaxVar;
begin
	for i:=1 to MaxVar do
	begin
		if (Estado.elemento[i].LexemaId = LexemaId) then //Si el Lexema es igual al Lexema pasado
		begin
			Estado.elemento[i].ValReal:= valor;
		end;
	end;
end;

procedure AsignarMatriz(var Estado:TEstado;var LexemaId:string; valor:TipoMatrix; TamFil,TamCol:ShortInt);
var i:1..MaxVar;
begin
	for i:=1 to MaxVar do
	begin
		if (Estado.elemento[i].LexemaId = LexemaId) then
		begin
			Estado.elemento[i].ValMatrix:= valor;
			estado.elemento[i].CantFila:= tamFil;
			estado.elemento[i].CantColumna:= TamCol;
		end;
	end;
end;

procedure AsignarCeldaMat(var Estado:TEstado;var LexemaId:string;valor:real; TamFil,TamCol:ShortInt);
var i:1..MaxVar;
begin
	for i:=1 to MaxVar do
	begin
		if (Estado.elemento[i].LexemaId = LexemaId) then
		begin
		Estado.elemento[i].ValMatrix[TamFil,TamCol]:= valor;
		end;
	end;

end;
procedure SumaEntreMatrices(var MResultado:TipoMatrix; Matrix1:TipoMatrix;fila,columna:ShortInt);
var fil:1..MaxFila;
	col:1..MaxColumna;
	begin
	for fil:=1 to fila do
		for col:=1 to columna do
		begin
		MResultado[fil,col]:= MResultado[fil,col] + Matrix1[fil,col]; // suma componente a componente
		end;
	end;
procedure RestaEntreMatrices(var MResultado:TipoMatrix; Matrix1:TipoMatrix;fila,columna:ShortInt);
var fil:1..MaxFila;
	col:1..MaxColumna;
	begin
	for fil:=1 to fila do
		for col:=1 to columna do
		begin
		MResultado[fil,col]:= MResultado[fil,col] - Matrix1[fil,col]; // resta componente a componente
		end;
	end;
procedure MultiEntreMatrices(var MResultado:TipoMatrix; Matrix1:TipoMatrix;fila,columna,columnaM1:ShortInt);
var fil:1..MaxFila;
	col,k:1..MaxColumna;
	Matrix2:TipoMatrix;
	suma:real;
	begin
	for fil:=1 to fila do
		for col:=1 to columnaM1 do
		begin
			suma:=0;
			for k:=1 to columna do
				suma:= suma + MResultado[fil,k] * Matrix1[k,col];
			Matrix2[fil,col]:= suma;
		end;
	MResultado:= Matrix2; // Asigna la nueva matriz resultantes
	end;
procedure EscalarPorMatrix(var MResultado:TipoMatrix;resultado:real;fila,columna:ShortInt);
var fil:1..MaxFila;
	col:1..MaxColumna;
	begin
	for fil:=1 to fila do
		for col:=1 to columna do
		begin
		MResultado[fil,col]:= MResultado[fil,col] * resultado;
		end;
	end;
procedure TransponerMatrix(var MResultado:TipoMatrix;fila,columna:ShortInt);
var fil:1..MaxFila;
	col:1..MaxColumna;
	matriz:TipoMatrix;
	begin
	matriz:= MResultado;
	//-Transponemos la matriz original y se la asignamos a otra matrix auxiliar
	for fil:=1 to fila do
		for col:=1 to columna do
			matriz[col,fil]:= MResultado[fil,col];
	MResultado:= matriz; // Obtengo la matriz transpuesta
	end;

// <> ::= "biliprograma" "id" ";" <Declaracion> <Cuerpo> "biliend" ";"
procedure EvalPrograma(var arbol:t_punteroA; var estado:TEstado);
begin
	EvalDeclaracion(arbol^.Hijos.elem[4],estado); // Evaluamos Declaraciones
	EvalCuerpo(arbol^.Hijos.elem[5],estado); // Evaluamos Cuerpo
end;

// <Cuerpo> ::= <Sent> ";" <Cuerpo> | epsilon
procedure EvalCuerpo(var arbol:t_punteroA;var estado:TEstado);
begin
	if (arbol^.Hijos.cant <> 0) then
	begin
	EvalSent(arbol^.Hijos.elem[1],estado); // Evaluamos Sent
	EvalCuerpo(arbol^.Hijos.elem[3],estado); // Evaluamos Cuerpo
	end;
end;

// <Sent> ::= <Asignacion> | <Condicional> | <Ciclo> | <Escritura> | <Lectura>
procedure EvalSent(var arbol:t_punteroA;var estado:TEstado);
begin
	case arbol^.Hijos.elem[1]^.Complex of
	VAsignacion:begin
  				EvalAsignacion(arbol^.Hijos.elem[1],estado); // Evaluamos Asignacion
				end;
	VCondicional:begin
		EvalCondicional(arbol^.Hijos.elem[1],estado); // Evaluamos Condicional
		end;
	VCiclo:begin
		   EvalCiclo(arbol^.Hijos.elem[1],estado); // Evaluamos Ciclo
		   end;
	VLectura:begin
		   EvalLectura(arbol^.Hijos.elem[1],estado); // Evaluamos Lectura
		  end;
	VEscribir:begin
		   EvalEscritura(arbol^.Hijos.elem[1],estado); // Evaluamos Escritura
			  end;
	end;
end;
// <Asignacion> ::= ”id” “opasig” <EASumRes> | "idm" <AsignacionT> 
procedure EvalAsignacion(var arbol:t_punteroA;var estado:TEstado);
var resultado:real;
begin
	case arbol^.Hijos.elem[1]^.Complex of
	Tid:begin
		EvalEASumRes(arbol^.Hijos.elem[3],estado,resultado); // Evaluamos EASumRes para obtener un valor real
		AsignarReal(estado,arbol^.Hijos.elem[1]^.Lexema,resultado); // Asignamos el valor real al LexemaId
		end;
	Tidm:begin
		EvalAsignacionT(arbol^.Hijos.elem[2],estado,arbol^.Hijos.elem[1]^.Lexema); //Evaluamos AsignacionT pasando el LexemaId
		end;
	end;
end;
// <AsignacionT> ::= "opasig" <EMSumRes> | "[" <EASumRes> ";" <EASumRes> "]" "opasig" <EASumRes>
procedure EvalAsignacionT(var arbol:t_punteroA;var estado:TEstado;LexemaId:string);
var matriz:TipoMatrix;
	tamFil,fila:1..MaxFila;
	tamCol,columna:1..MaxColumna;
	filaReal,columnaReal,resultado:real;

begin
	fila:=1;
	columna:=1;
	case arbol^.Hijos.cant of
	// if(arbol^.Hijos.cant = 2)then
	2:  begin
		EvalEMSumRes(arbol^.Hijos.elem[2],estado,matriz,fila,columna); // Evaluamos EMSumRes para obtener una matriz y obtenemos la cantidad de filas y columnas que tiene la matriz
		tamFil:= filaDe(estado,LexemaId); // Obtenemos la cantidad de filas que tiene definida la matriz correspondiente al LexemaId
		tamCol:= columnaDe(estado,LexemaId); // Obtenemos la cantidad de columnas que tiene definida la matriz correspondiente al LexemaId
		if ((tamFil = fila) and (tamCol = columna)) then // Si la cantidad de filas y columnas de la matriz son las que estan definidas entonces
			begin
			AsignarMatriz(estado,LexemaId,matriz,fila,columna); // Asignar la matriz al LexemaId pasandole la cantidad de filas y la cantidad de columnas
			end
		else 	begin
				clrscr;
				writeln('Error: La cantidad de filas o columnas no coinciden con las declaradas a ',LexemaId);
				writeln('-- PRESIONE UNA TECLA --');
				readkey;
				Halt(); // Forzamos un error
				end;
		end;
	7:	begin
		EvalEASumRes(arbol^.Hijos.elem[2],estado,filaReal); // Obtenemos el valor real que corresponde a la fila
		fila:= trunc(filaReal); // Truncamos filaReal para que nos devuelva la parte entera del numero
		EvalEASumRes(arbol^.Hijos.elem[4],estado,columnaReal); // Obtenemos el valor real que corresponde a la columna
		columna:= trunc(columnaReal); // Truncamos columnaReal para que nos devuelva la parte entera del numero
		tamFil:= filaDe(estado,LexemaId); // Obtenemos la cantidad de filas que tiene definida la matriz correspondiente al LexemaId
		tamCol:= columnaDe(estado,LexemaId); // Obtenemos la cantidad de columnas que tiene definida la matriz correspondiente al LexemaId
		if ((fila <= tamFil) and (columna <= tamCol)) then // Si la fila y columna estan en el rango definido de la cantidad de filas y columas que puede tener la variable matricial
			begin
			EvalEASumRes(arbol^.Hijos.elem[7],estado,resultado); // Obtenemos el valor real 
			AsignarCeldaMat(estado,LexemaId,resultado,fila,columna); // Asignamos el valor real a la matriz en la fila y columna correspondiente
			end
		else 	begin
				clrscr;
				writeln('Error: La cantidad de filas o columnas sobrepasa las declaradas en ',LexemaId);
				writeln('-- PRESIONE UNA TECLA --');
				readkey;
				Halt(); // Forzamos un error
				end;
		end;
	end;
end;
// <Condicional> ::= "if" “(“ <CondAnd> “)” "then" <Cuerpo> <CondicionalF>
procedure EvalCondicional(var arbol:t_punteroA;var estado:TEstado);
var condicion:boolean;
begin
	EvalCondAnd(arbol^.Hijos.elem[3],estado,condicion); // Obtenemos el valor de la condicion
	if condicion then // Si la condicion es verdadera
		EvalCuerpo(arbol^.Hijos.elem[6],estado); // Evaluamos lo que este en el cuerpo
	EvalCondicionalF(arbol^.Hijos.elem[7],estado,condicion); // Evaluamos lo que ocurra en EvalCondicionalF pasando la condicion 

end;
// <CondicionalF> ::= "end" | "else" <Cuerpo> "end"
procedure EvalCondicionalF(var arbol:t_punteroA;var estado:TEstado;condicion:boolean);
begin
	if (arbol^.Hijos.cant > 1) then // Si la cantidad de producciones es mayor que 1 (osea que debe evaluar lo que este en el cuerpo)
		EvalCuerpo(arbol^.Hijos.elem[2],estado); // Evaluamos lo que este en el cuerpo
end;
// <Ciclo> ::= "while" “(“ <CondAnd> “)”  "do" <Cuerpo> "end"
procedure EvalCiclo(var arbol:t_punteroA;var estado:TEstado);
var condicion:boolean;
begin
	condicion:=true;
	EvalCondAnd(arbol^.Hijos.elem[3],estado,condicion); // Obtenemos el valor de la condicion
	while condicion do // Mientras la condicion sea verdadera
		begin
		EvalCuerpo(arbol^.Hijos.elem[6],estado); // Evaluamos lo que este en el cuerpo
		EvalCondAnd(arbol^.Hijos.elem[3],estado,condicion); // Obtenemos el valor de la condicion
		end;
end;
// <CondAnd> ::= <CondOr> <CondAndT>
procedure EvalCondAnd(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean);
begin
	EvalCondOr(arbol^.Hijos.elem[1],estado,condicion); // Evaluamos CondOr para obtener el valor de la condicion
	EvalCondAndT(arbol^.Hijos.elem[2],estado,condicion); // Evaluamos CondAndT por si la condicion resultante se cambia o no
end;
// <CondAndT> ::= “and” <CondOr> <CondAndT> | epsilon
procedure EvalCondAndT(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean);
var condicion2:boolean;
begin
	if (arbol^.Hijos.cant <> 0)then // Si hay producciones entonces
		begin
			EvalCondOr(arbol^.Hijos.elem[2],estado,condicion2); // Evaluamos EvalCondOr para obtener el valor de la condicion2
			condicion:= condicion and condicion2; // Obtenemos el valor de la conjuncion entre la condicion con la condicion2
			EvalCondAndT(arbol^.Hijos.elem[3],estado,condicion); // Evaluamos EvalCondAndT por si la condicion resultante se cambia o no
		end;
end;
// <CondOr> ::= <CondNot> <CondOrT>
procedure EvalCondOr(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean);
begin
	EvalCondNot(arbol^.Hijos.elem[1],estado,condicion); // Evaluamos EvalCondNot para obtener el valor de la condicion
	EvalCondOrT(arbol^.Hijos.elem[2],estado,condicion); // Evaluamos EvalCondOrT por si la condicion resultante se cambia o no
end;
// <CondOrT> ::= “or” <CondNot> <CondOrT> | epsilon
procedure EvalCondOrT(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean);
var condicion2:boolean;
begin
	if (arbol^.Hijos.cant <> 0) then // Si hay producciones entonces
	begin
		EvalCondNot(arbol^.Hijos.elem[2],estado,condicion2); // Evaluamos EvalCondNot para obtener el valor de la condicion2
		condicion:= condicion or condicion2; // Obtenemos el valor de la disyuncion entre la condicion con la condicion2
		EvalCondOrT(arbol^.Hijos.elem[3],estado,condicion); // Evaluamos EvalCondOrT por si la condicion resultante se cambia o no
	end;
end;
// <CondNot> ::= “not” <CondNot> | <EC>
procedure EvalCondNot(var arbol:t_punteroA;var estado:TEstado;var condicion:boolean);
begin
	if (arbol^.Hijos.cant > 1) then // Si hay mas de una produccion la condicion queda afectada por una negacion 
		begin
		EvalCondNot(arbol^.Hijos.elem[2],estado,condicion); // Evaluamos EvalCondNot para obtener el valor de la condicion 
		condicion:= not condicion; // Obtenemos la negacion de la condicion 
		end
	else // Si no se obtiene el valor de la condicion 
		EvalEC(arbol^.Hijos.elem[1],estado,condicion); // Evaluamos EvalEC para obtener el valor de la condicion
end;
// <EC> ::= <EASumRes> “OpRel” <EASumRes> | “[“ <CondAnd> “]”
procedure EvalEC(var arbol:t_punteroA;var estado:TEstado;var resultado:boolean);
var numero1,numero2:real;
begin
	if(arbol^.Hijos.elem[1]^.Complex = VEASumRes) then
		begin
		EvalEASumRes(arbol^.Hijos.elem[1],estado,numero1); // Evaluamos EvalEASumRes para obtener el valor del numero
		EvalEASumRes(arbol^.Hijos.elem[3],estado,numero2); // Evaluamos EvalEASumRes para obtener el valor del numero

		case arbol^.Hijos.elem[2]^.Lexema of // Dependiendo del lexema:
		'<': resultado:= numero1 < numero2; // Obtenemos la condicion al compara si el numero1 es menor que el numero2
		'>': resultado:= numero1 > numero2; // Obtenemos la condicion al compara si el numero1 es mayor que el numero2
		'==': resultado:= numero1 = numero2; // Obtenemos la condicion al compara si el numero1 es igual que el numero2
		'<>': resultado:= numero1 <> numero2; // Obtenemos la condicion al compara si el numero1 es distinto que el numero2
		'<=','=<': resultado:= numero1 <= numero2; // Obtenemos la condicion al compara si el numero1 es menor o igual que el numero2
		'>=','=>': resultado:= numero1 >= numero2; // Obtenemos la condicion al compara si el numero1 es mayor o igual que el numero2
		end;
		end
	else
		begin
			EvalCondAnd(arbol^.Hijos.elem[2],estado,resultado); // Evaluamos EvalCondAnd para obtener el valor de la condicion
		end;
end;
// <EASumRes> ::= <EAMultDiv> <EASumResT>
procedure EvalEASumRes(var arbol:t_punteroA;var estado:TEstado;var resultado:real);
begin
	EvalEAMultDiv(arbol^.Hijos.elem[1],estado,resultado); // Evaluamos EvalEAMultDiv para obtener el valor real
	EvalEASumResT(arbol^.Hijos.elem[2],estado,resultado); // Evaluamos EvalEASumResT por si el valor resultante se cambia o no
end;
// <EASumResT> ::= "+" <EAMultDiv> <EASumResT> | "-" <EAMultDiv> <EASumResT> | epsilon
procedure EvalEASumResT(var arbol:t_punteroA;var estado:TEstado;var resultado:real);
var numero2:real;
begin
	if(arbol^.Hijos.cant <> 0) then // Si hay producciones entonces
	begin
		case arbol^.Hijos.elem[1]^.Complex of
		Tmas:begin
			 EvalEAMultDiv(arbol^.Hijos.elem[2],estado,numero2); // Evaluamos EvalEAMultDiv para obtener el valor real
  			 resultado:= resultado + numero2; // Obtenemos el valor resultante de realizar resultado + numero2
  			 EvalEASumResT(arbol^.Hijos.elem[3],estado,resultado); // Evaluamos EvalEASumResT por si el valor resultante se cambia o no
			 end;
		Tmenos:begin
			   EvalEAMultDiv(arbol^.Hijos.elem[2],estado,numero2); // Evaluamos EvalEAMultDiv para obtener el valor real
	  		   resultado:= resultado - numero2; // Obtenemos el valor resultante de realizar resultado - numero2
	  		   EvalEASumResT(arbol^.Hijos.elem[3],estado,resultado); // Evaluamos EvalEASumResT por si el valor resultante se cambia o no
			   end;
		end;
	end;
end;
// <EAMultDiv> ::= <EAPotRaiz> <EAMultDivT>
procedure EvalEAMultDiv(var arbol:t_punteroA;var estado:TEstado;var resultado:real);
begin
	EvalEAPotRaiz(arbol^.Hijos.elem[1],estado,resultado); // Evaluamos EvalEAPotRaiz para obtener el valor real
	EvalEAMultDivT(arbol^.Hijos.elem[2],estado,resultado); // Evaluamos EvalEAMultDivT por si el valor resultante se cambia o no
end;
// <EAMultDivT> ::= "*" <EAPotRaiz> <EAMultDivT> | "/" <EAPotRaiz> <EAMultDivT> | epsilon
procedure EvalEAMultDivT(var arbol:t_punteroA;var estado:TEstado;var resultado:real);
var numero2:real;
begin
	if(arbol^.Hijos.cant <> 0) then // Si hay producciones entonces
	begin
		case arbol^.Hijos.elem[1]^.Complex of
		Tasterisco:begin
			 EvalEAPotRaiz(arbol^.Hijos.elem[2],estado,numero2); // Evaluamos EvalEAPotRaiz para obtener el valor real
  			 resultado:= resultado * numero2; // Obtenemos el valor resultante al realizar resultado * numero2
  			 EvalEAMultDivT(arbol^.Hijos.elem[3],estado,resultado); // Evaluamos EvalEAMultDivT por si el valor resultante se cambia o no
			 end;
		Tdividir:begin
			   EvalEAPotRaiz(arbol^.Hijos.elem[2],estado,numero2); // Evaluamos EvalEAPotRaiz para obtener el valor real
	  		   resultado:= resultado / numero2; // Obtenemos el valor resultante al realizar resultado / numero2
	  		   EvalEAMultDivT(arbol^.Hijos.elem[3],estado,resultado); // Evaluamos EvalEAMultDivT por si el valor resultante se cambia o no
			   end;
		end;
	end;
end;
// <EAPotRaiz> ::= <Factor> <EAPotRaizT>
procedure EvalEAPotRaiz(var arbol:t_punteroA;var estado:TEstado;var resultado:real);
begin
	EvalFactor(arbol^.Hijos.elem[1],estado,resultado); // Evaluamos EvalFactor para obtener el valor real
	EvalEAPotRaizT(arbol^.Hijos.elem[2],estado,resultado); // Evaluamos EvalEAPotRaizT por si el valor resultante se cambia o no
end;
// <Factor>::= "constreal" | "id" | <EMD> | “(“ <EASumRes> “)” | “sizeCol” “(“ “idm” “) |  “sizeFila” “(“ “idm” “)” |  "-" <Factor> 
procedure EvalFactor(var arbol:t_punteroA;var estado:TEstado;var resultado:real);
begin
	case arbol^.Hijos.elem[1]^.Complex of
	TConstReal:begin
				Val(arbol^.Hijos.elem[1]^.Lexema,resultado); // Obtenemos el valor real del numero que era de tipo string
				end;
	Tid:begin
		resultado:= ValorDe(estado,arbol^.Hijos.elem[1]^.Lexema,0,0); // Obtenemos el valor real que guarda la variable
		end;
	VEMD:begin
		EvalEMD(arbol^.Hijos.elem[1],estado,resultado); // Evaluamos EvalEMD Obtenemos el valor real que esta guardado en la variable matricial 
		end;
	TparentesisA:begin
				EvalEASumRes(arbol^.Hijos.elem[2],estado,resultado); // Evaluamos EvalEASumRes para obtener el valor real
				end;
	TsizeCol:begin
				resultado:= columnaDe(estado,arbol^.Hijos.elem[3]^.Lexema); // Obtenemos el valor maximo de columna que tiene la variable matricial
				end;
	TsizeFila:begin
				resultado:= filaDe(estado,arbol^.Hijos.elem[3]^.Lexema) // Obtenemos el valor maximo de la fila que tiene la variable matricial
				end;
	Tmenos:begin
			// Val(arbol^.Hijos.elem[2]^.Lexema,resultado);
			EvalFactor(arbol^.Hijos.elem[2],estado,resultado); // Evaluamos EvalFactor para obtener el valor real
			resultado:= -resultado; // Obtenemos el valor opuesto del valor real
			end;
	end;
end;
// <EAPotRaizT> ::= “**” <Factor> <EAPotRaizT> | “rqz” <Factor> <EAPotRaizT>| epsilon
procedure EvalEAPotRaizT(var arbol:t_punteroA;var estado:TEstado;var resultado:real);
var numero2:real;
begin
	if (arbol^.Hijos.cant <> 0)then // Si hay producciones entonces
		case arbol^.Hijos.elem[1]^.Complex of
		TDosAsteriscos:	begin
						EvalFactor(arbol^.Hijos.elem[2],estado,numero2); // Obtenemos un valor
						resultado:= power(resultado,numero2); // TIENE QUE SER ENTERO SI O SI
						EvalEAPotRaizT(arbol^.Hijos.elem[3],estado,resultado); // Evaluamos EAPotRaizT por si el valor resultante cambia de valor
						end;
		Trqz: 	begin
				EvalFactor(arbol^.Hijos.elem[2],estado,numero2); //ANALIZAR
					if((numero2 < 0) and (trunc(resultado) mod 2 <> 0)) then // Si el valor es negativo y el numero no es par (Usamos trunc() para trabajar con la parte entera del numero)
						begin
						resultado:= -power(-numero2,1/resultado); // Se obtiene el opuesto del valor al realizar resultado rqz numero2
						end
					else if (numero2 > 0) then
						begin
						resultado:= power(numero2,1/resultado); // Se obtiene el valor al realizar resultado rqz numero2
						end
						else begin
							clrscr;
							writeln('Error: no se puede calcular dicha raiz');
							writeln('-- PRESIONE UNA TECLA --');
							readkey;
							Halt(); // Forzamos un error
							end;
				end;
		end;
end;
// <Declaracion> ::=  "dec" <DeclaracionF> "decend" ";" | epsilon
procedure EvalDeclaracion(var arbol:t_punteroA; var estado:TEstado);
begin
	if (arbol^.Hijos.cant <> 0) then // Si hay producciones entonces
	begin
	EvalDeclaracionF(arbol^.Hijos.elem[2],estado); // Evaluamos EvalDeclaracionF
	end;
end;
// <DeclaracionF> ::= "id" ":" "Real" ";" <DeclaracionF> | "idm" ":" "matrix" "[" "constreal" “;” "constreal" “]” ";" <DeclaracionF> | epsilon
procedure EvalDeclaracionF(var arbol:t_punteroA;var estado:TEstado);
var lexema:string;
	tamFila,tamColumna:real;
	tamFil:0..MaxFila;
	tamCol:0..MaxColumna;
	tipo:Ttipo;
begin
	if arbol^.Hijos.cant <> 0 then // Si hay producciones entonces
	begin
		tamFil:=0;
		tamCol:=0;
		lexema:= arbol^.Hijos.elem[1]^.Lexema;
		case arbol^.Hijos.elem[1]^.Complex of
		Tid: begin
			tipo:= Treal;
			agregarVar(estado,lexema,tipo,tamFil,tamCol); // Agregamos el Lexema del valor real al estado
			EvalDeclaracionF(arbol^.Hijos.elem[5],Estado); // Evaluamos EvalDeclaracionF por si hay mas variables para declarar
			end;
		Tidm:begin
			tipo:= Tmatriz;
			Val(arbol^.Hijos.elem[5]^.Lexema,tamFila); //Convierte el string a real
			Val(arbol^.Hijos.elem[7]^.Lexema,tamColumna); //Convierte el string a real
			tamFil:= trunc(tamFila); //trunca el numero real para obtener la parte entera
			tamCol:= trunc(tamColumna); //trunca el numero real para obtener la parte entera
			agregarVar(estado,lexema,tipo,TamFil,TamCol); //Agrega el Lexema del valor matricial al estado
			EvalDeclaracionF(arbol^.Hijos.elem[10],Estado); // Evaluamos EvalDeclaracionF por si hay mas variables para declarar
			end;
		end;	
	end;
end;
// <EMD> ::= “idm” “[“ <EASumRes> “;” <EASumRes> “]”
procedure EvalEMD(var arbol:t_punteroA;var estado:TEstado;var resultado:real);
var fila,columna:real;
	fil:0..MaxFila;
	col:0..MaxColumna;
begin
	EvalEASumRes(arbol^.Hijos.elem[3],estado,fila); // Evaluamos EASumRes para obtener el valor real
	fil:= trunc(fila); // Truncamos el valor obtenido para quedarnos con la parte entera del numero
	EvalEASumRes(arbol^.Hijos.elem[5],estado,columna); // Evaluamos EASumRes para obtener el valor real
	col:= trunc(columna); // Truncamos el valor obtenido para quedarnos con la parte entera del numero
	resultado:= ValorDe(Estado,arbol^.Hijos.elem[1]^.Lexema,fil,col); // Obtenemos el valor real que esta en la celda de la matriz en la fila y columna correspondiente
end;
// <EMSumRes> ::= <EMMultTra> <EMSumResT>
procedure EvalEMSumRes(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt);
begin
	EvalEMMultTra(arbol^.Hijos.elem[1],estado,MResultado,fila,columna); // Evaluamos EvalEMMulTra para obtener la matriz resultante y la cantidad de filas y columnas
	EvalEMSumResT(arbol^.Hijos.elem[2],estado,MResultado,fila,columna); // Evaluamos EvalEMSumResT por si la matriz resultante, fila o columna cambia o no
end;
// <EMSumResT> ::= "+" <EMMultTra> <EMSumResT> | "-" <EMMultTra> <EMSumResT> | epsilon
procedure EvalEMSumResT(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt);
var Matrix1:TipoMatrix;
	filaM1:1..MaxFila;
	columnaM1:1..MaxColumna;
begin
	if (arbol^.Hijos.cant <> 0) then // Si hay producciones entonces
	begin
		case arbol^.Hijos.elem[1]^.Complex of
		Tmas:	begin
				// Procedure suma de matrices
				EvalEMMultTra(arbol^.Hijos.elem[2],estado,Matrix1,filaM1,columnaM1); // Obtenemos la matriz y la cantidad de filas y columnas
				if ((filaM1 = fila) and (columnaM1 = columna)) then // Si las dimensiones de ambas matrices son iguales entonces
					begin
					SumaEntreMatrices(MResultado,Matrix1,fila,columna);
					end
				else 	begin // Si las dimensiones de ambas matrices NO son iguales entonces
						clrscr;
						writeln('Error: Las dimensiones de ambas matrices deben ser las mismas');
						writeln('-- PRESIONE UNA TECLA --');
						readkey;
						Halt(); // Forzamos un error
						end;
				EvalEMSumResT(arbol^.Hijos.elem[3],estado,MResultado,fila,columna); // Evaluamos EMSumResT por si la matriz resultante, filas y columnas cambia o no
				end;
		Tmenos: begin
				// Procedure resta de matrices
				EvalEMMultTra(arbol^.Hijos.elem[2],estado,Matrix1,filaM1,columnaM1); // Obtenemos la matriz y la cantidad de filas y columnas
				if ((filaM1 = fila) and (columnaM1 = columna)) then // Si las dimensiones de ambas matrices son iguales entonces
					begin
					RestaEntreMatrices(MResultado,Matrix1,fila,columna);
					end
				else 	begin // Si las dimensiones de ambas matrices NO son iguales entonces
						clrscr;
						writeln('Error: Las dimensiones de ambas matrices deben ser las mismas');
						writeln('-- PRESIONE UNA TECLA --');
						readkey;
						Halt(); // Forzamos un error
						end;
				EvalEMSumResT(arbol^.Hijos.elem[3],estado,MResultado,fila,columna); // Evaluamos EMSumResT por si la matriz resultante, filas y columnas cambia o no
				end;
		end;
	end;
end;
// <EMMultTra> ::= <EMMultiEsc> <EMMultTraT>
procedure EvalEMMultTra(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt);
begin
	
	EvalEMMultiEsc(arbol^.Hijos.elem[1],estado,MResultado,fila,columna); // Evaluamos EMMultiEsc para obtener una matriz y las filas y columnas correspondientes a esa matriz
	EvalEMMultTraT(arbol^.Hijos.elem[2],estado,MResultado,fila,columna); // Evaluamos EMMultTraT por si la matriz resultante, fila y columna cambia o no
end;
// <EMMultTraT> ::= "*" <EMMultiEsc> <EMMultTraT> | epsilon
procedure EvalEMMultTraT(var arbol:t_punteroA;var estado:TEstado;Var MResultado:TipoMatrix;var fila,columna:ShortInt);
var Matrix1,Matrix2:TipoMatrix;
	filaM1,fil:1..MaxFila;
	columnaM1,col,k:1..MaxColumna;
	suma:real;
begin
	if (arbol^.Hijos.cant <> 0) then // Si hay producciones entonces
	begin
		EvalEMMultiEsc(arbol^.Hijos.elem[2],estado,Matrix1,filaM1,columnaM1); // Evaluamos EMMultiEsc para obtener una matriz y las filas y columnas correspondientes
		if (columna = filaM1) then // Si la columna de la primera matriz es igual a la fila de la otra matriz entonces
			begin
			MultiEntreMatrices(MResultado,Matrix1,fila,columna,columnaM1);//Realiza multiplicacion entre dos matrices
			columna:= columnaM1; // Asigna la nueva columna para la matriz resultante
			end
		else 	begin // Si no se cumple la condicion para que se pueda realizar la multiplicacion entre matrices
				clrscr;
				writeln('Error: La columna de la primera matriz debe coincidir con la fila de la segunda matriz');
				writeln('-- PRESIONE UNA TECLA --');
				readkey;
				Halt(); // Forzamos un error
				end;
		EvalEMMultTraT(arbol^.Hijos.elem[3],estado,MResultado,fila,columna); // Evaluamos EMMultTraT por si la matriz resultante, fila y columna cambia o no
	end;
end;
// <EMMultiEsc> ::= “idm” <EMMultiEscT> | <ConstMatrix> <EMMultiEscT> | “(“ <EMSumRes> “)” <EMMultiEscT> | "@" "(" <EMSumRes> “)”  <EMMultiEscT>
procedure EvalEMMultiEsc(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt);
var fil,nuevaFila:1..MaxFila;
	col,nuevaColumna:1..MaxColumna;
	matriz:TipoMatrix;
begin
	case arbol^.Hijos.elem[1]^.Complex of
	Tidm:	begin
			MResultado:=ValoMatrixDe(Estado,arbol^.Hijos.elem[1]^.Lexema); // Obtenemos la matriz asociada al identificador
			fila:= filaDe(estado,arbol^.Hijos.elem[1]^.Lexema); // Obtenemos la cantidad de filas que tiene la matriz
			columna:= columnaDe(estado,arbol^.Hijos.elem[1]^.Lexema); // Obtenemos la cantidad de columnas que tiene la matriz
			EvalEMMultiEscT(arbol^.Hijos.elem[2],estado,MResultado,fila,columna);
			end;
	VConstMatrix:	begin
					EvalConstMatrix(arbol^.Hijos.elem[1],estado,MResultado,fila,columna); // Evaluamos ConstMatrix para obtener una matriz y sus filas y columnas
					EvalEMMultiEscT(arbol^.Hijos.elem[2],estado,MResultado,fila,columna); // Evaluamos EMMultiEscT por si la matriz resultante, fila y columna cambia o no
					end;
	TparentesisA:	begin
					EvalEMSumRes(arbol^.Hijos.elem[2],estado,MResultado,fila,columna); // Evaluamos EMSumRes para obtener una matriz y sus filas y columnas
					EvalEMMultiEscT(arbol^.Hijos.elem[4],estado,MResultado,fila,columna); // Evaluamos EMMultiEscT por si la matriz resultante, fila y columna cambia o no
					end;
	Tarroba:	begin
				EvalEMSumRes(arbol^.Hijos.elem[3],estado,MResultado,fila,columna); // Evaluamos EMSumRes para obtener una matriz y sus filas y columnas
				TransponerMatrix(MResultado,fila,columna);
				//-Transponemos la matriz original y se la asignamos a otra matrix auxiliar
				//- Intercambio: lo que guardaba fila ahora lo guarda columna y lo que guardaba columna lo guarda fila
				{-}nuevaFila:= columna;
				{-}nuevaColumna:= fila;
				{-}fila:= nuevaFila;
				{-}columna:= nuevaColumna;
				EvalEMMultiEscT(arbol^.Hijos.elem[5],estado,MResultado,fila,columna); // Evaluamos EMMultiEscT por si la matriz resultante, fila y columna cambia o no
				end;
	end;
end;
// <EMMultiEscT>::= “^” <Factor> <EMMultiEscT> | epsilon
procedure EvalEMMultiEscT(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt);
var fil:1..MaxFila;
	col:1..MaxColumna;
	resultado:real;
begin
	if (arbol^.Hijos.cant <> 0) then // Si hay producciones entonces
	begin
	EvalFactor(arbol^.Hijos.elem[2],estado,resultado); // Evaluamos Factor para obtener un valor real
	EscalarPorMatrix(MResultado,resultado,fila,columna);
	EvalEMMultiEscT(arbol^.Hijos.elem[3],estado,MResultado,fila,columna); // Evaluamos EMMultiEscT por si la matriz resultante, fila y columna cambia o no
	end;
end;
// <Lectura> ::= “leer" (“ “ConstString” "," "id" “)”
procedure EvalLectura(var arbol:t_punteroA;var estado:TEstado);
var valor:real;
begin
	write(arbol^.Hijos.elem[3]^.Lexema,' '); // Mostramos un mensaje por pantalla
	readln(valor); // Leemos un valor real
	AsignarReal(estado,arbol^.Hijos.elem[5]^.Lexema,valor); // Asignamos el valor real al Lexema correspondiente
end;
// <Escritura> ::= “escribir" (“ <ListDatoEscr> “)”
procedure EvalEscritura(var arbol:t_punteroA;var estado:TEstado);
begin
	EvalListDatoEscr(arbol^.Hijos.elem[3],estado); // Muestra un listado de datos en una misma linea, separado por un espacio
	writeln(); // Despues de que muestre la lista de datos debe haber un salto de linea
end;
// <ListDatoEscr> ::= <DatoEscr> <ListDatoEscrF>
procedure EvalListDatoEscr(var arbol:t_punteroA;var estado:TEstado);
begin
	EvalDatoEscr(arbol^.Hijos.elem[1],estado); // Evaluamos DatoEscr para mostrar los datos por pantalla
	EvalListDatoEscrF(arbol^.Hijos.elem[2],estado); // Evaluamos ListDatoEscrF por si hay mas de un dato para mostrar
end;
// <ListDatoEscrF> ::= “,” <ListDatoEscr> | epsilon
procedure EvalListDatoEscrF(var arbol:t_punteroA;var estado:TEstado);
begin
	if (arbol^.Hijos.cant <> 0) then // Si hay producciones entonces
		begin
		EvalListDatoEscr(arbol^.Hijos.elem[2],estado); // Evaluamos ListDatoEscr por si hay mas datos para mostrar
		end;
end;
// <DatoEscr> ::= “ConstString” | <EASumRes> | "matrix" "(" <EMSumRes> ")"
procedure EvalDatoEscr(var arbol:t_punteroA;var estado:TEstado);
var resultado:real;
	TamFil,fila:1..MaxFila;
	TamCol,columna:1..MaxColumna;
	matriz:TipoMatrix;
begin
	TamFil:=1;
	TamCol:=1;
	fila:= 1;
	columna:= 1;
	case arbol^.Hijos.elem[1]^.Complex of
	TConstString: 	begin
					write(arbol^.Hijos.elem[1]^.Lexema,' '); // Mostramos el string
					end;
	VEASumRes:	begin
				EvalEASumRes(arbol^.Hijos.elem[1],estado,resultado); // Obtenemos un valor real
				write(resultado:0:3,' '); // Mostramos el valor real
				end;
	Tmatrix:	begin
	 			EvalEMSumRes(arbol^.Hijos.elem[3],estado,matriz,TamFil,TamCol); // Obtenemos la matriz
	 			write('{ ');
	 			for fila:=1 to tamFil do
		 			begin
		 				write('{');
		 				for columna:=1 to TamCol do
			 				begin
			 				write(matriz[fila,columna]:0:2); // Mostramos el valor real que se guarda en la matriz
			 				if ((columna - TamCol) <> 0) then
			 					write(', ');
			 				end;
			 				write('} ');
		 			end;
		 		write('}');
	 			end;
	end;
end;
// <ConstMatrix> ::= "{" <Filas> "}"
procedure EvalConstMatrix(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var fila,columna:ShortInt);
var i:0..MaxFila;
	j:0..MaxColumna;
begin
	i:=0;
	j:=0;
	EvalFilas(arbol^.Hijos.elem[2],estado,MResultado,i,j,fila,columna); // Evaluamos Filas para obtener una matriz y filas y columnas correspondientes
end;
// <Filas>::= "{" <Columnas> "}" <Filas> | epsilon
procedure EvalFilas(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var i,j,fila,columna:ShortInt);
begin
	if (arbol^.Hijos.cant <> 0) then
	begin
		if i <= MaxFila then
		begin
			inc(i);
			//matriz con i constante y j variable
			EvalColumnas(arbol^.Hijos.elem[2],estado,MResultado,i,j,fila,columna); // Evaluamos columnas para obtener una cada elemento de las columnas y la cantidad de columnas correspondientes
			j:=0;
			//Aumentar la variable i de la matriz que se pase
			EvalFilas(arbol^.Hijos.elem[4],estado,MResultado,i,j,fila,columna);  // Evaluamos Filas por si hay mas filas para analizar
		end;
	end;
	fila:=i; // Obtenemos la cantidad de filas
end;
// <Columnas>::= <EASumRes> <ColumnasT>
procedure EvalColumnas(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var i,j,fila,columna:ShortInt);
var resultado:real;
begin
	if j <= MaxColumna then
	begin
		inc(j);
		EvalEASumRes(arbol^.Hijos.elem[1],estado,resultado); // Obtenemos el valor real
		MResultado[i,j]:=resultado; // Asignamos el valor en la fila y columna correspondiente a la matriz
		//ASIGNAR NUMERO A CELDAS
		EvalColumnasT(arbol^.Hijos.elem[2],estado,MResultado,i,j,fila,columna); // Evaluamos ColumnasT por si hay mas columnas para analizar
	end;
	columna:=j; // Obtenemos la cantidad de columnas
end;
// <ColumnasT>::= "," <Columnas> | epsilon
procedure EvalColumnasT(var arbol:t_punteroA;var estado:TEstado;var MResultado:TipoMatrix;var i,j,fila,columna:ShortInt);
begin
	if (arbol^.Hijos.cant <> 0) then	
	begin
	EvalColumnas(arbol^.Hijos.elem[2],estado,MResultado,i,j,fila,columna); // Evaluamos Columnas por si hay mas columnas para analizar
	end;
end;
end.
