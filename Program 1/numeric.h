#define NSYS 100
#define NTUP 1000
struct symtab{
	char *value;
	char *name;
}
struct imcode{
	char *operators;
	char *operand_left;
	char *operand_right;
	char *result;
}
struct symtab symbol_table[NSYS];
struct imcode tuples[NTUP];