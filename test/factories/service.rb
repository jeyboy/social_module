Factory.define :service, :class => Service do |f|
    f.provider 'open_id'
    f.uid 'twitter'
    f.secret 'hdhrtuy565'
    f.token "123456"
end