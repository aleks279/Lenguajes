%Tecnológico de Costa Rica
%Segundo Proyecto programado
%Preparado por:
%Ariel Herrera
%Saúl Zamora


%Compresión de texto por método Huffman
comprimir_huffman(NombreArchivo):-
	%Lee información de archivo, obtiene cada caracter individualmente
	leer_archivo(NombreArchivo, LettersList),
	%Procesa la lista de caracteres generando palabras
	all_letters_to_words(LettersList, WordsList),
	%Genera nodos con el Token y la cantidad de apariciones en el texto
	nodify_list(WordsList, NodesList),
	%Ordena por cantidad de apariciones
	select_sort(NodesList, Histograma),
	%Crea arbol de huffman
	crear_arbol_huffman(Histograma, ArbolHuffman),
	%crea diccionario de huffman con los códigos de compresión
	crear_diccionario(ArbolHuffman, DiccionarioHuffman),
	%almacena permanentemente el diccionario de huffman
	escribir_diccionario(DiccionarioHuffman, NombreArchivo),
	%Cambia palabras por su respectivo código de compresión
	comprimir(WordsList, DiccionarioHuffman,CompressedList),
	%Sobreescribe el archivo
	escribir_compresion(CompressedList, NombreArchivo).

%Lee de archivos de formato TXT
leer_archivo(Path, LettersList):-
	open(Path, read, Str),
	%obtiene lista con el stream separado letra a letra
	process_stream(Str, LettersList),
	close(Str).

%Busca un elemento concreto, devuelve el código de compresión
buscar(Elemento,[node(Token, _)|Tail],Result):-
	%Elimina delimitador para compararlo con el token en el diccionario
	desdelimitar(Elemento, ElementoDesdelimitado),
	ElementoDesdelimitado \== Token,
	buscar(Elemento,Tail,Result).
%Caso final, devuelve el codigo del elemento está en el diccionario
buscar(Elemento, [node(Token, Code)|_],Code):-
	desdelimitar(Elemento, ElementoDesdelimitado),
	ElementoDesdelimitado == Token.

% Genera la lista con los datos de compresión que sustituyen a los
% respectivos tokens
comprimir([HeadToCompress|TailToCompress], DiccionarioHuffman, [Code|TailCode]):-
	buscar(HeadToCompress, DiccionarioHuffman, Code),
	comprimir(TailToCompress, DiccionarioHuffman, TailCode).
comprimir([],_,[]).

%Almacena diccionario
escribir_diccionario(DiccionarioHuffman, NombreEscribir):-
	atom_concat('Diccionario', NombreEscribir, NombreDiccionario),
	open(NombreDiccionario, write, StrDiccionario),
	preparar_diccionario(DiccionarioHuffman, DiccionarioStr),
	write(StrDiccionario,DiccionarioStr),
	nl(StrDiccionario),
	close(StrDiccionario).
%genera una cadena de caracteres con todo el contenido del diccionario
preparar_diccionario(Diccionario, Resultado):-
	preparar_diccionario(Diccionario, '', Resultado).
preparar_diccionario([node(Token, Code)|TailDiccionario], Acumulador, Resultado):-
	atom_concat(Acumulador, '[', Inicio),
	atom_concat(Inicio, Token, Concatenado),
	atom_concat(Concatenado, ',', ConcatenadoComa),
	atom_concat(ConcatenadoComa, Code, ConcatenadoElemento2),
	atom_concat(ConcatenadoElemento2, '],', ConcatenadoFin),
	preparar_diccionario(TailDiccionario, ConcatenadoFin, Resultado).
preparar_diccionario([node(Token, Code)], Acumulador, ConcatenadoFin):-
	atom_concat(Acumulador, '[', Inicio),
	atom_concat(Inicio, Token, Concatenado),
	atom_concat(Concatenado, ',', ConcatenadoComa),
	atom_concat(ConcatenadoComa, Code, ConcatenadoElemento2),
	atom_concat(ConcatenadoElemento2, ']', ConcatenadoFin).

%Almacena Datos de la compresión
escribir_compresion(CodificatedData, NombreEscribir):-
	open(NombreEscribir, write, StrCompresion),
	preparar_compresion(CodificatedData, CodificatedDataStr),
	write(StrCompresion,CodificatedDataStr),
	nl(StrCompresion),
	close(StrCompresion).

