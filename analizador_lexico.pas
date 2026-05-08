unit Analizador_lexico;

interface
{$codepage UTF8}
uses tipos,crt,lista_TS;

const
   MaxSim=200;			{ej: Tif debe relacionarse con ---> if }
   FinArch= #0;			//ESO DEBE REPRESENTAR LOS COMANDOS CLAVES QUE LEERA NUESTRO LENGUAJE
type					//ID, CREAL, CAD; WHILE, if, VAR, PUNTO, PYCOM, COMA, DOSP, MENOS, MAS, PESOS, ERROR
  

  FileOfChar= file of char;	//ARCHIVO DE CARACTERES
procedure cargarTS (var TS:TablaDeSimbolos);
procedure AgregarTS(var TS:TablaDeSimbolos; var lexema:string; var complex:TipoSimboloGramatical);
Function EsIdentificadorMatricial(var Fuente:FileOfChar;var Control:LongInt;var Lexema:string):Boolean;
Function EsIdentificador(Var Fuente:FileOfChar; Var Control:LongInt; Var Lexema:String):Boolean;
Function EsSimboloEspecial(var Fuente:FileOfChar; var Control:LongInt;var Lexema:String;var CompLex:TipoSimboloGramatical):Boolean;
procedure ObtenerSiguienteCompLex(Var Fuente:FileOfChar;var Control:LongInt;var CompLex:TipoSimboloGramatical;var Lexema:string;var TS:TablaDeSimbolos);
procedure LeerCar(var Fuente:FileOfChar;var control:Longint; var car:char);

implementation

procedure cargarTS (var TS:TablaDeSimbolos);
  var
     palabra:TelemTS;
  BEGIN
    crearlista(TS);

    inc(TS.tam);
    palabra.lexema:= 'biliprograma';
    palabra.complex:=  Tbiliprograma;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'biliend';
    palabra.complex:=  Tbiliend;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'end';
    palabra.complex:=  Tend;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'dec';
    palabra.complex:=  Tdec;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'decend';
    palabra.complex:=  Tdecend;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'escribir';
    palabra.complex:=  Tescribir;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'leer';
    palabra.complex:=  Tleer;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'while';
    palabra.complex:= Twhile;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'if';
    palabra.complex:=  Tif;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'else';
    palabra.complex:=  Telse;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'real';
    palabra.complex:=  Treal;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'do';
    palabra.complex:=  Tdo;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'then';
    palabra.complex:=  Tthen;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'and';
    palabra.complex:=  Tand;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'or';
    palabra.complex:=  Tor;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'not';
    palabra.complex:=  Tnot;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'end';
    palabra.complex:=  Tend;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'matrix';
    palabra.complex:=  Tmatrix;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'sizeCol';
    palabra.complex:=  TsizeCol;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'sizeFila';
    palabra.complex:=  TsizeFila;
    InsertarEnLista(TS,palabra);

    inc(TS.tam);
    palabra.lexema:= 'of';
    palabra.complex:=  Tof;
    InsertarEnLista(TS,palabra);


    inc(TS.tam);
    palabra.lexema:= 'rqz';
    palabra.complex:=  Trqz;
    InsertarEnLista(TS,palabra);

  end;
procedure AgregarTS(var TS:TablaDeSimbolos; var lexema:string; var complex:TipoSimboloGramatical);//Agrega Lexema y Complex a una tabla de simbolos
  var
     existe: boolean;
     aux: T_punteroTS;
     dato: TelemTS;
  begin
  existe := false;
  aux := TS.cab;
  while (aux <> nil) and (not existe) do
        begin
        if aux^.info.lexema <> Lexema then
           begin
                aux := aux^.sig
           end
        ELSE
            if aux^.info.lexema = Lexema then
            begin
                 existe := true;
                 CompLex := aux^.info.CompLex;
            end;
         end;
  if (not existe) then
  begin
       CompLex := tid;
       dato.lexema := Lexema;
       dato.CompLex := tid;
       InsertarEnLista (TS,dato);
  end;
  end;
