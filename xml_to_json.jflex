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

//Captura textos que estejam entre aspas, INCLUINDO as próprias aspas de delimitação
LITERAL_STRING = \"([^\"\\]|\\.)*\"

//TEXT = [a-zA-Z_0-9 ][a-zA-Z_0-9 ]+
COMMENT = "<!--"[^\-]*"-->"

%%

{COMMENT} { System.out.println(yytext().trim() + " COMENTÁRIO"); }

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

//O Jflex NÃO permite criar um MACRO se o regex possui regra de exclusão
//ID de uma tag não identificada --> <tag >
[a-zA-Z_]+/(\s*>)|(\s*\/>)|(\s+[a-zA-Z]+=) {System.out.println(yytext().trim() + " ID"); return symbol(sym.ID, yytext().trim()); }

//O Jflex NÃO permite criar um MACRO se o regex possui regra de exclusão
//ID de uma tag identificada --> <tag id="placeholder">
[a-zA-Z_]+/=  {System.out.println(yytext().trim() + " ID"); return symbol(sym.ID, yytext().trim());}

{NUMBER} {return symbol(sym.NUMBER, Integer.parseInt(yytext()));}

{LITERAL_STRING} { System.out.println(yytext() + " LITERAL_STRING ");
                   return symbol(sym.LITERAL_STRING, 
                   '\"' + yytext().substring(1, yytext().length() -1) + '\"'); } //(index, index) não inclusivo

{COMMENT} { String string_comment = yytext().substring(4, yytext().length() - 3);
            System.out.println("COMENTÁRIO: (line " + (yyline + 1) + "):" + string_comment );
            return symbol(sym.COMMENT, string_comment);}

//O Jflex NÃO permite criar um MACRO se o regex possui regra de exclusão
//TEXT
//todo texto entre tags sempre aparece logo antes de um "OPEN_ANGLE <" da tag de fechamento
//<tag> texto escrito aqui </tag>
\s*[a-zA-Z0-9,_\-':+#\.][a-zA-Z0-9,_\-':+#\.\s]+/< {System.out.println(yytext().trim() + " TEXT"); return symbol(sym.TEXT, yytext().trim().replace("\r\n","\\n"));}

[ \t\r\n]+ {/* nothing */}
. {System.err.println("Erro: Caractere inválido!" + yytext() + 
                     " na linha " + (yyline + 1) + 
                     " e coluna " + (yycolumn + 1));}

<<EOF>> { return symbol(sym.EOF); }