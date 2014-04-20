class RootController < ApplicationController

  def placeholder
  end
  
  def index
    @tags = Tag.all
  end
  
end