Function EsIdentificadorMatricial(var Fuente:FileOfChar;var Control:LongInt;var Lexema:string):Boolean;
 const
  q0=0;
  F=[3];
  type
    Q=0..3;
    Sigma = (Letra,Digito,otro,Mayuscula);
    TipoDelta = Array[Q,Sigma] of Q;
  var 
    ControlAux:LongInt;
    EstadoActual:Q;
    Delta:TipoDelta;
    Car:Char;
    function CarASimb(Car:char):Sigma;
    begin
      Case Car of    //PRESTEN ATENCION ACA
      'a'..'z':CarASimb:=Letra;
      'A'..'Z':CarASimb:= Mayuscula;
      '0'..'9':CarASimb:= Digito;
      else
        CarASimb:=otro;
      end;
    end;

  begin
  {Cargar la tabla de transiciones}
  Delta[0,Mayuscula]:=1;
  Delta[0,Digito]:=2;
  Delta[0,otro]:=2;
  Delta[0,Letra]:=2;
  {--------------------}
  Delta[1,Mayuscula]:=1;
  Delta[1,Digito]:=1;
  Delta[1,otro]:=3;
  Delta[1,Letra]:=2;
  {--------------------}
  
  
  {Recorrer la cadena de entrada y cambiar estados}
  ControlAux:= Control;
  EstadoActual:=q0;
  Lexema:='';
  while (EstadoActual <> 3) and (EstadoActual <> 2) do
    begin
    LeerCar(Fuente,ControlAux,car);
    EstadoActual:= Delta[EstadoActual, CarASimb(car)];
    ControlAux:= ControlAux + 1;
    if EstadoActual <> 3 then
      Lexema:= Lexema + car;
    end;
  if EstadoActual in F then
    begin
    EsIdentificadorMatricial:= True;
    Control:= ControlAux-1;
    end
  else 
      EsIdentificadorMatricial:= False;
  end;
Function EsIdentificador(Var Fuente:FileOfChar; Var Control:LongInt; Var Lexema:String):Boolean;//Te dice si reconoce un identificador o no 
 Const
  q0=0;
  F=[3];
 Type
  Q=0..3;
  Sigma = (LetraMayuscula,LetraMinuscula,Digito,otro);
  TipoDelta=Array[Q,Sigma] of Q;
 Var
  ControlAux:LongInt;
  EstadoActual:Q;
  Delta:TipoDelta;
  Car:Char;

  function CarASimb(Car:char):Sigma;
  begin
    Case Car of    //PRESTEN ATENCION ACA
    'a'..'z':CarASimb:=LetraMinuscula;
    'A'..'Z':CarASimb:= LetraMayuscula;
    '0'..'9':CarASimb:= Digito;
    else
      CarASimb:=otro;
    end;
  end;

 Begin
  {Cargar la tabla de transiciones}
  Delta[0,Digito]:=1;
  Delta[0,otro]:=1;
  Delta[0,LetraMayuscula]:=0;
  Delta[0,LetraMinuscula]:=2;

  Delta[2,Digito]:=2;
  Delta[2,LetraMayuscula]:=2;
  Delta[2,LetraMinuscula]:=2;
  Delta[2,otro]:=3;

  {Recorrer la cadena de entrada y cambiar estados}
  ControlAux:=Control;
  EstadoActual:=q0;
  Lexema:='';
   While (EstadoActual <> 1) and (EstadoActual <> 3) do
    Begin
     LeerCar(Fuente, ControlAux, Car);
     EstadoActual:= Delta[EstadoActual,CarASimb(Car)];
     ControlAux:=ControlAux+1;
     If EstadoActual<>3 then
      Lexema:=Lexema+Car;
    End;
    If EstadoActual in F then
     Begin
      EsIdentificador:=True;
      Control:=ControlAux-1;
     End
      Else
       EsIdentificador:=False;
 End;
