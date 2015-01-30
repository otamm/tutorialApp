class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy] # execute 'logged_in_user' before the actions specified on 'only: []'.
  before_action :correct_user, only: [:destroy]

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
    @micropost.destroy
    flash[:success] = "Micropost deleted."
    redirect_to request.referrer || root_url # request.referrer is more or less like request.url used in friendly forwarding, but it automatically redirects back to the last URL visited.
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture) # only allows posting of a micropost's :content & :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id]) # checks if the sent URL contains the id of a micropost by the current user.
    redirect_to root_url if @micropost.nil?
  end

end
