comprimir_huffman(NombreArchivo):-
	leer_archivo(NombreArchivo, LettersList),
	all_letters_to_words(LettersList, WordsList),
	nodify_list(WordsList, NodesList),
	select_sort(NodesList, Histograma),
	crear_arbol_huffman(Histograma, ArbolHuffman),
	crear_diccionario(ArbolHuffman, DiccionarioHuffman),
	escribir_diccionario(DiccionarioHuffman, NombreArchivo),
	comprimir(WordsList, DiccionarioHuffman,CompressedList),
	escribir_compresion(CompressedList, NombreArchivo).

leer_archivo(Path, LettersList):-
	open(Path, read, Str),
	process_stream(Str, LettersList),
	close(Str).

buscar(Elemento,[node(Token, _)|Tail],Result):-
	desdelimitar(Elemento, ElementoDesdelimitado),
	ElementoDesdelimitado \== Token,
	buscar(Elemento,Tail,Result).
buscar(Elemento, [node(Token, Code)|_],Code):-
	desdelimitar(Elemento, ElementoDesdelimitado),
	ElementoDesdelimitado == Token.

comprimir([HeadToCompress|TailToCompress], DiccionarioHuffman, [Code|TailCode]):-
	buscar(HeadToCompress, DiccionarioHuffman, Code),
	comprimir(TailToCompress, DiccionarioHuffman, TailCode).
comprimir([],_,[]).


escribir_diccionario(DiccionarioHuffman, NombreEscribir):-
	atom_concat('Diccionario', NombreEscribir, NombreDiccionario),
	open(NombreDiccionario, write, StrDiccionario),
	preparar_diccionario(DiccionarioHuffman, DiccionarioStr),
	write(StrDiccionario,DiccionarioStr),
	nl(StrDiccionario),
	close(StrDiccionario).

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

escribir_compresion(CodificatedData, NombreEscribir):-
	open(NombreEscribir, write, StrCompresion),
	preparar_compresion(CodificatedData, CodificatedDataStr),
	write(StrCompresion,CodificatedDataStr),
	nl(StrCompresion),
	close(StrCompresion).

preparar_compresion(Diccionario, Resultado):-
	preparar_compresion(Diccionario, '', Resultado).
preparar_compresion([Code|TailCodes], Acumulador, Resultado):-
	atom_concat(Acumulador, Code, CodeAgregated),
	preparar_compresion(TailCodes, CodeAgregated, Resultado).
preparar_compresion([], Acumulador, Acumulador).



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

inc(X, Y):- Y is X+1.

naming_node(Element, node(Element,_)).
init_count(Count, node(_,Count)).

del(A,[A|T],R):- del(A,T,R).
del(A,[C|T],[C|R]):- del(A,T,R).
del(_,[],[]).

count(_,[], 1).
count(Element, Lista, Quantity):- count(Element, Lista, 1, Quantity).
count(Element, [Head|Tail], Quantity, Respuesta):-
	Element == Head,
	inc(Quantity, Incremented),
	count(Element, Tail, Incremented, Respuesta).
count(Element, [Head|_], Incremented, Incremented):- Element \== Head.
count(_, [], Incremented, Incremented).

nodify(Element, Tokens, Node):-
	count(Element, Tokens, Count),
	init_count(Count, Node),
	naming_node(Element, Node).


nodify_list(ListTokens, ListNodes):- msort(ListTokens, OrderedTokens), nodify_list_aux(OrderedTokens, ListNodes).
nodify_list_aux([HeadTokens|TailTokens], [Node|TailNodes]):-
	nodify(HeadTokens, TailTokens, Node),
	del(HeadTokens, TailTokens, WithoutLikeHead),
	nodify_list(WithoutLikeHead, TailNodes).
nodify_list_aux([],[]).

minimo([Head|Tail],Resultado):-
	minimo(Tail, Head, Resultado).

minimo([node(_,QuantityHead)|Tail],node(_,QuantityMin),Result):-
	QuantityHead=<QuantityMin,
	minimo(Tail,node(_,QuantityHead),Result).
minimo([node(_,QuantityHead)|Tail],node(_,QuantityMin),Result):-
	QuantityHead>QuantityMin,
	minimo(Tail,node(_,QuantityMin),Result).
minimo([],Min,Min).


select_sort([Head|TailUnordered], [Minimo|TailOrdered]):-
	minimo([Head|TailUnordered], Minimo),
	del(Minimo, [Head|TailUnordered], WithoutMax),
	select_sort(WithoutMax, TailOrdered).
select_sort([], []).

crear_arbol_huffman([NodeHistograma|TailHistograma], Resultado):-
	crear_arbol_huffman(TailHistograma, NodeHistograma, Resultado).

crear_arbol_huffman([NodeHistograma|TailHistograma], SubArbol, Resultado):-
	insertar_arbol_huffman(SubArbol, NodeHistograma, TokenAgregado),
	crear_arbol_huffman(TailHistograma, TokenAgregado, Resultado).
crear_arbol_huffman([], SubArbol, SubArbol).

suma(X,Y,Z):- Z is X+Y.

insertar_arbol_huffman(node(Token1, Quantity1), node(Token2, Quantity2), node(#,QuantityPadre,node(Token1, Quantity1), node(Token2, Quantity2))):-
	suma(Quantity1, Quantity2, QuantityPadre).
insertar_arbol_huffman(node(Token1, Quantity1, I, D), node(Token2, Quantity2), node(#,QuantityPadre,node(Token1, Quantity1, I, D), node(Token2, Quantity2))):-
	suma(Quantity1, Quantity2, QuantityPadre).

crear_diccionario(Arbol, Respuesta):-
	crear_diccionario(Arbol, Respuesta, '').

crear_diccionario(node(_, _, X, node(Token, _)), [node(Desdelimitado,AgregadoUno)|TailDiccionario], Code):-
	atom_concat(Code, '1', AgregadoUno),
	atom_concat(Code, '0', CodeAumentado),
	desdelimitar(Token, Desdelimitado),
	crear_diccionario(X, TailDiccionario, CodeAumentado).
crear_diccionario(node(Token, _), [node(Desdelimitado,CodeAumentado)], Code):-
	atom_concat('0', Code, CodeAumentado),
	desdelimitar(Token, Desdelimitado).


desdelimitar(TokenDelimitado, Token):-
	atom_concat(TokenTmp, '&%39', TokenDelimitado),
	atom_concat('&%39', Token, TokenTmp).










