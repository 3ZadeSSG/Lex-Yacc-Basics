#define S_SIZE 1000
#define T_SIZE 1000
struct symtab{
 char *value;
 char *name;
};
struct imcode{
 char *result; 
 char *operators;
 char *operand_left;
 char *operand_right; 
};
struct symtab symbol_table[S_SIZE];
struct imcode tuples[T_SIZE];

