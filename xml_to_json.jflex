import java_cup.runtime.*;

%%

%class XmlToJson
%cup
%unicode
%line
%column

%{
  private Symbol symbol(int type){
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value){
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

DIGIT = [0-9]
NUMBER = {DIGIT}+

LITERAL_STRING = \"([^\"\\]|\\.)*\"

TEXT = [a-zA-Z_0-9 ][a-zA-Z_0-9 ]+

//COMMENT = <!--(.)*-->

%%

"<" 		{System.out.println(yytext() + " OPEN_ANGLE"); return symbol(sym.OPEN_ANGLE);}
">" 		{System.out.println(yytext() + " CLOSE_ANGLE"); return symbol(sym.CLOSE_ANGLE);}
"/" 		{System.out.println(yytext() + " SLASH"); return symbol(sym.SLASH);}
"=" 		{System.out.println(yytext() + " ASSIGN"); return symbol(sym.ASSIGN);}
//"\""		{return symbol(sym.QUOTE_STRING);}

"&lt;"    	{return symbol(sym.LESS_THAN);}
"&gt;"    	{return symbol(sym.GREATER_THAN);}
"&amp;"    	{return symbol(sym.AMPERSAND);}
"&apost;"   {return symbol(sym.APOSTROPHE);}
"&quot;"    {return symbol(sym.QUOTE_MARK);}

//ID, o Jflex não permite criar um MACRO com regra de exclusão
//{ID} {return symbol(sym.ID, yytext());}
[a-zA-Z]+/(>)|(\s*\/>) {System.out.println(yytext() + " ID"); return symbol(sym.ID, yytext()); }

[a-zA-Z]+/={LITERAL_STRING}  {System.out.println(yytext() + " ID"); return symbol(sym.ID, yytext());}

{NUMBER} {return symbol(sym.NUMBER, Integer.parseInt(yytext()));}

//{SPACE} {System.out.println("ESPAÇO"); return symbol(sym.SPACE, " ");}

{LITERAL_STRING} { return symbol(sym.LITERAL_STRING, 
                   '\"' + yytext().substring(1, yytext().length() -1) + '\"'); } //(index, index) não inclusivo

{TEXT} {System.out.println(yytext() + " TEXT"); return symbol(sym.TEXT, yytext());}

//{COMMENT} {System.out.println("comentário encontrado");}

[ \t\r\n] {/* nothing */}
. {System.err.println("Erro: Caractere inválido!" + yytext() + 
                     " na linha " + (yyline + 1) + 
                     " e coluna " + (yycolumn + 1));}

<<EOF>> { return symbol(sym.EOF); }