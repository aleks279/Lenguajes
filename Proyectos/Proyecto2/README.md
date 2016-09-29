# Readme
## Installation: 
### Packages:
1.

## Usage:
### Functions:
?- comprimir_huffman(nombreArchivo).
```
[Description: The function executes all necessary functionality for compress the data, that includes: Creates a Huffman Tree, Generates the histogram, and Huffman's dictionary]
[Inputs: nombreArchivo is a char-string like 'nombre.txt', the hard drive path of text file]
[Outputs: A file that contains the huffman's dictionary, rewrites the original file with the respective compression codes]
```
?- leer_archivo(NombreArchivo, LettersList),
```
[Inputs: nombreArchivo is a char-string like 'nombre.txt', the hard drive path of text file]
[Outputs: LettersList is a list that contains each letter of the Stream of reading process of text file]
```
	
?- all_letters_to_words(LettersList, WordsList),
```
[Inputs: LettersList is a list that contains each letter of the Stream of reading process of text file]
[Outputs: WordsList is a list obtained of concatenate characters to generate words]
```
	
?- nodify_list(WordsList, NodesList),
```
[Inputs: WordsList is a list obtained of concatenate characters to generate words]
[Outputs: NodesList is a list obtained of to generate nodes and concatenate them to a list]
```
	
?- select_sort(NodesList, Histograma),
```
[Inputs: NodesList is a list obtained of to generate nodes and concatenate them to a list]
[Outputs: Histogram is the sorted input]
```
	
?- crear_arbol_huffman(Histograma, ArbolHuffman),
```
[Outputs: Histogram is a sorted list of nodes]
[Outputs: ArbolHuffman is a tree obtained using de huffman's algorithm specified in the project specification]
```
	
?- crear_diccionario(ArbolHuffman, DiccionarioHuffman),
```
[Outputs: ArbolHuffman is a tree obtained using de huffman's algorithm specified in the project specification]
[Outputs: DiccionarioHuffman is a list that contains nodes sorted by quantity of repetitions in the original text]
```
	
?- escribir_diccionario(DiccionarioHuffman, NombreArchivo),
```
[Description: The function saves the content of Huffman's Dictionary in a file named 'Diccionario<NombreArchivo>.txt']
[
Inputs: 
DiccionarioHuffman is a list that contains nodes sorted by quantity of repetitions in the original text,
NombreArchivo is a char-string like 'nombre.txt', the hard drive path of text file
]
```

?- comprimir(WordsList, DiccionarioHuffman,CompressedList),
```
[
Inputs: 
DiccionarioHuffman is a list that contains nodes sorted by quantity of repetitions in the original text,
WordsList is a list obtained of concatenate characters to generate words
]
[Outputs: CompressedList is a list in which the tokens or words are replaced with the compression codes]
```

?- escribir_compresion(CompressedList, NombreArchivo).
```
[
Inputs: 
CompressedList is a list in which the tokens or words are replaced with the compression codes,
NombreArchivo is a char-string like 'nombre.txt', the hard drive path of text file]
]
[Outputs: the rule rewrites the original file with the respectives compression codes]
```

Any other function depends of the previous one. 

Known Issues: 
The file that you want to compress must be in the same folder of the source code, 
Numerical characters generates errors,
A too Long text, will cause errors.
