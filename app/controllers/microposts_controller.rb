class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy] # execute 'logged_in_user' before the actions specified on 'only: []'.

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy

  end

  private

  def micropost_params
    params.require(:micropost).permit(:content) # only allows posting of a micropost's :content
  end

end
