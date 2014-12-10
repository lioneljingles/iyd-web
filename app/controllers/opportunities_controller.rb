class OpportunitiesController < ApplicationController
    
  def list
    
    row = params[:row].to_i
    district = params[:district].to_i != -1 ? params[:district].to_i : nil
    position = params[:position].to_i != -1 ? params[:position].to_i : nil
    duration = params[:duration].to_i != -1 ? params[:duration].to_i : nil
    
    opps = Opportunity.page(row, district, position, duration)
    
    has_more = false
    if opps.length > 5
      has_more = true
      opps.pop
    end
    render json: {
      success: true,
      row: row,
      has_more: has_more,
      opps: opps
    }
  end
  
  def show
    @opps = Opportunity.all
  end
  
  def new
    @org = Organization.includes(:images, :tags).find_by_slug(params[:slug])
    @opp = @org.opportunities.new
    if current_user == @org.user
      render partial: 'new'
    else
      render partial: 'root/invalid'
    end
  end

  def create
    org = Organization.includes(:images, :tags).find_by_slug(params[:slug])
    if current_user == org.user
      opp = org.opportunities.new(opp_params)      
      if opp.save()
        redirect_to org.profile({created_opportunity: true}), status: 303
      else
        @errors = {}
        for field, message in opp.errors
          @errors['opp_' + field.to_s] = message.capitalize
        end
        render '_new'
      end
    else
      render 'root/invalid'
    end
  end
  
  def edit
    @org = Organization.includes(:images, :tags).find_by_slug(params[:slug])
    @opp = @org.opportunities.find(params[:id].to_i)
    if current_user == @org.user and not @opp.nil?
      render partial: 'new'
    else
      render partial: 'root/invalid'
    end
  end
  
  def update
    org = Organization.find_by_slug(params[:slug])
    opp = org.opportunities.find(params[:id].to_i)
    params = opp_params
    params[:description] = CGI::escapeHTML(params[:description])
    params[:start_date] = Date.parse(params[:start_date]) unless params[:start_date].blank?
    params[:end_date] = Date.parse(params[:end_date]) unless params[:end_date].blank?
    if current_user == org.user and not opp.nil?
      if opp.update(params)
        redirect_to org.profile({updated_opportunity: true})
      else
        @errors = {}
        for field, message in opp.errors
          @errors['organization_' + field.to_s] = message
        end
        @tags = Tag.all
        render '_edit'
      end
    else
      render partial: 'root/invalid'
    end
  end
  
  def destroy
    org = Organization.find_by_slug(params[:slug])
    opp = org.opportunities.find(params[:id].to_i)
    if current_user == org.user and not opp.nil?
      opp.visibility = Opportunity::Visibility::REMOVED
      opp.save
      redirect_to org.profile({deleted_opportunity: true}), status: 303
    else
      render partial: 'root/invalid'
    end
  end
  
  private
  
  def opp_params    
    params.require(:opp).permit(
      :title, 
      :description, 
      :position, 
      :start_date, 
      :end_date
    )
  end
  
end




