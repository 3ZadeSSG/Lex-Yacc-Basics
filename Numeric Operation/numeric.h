#define NSYS 100 
#define NTUP 1000
struct symtab{
 char *name;
 char *value;
};
struct imcode{
 char *operand_left;
 char *operand_right;
 char *result;
 char *operators;
};
struct symtab symbol_table[NSYS];
struct imcode tuples[NTUP];
