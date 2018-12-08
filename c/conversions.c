#include "conversions.h"

// TODO consider `long` type
int ruby_fixnum_to_c_int(VALUE val) {
  Check_Type(val, T_FIXNUM);
  return NUM2INT(val);
}

char* ruby_string_to_c_string(VALUE val) {
  Check_Type(val, T_STRING);
  return StringValueCStr(val);
}

double ruby_float_to_c_double(VALUE val) {
  Check_Type(val, T_FLOAT);
  return RFLOAT_VALUE(val);
}

bool ruby_bool_to_c_bool(VALUE val) {
  if (val == Qtrue) {
    return true;
  } else if (val == Qfalse) {
    return false;
  } else {
    rb_raise(rb_eTypeError, "wrong argument type %s (expected Boolean)", rb_obj_classname(val));
  }
}

const struct conversions Conversions = {
  .ruby_fixnum_to_c_int = ruby_fixnum_to_c_int,
  .ruby_string_to_c_string = ruby_string_to_c_string,
  .ruby_float_to_c_double = ruby_float_to_c_double,
  .ruby_bool_to_c_bool = ruby_bool_to_c_bool
};
