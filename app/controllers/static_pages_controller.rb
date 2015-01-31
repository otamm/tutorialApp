class StaticPagesController < ApplicationController
  def home
    if logged_in? # 'current_user' only exists if the user is logged, so the variable is only defined that way.
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end
end
