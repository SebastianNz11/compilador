import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "#"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Texto */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*

/* Número entero */
NumeroEnt = 0 | [1-9][0-9]*

/* Número flotante */
NumeroFlot = [0-9]+(\.[0-9]+)?

/* Cadena */
Cadena = \"([^\"\\]|\\.)*\"

/* Booleano */
Booleano = (true|false)

/* Parentesis y Llaves */
ParAbrir = "("
ParCierre = ")"
LlaAbrir = "{"
LlaCierre = "}"

/* Separadores */
Coma = ","
PuntoComa = ";"

/* Asignacion y Operaciones */
Asignacion = "="
OpeAritmetico = "+"|"-"|"*"|"/"
OpeLogico = "&&"|"||"|"!"
Comparacion = "=="|"!="|"<"|">"|"<="|"=>"

/* Ciclos */
Ciclo = (for|while|do-while)
InstCiclo = (break|continue)

/* Condicional */
Condicional = (if|else|else-if)
FinCondicional = (end-if)

%%

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/* Esta parte define el tipo de componente lexico */

/* Identificador */
\#{Identificador} {return token(yytext(), "VARIABLE", yyline, yycolumn);} 
\${Identificador} {return token(yytext(), "FUNCION", yyline, yycolumn);} 
\+{Identificador} {return token(yytext(), "OBJETO", yyline, yycolumn);} 

/* Números */
{NumeroEnt} { return token(yytext(), "ENTERO", yyline, yycolumn);}
{NumeroFlot} { return token(yytext(), "FLOTANTE", yyline, yycolumn);}

/* Cadenas */
{Cadena} { return token(yytext(), "CADENA", yyline, yycolumn);}

/* Booleano */
{Booleano} { return token(yytext(), "BOOLEANO", yyline, yycolumn);}

/* Parentesis y Llaves */
{ParAbrir} { return token(yytext(), "PARENTESIS_APERTURA", yyline, yycolumn);}
{ParCierre} { return token(yytext(), "PARENTESIS_CIERRE", yyline, yycolumn);}
{LlaAbrir} { return token(yytext(), "LLAVE_APERTURA", yyline, yycolumn);}
{LlaCierre} { return token(yytext(), "LLAVE_CIERRE", yyline, yycolumn);}

/* Separadores */
{Coma} { return token(yytext(), "COMA", yyline, yycolumn);}
{PuntoComa} { return token(yytext(), "PUNTO_Y_COMA", yyline, yycolumn);}

/* Asignacion y Operacion */
{Asignacion} { return token(yytext(), "ASIGNACION", yyline, yycolumn);}
{OpeAritmetico} { return token(yytext(), "OPERADOR_ARITMETICO", yyline, yycolumn);}
{OpeLogico} { return token(yytext(), "OPERADOR_LOGICO", yyline, yycolumn);}
{Comparacion} { return token(yytext(), "COMPARADOR", yyline, yycolumn);}

/* Ciclos */
{Ciclo} { return token(yytext(), "CICLO", yyline, yycolumn);}
{InstCiclo} { return token(yytext(), "INSTRUCCION_CICLO", yyline, yycolumn);}

/* Condicional */
{Condicional} { return token(yytext(), "CONDICIONAL", yyline, yycolumn);}
{FinCondicional} { return token(yytext(), "FIN_CONDICIONAL", yyline, yycolumn);}

. { return token(yytext(), "ERROR", yyline, yycolumn); } 