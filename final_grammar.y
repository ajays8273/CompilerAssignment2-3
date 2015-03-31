%{
	#include <bits/stdc++.h>
	using namespace std;
	#define YYSTYPE holder_union
	extern int yyparse(void);
	extern int yylex();
	extern int mylineno ;
	extern char* yytext ;
	extern int yyleng;
	void yyerror(string);
	int flag=0;
	struct node_struct {
		string code_node;
		vector<node_struct*> v_node;
		string id_node;
		string dtype_node;
	};
	union holder_union {
		node_struct* node_holder;
		char* s_holder;
	};
	
	node_struct* root_node_struct=NULL;	
%}

%token INT FLOAT BOOL VOID
%token INT_NUM FLOAT_NUM TRUE FALSE IDENTIFIER  
%token SEMI LP RP COMMA LCB RCB 
%token MAIN INPUT OUTPUT WHILE FOR IF IFX ELSE BREAK RETURN
%token EQUALS DOUBLE_EQ GREATER GREATER_EQ LESS LESS_EQ NOT_EQ 
%token MULT DIV INCR DECR AND OR NOT PLUS MINUS

%start START_CODE
%%

START_CODE		:	global main LP parameters_list RP Compound_statements
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "START_CODE";
					root_node_struct = new_node_struct;
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					(new_node_struct->v_node).push_back($4.node_holder);
					(new_node_struct->v_node).push_back($6.node_holder);
					$$.node_holder = new_node_struct;
				}
  			;
  			
main 		:	MAIN 
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "main";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

global  		: 	declaration_list			
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "global_declaration_list";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	/*empty input*/
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "global_empty";
					$$.node_holder = new_node_struct;
				}
			;
						
declaration_list	:	declaration_list declaration
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "declaration_list";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}		
			|	declaration
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "declaration";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}							
			;
						
declaration		:	variable_declaration
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "declaration_variable";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}					
			|		function_declaration					
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "declaration_function";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

variable_declaration	:	type_specifier identifier  SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "variable declaration";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	type_specifier identifier  error 	{flag=1;}
			;
			
identifier	:	IDENTIFIER	
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "identifier";
				new_node_struct->id_node = string(yytext,strlen(yytext));
				$$.node_holder = new_node_struct;
			}
		;
			
type_specifier		:	int
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "dtype_node_int";
					new_node_struct->id_node = string(yytext,yyleng);
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	float
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "dtype_node_float";
					new_node_struct->id_node = string(yytext,yyleng);
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	bool
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "dtype_node_bool";
					new_node_struct->id_node = string(yytext,yyleng);
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			
			|	error	{flag=1;}
			;

int 		:	INT
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "INT";
				new_node_struct->id_node = string(yytext,strlen(yytext));
				$$.node_holder = new_node_struct;
			}
		;
		
float 		:	FLOAT
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "FLOAT";
				new_node_struct->id_node = string(yytext,strlen(yytext));
				$$.node_holder = new_node_struct;
			}
		;

bool 		:	BOOL
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "BOOL";
				new_node_struct->id_node = string(yytext,strlen(yytext));
				$$.node_holder = new_node_struct;
			}
		;
			


function_declaration	:	type_specifier identifier LP parameters_list RP Compound_statements
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "function_declaration";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					(new_node_struct->v_node).push_back($4.node_holder);
					(new_node_struct->v_node).push_back($6.node_holder);
					$$.node_holder = new_node_struct;
				}		
			;


parameters_list		:	parameters_list COMMA parameters
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "param_list";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					$$.node_holder = new_node_struct;
				}
			|		parameters
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "param";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	/*empty*/
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "empty_param";
					$$.node_holder = new_node_struct;
				}
			;
							
parameters		:	type_specifier	identifier
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "parameters";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

Statement_list		:	Statement_list	Statements	
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Statements list";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}				
			|	/*empty*/
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "emptyStatement_list";
					$$.node_holder = new_node_struct;
				}										
			;	

Statements		:	Output_statements
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Output Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	Input_statements
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "input Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	Function_call_statements
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "function Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			
			|	Compound_statements
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Compound Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	Loop_statements
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Loop Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	Condition_statements
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Condition Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	Expression_statements 
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "expr Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	Break_statement
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "break Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	Return_statement
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "return Statements";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;