Function EsSimboloEspecial(var Fuente:FileOfChar; var Control:LongInt;var Lexema:String;var CompLex:TipoSimboloGramatical):Boolean;//Te dice si reconoce un simbolo especial o no (Usando AF)
  var car:char;
  begin
  EsSimboloEspecial:=False;
  LeerCar(Fuente,control,car);
  case car of
  ';': begin
        CompLex:= TpuntoYcoma;
        Lexema:= ';';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  '+': begin
        CompLex:= Tmas;
        Lexema:= '+';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  '-': begin
        CompLex:= Tmenos;
        Lexema:= '-';
        EsSimboloEspecial:=True;
        inc(Control);
        end;  
  '*': begin
        CompLex:= Tasterisco;
        Lexema:= '*';
        EsSimboloEspecial:=True;
        inc(Control);
        LeerCar(Fuente,Control,car);
          if car = '*' then
            begin
            Lexema:= '**';
            CompLex:= TDosAsteriscos;
            Inc(Control);
            end;
        end;
  '^': begin
        CompLex:= Tangulito;
        Lexema:= '^';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  '[': begin
        CompLex:= TcorcheteA;
        Lexema:= '[';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  ']': begin
        CompLex:= TcorcheteC;
        Lexema:= ']';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  '(': begin
        CompLex:= TparentesisA;
        Lexema:= '(';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  ')': begin
        CompLex:= TparentesisC;
        Lexema:= ')';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  '{': begin
        CompLex:= TLlaveA;
        Lexema:= '{';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  '}': begin
        CompLex:= TLlaveC;
        Lexema:= '}';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  ',': begin
        CompLex:= Tcoma;
        Lexema:= ',';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  '/': begin
        CompLex:= Tdividir;
        Lexema:= '/';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  '@': begin
        CompLex:= Tarroba;
        Lexema:= '@';
        EsSimboloEspecial:=True;
        inc(Control);
        end;
  {'.': begin
          CompLex:= Tpunto;
          Lexema:= '.';
          EsSimboloEspecial:=True;
          inc(Control);
          end;}
  '>': begin
        CompLex:= Toprel;
        Lexema:= '>';
        EsSimboloEspecial:=True;
        inc(Control);
        LeerCar(Fuente,Control,car);
          if car = '=' then
            begin
            Lexema:= '>=';
            Inc(Control);
            end;
          end;
  '<': begin
          CompLex:= Toprel;
          Lexema:= '<';
          EsSimboloEspecial:=True;
          inc(Control);
          LeerCar(Fuente,Control,car);
          case car of
          '>': begin
              Lexema:= '<>';
              Inc(Control);
              end;
          '=': begin
              Lexema:= '<=';
              Inc(Control);
              end;
          end;
          end;
  '=': begin
        CompLex:=Toprel;
        Lexema:='=';
        EsSimboloEspecial:=True;
        Inc(Control);
        LeerCar(Fuente,Control,car);
        case car of
        '>': begin
            Lexema:= '=>';
            Inc(Control);
            end;
        '<': begin
            Lexema:= '=<';
            Inc(Control);
            end;
        end;
        end;
  ':': begin
        CompLex:= Tdospuntos;
        Lexema:= ':';
        EsSimboloEspecial:=True;
        inc(Control);
        LeerCar(Fuente,Control,car);
        if car = '=' then
          begin
          CompLex:= Topasig;
          Lexema:= ':=';
          Inc(Control);
          end;
        end;
  end;
  end;
Function EsConstanteReal(var Fuente:FileOfChar;var Control:Longint;var Lexema:string):Boolean;//Te dice si reconoce una constante real o no (Usando AF)
  Const 
    q0=0;
    F=[4];
    Muerto = 5;
  Type 
    Sigma = (Menos,Digito,Coma,Otro);
    Q= 0..6;
    TipoDelta= Array[Q,Sigma] of Q;
  var 
    ControlAux:LongInt;
    EstadoActual:Q;
    Delta:TipoDelta;
    Car:Char;

    function CarASimb(Car:char):Sigma;
    begin
      Case Car of    //PRESTEN ATENCION ACA
      '.':CarASimb:=Coma;
      //'-':CarASimb:=Menos;
      '0'..'9':CarASimb:= Digito;
      else
        CarASimb:=Otro;
      end;
    end;

  begin
  {TRANSICIONES}
  Delta[0,Digito]:=2;
  // Delta[0,Menos]:=1; //<- NO VA
  Delta[0,Coma]:=5; 
  Delta[0,Otro]:=5;
  {-------NO VA--------}
  // Delta[1,Digito]:=2; 
  // Delta[1,Menos]:=5;
  // Delta[1,Coma]:=5;
  // Delta[1,Otro]:=5;
  {---------------}
  Delta[2,Digito]:=2;
  // Delta[2,Menos]:=5; //<- NO VA
  Delta[2,Coma]:=3;
  Delta[2,Otro]:=4;
  {---------------}
  Delta[3,Digito]:=6;
  // Delta[3,Menos]:=5; //<- NO VA
  Delta[3,Coma]:=5;
  Delta[3,Otro]:=5;
  {---------------}
  {Delta[4,]:=;
    Delta[4,]:=;
    Delta[4,]:=;
    Delta[4,]:=;}
  {---------------}
  {Delta[5,]:=;}
  {Delta[5,]:=;}
  {Delta[5,]:=;}
  {Delta[5,]:=;}
  {---------------}
  Delta[6,Digito]:=6;
  // Delta[6,Menos]:=5;  //<- NO VA
  Delta[6,Coma]:=5;
  Delta[6,Otro]:=4;

  {Recorrer la cadena de entrada y cambiar estados}
  ControlAux:=Control;
  EstadoActual:=q0;
  Lexema:='';
   While (EstadoActual <> Muerto) and (EstadoActual <> 4) do
    Begin
     LeerCar(Fuente, ControlAux, Car);
     EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
     ControlAux:=ControlAux+1;
     If (EstadoActual = 2)or((EstadoActual = 3)or(EstadoActual = 6)) then
      Lexema:=Lexema+Car;
    End;
    If EstadoActual in F then
     Begin
      EsConstanteReal:=True;
      Control:=ControlAux-1;
     End
      Else 
       EsConstanteReal:=False;
  End;
