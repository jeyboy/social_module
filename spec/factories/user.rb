Factory.define :user, :class => User do |f|
    f.fullname {"Petrov #{SecureRandom.hex(10)}"}
    f.login {"sharks #{SecureRandom.hex(10)}"}
    f.email {"shark#{SecureRandom.hex(2)}@mail.ru"}
    f.password "123456"
    f.password_confirmation {|u| u.password}
end