class AwardsController < ApplicationController
  # GET /awards
  # GET /awards.xml
  def index
    @awards = Award.all

    respond_to do |format|
      format.html { render :layout => false }
      format.json do
        @award_groups = AwardGroup.all
        render :template => 'awards/index.json.rb'
      end
    end
  end

  # GET /awards/1
  # GET /awards/1.xml
  def show
    @awards = Award.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @awards }
    end
  end

  # GET /awards/new
  # GET /awards/new.xml
  def new
    @awards = Award.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @awards }
    end
  end

  # GET /awards/1/edit
  def edit
    @awards = Award.find(params[:id])
  end

  # POST /awards
  # POST /awards.xml
  def create
    @awards = Award.new(params[:awards])

    respond_to do |format|
      if @awards.save
        flash[:notice] = 'Awards was successfully created.'
        format.html { redirect_to(@awards) }
        format.xml  { render :xml => @awards, :status => :created, :location => @awards }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @awards.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /awards/1
  # PUT /awards/1.xml
  def update
    @awards = Award.find(params[:id])

    respond_to do |format|
      if @awards.update_attributes(params[:awards])
        flash[:notice] = 'Awards was successfully updated.'
        format.html { redirect_to(@awards) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @awards.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /awards/1
  # DELETE /awards/1.xml
  def destroy
    @awards = Award.find(params[:id])
    @awards.destroy

    respond_to do |format|
      format.html { redirect_to(awards_url) }
      format.xml  { head :ok }
    end
  end
end