%genera una cadena de caracteres con todo el contenido de compresión
preparar_compresion(Diccionario, Resultado):-
	preparar_compresion(Diccionario, '', Resultado).
preparar_compresion([Code|TailCodes], Acumulador, Resultado):-
	atom_concat(Acumulador, Code, CodeAgregated),
	preparar_compresion(TailCodes, CodeAgregated, Resultado).
preparar_compresion([], Acumulador, Acumulador).

%Procesa el Stream obteniendo una lista con cada caracter del Stream
process_stream(Stream, []) :-
	at_end_of_stream(Stream).
process_stream(Stream, [Character|Resto]) :-
	get_char(Stream, Character),
	process_stream(Stream, Resto).


%Valida los caracteres especiales
reserved_char(Letter):-
	char_code(Letter, Code),
	Code > 31,
	Code <48.
reserved_char(Letter):-
	char_code(Letter, Code),
	Code > 57,
	Code < 65.
reserved_char(Letter):-
	char_code(Letter, Code),
	Code > 90,
	Code < 97.
reserved_char(Letter):-
	char_code(Letter, Code),
	Code > 122,
	Code < 192.
reserved_char(Letter):-
	char_code(Letter, Code),
	Code > 255.
reserved_char(Letter):-
	Letter == '\n'.

%Agrega Delimitadores.

add_delimiter_before(Without_Delim, With_Delim):-
	atom_concat('&%39', Without_Delim, With_Delim).

add_delimiter_after(Without_Delim, With_Delim):-
	atom_concat(Without_Delim, '&%39', With_Delim).

% forma una palabra apartir de letras en una lista, hasta que se
% encuentra con un caractér especial (incluido el espacio).

letters_to_word([HLetterOfWord], [], Word):-
	add_delimiter_before(HLetterOfWord, DelimAfter),
	add_delimiter_after(DelimAfter, Word).
letters_to_word([HLetterOfWord|TLettersOfWord], RestoLista, Word):-
	not(reserved_char(HLetterOfWord)),
	add_delimiter_before(HLetterOfWord, DelimBefore),
	letters_to_word(TLettersOfWord, RestoLista, DelimBefore, Word).


letters_to_word([HLetterOfWord|TLettersOfWord],[HLetterOfWord|TLettersOfWord],WordBefore, WordFinale):-
	reserved_char(HLetterOfWord),
	add_delimiter_after(WordBefore,WordFinale).
letters_to_word([HLetterOfWord],[],WordBefore, WordFinale):-
	not(reserved_char(HLetterOfWord)),
	atom_concat(WordBefore, HLetterOfWord, Word),
	add_delimiter_after(Word, WordFinale).
letters_to_word([HLetterOfWord|TLettersOfWord], RestoLista, WordBefore, WordFinale):-
	not(reserved_char(HLetterOfWord)),
	atom_concat(WordBefore, HLetterOfWord, WordAfter),
	letters_to_word(TLettersOfWord, RestoLista, WordAfter, WordFinale).

%Forma todas las palabras en una lista de letras.

all_letters_to_words([HLettersOfWords|TLettersOfWords], [MakedWord|TRestOfLetters]):-
	not(reserved_char(HLettersOfWords)),
	letters_to_word([HLettersOfWords|TLettersOfWords], RestoLista, MakedWord),
	all_letters_to_words(RestoLista,TRestOfLetters).
all_letters_to_words([HLettersOfWords|TLettersOfWords], [MakedWord|TRestOfLetters]):-
	reserved_char(HLettersOfWords),
	add_delimiter_before(HLettersOfWords, DelimA),
	add_delimiter_after(DelimA, MakedWord),
	all_letters_to_words(TLettersOfWords,TRestOfLetters).
all_letters_to_words([],[]).

%Aumenta X en 1 y lo asigana a Y
inc(X, Y):- Y is X+1.
%Asigna el token al nodo
naming_node(Element, node(Element,_)).

%asigna la cantidad al nodo
init_count(Count, node(_,Count)).

%Elimina datos de una lista
del(A,[A|T],R):- del(A,T,R).
del(A,[C|T],[C|R]):- del(A,T,R).
del(_,[],[]).

