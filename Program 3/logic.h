#define SIZE 1000
typedef struct SYMTAB{
 char *name;
 char *value;
}symtab;
typedef struct IMCODE{
 char *result;
 char *operators;
 char *operand_left;
 char *operand_right;
}imcode;
symtab symbol_table[SIZE];
imcode tuples[SIZE];
