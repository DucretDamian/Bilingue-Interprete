unit Archivo;

interface
{$codepage UTF8}
const ruta= 'Lenguaje.txt';
type
  FileOfChar = file of char;

procedure crear_y_abrir_Fuente(var Fuente:FileOfChar);
procedure cerrar_Fuente(var Fuente:FileOfChar);
procedure leer_Fuente(var Fuente:FileOfChar;var dato:char;control:Longint);
procedure escri_Fuente(var Fuente:FileOfChar;dato:char;control:Longint);
implementation
procedure crear_y_abrir_Fuente(var Fuente:FileOfChar);
begin
   assign(Fuente,ruta);
   {$I-}
   reset(Fuente);
   {$I+}
   if IOResult <> 0 then
   rewrite(Fuente);
end;
procedure cerrar_Fuente(var Fuente:FileOfChar);
begin
   close(Fuente);
end;
procedure leer_Fuente(var Fuente:FileOfChar;var dato:char;control:Longint);
begin
   seek(Fuente,control);
   read(Fuente,dato);
end;
procedure escri_Fuente(var Fuente:FileOfChar;dato:char;control:Longint);
begin
   seek(Fuente,control);
   write(Fuente,dato);
end;

end.

