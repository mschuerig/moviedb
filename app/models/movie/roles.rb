
class Movie

  module RoleTypeExtensions
    include RoleTypeAssociationExtensions

    def update(role_type, people_ids_or_role_attributes)
      # people_ids_or_role_attributes   == [{attributes}|person_id, ...]
      # people_ids_and_role_attributes  == [[person_id, attributes], ...]
      # obsolete == [role, ...]
      # updated  == [[person_id, attributes], ...]
      # fresh    == [[person_id, attributes], ...]
      #
      transaction do
        id_attr = RoleType.its_name(role_type) + '_id'
        type    = RoleType[role_type]

        people_ids_and_role_attributes = extrapose_key(people_ids_or_role_attributes, id_attr)
        people_ids = people_ids_and_role_attributes.map { |pair| pair.first.to_s }

        current_roles      = self.as(role_type)
        current_roles_by_person_id = current_roles.index_by { |role| role.person_id.to_s }

        obsolete = current_roles.select { |role|
          !people_ids.include?(role.person_id.to_s)
        }
        
        updated, fresh = people_ids_and_role_attributes.partition { |person_id, _|
          current_roles_by_person_id.include?(person_id)
        }

        ### TODO this is bad as it requires loading the entire association
        self.each do |role|
          role.mark_for_destruction if obsolete.include?(role)
        end

        updated.each do |person_id, attribs|
          current_roles_by_person_id[person_id].attributes = attribs
        end
        fresh.each do |person_id, attribs|
          self.build((attribs || {}).merge(:person_id => person_id, :role_type => type))
        end
      end
    end

    private

    def extrapose_key(hashes, key)
      hashes.map { |h|
        if h.kind_of?(Hash)
          [ h[key], h.reject { |k, _| k == key } ]
        else
          [ h, nil ]
        end
      }
    end
  end

  has_many :roles, :dependent => :destroy,
    :autosave => true, :extend => RoleTypeExtensions

  RoleType.each_name do |role_name|
    define_method(role_name.pluralize) do
      roles.as(role_name)
    end

    define_method("#{role_name.pluralize}=") do |others|
      roles.update(role_name, others)
    end
  end


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

  has_many :participants, :through => :roles, :source => :person,
    :autosave => true, :extend => ParticipantTypeExtensions
end
