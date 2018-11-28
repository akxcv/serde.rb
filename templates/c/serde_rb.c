#include <stdio.h>
#include <ruby.h>

extern char *serde_rb_rs_<%= serializer[:name] %>(<%= serializer[:joint_fields_c] %>);

VALUE c_to_json(VALUE _instance, <%= serializer[:fields].map { |f| "VALUE #{f[:name]}" }.join(', ') %>) {
  <%= serializer[:fields].map { |f| f[:cdecl] }.join("\n") %>
  return rb_str_new2(serde_rb_rs_<%= serializer[:name] %>(<%= serializer[:fields].map { |f| "c_#{f[:name]}" }.join(', ') %>));
}

void Init_serde_rb(void) {
  VALUE klass = rb_const_get(rb_cObject, rb_intern("<%= serializer[:class_name] %>"));

  rb_define_method(klass, "internal_to_json", c_to_json, <%= serializer[:fields].length %>);
}
