Factory.define :user, :class => User do |f|
    f.fullname {"Petrov #{SecureRandom.hex(4)}"}
    f.login {"sharks #{SecureRandom.hex(4)}"}
    f.email {"shark#{SecureRandom.hex(2)}@mail.ru"}
    f.password "1234567"
    f.password_confirmation {|u| u.password}
end