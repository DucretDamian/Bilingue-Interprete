unit unidad_arbol;
interface
uses tipos,crt;

procedure crear_arbol(var raiz:t_punteroA;lexemaa:string;complexx:TipoSimboloGramatical);
procedure crear_nodo(var raiz:t_punteroA;var complexx:TipoSimboloGramatical);
procedure agregar_hijo(var raiz:t_punteroA; var hijo:t_punteroA);
procedure guardar_arbol(var raiz:t_punteroA;ruta:string);
procedure guardar_nodo(var raiz:t_punteroA;var arch:text;desplazamiento:integer);
// procedure agregar_dato_arbol(var raiz:t_punteroA;dato_arbol:TipoSimboloGramatical);
implementation
procedure crear_arbol(var raiz:t_punteroA;lexemaa:string;complexx:TipoSimboloGramatical);
var i:byte;
	begin
	new(raiz);
	raiz^.Complex:= complexx;
	raiz^.Lexema:= lexemaa;
	raiz^.Hijos.cant:= 0;
	for i:=0 to MaxProduc do
		begin
		raiz^.Hijos.elem[i]:= nil;
		end;
	end;
procedure crear_nodo(var raiz:t_punteroA;var complexx:TipoSimboloGramatical);
	begin
	new(raiz);
	raiz^.Complex:= complexx;
	raiz^.Lexema:= '';
	raiz^.Hijos.cant:= 0;
	end;
procedure agregar_hijo(var raiz:t_punteroA; var hijo:t_punteroA);
	begin
	if raiz^.Hijos.cant < MaxProduc then
		begin
			inc(raiz^.Hijos.cant);
			raiz^.Hijos.elem[raiz^.Hijos.cant]:= hijo;
		end;
	end;
procedure guardar_arbol(var raiz:t_punteroA;ruta:string);
var arch:text;
	begin
	assign(arch,ruta);
	rewrite(arch);
	guardar_nodo(raiz,arch,0);
	close(arch);
	end;
procedure guardar_nodo(var raiz:t_punteroA;var arch:text;desplazamiento:integer);
var i:integer;
	begin
	writeln(arch,'':desplazamiento,raiz^.Complex,' (',raiz^.Lexema,')');
	for i:=1 to raiz^.Hijos.cant do 
		begin
		guardar_nodo(raiz^.Hijos.elem[i],arch,desplazamiento + 2);
		end;  
	end;
end.