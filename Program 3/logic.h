#define SIZE 1000
struct symtab{
 char *name;
 char *value;
};
struct imcode{
 char *result;
 char *operators;
 char *operand_left;
 char *operand_right;
};
struct symtab symbol_table[SIZE];
struct imcode tuples[SIZE];
