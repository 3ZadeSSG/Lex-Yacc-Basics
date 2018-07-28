#define NSYS 100 //max size of symbol table
#define NTUP 1000 //max size of quadruple table
struct symtab{ //symbol table type only holds label and its vlaue
 char *value;
 char *name;
};
struct imcode{ //a 3 address intermediate code will contain 2 operand 1 operator
  char *operators;
  char *operand_left;
  char *operand_right;
  char *result;
};
struct symtab symbol_table[NSYS];
struct imcode tuples[NTUP];

