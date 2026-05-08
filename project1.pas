program project1;
{$codepage UTF8}
uses crt,Archivo,Analizador_lexico,unidad_arbol,tipos,analizador_sintactico,evaluador;
var 
	Fuente:FileOfChar;
	arbol:t_punteroA;
	error:boolean;
	estado:TEstado;
begin
	Analizador_Sintactico_DPNR(Fuente,arbol,error);
	guardar_arbol(arbol,'Arbol.TXT');
	writeln('AFUERA');
	if (error = False) then
	begin
		clrscr;
		EvalPrograma(arbol,estado);
		writeln('Presione una tecla para salir.');
	end;

	readkey;
end.