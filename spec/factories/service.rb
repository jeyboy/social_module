Factory.define :service, :class => Service do |f|
    f.provider 'twitter'
    f.uid '352243409'
    f.association :user_id, :factory => :user
    f.credentials "352243409-8I8kX5p4N2hNzNFt1gfklLVv58LgfYm6Ow8fYBc8"
end