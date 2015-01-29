class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy] # execute 'logged_in_user' before the actions specified on 'only: []'.

  def create

  end

  def destroy

  end

end
