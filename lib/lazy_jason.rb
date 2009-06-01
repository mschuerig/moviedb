
module LazyJason
  DEFAULT_EXPIRATION_TIME = 10.seconds.freeze

  def index
    objects = scope.all(:offset => @offset_limit[0], :limit => @offset_limit[1])

    if stale?(:last_modified => last_modified(objects),
        :etag => objects, :public => public_caching)
      count = scope.count
      set_object_list(objects)
      set_count(count)

      expires_in expiration_time
      respond_to do |format|
        format.json do
          render
        end
      end
    end
  end

  def show
    object = scope.find(params[:id])

    if stale?(:last_modified => last_modified(object),
        :etag => object, :public => public_caching)
      set_object(object)

      expires_in expiration_time
      respond_to do |format|
        format.json
      end
    end
  end

  def create
    object = saved = nil
    scope.transaction do
      object = scope.new(params[:attributes])
      set_object(object)
      saved = object.save
    end
    respond_to do |format|
      if saved
        format.json { render :action => :show, :location => polymorphic_path(object) }
      else
        ### TODO
      end
    end
  end

  def update
    object = scope.find(params[:id])

    if update_matches_current_version?(object)
      set_object(object)

      updated = scope.transaction {
        object.update_attributes(params[:attributes])
      }

      respond_to do |format|
        if updated
          format.json { render :action => :show }
        else
          ### TODO error response
        end
      end
    else
      head :precondition_failed
    end
  end

  def destroy
    object = scope.find(params[:id])
    set_object(object)
    object.destroy

    respond_to do |format|
      format.json { head :ok } ### TODO
    end
  end

  protected

  def public_caching
    true
  end

  def expiration_time
    DEFAULT_EXPIRATION_TIME
  end

  def last_modified(object_or_list)
    updated_at = case object_or_list
      when ActiveRecord::Base
        object_or_list.updated_at
      when Array
        object_or_list.map(&:updated_at).max
      else
        nil
      end
    updated_at ? updated_at.utc : nil
  end

  def update_matches_current_version?(object)
    response.etag = object
    if_match_header = request.headers['IF-MATCH']
    if_match_header.nil? || (if_match_header == response.etag)
  end
end