Function_call_statements	:	identifier equals identifier LP Identifier_list RP SEMI
					{
						node_struct *new_node_struct = new node_struct;
						new_node_struct->code_node = "Function Statements1";
						(new_node_struct->v_node).push_back($1.node_holder);
						(new_node_struct->v_node).push_back($2.node_holder);
						(new_node_struct->v_node).push_back($3.node_holder);
						(new_node_struct->v_node).push_back($5.node_holder);
						$$.node_holder = new_node_struct;
					}
				| 		identifier equals identifier LP Identifier_list RP error	{flag=1;}
				|		identifier LP Identifier_list RP SEMI
					{
						node_struct *new_node_struct = new node_struct;
						new_node_struct->code_node = "Function Statements2";
						(new_node_struct->v_node).push_back($1.node_holder);
						(new_node_struct->v_node).push_back($3.node_holder);
						$$.node_holder = new_node_struct;
					}
				| 	identifier LP Identifier_list RP error		{flag=1;}
				;
				
Identifier_list		:	Identifier_list COMMA identifier
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Identifier_list";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	identifier
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Identifier_list_single";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	/*empty*/
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Identifier_list_empty";
					$$.node_holder = new_node_struct;
				}
			;

Output_statements	:	output LP type_specifier COMMA identifier RP SEMI
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Print statement";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					(new_node_struct->v_node).push_back($5.node_holder);
					$$.node_holder = new_node_struct;
				}
			;			

output		: 	OUTPUT
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "OUTPUT";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}			
		;
					
Input_statements	:	input LP type_specifier COMMA identifier RP SEMI
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Input statement";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					(new_node_struct->v_node).push_back($5.node_holder);
					$$.node_holder = new_node_struct;
				}
			;			

input		: 	INPUT
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "INPUT";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}			
		;
		
Compound_statements	:	LCB local_declaration Statement_list RCB
				{
					node_struct *new_node_struct = new node_struct;
					new_node_struct->code_node = "Compound Statements";
					(new_node_struct->v_node).push_back($2.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					$$.node_holder = new_node_struct;
				}
			;
						
local_declaration	:	local_declaration variable_declaration
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "Local declaration";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}						
			| 	/*empty*/
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "local empty";
					$$.node_holder = new_node_struct;
				}											
			;

