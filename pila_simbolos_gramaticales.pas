unit pila_simbolos_gramaticales;

interface
uses tipos,crt;
procedure crear_pila(var p:t_pila);
procedure apilar(var p:t_pila;dato_pila:t_dato_pila);
procedure desapilar(var p:t_pila;var dato_pila:t_dato_pila);
procedure apilarTodo(var p:t_pila;var arbol:t_punteroA);
function pila_vacia(p:t_pila):boolean;
implementation
procedure crear_pila(var p:t_pila);
	begin
	p.tope:=nil;
	p.tam:=0;
	end;
procedure apilar(var p:t_pila;dato_pila:t_dato_pila);
	var act,dir:t_puntero;
		begin
		new(dir);
		dir^.info:= dato_pila;
		dir^.sig:= p.tope;
		p.tope:= dir;
		inc(p.tam);
		end;
procedure desapilar(var p:t_pila;var dato_pila:t_dato_pila);
	var dir:t_puntero;
		begin
		dir:= p.tope;			//Dir guarda el puntero que esta en la cabecera
		dato_pila:= dir^.info;	//A dato_pila guarda el valor que hay en dir^.info
		p.tope:= p.tope^.sig;		//A cabecera hago que a punte a lo siguiente de cabecera 
		dispose(dir);	//Elimino Dir
		dec(p.tam);		//Decremento el tamaño de la pila
		end;
procedure apilarTodo(var p:t_pila;var arbol:t_punteroA);
var i:0..MaxProduc;
	dato_pila:t_dato_pila;
	begin
	for i:= arbol^.Hijos.cant downto 1 do
		begin
		dato_pila.arbol:= arbol^.Hijos.elem[i];
		dato_pila.Simbolo:= arbol^.Hijos.elem[i]^.Complex;
		apilar(p,dato_pila)
		end;
	end;
function pila_vacia(p:t_pila):boolean;	//Usar como: mientras NO(pila_vacia(P)) do
	begin
	pila_vacia:= p.tam = 0;
	end;
end.