%Cuenta apariciones de tokens
count(_,[], 1).
count(Element, Lista, Quantity):- count(Element, Lista, 1, Quantity).
count(Element, [Head|Tail], Quantity, Respuesta):-
	Element == Head,
	inc(Quantity, Incremented),
	count(Element, Tail, Incremented, Respuesta).
count(Element, [Head|_], Incremented, Incremented):- Element \== Head.
count(_, [], Incremented, Incremented).

%Genera los nodos de la forma node(Token, Quantity)
nodify(Element, Tokens, Node):-
	%Cuenta la cantidad de apariciones
	count(Element, Tokens, Count),
	init_count(Count, Node),
	naming_node(Element, Node).

%Genera una lista de nodos apartir de una lista de tokens
nodify_list(ListTokens, ListNodes):- msort(ListTokens, OrderedTokens), nodify_list_aux(OrderedTokens, ListNodes).
nodify_list_aux([HeadTokens|TailTokens], [Node|TailNodes]):-
	nodify(HeadTokens, TailTokens, Node),
	%Elimina los datos procesados (Palabras ya contadas)
	del(HeadTokens, TailTokens, WithoutLikeHead),
	nodify_list(WithoutLikeHead, TailNodes).
nodify_list_aux([],[]).

%Obtiene el minimo de la lista de nodos según cantidad de apariciones
minimo([Head|Tail],Resultado):-
	minimo(Tail, Head, Resultado).

minimo([node(_,QuantityHead)|Tail],node(_,QuantityMin),Result):-
	QuantityHead=<QuantityMin,
	minimo(Tail,node(_,QuantityHead),Result).
minimo([node(_,QuantityHead)|Tail],node(_,QuantityMin),Result):-
	QuantityHead>QuantityMin,
	minimo(Tail,node(_,QuantityMin),Result).
minimo([],Min,Min).

%ordena de menor a mayor
select_sort([Head|TailUnordered], [Minimo|TailOrdered]):-
	minimo([Head|TailUnordered], Minimo),
	del(Minimo, [Head|TailUnordered], WithoutMax),
	select_sort(WithoutMax, TailOrdered).
select_sort([], []).

%Genera arbol apartir de una lista ordenada de forma ascendente
crear_arbol_huffman([NodeHistograma|TailHistograma], Resultado):-
	crear_arbol_huffman(TailHistograma, NodeHistograma, Resultado).

crear_arbol_huffman([NodeHistograma|TailHistograma], SubArbol, Resultado):-
	insertar_arbol_huffman(SubArbol, NodeHistograma, TokenAgregado),
	crear_arbol_huffman(TailHistograma, TokenAgregado, Resultado).
crear_arbol_huffman([], SubArbol, SubArbol).

%Suma X y Y y lo almacena en Z
suma(X,Y,Z):- Z is X+Y.

% Inserta nodo en el arbol de huffman, con el algoritmo definido en la
% especificación del proyecto
insertar_arbol_huffman(node(Token1, Quantity1), node(Token2, Quantity2), node(#,QuantityPadre,node(Token1, Quantity1), node(Token2, Quantity2))):-
	suma(Quantity1, Quantity2, QuantityPadre).
insertar_arbol_huffman(node(Token1, Quantity1, I, D), node(Token2, Quantity2), node(#,QuantityPadre,node(Token1, Quantity1, I, D), node(Token2, Quantity2))):-
	suma(Quantity1, Quantity2, QuantityPadre).

%Genera el diccionario de sustitución de Huffman
crear_diccionario(Arbol, Respuesta):-
	crear_diccionario(Arbol, Respuesta, 1).
%Genera los códigos de compresión
crear_diccionario(node(_, _, X, node(Token, _)), [node(Desdelimitado,Code)|TailDiccionario], Code):-
	CodeAumentado is Code*10,
	desdelimitar(Token, Desdelimitado),
	crear_diccionario(X, TailDiccionario, CodeAumentado).
crear_diccionario(node(Token, _), [node(Desdelimitado,CodeAumentado)], Code):-
	CodeAumentado is Code*10,
	desdelimitar(Token, Desdelimitado).

%Eliminar el delimitador '&%39'
desdelimitar(TokenDelimitado, Token):-
	atom_concat(TokenTmp, '&%39', TokenDelimitado),
	atom_concat('&%39', Token, TokenTmp).















