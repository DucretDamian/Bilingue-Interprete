unit lista_TS;

interface 

uses tipos;



Procedure CrearLista(VAR TS:TablaDeSimbolos);
Procedure InsertarEnLista (var TS:TablaDeSimbolos; palabra:TelemTS);

implementation

Procedure CrearLista(VAR TS:TablaDeSimbolos);
begin
    TS.tam:= 0;
    TS.cab:= NIL;
end;

Procedure InsertarEnLista (var TS:TablaDeSimbolos; palabra:TelemTS);
var
    dir, ant, act: T_punteroTS;
BEGIN
    new (dir);
    dir^.info:= palabra;
     IF (TS.cab = nil) OR (TS.cab^.info.lexema > palabra.lexema) THEN
     BEGIN
         dir^.sig := TS.cab;
         TS.cab := dir;
     END
     ELSE
         BEGIN
         ant := TS.cab;
         act := TS.cab^.sig;
         WHILE (act <> nil) AND (act^.info.lexema < palabra.lexema) DO
               BEGIN
             ant:= act;
             act:= act^.sig
             END;
         dir^.sig:= act;
         ant^.sig:= dir;
         END;
     inc(TS.tam);
 END;

end.