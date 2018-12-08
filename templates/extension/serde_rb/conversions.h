#include <stdbool.h>
#include <ruby.h>

struct conversions {
  int (*ruby_fixnum_to_c_int) (VALUE);
  char* (*ruby_string_to_c_string) (VALUE);
  double (*ruby_float_to_c_double) (VALUE);
  bool (*ruby_bool_to_c_bool) (VALUE);
};

extern const struct conversions Conversions;
