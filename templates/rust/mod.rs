use serde_derive::Serialize;

#[derive(Serialize)]
pub struct Struct {
    <% fields.each do |field| %>
        pub <%= field[:name] %>: <%= field[:type] %>,
    <% end %>
}
