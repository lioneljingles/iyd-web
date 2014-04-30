class OrganizationsController < ApplicationController
    
  def show
    @welcome = params.has_key?(:welcome)
    @org = Organization.includes(:images, :tags).find_by_slug(params[:slug])
  end
  
  def new
    @tags = Tag.all
    render partial: 'new'
  end

  def create
    org = Organization.new(org_params)
    org.images << Image.new(params[:image].permit(:image)) if params.has_key?(:image)
    org.tags = Tag.find_all_by_name(params.permit(:tags))
    if org.save()
      redirect_to org_slug_path(slug: org.slug, welcome: true)
    else
      @errors = {}
      for field, message in org.errors
        @errors['organization_' + field.to_s] = message
      end
      @tags = Tag.all
      render '_new'
    end
  end
  
  def details
    @org = Organization.find_by_slug(params[:slug])
    render partial: 'details'
  end
  
  def update_details
    org = Organization.find_by_slug(params[:slug])
    if org.update(org_params)
      redirect_to org_slug_path(slug: org.slug, updated: true)
    else
      @errors = {}
      for field, message in org.errors
        @errors['organization_' + field.to_s] = message
      end
      @tags = Tag.all
      render '_details'
    end
  end
  
  def password
    @token = params[:token]
    if @token
      @org = Organization.find_by_reset_token(@token)
      if @org.nil?
        render '_not_found'
      else
        render '_password'
      end
    else
      @org = current_user
      if @org.nil?
        render partial: 'password'
      else
        render partial: 'not_found'
      end
    end
  end
  
  def update_password
    org = Organization.find_by_slug(params[:slug])
    if org.update(org_params)
      redirect_to org_slug_path(slug: org.slug, updated: true)
    else
      @errors = {}
      for field, message in org.errors
        @errors['organization_' + field.to_s] = message
      end
      @tags = Tag.all
      render '_password'
    end
  end
  
  private
  
  def org_params
    params.require(:organization).permit(
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

end



