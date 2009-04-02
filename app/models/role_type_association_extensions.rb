
module RoleTypeAssociationExtensions
  define_method("as") do |role_name|
    return self if role_name.blank?
    role_name = role_name.kind_of?(RoleType) ? role_name.name : role_name.to_s
    self.scoped(
       # PostgreSQL doesn't allow forward references to joined tables.
       # Unfortunately, ActiveRecord merges the many scoped joins
       # in an unsuitable order.
       # We'll work around this with a CROSS JOIN + WHERE clause.
       #:joins => 'INNER JOIN role_types ON roles.role_type_id = role_types.id',
       #:conditions => { :role_types => { :name => role_name } })
      :joins => 'CROSS JOIN role_types',
      :conditions => ["roles.role_type_id = role_types.id AND role_types.name = ?", role_name]
    )
  end
  RoleType.each_name do |name|
    define_method("as_#{name}") do
      as(name)
    end
  end
end