Function EsCadena(var Fuente:FileOfChar;var Control:LongInt;var Lexema:string):Boolean;//Te dice si reconoce una cadena o no (Usando AF)
  Const
  q0=0;
  F=[4];
 Type
  Q=0..5;
  Sigma = (ComillaSimp,Caracter,otro);
  TipoDelta=Array[Q,Sigma] of Q;
 Var
  ControlAux:LongInt;
  EstadoActual:Q;
  Delta:TipoDelta;
  Car:Char;

  function CarASimb(Car:char):Sigma;
  begin
    Case Car of    //PRESTEN ATENCION ACA
    'a'..'z','A'..'Z','0'..'9':CarASimb:=Caracter;
    chr(39):CarASimb:= ComillaSimp;
    else
      CarASimb:=otro;
    end;
  end;

 Begin
  {Cargar la tabla de transiciones}
  Delta[0,otro]:= 5;
  Delta[0,Caracter]:= 5;
  Delta[0,ComillaSimp]:= 1;
  {-------------}
  Delta[1,ComillaSimp]:= 5;
  Delta[1,otro]:= 2;
  Delta[1,Caracter]:= 2;
  {-------------}
  Delta[2,ComillaSimp]:= 3;
  Delta[2,Otro]:= 2;
  Delta[2,Caracter]:= 2;
  {-------------}
  Delta[3,Otro]:= 4;
  {Recorrer la cadena de entrada y cambiar estados}
  ControlAux:=Control;
  EstadoActual:=q0;
  Lexema:='';
   While (EstadoActual <> 5) and (EstadoActual <> 4) do
    Begin
     LeerCar(Fuente, ControlAux, Car);
     EstadoActual:= Delta[EstadoActual,CarASimb(Car)];
     ControlAux:=ControlAux+1;
     If (EstadoActual<>4)  and ((EstadoActual <> 1) and (EstadoActual <> 3)) then // Esto hace que mientras no haya llegado al final, que guarde los caracteres que va leyendo...
      Lexema:=Lexema+Car; // pero sin contar las comillas simples que estan en EstadoActual = 1 y EstadoActual = 3
    End;
    If EstadoActual in F then
     Begin
      EsCadena:=True;
      Control:=ControlAux-1;
     End
      Else
       EsCadena:=False;
 End;
procedure ObtenerSiguienteCompLex(Var Fuente:FileOfChar;var Control:LongInt;var CompLex:TipoSimboloGramatical;var Lexema:string;var TS:TablaDeSimbolos);
  var car:char;
  begin {La TS ya ingresa cargada con las palabras reservadas}
    {Avanzar el control salteando tos los caracteres de control y espacios, hasta el primer caracter significativo}
    LeerCar(Fuente,Control,car);
    cargarTS(TS);
    while car in [#1..#32] do//Si el caracter esta en el rango de 1 a 32 del codigo ASCII (Avanzar el control salteando tos los caracteres de control y espacios, hasta el primer caracter significativo)
      begin
        control:=control+1;
        LeerCar (Fuente,control,car);
        end;
    if car = #0 then//Si el caracter es Nulo
      CompLex:= pesos
    else if EsIdentificador(Fuente,Control,Lexema) then
      AgregarTS(TS,Lexema,CompLex)
    else if EsIdentificadorMatricial(Fuente,Control,Lexema) then
      begin
      // writeln('---COMPLEX: ',Complex);
      // AgregarTS(TS,Lexema,CompLex);
      // readkey;
       CompLex:= Tidm;
      end
    else if EsConstanteReal(Fuente,Control,Lexema) then
      CompLex:= TConstReal
    else if EsCadena(Fuente,Control,Lexema) then
      Complex:= TConstString
    {else ....}
    else if Not EsSimboloEspecial(Fuente,Control,Lexema,Complex) then
      begin
      CompLex:= error_lexico;
      Control:= Control + 1;
      end;
    // writeln(Complex);
  end;
procedure LeerCar(var Fuente:FileOfChar;var control:Longint; var car:char);//Lee el proximo caracter del archivo
  begin
    if control < filesize(Fuente) then
      begin
        seek(FUENTE,control);
        read(fuente,car);
      end
    else
        begin
          car:=FinArch;
        end;
  end;

end.

