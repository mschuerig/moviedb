
module LazyJason

  def index
    respond_to do |format|
      format.json do
        objects = scope.all(:offset => @offset_limit[0], :limit => @offset_limit[1])
        count = scope.count
        set_object_list(objects)
        set_count(count)
        render
      end
    end
  end

  def show
    object = scope.find(params[:id])
    set_object(object)

    respond_to do |format|
      format.json
    end
  end

  def create
    object = scope.new(params[:attributes])
    set_object(object)

    respond_to do |format|
      if object.save
        format.json { render :action => :show, :location => polymorphic_path(object) }
      else
        ### TODO
      end
    end
  end

  def update
    object = scope.find(params[:id])
    set_object(object)

    respond_to do |format|
      if object.update_attributes(params[:attributes])
        format.json { render :action => :show }
      else
        ### TODO error response
      end
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

end
