unit tipos;

interface
const MaxProduc = 10;
Type
	TipoSimboloGramatical= (VPrograma,VCuerpo,VSent,VAsignacion,VAsignacionT,VCondicional,VCondicionalF,VCiclo,
                          VCondAnd,VCondAndT,VCondOr,VCondOrT,VCondNot,VEC,VEASumRes,VEASumResT,VEAMultDiv,VEAMultDivT,
                          VEAPotRaiz,VFactor,VEAPotRaizT,VDeclaracion,VDeclaracionF,VEMD,VEMSumRes,
                          VEMSumResT,VEMMultTra,VEMMultTraT,VEMMultiEsc,VEMMultiEscT,VLectura,VEscribir,VListaDatoEscr,
                          VListaDatoEscrF,VDatoEscr,VConstMatrix,VFilas,VColumnas,VColumnasT,
                          Tbiliprograma,TpuntoYcoma,Tpunto,Tid,Tidm,Tdec,Tdecend,Tif,TparentesisA,TparentesisC,Twhile,Tescribir,Tleer,
                          Tbiliend,Tend,Telse,TsizeCol,TsizeFila,Tarroba,TConstString,TConstReal,Tnot,Tand,Tor,TcorcheteA,TcorcheteC,
                          Tmas,Tmenos,Tasterisco,Tdividir,TDosAsteriscos,Trqz,TOpRel,TAngulito,
                          Tcoma,TLlaveA,TLlaveC,TOpAsig,Tdo,Tthen,Tmatrix,Tdospuntos,Tof,Treal,pesos,error_lexico); //El valor "pesos" en los símbolos gramaticales indica fin de archivo.

  TElemTS= record   //TIPO DE ARCHIVO QUE CONTIENE: Lexema (string) y compLex (enumerado)
   compLex:TipoSimboloGramatical;
   Lexema:string;
  end;
  T_punteroTS = ^T_nodoTS;
  T_nodoTS = record
          info:TElemTS;
          sig:T_punteroTS;
          end;
  TablaDeSimbolos = record
        cab,act:T_punteroTS;
        tam:LongInt;
        end;
  // TIPOS PARA LA TAS
  tipo_variable = VPrograma..VColumnasT;
  tipo_terminal = Tbiliprograma..pesos;
  TProducciones = record
        elem: array [1..MaxProduc] of TipoSimboloGramatical;
        cant:0..MaxProduc;
        end;
  tipo_tas = array[tipo_variable, tipo_terminal] of ^TProducciones;
  // TIPOS PARA EL ARBOL
  t_punteroA = ^t_nodoA;
  
  t_hijosA = record
    elem: array[0..MaxProduc] of t_punteroA;
    cant: 0..MaxProduc;
    end;
  
  t_nodoA = record
    CompLex:TipoSimboloGramatical;
    Lexema:string;
    Hijos: t_hijosA;
    end;
  // TIPOS PARA LA PILA
  t_dato_pila = record
    Simbolo: TipoSimboloGramatical;
    arbol: t_punteroA;
    end;
  
  t_puntero = ^t_nodo;
  
  t_nodo = record
    info: t_dato_pila;
    sig: t_puntero;
    end;

  t_pila = record
    tope:t_puntero;
    tam:cardinal;
    end;
implementation

end.