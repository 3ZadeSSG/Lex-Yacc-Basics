#define S_SIZE 100
#define T_SIZE 1000
struct symtab{
 char *name;
 char *value;
};
struct imcode{
 char *result;
 char *operand_left;
 char *operand_right;
 char *operators;
};
struct symtab symbol_table[S_SIZE];
struct imcode tuples[T_SIZE];
