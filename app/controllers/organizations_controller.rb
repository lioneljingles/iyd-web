class OrganizationsController < ApplicationController
    
  def new
    @tags = Tag.all
    render partial: 'new'
  end

  def create
  end

end