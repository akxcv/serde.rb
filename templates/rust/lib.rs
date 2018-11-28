use std::os::raw::c_char;
use std::ffi::CStr;

mod <%= serializer[:name] %>;

#[no_mangle]
pub extern "C" fn serde_rb_rs_<%= serializer[:name] %> (<%= serializer[:joint_fields_rctype] %>) -> *const u8 {
    let name = unsafe {
        CStr::from_ptr(name).to_string_lossy().into_owned()
    };
    let instance = <%= serializer[:name] %>::Struct {
        <% serializer[:fields].each do |field| %>
            <%= field[:name] %>,
        <% end %>
    };
    serde_json::to_string(&instance).unwrap().as_ptr()
}
