class OrganizationsController < ApplicationController
  
  include Rails.application.routes.url_helpers
  
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
    has_more = false if (row == 0 and orgs.length < 3) or (orgs.length < 2)
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
    org.tags = Tag.where(name: params.permit(tags: [])[:tags])
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