Loop_statements		:	while LP expression RP 	Compound_statements
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "while LOOP";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					(new_node_struct->v_node).push_back($5.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	while LP error RP 	{flag=1;}
			|	while LP expression RP  error '\n' 	{flag=1;}
			|	for LP Expression_statements expression SEMI Expression_statements RP 	Compound_statements	
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "for LOOP";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					(new_node_struct->v_node).push_back($4.node_holder);
					(new_node_struct->v_node).push_back($6.node_holder);
					(new_node_struct->v_node).push_back($8.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	for LP error RP		{flag=1;}
			;

while 		:	WHILE
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "WHILE";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

for 		:	FOR
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "FOR";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

Condition_statements	:	if LP expression RP Compound_statements	
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "if";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					(new_node_struct->v_node).push_back($5.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	ifx LP expression RP Compound_statements else Compound_statements
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "ifx";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					(new_node_struct->v_node).push_back($5.node_holder);
					(new_node_struct->v_node).push_back($6.node_holder);
					(new_node_struct->v_node).push_back($7.node_holder);
					$$.node_holder = new_node_struct;
				}
			|   	if LP error RP 			{flag=1;}
			| 	if LP expression RP error 	{flag=1;}
			|	ifx LP error RP 		{flag=1;}
			|	ifx LP expression RP Compound_statements error RCB 	{flag=1;}
			;

if		: 	IF
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "IF";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

else		: 	ELSE
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "ELSE";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

ifx		: 	IFX
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "IFX";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;			

Expression_statements	:	identifier equals expression  SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr1";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					$$.node_holder = new_node_struct;
				}	
			
			|	identifier incr	SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "post incr";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			
			|	identifier decr	SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "post decr";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			
			|	incr identifier SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "pre incr";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			
			|	decr identifier	SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "pre decr";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			
			|	expression SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "exprstmt expr";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			
			;
					
equals	:	EQUALS
		{
			node_struct *new_node_struct = new node_struct;
			new_node_struct->code_node = "EQUALS";
			new_node_struct->id_node = string(yytext,yyleng);
			$$.node_holder = new_node_struct;
		}
	;

incr	:	INCR
		{
			node_struct *new_node_struct = new node_struct;
			new_node_struct->code_node = "INCR";
			new_node_struct->id_node = string(yytext,yyleng);
			$$.node_holder = new_node_struct;
		}
	;

decr	:	DECR
		{
			node_struct *new_node_struct = new node_struct;
			new_node_struct->code_node = "DECR";
			new_node_struct->id_node = string(yytext,yyleng);
			$$.node_holder = new_node_struct;
		}
	;
	
expression		:	expression operators_bitwise expression_relation
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr bit";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	expression_relation
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr rel only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

expression_relation	:	expression_relation operators_relation expression_addsub
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr rel";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	expression_addsub
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr addsub only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

						
expression_addsub	:	expression_addsub  operators_addsub expression_multdiv						
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr adsub";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	expression_multdiv
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr mult only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

						
expression_multdiv	:	expression_multdiv operators_multdiv expression_simple
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr mult";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					(new_node_struct->v_node).push_back($3.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	expression_simple
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr simple only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

						
expression_simple	:	LP expression RP
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr simple";
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	not expression_simple
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "expr simple not";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	operators_addsub expression_simple
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "operators_addsub expression_simple";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	int_num
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "int only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	true
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "true only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	false
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "false only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	float_num
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "float only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	identifier
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "identifier only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

int_num		:	INT_NUM
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "INT_NUM";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;												

true		:	TRUE
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "TRUE";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

false		:	FALSE
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "FALSE";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;
		
not		:	NOT
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "NOT";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

float_num	:	FLOAT_NUM
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "FLOAT";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;
					

Break_statement		:	break SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "break only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}	
			|		break error		{flag=1;}
			;

break		:	BREAK
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "BREAK";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

Return_statement	:	return expression SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "return expr only";
					(new_node_struct->v_node).push_back($1.node_holder);
					(new_node_struct->v_node).push_back($2.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	return expression error		{flag=1;}
			|	return SEMI
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "return only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	return error		{flag=1;}
			;													
		
return		:	RETURN
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "RETURN";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;


operators_bitwise	:	and
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "and only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	or
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "or only";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

and		:	AND
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "AND";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

or		:	OR
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "OR";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;
operators_relation	:	double_eq
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "double_eq";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	greater_eq
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "greater_eq";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	greater
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "greater";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	less_eq
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "less_eq";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	less
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "less";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	not_eq
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "not_eq";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

double_eq	:	DOUBLE_EQ
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "DOUBLE_EQ";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

greater_eq	:	GREATER_EQ
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "GREATER_EQ";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

greater		:	GREATER
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "GREATER";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

less_eq		:	LESS_EQ
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "LESS_EQ";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

less		:	LESS
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "LESS";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

not_eq		:	NOT_EQ
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "NOT_EQ";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;
						
operators_addsub	:	plus
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "plus";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	minus
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "minus";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
					;

operators_multdiv	:	mult
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "mult";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			|	div
				{
					node_struct* new_node_struct = new node_struct;
					new_node_struct->code_node = "div";
					(new_node_struct->v_node).push_back($1.node_holder);
					$$.node_holder = new_node_struct;
				}
			;

plus		:	PLUS
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "PLUS";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

minus		:	MINUS
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "MINUS";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

mult		:	MULT
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "MULT";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

div		:	DIV
			{
				node_struct *new_node_struct = new node_struct;
				new_node_struct->code_node = "DIV";
				new_node_struct->id_node = string(yytext,yyleng);
				$$.node_holder = new_node_struct;
			}
		;

		

%%

void tree_traversal(node_struct *n,int cnt)
{
	//for easy node_struct recognition

	
	
	for(int i=0;i<cnt;i++) cout<<"-";
	if(n==NULL){
		cout<<"No CHILD NODE!\n";
		return;
	}
	cout <<"Code: "<<n->code_node<<"; Children: "<<(n->v_node).size()<<"; ID, if any: "<<n->id_node<<endl;
	for (int i = 1; i <= (n->v_node).size(); ++i)
		tree_traversal((n->v_node)[i-1],cnt+1);
}
int main()
{
	yyparse();
	if(flag==1)
	{
		cout<<"TREE NOT FORMED BECUASE OF ERRORS\n";
	}
	else
	{
	tree_traversal(root_node_struct,0);
	}
}
void yyerror (string s_holder) { printf("Error in line: %d, text: %s_holder \n", mylineno, yytext);}



 					
