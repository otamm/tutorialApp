class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in? # 'current_user' only exists if the user is logged, so the variable is only defined that way.
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end
end
