#define SIZE 1000
struct symtab{
 char *name;
 char value;
};
struct imcode{
 char *result;
 char *operand_left;
 char *operators;
};
struct symtab symbol_table[SIZE];
struct imcode tuples[SIZE];

