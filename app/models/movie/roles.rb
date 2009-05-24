
class Movie
  
  has_many :roles, :dependent => :destroy, :extend => RoleTypeAssociationExtensions

  module ParticipantTypeExtensions
    include RoleTypeAssociationExtensions

    ### TODO how to ensure that the new participant is seen before saving?
    def add(role_name, person, options = {})
      proxy_owner.roles.build(
        :person => person,
        :role_type => RoleType[role_name],
        :credited_as => options[:as]
      )
    end

    def remove(role_name, person)
      role = Role.find(:first,
        :joins => :role_type,
        :conditions => {
          :person_id => person,
          :movie_id  => proxy_owner,
          :role_types => { :name => role_name.to_s }
        })
      proxy_owner.roles.delete(role)
    end

    def replace(role, refs_with_options)
      transaction do
        options = refs_with_options.map { |o| o.kind_of?(Hash) ? o.dup.delete(:id) : {} }
        others  = refs_with_options.map { |o| o.kind_of?(Hash) ? o[:id] : o }

        others  = Person.find(others)
        current = proxy_owner.participants.as(role)

        obsolete = current.select { |o| !others.include?(o) }
        fresh    = others.zip(options).select { |o, opts| !current.include?(o) }

        obsolete.each { |o|       self.remove(role, o) }
        fresh.each    { |o, opts| self.add(role, o, opts) }
      end
    end

    RoleType.each_name do |name|
      class_eval <<-END
        def add_#{name}(person, options = {})
          add(:#{name}, person, options)
        end
        def remove_#{name}(person)
          remove(:#{name}, person)
        end
        def replace_#{name.pluralize}(others)
          replace(:#{name}, others)
        end
      END
    end
  end

  has_many :participants, :through => :roles, :source => :person, :extend => ParticipantTypeExtensions


  RoleType.each_name do |role_name|
    define_method(role_name.pluralize) do
      participants.as(role_name)
    end

    define_method("#{role_name.pluralize}=") do |others|
      participants.replace(role_name, others)
    end
  end
end
