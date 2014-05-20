class OrganizationsController < ApplicationController
    
  def list
    row = params[:row].to_i
    tag = params.has_key?('tag') ? params[:tag] : nil
    if request.referer.include?('pups!')
      render_debug(row)
      return
    end
    if tag.blank?
      orgs = Organization.page(row)
    else
      orgs = Tag.org_page(tag, row)
    end
    has_more = true
    has_more = false if (row == 0 and orgs.length < 4) or (orgs.length < 3)
    if has_more and orgs.pop.nil?
      has_more = false
    end
    render json: {
      success: true,
      row: row,
      has_more: has_more,
      orgs: orgs
    }
  end
  
  def show
    @org = Organization.includes(:images, :tags).find_by_slug(params[:slug])
    @is_owner = current_user == @org.user
    if @is_owner and params.has_key?(:welcome)
      @org_url = request.protocol + request.host + @org.profile
    end
  end
  
  def new
    @tags = Tag.all
    render partial: 'new'
  end

  def create
    org = Organization.new(org_params)
    org.images << Image.new(params[:image].permit(:image)) if params.has_key?(:image)    
    org.tags = Tag.where(name: params.permit(tags: [])[:tags])
    if org.save()
      redirect_to org.profile({welcome: true})
    else
      @errors = {}
      for field, message in org.errors
        @errors['organization_' + field.to_s] = message
      end
      @tags = Tag.all
      render '_new'
    end
  end
  
  def edit
    @tags = Tag.all
    @org = Organization.find_by_slug(params[:slug])
    render partial: 'edit'
  end
  
  def update
    org = Organization.find_by_slug(params[:slug])
    if org.update(org_params)
      redirect_to org.profile({update: true})
    else
      @errors = {}
      for field, message in org.errors
        @errors['organization_' + field.to_s] = message
      end
      @tags = Tag.all
      render '_edit'
    end
  end
  
  private
  
  def org_params
    params.require(:org).permit(
      :email, 
      :password, 
      :password_confirmation, 
      :name,
      :contact,
      :website,
      :summary,
      :description
    )
  end
  
  def render_debug(row)
    # Debug Test Template
    debug_org = {
      image: 'http://1.bp.blogspot.com/-f-KzlJE0ncU/TxGXIYMriII/AAAAAAAACXA/ddCZoDVUs_Y/s1600/Kitten+and+Puppy5.jpg', 
      name: 'The puppy kitty committee', summary: 'An awesome group of amazing animals!', path: '/',
    }
    render json: {success: true, row: row, has_more: true, orgs: [debug_org, debug_org, debug_org]}
  end

end




