# Because I miss it.  And I don't want to rely on ActiveSupport.
unless defined? Object.returning
  class Object
    def returning(value)
      yield(value)
      value
    end
  end
end