%{
	#include <stdio.h> 
	#include <iostream>
	#include "y.tab.h" 
	int mylineno=1;

%}

DIGIT			[0-9]   
LETTER			[a-zA-Z_]
NUMBER			{DIGIT}+
FLOAT			{DIGIT}*"."{DIGIT}*
IDENTIFIER		{LETTER|"_"}+{DIGIT}*
BOOL			{"true"|"false"}

%%
[ \t]			;
\n			{ mylineno++ ; 		}
"and"			{ return(AND);		}
"or"			{ return(OR);		}
"not"			{ return(NOT);		}
"break" 		{ return(BREAK);	}
"true"      		{ return(TRUE);		}
"false"      		{ return(FALSE);	}
"input"			{ return(INPUT);	}
"output"		{ return(OUTPUT);	}
float 			{ return(FLOAT);	}
int 			{ return(INT);		}
bool 			{ return(BOOL);		}
for 			{ return(FOR);		}
while 			{ return(WHILE);	}
if 			{ return(IF);		}
ifx 			{ return(IFX);		}
else 			{ return(ELSE);		}
return 			{ return(RETURN);	}
"==" 			{ return(DOUBLE_EQ);	}
"!=" 			{ return(NOT_EQ); 	}
main			{return(MAIN);		}
"<=" 			{ return(LESS_EQ);	}
">=" 			{ return(GREATER_EQ);	}
"++" 			{ return(INCR);		}
"--" 			{ return(DECR);		}
"+" 			{ return(PLUS);		}
"-" 			{ return(MINUS);	}
"*" 			{ return(MULT);		}
"/" 			{ return(DIV);		}
"=" 			{ return(EQUALS);	}
[<] 			{ return(LESS);		}
[>] 			{ return(GREATER);	}
\{ 			{ return(LCB);		}
\} 			{ return(RCB);		}
[\(] 			{ return(LP);		}
[/)] 			{ return(RP);		}
[;] 			{ return(SEMI);		}
[,] 			{ return(COMMA);	}
{DIGIT}+{LETTER}+ 	{ 			}
{LETTER}+{DIGIT}*	{ return(IDENTIFIER);	}
{DIGIT}+		{ return(INT_NUM);	}
{DIGIT}*"."{DIGIT}*	{ return(FLOAT_NUM);	}
.			{			}
%%
int yywrap(void)
{
	return 1;
}
