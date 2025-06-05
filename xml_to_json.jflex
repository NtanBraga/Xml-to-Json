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
ID = [a-zA-Z]+
TEXT = [a-zA-Z_0-9]+
COMMENT = <!--[a-zA-Z_0-9]*-->

%%

"<" 		{return symbol(sym.OPEN_ANGLE);}
">" 		{return symbol(sym.CLOSE_ANGLE);}
"/" 		{return symbol(sym.SLASH);}
"=" 		{return symbol(sym.ASSIGN);}
"\""		{return symbol(sym.QUOTE_STRING);}

"&lt;"    	{return symbol(sym.LESS_THAN);}
"&gt;"    	{return symbol(sym.GREATER_THAN);}
"&amp;"    	{return symbol(sym.AMPERSAND);}
"&apost;"   {return symbol(sym.APOSTROPHE);}
"&quot;"    {return symbol(sym.QUOTE_MARK);}


{ID} {return symbol(sym.ID, yytext());}
{NUMBER} {return symbol(sym.NUM, Integer.parseInt(yytext()));}
{TEXT} {return symbol(sym.TEXT, yytext());}

[ \t\r\n] {/* nothing */}
. {System.err.printl("Erro: Caractere inválido!" + yytext() + 
                     " na linha " + (yyline + 1) + 
                     " e coluna " + (yycolumn + 1));}

<<EOF>> { return symbol(sym.EOF); }